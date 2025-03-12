local KeyInstruction = require('../Components/KeyInstruction')
local StageProgress = require('../Components/StageProgress')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')
local Button = require('../Components/Button')
local Die = require('../Components/Die')

local VictoryScreen = {}
VictoryScreen.screen = 7

-- dice set for rendering what's in our starting bag
local dice = {}

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local introDiceTrayCanvas = nil

-- confirm button canvas
local confirmButtonWidth, confirmButtonHeight = 195, 50
local confirmButtonCanvas = Button.createCanvas(confirmButtonWidth, confirmButtonHeight)

-- Title Text canvas
local titleTextWidth, titleTextHeight = 730, 200
local titleTextCanvas = Button.createCanvas(titleTextWidth, titleTextHeight)

function VictoryScreen.load()
	screen = VictoryScreen.screen
	selectedRow = 'intro'
	introMusic()

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

	brokenDice = {}
	for index, dieConfig in ipairs(brokenDiceBag) do
		local newDie = {
			value = 0,
			assignment = nil,
			diceBagIndex = index,
			dieConfig = dieConfig,
			canvas = Die.createCanvas(0)
		}
		table.insert(brokenDice, newDie)
	end

	-- build tray canvas for the victory screen
	diceTrayWidth = 620
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, #dice)
	introDiceTrayCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

	-- build broken dice tray canvas
	brokenDiceTrayWidth = 360
	brokenDiceTrayHeight = DiceTray.getHeight(brokenDiceTrayWidth, math.max(#brokenDice, 4))
	brokenDiceTrayCanvas = DiceTray.createCanvas(brokenDiceTrayWidth, brokenDiceTrayHeight, false)

	-- read out the first intro box selection
	tts.readVictoryScreen()
end

function VictoryScreen.update(dt)
	if screen ~= VictoryScreen.screen then return end
end

function VictoryScreen.keypressed(key)
	if screen ~= VictoryScreen.screen then return end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'broken' then
			selectedRow = 'intro'
			tts.readVictoryScreen()

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'dice' then
			selectedRow = 'broken'
			tts.readBrokenDiceTray()

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'again' then
			selectedRow = 'dice'
			tts.readDiceTray()

			validKey = true
      selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedRow = 'broken'
			tts.readBrokenDiceTray()

			validKey = true
      selectSFX()
		elseif selectedRow == 'broken' then
			selectedRow = 'dice'
			tts.readDiceTray()

			validKey = true
      selectSFX()
		elseif selectedRow == 'dice' then
			selectedRow = 'again'
			tts.readPlayAgainButton()

			validKey = true
      selectSFX()
		end
	end

	if selectedRow == 'again' then
		if key == 'x' then
			runs = runs + 1
			playerHP = playerMaxHP
			TransitionScreen.load(IntroScreen, false)
			validKey = true
		end
	end
end

function VictoryScreen.draw()
	if screen ~= VictoryScreen.screen then return end

	-- hiding this until there is a more complete implementation and SR support
	-- StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockY = 45
	Button.draw(titleTextCanvas, x, textBlockY, titleTextWidth, titleTextHeight, 20, selectedRow == 'intro', TextBlocks.victory)

	local brokenDiceTrayX = getXForWidth(brokenDiceTrayWidth)
	local brokenDiceTrayY = 285
	DiceTray.draw(brokenDiceTrayCanvas, brokenDiceTrayHeight, brokenDiceTrayX, brokenDiceTrayY, brokenDice, selectedRow == 'broken' and 0)

	local diceTrayX = getXForWidth(diceTrayWidth)
	local activeDiceTrayY = 400
	DiceTray.draw(introDiceTrayCanvas, diceTrayHeight, diceTrayX, activeDiceTrayY, dice, selectedRow == 'dice' and 0)

	local keyInstructionX = 45
	local keyInstructionY = 525
	local keyInstructionWidth = 536
	if selectedRow == 'intro' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F',  'to Preview Dice',true)
	elseif selectedRow == 'broken' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F',  'to Preview Dice',true)
	elseif selectedRow == 'dice' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Continue',true)
	elseif selectedRow == 'again' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Continue', true)
	end

	local confirmButtonX, confirmButtonY = 575, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, confirmButtonHeight, 0, selectedRow == 'again', 'Continue')
end

return VictoryScreen
