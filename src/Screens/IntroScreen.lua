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
local titleTextWidth, titleTextHeight = 730, 240
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
		elseif selectedRow == 'begin' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readIntroDiceTray()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readIntroDiceTray()
		elseif selectedRow == 'dice' then
			selectedRow = 'begin'
			tts.readBeginButton()
		end
	end

	if selectedRow == 'dice' then
		if key == 'left' then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDiceConfig(diceBag[selectedDiceIndex])
		end
		if key == 'right' then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #dice)
			tts.readSelectedDiceConfig(diceBag[selectedDiceIndex])
		end
	end

	if selectedRow == 'begin' then
		if key == 'x' then
			TransitionScreen.load(GameScreen, true)
		end
	end
end

function IntroScreen.draw()
	if screen ~= IntroScreen.screen then return end

	StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockY = 90
	Button.draw(titleTextCanvas, x, textBlockY, titleTextWidth, titleTextHeight, 40, selectedRow == 'intro', TextBlocks.introLore)

	local diceTrayX = getXForWidth(diceTrayWidth)
	local diceTrayY = 365
	DiceTray.draw(introDiceTrayCanvas, diceTrayHeight, diceTrayX, diceTrayY, dice, selectedRow == 'dice' and selectedDiceIndex or nil)

	local confirmButtonX, confirmButtonY = 580, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, confirmButtonHeight, 0, selectedRow == 'begin', 'Begin')
end

return IntroScreen
