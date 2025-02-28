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
local confirmButtonWidth, confirmButtonHeight = 170, 50
local confirmButtonCanvas = Button.createCanvas(confirmButtonWidth, confirmButtonHeight)

-- Title Text canvas
local titleTextWidth, titleTextHeight = 730, 200
local titleTextCanvas = Button.createCanvas(titleTextWidth, titleTextHeight)

function VictoryScreen.load()
	screen = VictoryScreen.screen
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

	-- build tray canvas for the victory screen
	diceTrayWidth = 620
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, #dice)
	introDiceTrayCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

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
		if selectedRow == 'dice' then
			selectedRow = 'intro'
			tts.readVictoryScreen()

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'again' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readDiceTray()

			validKey = true
      selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
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
			TransitionScreen.load(TitleScreen, false)
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

	local diceTrayX = getXForWidth(diceTrayWidth)
	local diceTrayY = 365
	DiceTray.draw(introDiceTrayCanvas, diceTrayHeight, diceTrayX, diceTrayY, dice, selectedRow == 'dice' and selectedDiceIndex or nil)

	local keyInstructionX = 45
	local keyInstructionY = 525
	local keyInstructionWidth = 536
	if selectedRow == 'intro' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F',  'to Preview Dice',true)
	elseif selectedRow == 'dice' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Restart',true)
	elseif selectedRow == 'again' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Restart', true)
	end

	local confirmButtonX, confirmButtonY = 580, 510
	Button.draw(confirmButtonCanvas, confirmButtonX, confirmButtonY, confirmButtonWidth, confirmButtonHeight, 0, selectedRow == 'again', 'Restart')
end

return VictoryScreen
