local DieInstruction = require('../Components/DieInstruction')
local KeyInstruction = require('../Components/KeyInstruction')
local DiceTray = require('../Components/DiceTray')
local FatRect = require('../Components/FatRect')
local Button = require('../Components/Button')
local Player = require('../Components/Player')
local Enemy = require('../Components/Enemy')
local Die = require('../Components/Die')

local PlayerConfig = require('../Data/PlayerConfig')
local EnemyOrder = require('../Data/EnemyOrder')

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

-- last action results
playerTotalATK = nil
playerTotalDEF = nil

local rollingSpeed = 0.3
local resolutionSpeed = 1

function loadEnemyConfig(newEnemyConfig)
	enemyConfig = newEnemyConfig
	enemyHP = enemyConfig.startingHP + stage*2
	enemyBLK = math.max(enemyConfig.startingBLK + enemyStartingBLKBonus + stage*2, 0)
	enemyActions = enemyConfig.ready(round, enemyHP, enemyBLK)
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
	playerTotalATK = 0
	playerTotalDEF = 0
	selectedCharacter = nil
end

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local gameDiceTrayCanvas = nil

-- confirm button canvas
local confirmButtonWidth, confirmButtonHeight = 180, 50
local confirmButtonCanvas = Button.createCanvas(confirmButtonWidth, confirmButtonHeight)

function GameScreen.load()
	screen = GameScreen.screen

	battleMusic()

	-- reset values
	round = 1
	playerBLK = playerStartingBLK
	selectedDiceIndex = 0
	selectedCharacter = nil
	selectedRow = 'characters'
	animationTimer = 0
	phase = 'rollingDice'
	diceIndexBag = {}
	activeDice = {}

	for index, dieConfig in ipairs(diceBag) do
		putDiceInBag({index})
	end
	loadEnemyConfig(EnemyOrder[stage])

	-- build tray canvas for the intro screen
	diceTrayWidth = 600
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, 4)
	gameDiceTrayCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

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
		if animationTimer > resolutionSpeed then
			-- if the enemy is done attacking
			if #enemyActions == 0 then
				-- if the player died, go to resolving
				if playerHP == 0 then
					phase = 'resolveBattle'
				else
					phase = 'rollingDice'
					round = round + 1
					enemyActions = enemyConfig.ready(round, enemyHP, enemyBLK)

					selectedRow = 'characters'
					tts.readCharactersUpdate()
				end
			else
				local currentAction = table.remove(enemyActions, 1)
				-- if the enemy is attacking
				if currentAction.type == 'ATK' then
					-- we have enough damage to go through block
					if currentAction.value - playerBLK > 0 then
						playerHP = math.max(playerHP - (currentAction.value - playerBLK), 0)
						playerBLK = 0
					else
						playerBLK = playerBLK - currentAction.value
					end
					attackSFX()
					tts.readEnemyAttack(currentAction)
				end

				-- if the enemy is doing something else
				if currentAction.type == 'DEF' then
					enemyBLK = math.min(enemyBLK + currentAction.value, 99)
					blockSFX()
					tts.readEnemyGuard(currentAction)
				end
			end

			-- reset the timer and set the dice to be rolling now
			animationTimer = 0
		end
	end

	-- if we are actively adding new dice, roll new ones
	if phase == 'rollingDice' then
		if animationTimer > rollingSpeed then
			-- draw the top die from our available dice and reset the timer
			local newValue = rollDiceFromBag()
			rollSFX()
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

		if animationTimer > resolutionSpeed then
			-- if we've finished resolving all our dice
			if #assignedDice == 0 then
				-- apply all onSave effects to remaining dice
				for index, die in ipairs(activeDice) do
					if die.dieConfig.onSave then
						die.dieConfig.onSave(die)
					end
				end

				-- check if the enemy has been defeated
				if enemyHP == 0 then
					phase = 'resolveBattle'
					tts.readEnemyDefeated()
				else
					phase = 'resolvingEnemyAction'
					tts.readEnemyActionStart()
				end
			else
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
					playerTotalATK = playerTotalATK + dieToRemove.value
					attackSFX()
					tts.readAttack(dieToRemove)
				end

				-- if this is a block die, add that to players block
				if dieToRemove.assignment == 'DEF' then
					playerBLK = math.min(playerBLK + dieToRemove.value, 99)
					playerTotalDEF = playerTotalDEF + dieToRemove.value
					blockSFX()
					tts.readBlock(dieToRemove)
				end

				-- pop an element, and reset the timer
				table.remove(activeDice, assignedDice[1])
				putDiceInBag({dieToRemove.diceBagIndex})
			end
			animationTimer = 0
		end
	end

	if phase == 'resolveBattle' then
		if animationTimer > 1 then
			-- if we have 0 hp, we lost
			if (playerHP == 0) then
				TransitionScreen.load(GameOverScreen, false)
			end
			-- if we won, advance to whatever the next stage is
			if (enemyHP == 0) then
				TransitionScreen.next()
			end
		end
	end
end

function GameScreen.keypressed(key)
	if screen ~= GameScreen.screen then return end

	-- don't allow key actions if we are in the middle of resolving a phase
	if phase ~= '' then
		invalidSelectSFX()
		return
	end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'dice' then
			selectedCharacter = nil
			selectedRow = 'characters'
			tts.readCharactersPreview()

			validKey = true
			selectBackSFX()
		elseif selectedRow == 'confirm' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readDiceTrayPreview()

			validKey = true
			selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'characters' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readDiceTrayPreview()

			validKey = true
			selectSFX()
		elseif selectedRow == 'dice' then
			selectedRow = 'confirm'
			tts.readDiceAssignment()

			validKey = true
			selectSFX()
		end
	end

	-- change which character we are looking at
	if selectedRow == 'characters' then
		if key == 'left' and selectedCharacter ~= 'player' then
			selectedCharacter = 'player'
			tts.readPlayerStatus()

			validKey = true
			selectSFX()
		end
		if key == 'right' and selectedCharacter ~= 'enemy' then
			selectedCharacter = 'enemy'
			tts.readEnemyStatus()

			validKey = true
			selectSFX()
		end
	end

	-- change which die is selected
	if selectedRow == 'dice' then
		if key == 'left' and selectedDiceIndex == 1 then
			selectedDiceIndex = 0
			tts.readDiceTrayPreview()

			validKey = true
			selectBackSFX()
		end
		if key == 'left' and selectedDiceIndex > 1 then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDie()

			validKey = true
			selectBackSFX()
		end
		if key == 'right' and selectedDiceIndex < #activeDice then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #activeDice)
			tts.readSelectedDie()

			validKey = true
			selectSFX()
		end

		local selectedDie = activeDice[selectedDiceIndex]
		if selectedDie then
			if key == 'a' then
				selectedDie.assignment = 'ATK'
				tts.readAssignmentResult('ATK')

				validKey = true
				assignAttackSFX()
			end
			if key == 'd' then
				selectedDie.assignment = 'DEF'
				tts.readAssignmentResult('DEF')

				validKey = true
				assignBlockSFX()
			end
			if key == 'c' then
				selectedDie.assignment = nil
				tts.readClearAssignment()

				validKey = true
				assignClearSFX()
			end
		end
	end

	if selectedRow == 'confirm' then
		if key == 'x' then
			confirmAttack()

			validKey = true
			animationTimer = resolutionSpeed / 2
			confirmSFX()
		end
	end

	-- hotkeys for getting player / enemy status
	if key == 'e' then
		tts.enemyPreview()

		validKey = true
	end
	if key == 'q' then
		tts.playerPreview()

		validKey = true
	end
end

function GameScreen.draw()
	if screen ~= GameScreen.screen then return end

	-- most of the controls here should be the same width, and left-aligned
	local width = 620
	local x = getXForWidth(620)

	-- player and enemy window
	Player.draw(selectedRow == 'characters' and selectedCharacter ~= 'enemy', playerHP, playerBLK)
	Enemy.draw(enemyConfig, selectedRow == 'characters' and selectedCharacter ~= 'player', enemyHP, enemyBLK, enemyActions)

	local dieInstructionY = 290
	local dieInstructionWidth = 600
	local dieInstructionHeight = 50
	local dieInstructionX = getXForWidth(dieInstructionWidth)
	if selectedRow == 'dice' and selectedDiceIndex > 0 and activeDice[selectedDiceIndex].dieConfig.buff then
		DieInstruction.draw(dieInstructionX, dieInstructionY, dieInstructionWidth, dieInstructionHeight, activeDice[selectedDiceIndex], false, 'buff')
	end

	-- draw the dice tray
	local diceTrayX = getXForWidth(diceTrayWidth) - 10
	local diceTrayY = 345
	DiceTray.draw(gameDiceTrayCanvas, diceTrayHeight, diceTrayX, diceTrayY, activeDice, selectedRow == 'dice' and selectedDiceIndex or nil, 4)

	local keyInstructionX = 45
	local keyInstructionY = 525
	local keyInstructionWidth = 536
	if selectedRow == 'characters' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Select Dice', true)
	elseif selectedRow == 'dice' and selectedDiceIndex == 0 then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'Q', 'to Select Dice', true)
	elseif selectedRow == 'dice' and selectedDiceIndex > 0 then
		if (frame % 16) < 4 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'a', 'for Attacking', true)
		elseif (frame % 16) < 8 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'd', 'for Defending', true)
		elseif (frame % 16) < 12 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'c', 'to Clear', true)
		else
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Confirm', true)
		end
	elseif selectedRow == 'confirm' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Confirm', true)
	end

	-- draw the confirmation button
	local confirmButtonX, confirmButtonY = 575, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, confirmButtonHeight, 0, selectedRow == 'confirm', 'Confirm')
end

return GameScreen
