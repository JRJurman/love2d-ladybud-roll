local StageProgress = require('../Components/StageProgress')
local TextAndGraphic = require('../Components/TextAndGraphic')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')
local Button = require('../Components/Button')
local DieConfig = require('../Data/DieConfig')

local DicePackScreen = {}
DicePackScreen.screen = 5

local possibleDieConfigs = {
	DieConfig.BlueDie,
	DieConfig.RedDie,
	DieConfig.GreenDie,
	DieConfig.WhiteDie,
	DieConfig.YellowDie,
}

local possibleDiceOptions = {}

function buildDieConfigOption()
	local option = {}
	for i=1,3 do
		local possibleDiceOptionIndex = math.random(1, #possibleDiceOptions)
		local dieConfigIndex = possibleDiceOptions[possibleDiceOptionIndex]
		local dieConfig = possibleDieConfigs[dieConfigIndex]
		table.remove(possibleDiceOptions, possibleDiceOptionIndex)
		local newDie = { value = dieConfig.max, assignment = nil, diceBagIndex = dieConfigIndex, dieConfig = dieConfig }

		table.insert(option, 1, newDie)
	end

	print(option)
	return option
end

local prizeOptions = {}

function DicePackScreen.load()
	screen = DicePackScreen.screen

	-- build sets of dice that the player can choose from
	possibleDiceOptions = {
		1, 1, 1,
		2, 2, 2,
		3, 3, 3,
		4, 4, 4,
		5, 5, 5,
	}
	prizeOptions1 = buildDieConfigOption()
	prizeOptions2 = buildDieConfigOption()
	prizeOptions3 = buildDieConfigOption()
end

function DicePackScreen.update(dt)
	if screen ~= DicePackScreen.screen then return end
end

function DicePackScreen.keypressed(key)
	if screen ~= DicePackScreen.screen then return end
end

function DicePackScreen.draw()
	if screen ~= DicePackScreen.screen then return end

	StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockY = 100
	local textBlockHeight = 85

	TextAndGraphic.draw(x, textBlockY, width, textBlockHeight, {1,1,1}, selectedRow == 'intro', TextBlocks.dicePacks, 0)

	local trayWidth = 320
	local trayX = x
	local trayY = textBlockY + textBlockHeight + 5
	DiceTray.draw(trayX, trayY + 0, trayWidth, prizeOptions1, selectedRow == 'prize1' and selectedDiceIndex or nil)
	DiceTray.draw(trayX, trayY + 125, trayWidth, prizeOptions2, selectedRow == 'prize2' and selectedDiceIndex or nil)
	DiceTray.draw(trayX, trayY + 250, trayWidth, prizeOptions3, selectedRow == 'prize3' and selectedDiceIndex or nil)

	Button.draw(600, 525, 180, 50, {1,1,1}, selectedRow == 'skip', 'Skip')
end

return DicePackScreen
