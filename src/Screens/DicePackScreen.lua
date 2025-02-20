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
	for i=1,2 do
		local possibleDiceOptionIndex = math.random(1, #possibleDiceOptions)
		local dieConfigIndex = possibleDiceOptions[possibleDiceOptionIndex]
		local dieConfig = possibleDieConfigs[dieConfigIndex]
		table.remove(possibleDiceOptions, possibleDiceOptionIndex)
		local newDie = { value = dieConfig.max, assignment = nil, diceBagIndex = dieConfigIndex, dieConfig = dieConfig }

		table.insert(option, 1, newDie)
	end

	return option
end

local packOptions = {}

function DicePackScreen.load()
	screen = DicePackScreen.screen

	-- build sets of dice that the player can choose from
	possibleDiceOptions = {
		1, 1,
		2, 2,
		3, 3,
		4, 4,
		5, 5,
	}
	packOptions1 = buildDieConfigOption()
	packOptions2 = buildDieConfigOption()
	packOptions3 = buildDieConfigOption()

	selectedRow = 'intro'

	tts.readDicePackIntro()
end

function DicePackScreen.update(dt)
	if screen ~= DicePackScreen.screen then return end
end

function DicePackScreen.keypressed(key)
	if screen ~= DicePackScreen.screen then return end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'pack1' then
			selectedRow = 'intro'
			tts.readDicePackIntro()
		elseif selectedRow == 'pack2' then
			selectedDiceIndex = 0
			selectedRow = 'pack1'
			tts.readPackSummary(packOptions1, 1)
		elseif selectedRow == 'pack3' then
			selectedDiceIndex = 0
			selectedRow = 'pack2'
			tts.readPackSummary(packOptions2, 2)
		elseif selectedRow == 'skip' then
			selectedDiceIndex = 0
			selectedRow = 'pack3'
			tts.readPackSummary(packOptions3, 3)
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'pack1'
			tts.readPackSummary(packOptions1, 1)
		elseif selectedRow == 'pack1' then
			selectedDiceIndex = 0
			selectedRow = 'pack2'
			tts.readPackSummary(packOptions2, 2)
		elseif selectedRow == 'pack2' then
			selectedDiceIndex = 0
			selectedRow = 'pack3'
			tts.readPackSummary(packOptions3, 3)
		elseif selectedRow == 'pack3' then
			selectedRow = 'skip'
			tts.readSkipButton()
		end
	end

	-- determine if we are looking at a pack option (and which one specifically)
	local selectedPackOptions =
		selectedRow == 'pack1' and packOptions1 or
		selectedRow == 'pack2' and packOptions2 or
		selectedRow == 'pack3' and packOptions3 or nil

	local packIndex =
		selectedRow == 'pack1' and 1 or
		selectedRow == 'pack2' and 2 or
		selectedRow == 'pack3' and 3 or nil

	if selectedPackOptions then
		if key == 'left' then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 0)
			if selectedDiceIndex == 0 then
				tts.readPackSummary(selectedPackOptions, packIndex)
			else
				tts.readSelectedDiceConfig(selectedPackOptions[selectedDiceIndex].dieConfig)
			end
		end
		if key == 'right' then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #selectedPackOptions)
			tts.readSelectedDiceConfig(selectedPackOptions[selectedDiceIndex].dieConfig)
		end
		if key == 'x' then
			for index, die in ipairs(selectedPackOptions) do
				table.insert(diceBag, 1, die.dieConfig)
			end
			TransitionScreen.load(DiceBreakScreen, true)
		end
	end

	if selectedRow == 'skip' then
		if key == 'x' then
			TransitionScreen.load(DiceBreakScreen, true)
		end
	end
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
	DiceTray.draw(trayX, trayY + 0, trayWidth, packOptions1, selectedRow == 'pack1' and selectedDiceIndex or nil)
	DiceTray.draw(trayX, trayY + 125, trayWidth, packOptions2, selectedRow == 'pack2' and selectedDiceIndex or nil)
	DiceTray.draw(trayX, trayY + 250, trayWidth, packOptions3, selectedRow == 'pack3' and selectedDiceIndex or nil)

	Button.draw(600, 525, 180, 50, selectedRow == 'skip', 'Skip')
end

return DicePackScreen
