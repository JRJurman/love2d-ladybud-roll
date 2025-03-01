local DieInstruction = require('../Components/DieInstruction')
local KeyInstruction = require('../Components/KeyInstruction')
local StageProgress = require('../Components/StageProgress')
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

-- text block canvas
local textBlockWidth, textBlockHeight = 730, 115
local textBlockCanvas = Button.createCanvas(textBlockWidth, textBlockHeight)

function DiceBreakScreen.load()
	screen = DiceBreakScreen.screen
	selectedRow = 'intro'
	selectedDiceIndex = 0

	breakMusic()

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

			validKey = true
      selectBackSFX()
		elseif selectedRow == 'skip' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readBreakDiceTray()

			validKey = true
      selectBackSFX()
		end
	end

	if key == 'down' then
		if selectedRow == 'intro' then
			selectedDiceIndex = 0
			selectedRow = 'dice'
			tts.readBreakDiceTray()

			validKey = true
      selectSFX()
		elseif selectedRow == 'dice' then
			selectedRow = 'skip'
			tts.readSkipButton()

			validKey = true
      selectSFX()
		end
	end

	if selectedRow == 'dice' then
		if key == 'left' and selectedDiceIndex > 1 then
			selectedDiceIndex = math.max(selectedDiceIndex - 1, 1)
			tts.readSelectedDiceConfigAndBreakBuff(diceBag[selectedDiceIndex])

			validKey = true
      selectBackSFX()
		end
		if key == 'right' and selectedDiceIndex < #dice then
			selectedDiceIndex = math.min(selectedDiceIndex + 1, #dice)
			tts.readSelectedDiceConfigAndBreakBuff(diceBag[selectedDiceIndex])

			validKey = true
      selectSFX()
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

function DiceBreakScreen.draw()
	if screen ~= DiceBreakScreen.screen then return end

	-- hiding this until there is a more complete implementation and SR support
	-- StageProgress.draw()

	local width = 730
	local x = getXForWidth(width)

	local textBlockX = x
	local textBlockY = 0

	Button.draw(textBlockCanvas, textBlockX, textBlockY, textBlockWidth, textBlockHeight, 13, selectedRow == 'intro', TextBlocks.diceBreak)

	local dieInstructionY = 195
	local dieInstructionWidth = 600
	local dieInstructionHeight = 80
	local dieInstructionX = getXForWidth(dieInstructionWidth)
	if selectedDiceIndex > 0 then
		DieInstruction.draw(dieInstructionX, dieInstructionY, dieInstructionWidth, dieInstructionHeight, dice[selectedDiceIndex], false, 'brokenBuff')
	end

	local diceTrayX = x
	local diceTrayY = 320
	DiceTray.draw(diceBreakCanvas, diceTrayHeight, diceTrayX, diceTrayY, dice, selectedRow == 'dice' and selectedDiceIndex or nil)

	local keyInstructionX = 45
	local keyInstructionY = 525
	local keyInstructionWidth = 500
	if selectedRow == 'intro' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Scan Dice', true)
	elseif selectedDiceIndex then
		if (frame % 12) < 4 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'F', 'to Skip', true)
		elseif (frame % 12) < 8 then
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'Q', 'to Scan Dice', true)
		else
			KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Break Die', true)
		end
	elseif selectedRow == 'skip' then
		KeyInstruction.draw(keyInstructionX, keyInstructionY, keyInstructionWidth, 'x', 'to Skip', true)
	end

	local skipButtonX, skipButtonY = 580, 510
	Button.draw(skipButtonCanvas, skipButtonX, skipButtonY, skipButtonWidth, skipButtonHeight, 0, selectedRow == 'skip', 'Skip')
end

return DiceBreakScreen
