local PositionFunctions = require('../Functions/PositionFunctions')

local DiceTray = require('../Components/DiceTray')
local FatRect = require('../Components/FatRect')
local Button = require('../Components/Button')
local Player = require('../Components/Player')
local Enemy = require('../Components/Enemy')

local EnemyConfig = require('../Data/EnemyConfig')
local PlayerConfig = require('../Data/PlayerConfig')

local GameScreen = {}
GameScreen.screen = 2

-- menu options
selectedDiceIndex = nil
selectedCharacter = nil
selectedRow = nil

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
	enemyBLK = enemyConfig.startingBLK
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
	local die = diceBag[diceBagIndex]

	-- roll the die to turn it something for the tray
	local value = math.random(die.min, die.max)

	return { value = value, assignment = nil, diceBagIndex = diceBagIndex }
end

function confirmAttack()
	phase = 'removingDice'
	animationTimer = 0
	selectedDiceIndex = 1
end

function GameScreen.load()
	screen = GameScreen.screen

	diceIndexBag = {}
	activeDice = {}
	for index, diceConfig in ipairs(diceBag) do
		putDiceInBag({index})
	end
	loadEnemyConfig(EnemyConfig.Sandbag)

	-- reset values
	round = 1
	selectedDiceIndex = 1
	selectedCharacter = 'enemy'
	selectedRow = 'characters'
	animationTimer = 0
	phase = 'rollingDice'
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
			local diceConfig = diceBag[dieToRemove.diceBagIndex]
			local totalValue = dieToRemove.value + diceConfig.resolve(dieToRemove.assignment, dieToRemove.value)

			-- if this is an attack die, remove block, then hp from enemy
			if dieToRemove.assignment == 'ATK' then
				-- we have enough damage to go through block
				if totalValue - enemyBLK > 0 then
					enemyHP = math.max(enemyHP - (totalValue - enemyBLK), 0)
					enemyBLK = 0
				else
					enemyBLK = enemyBLK - totalValue
				end
			end

			-- if this is a block die, add that to players block
			if dieToRemove.assignment == 'DEF' then
				playerBLK = playerBLK + totalValue
			end

			-- pop an element, and reset the timer
			table.remove(activeDice, assignedDice[1])
			putDiceInBag({dieToRemove.diceBagIndex})
			animationTimer = 0
		end
		if #assignedDice == 0 then
			if enemyHP == 0 then
				phase = 'resolveBattle' -- TODO IMPLEMENT THIS PHASE
			else
				phase = 'resolvingEnemyAction'
			end
		end
	end

	if phase == 'resolveBattle' then
		if animationTimer > 1 then
			TransitionScreen.load(MapScreen)
		end
	end
end

function GameScreen.keypressed(key)
	if screen ~= GameScreen.screen then return end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'dice' then
			selectedRow = 'characters'
		elseif selectedRow == 'confirm' then
			selectedRow = 'dice'
		end
	end
	if key == 'down' then
		if selectedRow == 'characters' then
			selectedRow = 'dice'
		elseif selectedRow == 'dice' then
			selectedRow = 'confirm'
		end
	end

	-- change which character we are looking at
	if selectedRow == 'characters' then
		if key == 'left' then
			selectedCharacter = 'player'
		end
		if key == 'right' then
			selectedCharacter = 'enemy'
		end
	end

	-- change which die is selected
	if selectedRow == 'dice' then
		if key == 'left' then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
		end
		if key == 'right' then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #activeDice)
		end

		local selectedDie = activeDice[selectedDiceIndex]
		if selectedDie then
			if key == 'a' then
				selectedDie.assignment = 'ATK'
			end
			if key == 'd' then
				selectedDie.assignment = 'DEF'
			end
			if key == 'c' then
				selectedDie.assignment = nil
			end
			if key == 'x' then
				-- rotate selectedDie.assignment
			end
		end
	end

	if selectedRow == 'confirm' then
		if key == 'x' then
			confirmAttack()
		end
	end
end

function GameScreen.draw()
	if screen ~= GameScreen.screen then return end

	-- most of the controls here should be the same width, and left-aligned
	local width = 620
	local x = PositionFunctions.getXForWidth(620)

	FatRect.draw(x, 66, width, 250, 3, {1,1,1}, {0,0,0}, selectedRow == 'characters')
	Player.draw(selectedRow == 'characters' and selectedCharacter == 'player', playerHP, playerBLK)
	Enemy.draw('Sandbag', selectedRow == 'characters' and selectedCharacter == 'enemy', enemyHP, enemyBLK, nil, enemyActions)

	-- draw the dice tray
	DiceTray.draw(x, 350, width, activeDice, diceBag, selectedRow == 'dice' and selectedDiceIndex or nil)

	-- draw the confirmation button
	Button.draw(x, 510, width, 40, 3, {1,1,1}, selectedRow == 'confirm', 'Confirm')
end

return GameScreen
