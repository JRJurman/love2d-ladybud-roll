local KeyInstruction = require('../Components/KeyInstruction')
local DieInstruction = require('../Components/DieInstruction')
local StageProgress = require('../Components/StageProgress')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')
local Button = require('../Components/Button')
local Die = require('../Components/Die')

local IntroScreen = {}
IntroScreen.screen = 4

-- dice set for rendering what's in our starting bag
local dice = {}

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local introDiceTrayCanvas = nil

-- confirm button canvas
local confirmButtonWidth, confirmButtonHeight = 170, 50
local confirmButtonCanvas = Button.createCanvas(confirmButtonWidth, confirmButtonHeight)

-- Title Text canvas
local titleTextWidth, titleTextHeight = 730, 200
local titleTextCanvas = Button.createCanvas(titleTextWidth, titleTextHeight)

function IntroScreen.load()
	screen = IntroScreen.screen
	stage = 1
	selectedRow = 'intro'
	selectedDiceIndex = 0

	dice = {}
	for index, dieConfig in ipairs(diceBag) do
		local newDie = {
			value = dieConfig.max,
			assignment = nil,
			diceBagIndex = index,
			dieConfig = dieConfig,
			canvas = Die.createCanvas(dieConfig.max)
		}
		table.insert(dice, newDie)
	end

	-- build tray canvas for the intro screen
	diceTrayWidth = 620
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, #dice)
	introDiceTrayCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

	-- read out the first intro box selection
	tts.readIntroLore()
end

function IntroScreen.update(dt)
	if screen ~= IntroScreen.screen then return end
end

function IntroScreen.keypressed(key)
	if screen ~= IntroScreen.screen then return end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'dice' then
			selectedRow = 'intro'
			tts.readIntroLore()

			validKey = true
			selectBackSFX()
		elseif selectedRow == 'begin' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readIntroDiceTray()

			validKey = true
			selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readIntroDiceTray()

			validKey = true
			selectSFX()
		elseif selectedRow == 'dice' then
			selectedRow = 'begin'
			tts.readBeginButton()

			validKey = true
			selectSFX()
		end
	end

	if selectedRow == 'dice' then
		if key == 'left' and selectedDiceIndex > 1 then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDiceConfig(diceBag[selectedDiceIndex])

			validKey = true
			selectBackSFX()
		end
		if key == 'right' and selectedDiceIndex < #dice then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #dice)
			tts.readSelectedDiceConfig(diceBag[selectedDiceIndex])

			validKey = true
			selectSFX()
		end
	end

	if selectedRow == 'begin' then
		if key == 'x' then
			TransitionScreen.next()
			validKey = true
		end
	end
end

function IntroScreen.draw()
	if screen ~= IntroScreen.screen then return end

	-- hiding this until there is a more complete implementation and SR support
	-- StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockY = 45
	Button.draw(titleTextCanvas, x, textBlockY, titleTextWidth, titleTextHeight, 20, selectedRow == 'intro', TextBlocks.introLore)

	local dieInstructionY = 290
	local dieInstructionWidth = 600
	local dieInstructionX = getXForWidth(dieInstructionWidth)
	if selectedDiceIndex > 0 then
		DieInstruction.draw(dieInstructionX, dieInstructionY, dieInstructionWidth, dice[selectedDiceIndex], true, 'buff')
	end

	local diceTrayX = getXForWidth(diceTrayWidth)
	local diceTrayY = 365
	DiceTray.draw(introDiceTrayCanvas, diceTrayHeight, diceTrayX, diceTrayY, dice, selectedRow == 'dice' and selectedDiceIndex or nil)

	local keyInstructionX = 45
	local keyInstructionY = 525
	local keyInstructionWidth = 536
	if selectedRow == 'intro' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F',  'to Preview Dice',true)
	elseif selectedRow == 'dice' then
		if (frame % 6) < 3 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'Q', 'to Scan Dice', true)
		else
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Begin',true)
		end
	elseif selectedRow == 'begin' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Begin', true)
	end

	local confirmButtonX, confirmButtonY = 580, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, confirmButtonHeight, 0, selectedRow == 'begin', 'Begin')
end

return IntroScreen
