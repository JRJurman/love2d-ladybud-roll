local StageProgress = require('../Components/StageProgress')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')
local Button = require('../Components/Button')
local DieConfig = require('../Data/DieConfig')
local Die = require('../Components/Die')

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
		local newDie = {
			value = dieConfig.max,
			assignment = nil,
			diceBagIndex = dieConfigIndex,
			dieConfig = dieConfig,
			canvas = Die.createCanvas(dieConfig.max)
		}

		table.insert(option, 1, newDie)
	end

	return option
end

local packOptions = {}

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local dicePackCanvas = nil

-- skip button canvas
local skipButtonWidth, skipButtonHeight = 170, 50
local skipButtonCanvas = Button.createCanvas(skipButtonWidth, skipButtonHeight)

-- text block canvas
local textBlockWidth, textBlockHeight = 730, 115
local textBlockCanvas = Button.createCanvas(textBlockWidth, textBlockHeight)

function DicePackScreen.load()
	screen = DicePackScreen.screen

	breakMusic()

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

	diceTrayWidth = 200
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, 2)
	dicePackCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

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

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'pack2' then
			selectedDiceIndex = 0
			selectedRow = 'pack1'
			tts.readPackSummary(packOptions1, 1)

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'pack3' then
			selectedDiceIndex = 0
			selectedRow = 'pack2'
			tts.readPackSummary(packOptions2, 2)

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'skip' then
			selectedDiceIndex = 0
			selectedRow = 'pack3'
			tts.readPackSummary(packOptions3, 3)

			validKey = true
      selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'pack1'
			tts.readPackSummary(packOptions1, 1)

			validKey = true
      selectSFX()
		elseif selectedRow == 'pack1' then
			selectedDiceIndex = 0
			selectedRow = 'pack2'
			tts.readPackSummary(packOptions2, 2)

			validKey = true
      selectSFX()
		elseif selectedRow == 'pack2' then
			selectedDiceIndex = 0
			selectedRow = 'pack3'
			tts.readPackSummary(packOptions3, 3)

			validKey = true
      selectSFX()
		elseif selectedRow == 'pack3' then
			selectedRow = 'skip'
			tts.readSkipButton()

			validKey = true
      selectSFX()
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
		if key == 'left' and selectedDiceIndex > 0 then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 0)
			if selectedDiceIndex == 0 then
				tts.readPackSummary(selectedPackOptions, packIndex)
			else
				tts.readSelectedDiceConfig(selectedPackOptions[selectedDiceIndex].dieConfig)
			end

			validKey = true
      selectBackSFX()
		end
		if key == 'right' and selectedDiceIndex < #selectedPackOptions then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #selectedPackOptions)
			tts.readSelectedDiceConfig(selectedPackOptions[selectedDiceIndex].dieConfig)

			validKey = true
      selectSFX()
		end
		if key == 'x' then
			for index, die in ipairs(selectedPackOptions) do
				table.insert(diceBag, 1, die.dieConfig)
			end
			TransitionScreen.next()
			validKey = true
		end
	end

	if selectedRow == 'skip' then
		if key == 'x' then
			TransitionScreen.next()
			validKey = true
		end
	end
end

function DicePackScreen.draw()
	if screen ~= DicePackScreen.screen then return end

	-- hiding this until there is a more complete implementation and SR support
	-- StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockX = x
	local textBlockY = 0

	Button.draw(textBlockCanvas, textBlockX, textBlockY, textBlockWidth, textBlockHeight, 13, selectedRow == 'intro', TextBlocks.dicePacks)

	local trayX = x
	local trayY = 150
	DiceTray.draw(dicePackCanvas, diceTrayHeight, trayX, trayY + 0, packOptions1, selectedRow == 'pack1' and selectedDiceIndex or nil)
	DiceTray.draw(dicePackCanvas, diceTrayHeight, trayX, trayY + 125, packOptions2, selectedRow == 'pack2' and selectedDiceIndex or nil)
	DiceTray.draw(dicePackCanvas, diceTrayHeight, trayX, trayY + 250, packOptions3, selectedRow == 'pack3' and selectedDiceIndex or nil)

	local skipButtonX = 600
	local skipButtonY = 525
	local skipButtonWidth = 180
	Button.draw(skipButtonCanvas, skipButtonX, skipButtonY, skipButtonWidth, skipButtonHeight, 0, selectedRow == 'skip', 'Skip')
end

return DicePackScreen
