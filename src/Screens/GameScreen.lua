local DiceTray = require('../Components/DiceTray')
local FatRect = require('../Components/FatRect')
local Button = require('../Components/Button')
local Player = require('../Components/Player')
local Enemy = require('../Components/Enemy')

local DieConfig = require('../Data/DieConfig')

local GameScreen = {}
GameScreen.screen = 2

selectedDiceIndex = 1
selectedCharacter = 'enemy'
selectedRow = 'characters'
removingDice = false
animationTimer = 0
rollingDice = true

playerHP = 20
playerBLK = 2
enemyHP = 20
enemyBLK = 5

diceBag = {
	DieConfig.BlueDie,
	DieConfig.BlueDie,
	DieConfig.RedDie,
	DieConfig.RedDie,
	DieConfig.Ladybug,
}

diceIndexBag = {}
activeDice = {}

function printDiceIndexBag()
	print('DICE INDEX BAG')
	for index, dice in ipairs(diceIndexBag) do
		print('['..index..']: '..dice)
	end
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
	removingDice = true
	animationTimer = 0
	selectedDiceIndex = 1
end

function GameScreen.load()
	screen = GameScreen.screen
	for index, diceConfig in ipairs(diceBag) do
		putDiceInBag({index})
	end
end

function GameScreen.update(dt)
	if screen ~= GameScreen.screen then return end

	-- if we are actively adding new dice, roll new ones
	if rollingDice then
		animationTimer = animationTimer + dt
		if animationTimer > 0.3 then
			-- draw the top die from our available dice and reset the timer
			local newValue = rollDiceFromBag()
			table.insert(activeDice, 1, newValue)
			animationTimer = 0
		end
		if #activeDice == 4 then
			rollingDice = false
		end
	end

	-- if we are actively removing dice, pop off assigned dice
	if removingDice then
		local assignedDice = getAssignedDiceIndexes(activeDice)

		animationTimer = animationTimer + dt
		if animationTimer > 0.3 then
			local dieToRemove = activeDice[assignedDice[1]]
			local diceConfig = diceBag[dieToRemove.diceBagIndex]
			local totalValue = dieToRemove.value + diceConfig.resolve(dieToRemove.assignment, dieToRemove.value)

			-- if this is an attack die, remove block, then hp from enemy
			if dieToRemove.assignment == 'ATK' then
				-- we have enough damage to go through block
				if totalValue - enemyBLK > 0 then
					enemyHP = enemyHP - (totalValue - enemyBLK)
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
			printDiceIndexBag()
			animationTimer = 0
		end
		if #assignedDice == 0 then
			removingDice = false
			rollingDice = true
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

	-- draw the player / enemy
	local characterBorder = selectedRow == 'characters' and {1,1,1} or {0.7, 0.7, 0.7}
	FatRect.draw(100, 66, 620, 250, 3, characterBorder, {0,0,0})
	Player.draw(selectedRow == 'characters' and selectedCharacter == 'player', playerHP, playerBLK)
	Enemy.draw('Sandbag', selectedRow == 'characters' and selectedCharacter == 'enemy', enemyHP, enemyBLK)

	-- draw the dice tray
	DiceTray.draw(100, 350, activeDice, diceBag, selectedRow == 'dice' and selectedDiceIndex or nil)

	-- draw the confirmation button
	Button.draw(100, 510, 620, 40, 3, {0.7, 0.7, 0.7}, {1,1,1}, selectedRow == 'confirm', 'Confirm')
end

return GameScreen
