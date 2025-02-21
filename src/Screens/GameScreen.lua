local PositionFunctions = require('../Functions/PositionFunctions')

local DiceTray = require('../Components/DiceTray')
local FatRect = require('../Components/FatRect')
local Button = require('../Components/Button')
local Player = require('../Components/Player')
local Enemy = require('../Components/Enemy')
local Die = require('../Components/Die')

local EnemyConfig = require('../Data/EnemyConfig')
local PlayerConfig = require('../Data/PlayerConfig')

local GameScreen = {}
GameScreen.screen = 2

-- menu options
selectedCharacter = nil

-- animation handlers
animationTimer = nil
phase = nil

enemyHP = nil
enemyBLK = nil
enemyActions = nil
enemyConfig = nil
round = nil

function loadEnemyConfig(newEnemyConfig)
	enemyConfig = newEnemyConfig
	enemyHP = enemyConfig.startingHP
	enemyBLK = math.max(enemyConfig.startingBLK + enemyStartingBLKBonus, 0)
	enemyActions = enemyConfig.ready(round, enemyHP, enemyBLK)
	hasHeardEnemyVisualDescription = false
end

function getAssignedDiceIndexes(dice)
	local assignedIndexes = {}
	for index, die in ipairs(dice) do
		if (die.assignment) then
			table.insert(assignedIndexes, index)
		end
	end

	return assignedIndexes
end

function putDiceInBag(diceBagIndexes)
	for index, dieIndex in ipairs(diceBagIndexes) do
		local indexToInsert = math.random(1, #diceIndexBag + 1)
		table.insert(diceIndexBag, indexToInsert, dieIndex)
	end
end

function rollDiceFromBag()
	local diceBagIndex = table.remove(diceIndexBag, 1)
	local dieConfig = diceBag[diceBagIndex]

	-- roll the dieConfig (+ bonuses) to roll it for the tray
	local possibleMax = dieConfig.max + playerDiceCapBonus
	local possibleMin = math.min(dieConfig.min + playerDiceFloorBonus, possibleMax)
	local value = math.random(possibleMin, possibleMax)

	return {
		value = value,
		assignment = nil,
		diceBagIndex = diceBagIndex,
		dieConfig = dieConfig,
		canvas = Die.createCanvas(value)
	}
end

function confirmAttack()
	phase = 'removingDice'
	animationTimer = 0
	selectedDiceIndex = 0
end

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local gameDiceTrayCanvas = nil

-- confirm button canvas
local confirmButtonWidth, confirmButtonHeight = 180, 50
local confirmButtonCanvas = Button.canvas(confirmButtonWidth, confirmButtonHeight)

function GameScreen.load()
	screen = GameScreen.screen

	diceIndexBag = {}
	activeDice = {}
	for index, dieConfig in ipairs(diceBag) do
		putDiceInBag({index})
	end
	loadEnemyConfig(EnemyConfig.Centipede)

	-- reset values
	round = 1
	playerBLK = playerStartingBLK
	selectedDiceIndex = 0
	selectedCharacter = nil
	selectedRow = 'characters'
	animationTimer = 0
	phase = 'rollingDice'

	-- build tray canvas for the intro screen
	diceTrayWidth = 600
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, 4)
	gameDiceTrayCanvas = DiceTray.Canvas(diceTrayWidth, diceTrayHeight, false)

	tts.readCharactersPreview()
end

function GameScreen.update(dt)
	if screen ~= GameScreen.screen then return end
	if phase == '' then
		return
	end

	animationTimer = animationTimer + dt

	-- if we are resolving an enemy attack, wait for the timer and then apply effects
	if phase == 'resolvingEnemyAction' then
		if animationTimer > 0.6 then
			local currentAction = table.remove(enemyActions, 1)
			-- if the enemy is attacking
			if currentAction.type == 'ATK' then
				-- we have enough damage to go through block
				if currentAction.value - playerBLK > 0 then
					playerHP = playerHP - (currentAction.value - playerBLK)
					playerBLK = 0
				else
					playerBLK = playerBLK - currentAction.value
				end
			end

			-- if the enemy is doing something else
			if currentAction.type == 'DEF' then
				enemyBLK = enemyBLK + currentAction.value
			end

			-- reset the timer and set the dice to be rolling now
			animationTimer = 0

			if #enemyActions == 0 then
				phase = 'rollingDice'
				round = round + 1
				enemyActions = enemyConfig.ready(round, enemyHP, enemyBLK)

				selectedRow = 'characters'
				tts.readCharactersUpdate()
			end
		end
	end

	-- if we are actively adding new dice, roll new ones
	if phase == 'rollingDice' then
		if animationTimer > 0.3 then
			-- draw the top die from our available dice and reset the timer
			local newValue = rollDiceFromBag()
			table.insert(activeDice, 1, newValue)
			animationTimer = 0
		end
		if #activeDice == 4 then
			phase = ''
		end
	end

	-- if we are actively removing dice, pop off assigned dice
	if phase == 'removingDice' then
		local assignedDice = getAssignedDiceIndexes(activeDice)

		if animationTimer > 0.3 then
			local dieToRemove = activeDice[assignedDice[1]]
			local dieConfig = dieToRemove.dieConfig
			if dieConfig.resolveAssignment then
				dieConfig.resolveAssignment(dieToRemove)
			end

			-- if this is an attack die, remove block, then hp from enemy
			if dieToRemove.assignment == 'ATK' then
				-- we have enough damage to go through block
				if dieToRemove.value - enemyBLK > 0 then
					enemyHP = math.max(enemyHP - (dieToRemove.value - enemyBLK), 0)
					enemyBLK = 0
				else
					enemyBLK = enemyBLK - dieToRemove.value
				end
			end

			-- if this is a block die, add that to players block
			if dieToRemove.assignment == 'DEF' then
				playerBLK = playerBLK + dieToRemove.value
			end

			-- pop an element, and reset the timer
			table.remove(activeDice, assignedDice[1])
			putDiceInBag({dieToRemove.diceBagIndex})
			animationTimer = 0
		end
		if #assignedDice == 0 then
			-- apply all onSave effects to remaining dice
			for index, die in ipairs(activeDice) do
				if die.dieConfig.onSave then
					die.dieConfig.onSave(die)
				end
			end
			if enemyHP == 0 then
				phase = 'resolveBattle'
			else
				phase = 'resolvingEnemyAction'
			end
		end
	end

	if phase == 'resolveBattle' then
		if animationTimer > 1 then
			TransitionScreen.load(DicePackScreen, true)
		end
	end
end

function GameScreen.keypressed(key)
	if screen ~= GameScreen.screen then return end

	-- don't allow key actions if we are in the middle of resolving a phase
	if phase ~= '' then
		return
	end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'dice' then
			selectedCharacter = nil
			selectedRow = 'characters'
			tts.readCharactersPreview()

		elseif selectedRow == 'confirm' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readDiceTrayPreview()
		end
	end

	if key == 'down' then
		if selectedRow == 'characters' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readDiceTrayPreview()
		elseif selectedRow == 'dice' then
			selectedRow = 'confirm'
			tts.readDiceAssignment()
		end
	end

	-- change which character we are looking at
	if selectedRow == 'characters' then
		if key == 'left' then
			selectedCharacter = 'player'
			tts.readPlayerStatus()
		end
		if key == 'right' then
			selectedCharacter = 'enemy'
			tts.readEnemyStatus()
		end
	end

	-- change which die is selected
	if selectedRow == 'dice' then
		if key == 'left' then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDie()
		end
		if key == 'right' then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #activeDice)
			tts.readSelectedDie()
		end

		local selectedDie = activeDice[selectedDiceIndex]
		if selectedDie then
			if key == 'a' then
				selectedDie.assignment = 'ATK'
				tts.readAssignmentResult()
			end
			if key == 'd' then
				selectedDie.assignment = 'DEF'
				tts.readAssignmentResult()
			end
			if key == 'c' then
				selectedDie.assignment = nil
			end
		end
	end

	if selectedRow == 'confirm' then
		if key == 'x' then
			confirmAttack()
		end
	end

	-- hotkeys for getting player / enemy status
	if key == 'e' then
		tts.enemyPreview()
	end
	if key == 'q' then
		tts.playerPreview()
	end
end

function GameScreen.draw()
	if screen ~= GameScreen.screen then return end

	-- most of the controls here should be the same width, and left-aligned
	local width = 620
	local x = getXForWidth(620)

	-- player and enemy window
	Player.draw(selectedRow == 'characters' and selectedCharacter ~= 'enemy', playerHP, playerBLK)
	Enemy.draw(enemyConfig, selectedRow == 'characters' and selectedCharacter ~= 'player', enemyHP, enemyBLK, nil, enemyActions)

	-- draw the dice tray
	local diceTrayX = getXForWidth(diceTrayWidth) - 10
	local diceTrayY = 330
	DiceTray.draw(gameDiceTrayCanvas, diceTrayHeight, diceTrayX, diceTrayY, activeDice, selectedRow == 'dice' and selectedDiceIndex or nil, 4)

	-- draw the confirmation button
	local confirmButtonX, confirmButtonY = 575, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, selectedRow == 'confirm', 'Confirm')
end

return GameScreen
