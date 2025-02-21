local StageProgress = require('../Components/StageProgress')
local TextAndGraphic = require('../Components/TextAndGraphic')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')
local Button = require('../Components/Button')
local Die = require('../Components/Die')

local DiceBreakScreen = {}
DiceBreakScreen.screen = 6

-- dice set for rendering what's in our starting bag
local dice = {}

-- dice tray canvas variables (which we only want to create on load)
local diceTrayWidth = nil
local diceTrayHeight = nil
local diceBreakCanvas = nil

-- skip button canvas
local skipButtonWidth, skipButtonHeight = 170, 50
local skipButtonCanvas = Button.createCanvas(skipButtonWidth, skipButtonHeight)

function DiceBreakScreen.load()
	screen = DiceBreakScreen.screen
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

	diceTrayWidth = 730
	diceTrayHeight = DiceTray.getHeight(diceTrayWidth, #dice)
	diceBreakCanvas = DiceTray.createCanvas(diceTrayWidth, diceTrayHeight, false)

	-- read out the first box selection
	tts.readDiceBreakIntro()
end

function DiceBreakScreen.update(dt)
	if screen ~= DiceBreakScreen.screen then return end
end

function DiceBreakScreen.keypressed(key)
	if screen ~= DiceBreakScreen.screen then return end

	-- change which set of elements we are selecting
	if key == 'up' then
		if selectedRow == 'dice' then
			selectedRow = 'intro'
			tts.readDiceBreakIntro()
		elseif selectedRow == 'skip' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readBreakDiceTray()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readBreakDiceTray()
		elseif selectedRow == 'dice' then
			selectedRow = 'skip'
			tts.readSkipButton()
		end
	end

	if selectedRow == 'dice' then
		if key == 'left' then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDiceConfigAndBreakBuff(diceBag[selectedDiceIndex])
		end
		if key == 'right' then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #dice)
			tts.readSelectedDiceConfigAndBreakBuff(diceBag[selectedDiceIndex])
		end
	end

	if selectedRow == 'dice' and selectedDiceIndex > 0 then
		if key == 'x' then
			tts.breakSelectedDice(diceBag[selectedDiceIndex])

			-- check if this die has an onBreaking ability
			-- we still allow removing dice that don't
			if (diceBag[selectedDiceIndex].onBreaking) then
				diceBag[selectedDiceIndex].onBreaking()
			end

			table.remove(diceBag, selectedDiceIndex)
			TransitionScreen.load(GameScreen, true)
		end
	end

	if selectedRow == 'skip' then
		if key == 'x' then
			TransitionScreen.load(GameScreen, true)
		end
	end
end

function DiceBreakScreen.draw()
	if screen ~= DiceBreakScreen.screen then return end

	StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockHeight = 240
	local textBlockY = 110
	TextAndGraphic.draw(x, textBlockY, width, textBlockHeight, {1,1,1}, selectedRow == 'intro', TextBlocks.diceBreak, 330)

	local diceTrayX = x
	local diceTrayY = 365
	DiceTray.draw(diceBreakCanvas, diceTrayHeight, diceTrayX, diceTrayY, dice, selectedRow == 'dice' and selectedDiceIndex or nil)

	local skipButtonX, skipButtonY = 580, 510
	Button.draw(skipButtonCanvas, skipButtonX, skipButtonY, skipButtonWidth, selectedRow == 'skip', 'Skip')
end

return DiceBreakScreen
