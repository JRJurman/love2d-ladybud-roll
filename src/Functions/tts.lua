local TextBlocks = require('Data/TextBlocks')

local tts = {}
ttsText = ''
ttsInstructions = ''
repeatingText = 0

function printTTS()
	local text = ttsText:gsub("\n", " ")
	print('tts: '..text)
end

function indexToPlace(index)
	if index == 1 then
		return '1st'
	end
	if index == 2 then
		return '2nd'
	end
	if index == 3 then
		return '3rd'
	end
	-- if the number ends in 1, then it is '-st', otherwise '-th'
	-- fun fact, voice over will read 21th as 21st, but it is unclear
	-- if all screen readers behave this way
	if index % 10 == 1 then
		return tostring(index)..'st'
	else
		return tostring(index)..'th'
	end
end

-- repeat at any time
function tts.repeatText()
	print('tts: repeating...')
	repeatingText = 0.5
end

-- repeat instructions at any time
function tts.repeatInstructions()
	if ttsText == ttsInstructions then
		tts.repeatText()
	else
		ttsText = ttsInstructions
		printTTS()
	end
end

-- title screen
function tts.readTitleScreen()
	ttsText = 'Lady-Bud Roll, created by Jesse Jurman, art by Ethan Jurman. Press X key to start. Press R key to repeat screen reader text. Press Z key to repeat instructions. Press M key to mute music. Press 0 through 9 keys to adjust volume. Press F key to swap fonts. Press T key to disable animations. Press R key at any time to repeat screen reader text.'
	ttsInstructions = 'Press X key to start'
	printTTS()
end

-- intro screen

function tts.readIntroLore()
	ttsInstructions = ' Press down to preview dice.'
	ttsText = TextBlocks.introLore..ttsInstructions
	printTTS()
end

function tts.readIntroDiceTray()
	local diceReadout = 'Your starting '..#diceBag..' dice. '
	ttsInstructions = 'Press right to learn more about each die. Press down to begin your adventure.'
	ttsText = diceReadout..ttsInstructions
	printTTS()
end

function tts.readSelectedDiceConfig(dieConfig)
	local dieConfigTitle = indexToPlace(selectedDiceIndex)..', a '..dieConfig.label..'. '
	local dieConfigMinMax = 'The range of values on this die are '..dieConfig.min..' to '..dieConfig.max..'. '
	local dieConfigBuff = ''
	if dieConfig.buff then
		dieConfigBuff = 'In combat, this die '..dieConfig.buff
	end
	ttsText = dieConfigTitle..dieConfigMinMax..dieConfigBuff
	printTTS()
end

function tts.readBeginButton()
	ttsInstructions = 'Begin Button: Press X key to start.'
	ttsText = ttsInstructions
	printTTS()
end

-- dice pack screen

function tts.readDicePackIntro()
	local packIntro = ' There are three packs, each with two dice. '
	ttsInstructions = 'Press down to preview the dice, and press X on one pack to add it to your own.'
	ttsText = TextBlocks.dicePacks..packIntro..ttsInstructions
	printTTS()
end

function tts.readPackSummary(selectedPackOptions, packIndex)
	local packText = 'The '..indexToPlace(packIndex)..' pack: '
	-- note - the join here is in-part expecting packs of two dice;
	-- changes would need to be made and tested for larger dice packs
	for index, die in ipairs(selectedPackOptions) do
		if index > 1 then
			previousDieLabel = selectedPackOptions[index - 1].dieConfig.label
			-- if this is the same as the last die, add 'another' to the readout
			if previousDieLabel == die.dieConfig.label then
				packText = packText..' and another '..die.dieConfig.label
			else
				packText = packText..' and a '..die.dieConfig.label
			end
		else
			packText = packText..'a '..die.dieConfig.label
		end
	end
	packText = packText..'. '

	local instructions = 'Press X to select this pack, or right to get more details on each die. '
	if packIndex == 1 then
		instructions = instructions..'There are two more packs to choose from, you can press down to check other options, or go to the bottom to skip.'
	end
	ttsInstructions = instructions
	ttsText = packText..ttsInstructions
	printTTS()
end

function tts.readSkipButton()
	ttsInstructions = 'Skip Button: press X to skip and go to the next battle'
	ttsText = ttsInstructions
	printTTS()
end

function tts.packSelected()
	ttsText = 'Pack Selected'
	printTTS()
end

-- dice break screen

function tts.readDiceBreakIntro()
	ttsInstructions = ' Press down to look at your dice and the different buffs.'
	ttsText = TextBlocks.diceBreak..ttsInstructions
	printTTS()
end

function tts.readBreakDiceTray()
	local diceReadout = 'Your '..#diceBag..' dice. '
	ttsInstructions = 'Press right to learn what breaking the die would do. Press down if you want to skip destroying a die.'
	ttsText = diceReadout..ttsInstructions
	printTTS()
end

function tts.readSelectedDiceConfigAndBreakBuff(dieConfig)
	local dieConfigTitle = indexToPlace(selectedDiceIndex)..', a '..dieConfig.label..'. '
	local dieConfigBuff = ''
	if dieConfig.brokenBuff then
		dieConfigBuff = 'When broken this die '..dieConfig.brokenBuff..'. '
	else
		dieConfigBuff = 'This die has no benefit when broken.'
	end
	local instructions = ''
	if selectedDiceIndex == 1 then
		instructions = 'Press X to destroy this die and get this buff, or right to scan more dice. '
		ttsInstructions = instructions
	end
	ttsText = dieConfigTitle..dieConfigBuff..instructions
	printTTS()
end

function tts.breakSelectedDice(dieConfig)
	ttsText = 'Breaking '..dieConfig.label..'. '
	printTTS()
end

-- game over screen
function tts.readGameOverScreen()
	local enemyResult = 'You were defeated by the '..enemyConfig.name..'. '
	ttsInstructions = 'Press X to restart the game. '
	ttsText = 'Game Over. '..enemyResult..ttsInstructions
	printTTS()
end

-- victory screen
function tts.readVictoryScreen()
	ttsInstructions = ' Press down to review your final dice, and start again. '
	ttsText = TextBlocks.victory..ttsInstructions
	printTTS()
end

function tts.readDiceTray()
	local diceText = 'Your final dice bag: '
	for index, dieConfig in ipairs(diceBag) do
		diceText = diceText..' a '..dieConfig.label..', '
	end
	ttsInstructions = 'Press down to start a new game.'
	ttsText = diceText..ttsInstructions
	printTTS()
end

function tts.readBrokenDiceTray()
	local diceText = 'The Dice you broke: '
	for index, dieConfig in ipairs(brokenDiceBag) do
		diceText = diceText..' a '..dieConfig.label..', '
	end
	ttsInstructions = 'Press down to preview your dice.'
	ttsText = diceText..ttsInstructions
	printTTS()
end

function tts.readPlayAgainButton()
	ttsText = 'Continue button: press X to start from the first stage with your dice'
	ttsInstructions = ttsText
	printTTS()
end

-- game screen
function tts.readCharactersPreview()
	local actionText = ''
	for index, action in ipairs(enemyActions) do
		if index > 1 then
			actionText = actionText..', and '
		end
		if action.type == 'ATK' then
			actionText = actionText..'attack for '..action.value..' damage'
		end
		if action.type == 'DEF' then
			actionText = actionText..'block '..action.value..' future damage'
		end
	end

	local enemyStatus = 'You are facing off against a '..enemyConfig.name..' with '..enemyHP..' health;'
	if enemyBLK then
		enemyStatus = enemyStatus..' and '..enemyBLK..' block. '
	end

	local enemyActionText = 'They are planning to '..actionText..'. '
	local enemyActionHotKey = 'You can press E at any time to hear the enemy actions and stats. '

	local playerStatus = 'You have '..playerHP..' health, and '..playerBLK..' block. '
	local playerHotKey = 'You can press Q at any time to hear your own stats. '

	ttsInstructions = 'Press down to view your dice.'
	ttsText = enemyStatus..enemyActionText..enemyActionHotKey..playerStatus..playerHotKey..ttsInstructions
	printTTS()
end

function tts.enemyPreview()
	local actionText = ''
	for index, action in ipairs(enemyActions) do
		if index > 1 then
			actionText = actionText..', and '
		end
		if action.type == 'ATK' then
			actionText = actionText..'attack for '..action.value..' damage'
		end
		if action.type == 'DEF' then
			actionText = actionText..'block '..action.value..' future damage'
		end
	end

	local enemyStatus = 'The '..enemyConfig.name..' has '..enemyHP..' health;'
	if enemyBLK then
		enemyStatus = enemyStatus..' and '..enemyBLK..' block. '
	end

	local enemyActionText = 'They are planning to '..actionText..'. '
	ttsText = enemyStatus..enemyActionText
	printTTS()
end

function tts.playerPreview()
	local playerStatus = 'You have '..playerHP..' health, and '..playerBLK..' block. '
	ttsText = playerStatus
	printTTS()
end

function tts.readPlayerStatus()
	local playerDescription = 'Your character, '..playerConfig.name
	playerDescription = playerDescription..', '..playerConfig.visualDescription..' '
	local playerStatus = 'Currently '..playerHP..' health '..'and '..playerBLK..' block. '

	ttsText = playerDescription..playerStatus
	printTTS()
end

function tts.readEnemyStatus()
	local enemyDescription = 'Your opponent, '..enemyConfig.name
	enemyDescription = enemyDescription..', '..enemyConfig.visualDescription..' '
	local enemyStatus = 'Currently '..enemyHP..' health and '..enemyBLK..' block. '
	ttsText = enemyDescription..enemyStatus
	printTTS()
end

function tts.readCharactersUpdate()
	local actionText = ''
	for index, action in ipairs(enemyActions) do
		if index > 1 then
			actionText = actionText..', and '
		end
		if action.type == 'ATK' then
			actionText = actionText..'attack for '..action.value..' damage'
		end
		if action.type == 'DEF' then
			actionText = actionText..'block '..action.value..' future damage'
		end
	end

	local enemyStatus = enemyConfig.name..' is still standing with '..enemyHP..' health, and '..enemyBLK..' block. '
	local enemyActionText = 'They are planning to '..actionText..'. '

	local playerStatus = 'You have '..playerHP..' health, and '..playerBLK..' block. '

	ttsInstructions = 'Press down to view your dice and continue the fight.'
	ttsText = enemyStatus..enemyActionText..playerStatus..ttsInstructions
	printTTS()
end

function tts.readDiceTrayPreview()
	local diceOptions = ''
	for index, die in ipairs(activeDice) do
		local dieConfig = die.dieConfig
		diceOptions = diceOptions..', a '..dieConfig.shortLabel..' '..die.value
		if (die.assignment) then
			diceOptions = diceOptions..' (assigned)'
		end
	end
	ttsInstructions = 'Press right to scan and assign these dice. Press down after assigning dice to confirm your selection and attack!'
	ttsText = 'Your dice tray: You have rolled '..#activeDice..' dice;'..diceOptions..'. '..ttsInstructions
	printTTS()
end

function tts.readDiceAssignment()
	local assignedAttackDiceText = ''
	local assignedDefenseDiceText = ''
	local assignedDice = getAssignedDiceIndexes(activeDice)

	for index, assignedDieIndex in ipairs(assignedDice) do
		local die = activeDice[assignedDieIndex]
		local dieConfig = diceBag[die.diceBagIndex]

		if (die.assignment == 'ATK') then
			assignedAttackDiceText = assignedAttackDiceText..', a '..dieConfig.shortLabel..' '..die.value
		end
		if (die.assignment == 'DEF') then
			assignedDefenseDiceText = assignedDefenseDiceText..', a '..dieConfig.shortLabel..' '..die.value
		end
	end

	-- if there were no dice assigned, replace text with that
	if #assignedAttackDiceText == 0 then
		assignedAttackDiceText = 'no dice'
	end

	if #assignedDefenseDiceText == 0 then
		assignedDefenseDiceText = 'no dice'
	end

	unassignedCount = 4 - #assignedDice

	ttsInstructions = 'Press X to confirm actions.'
	ttsText = 'Confirm Button: You are attacking with '..assignedAttackDiceText..'; are defending with '..assignedDefenseDiceText..'; and have '..unassignedCount..' unassigned dice. '..ttsInstructions
	printTTS()
end

function tts.readSelectedDie()
	local selectedDie = activeDice[selectedDiceIndex]
	local dieConfig = diceBag[selectedDie.diceBagIndex]

	local dieSlot = indexToPlace(selectedDiceIndex)

	local dieDescription = ''
	dieDescription = dieDescription..dieConfig.label..', rolled '..selectedDie.value..'. '
	if dieConfig.buff then
		dieDescription = dieDescription..'A '..dieConfig.label..' '..dieConfig.buff..'. '
	end
	if selectedDie.assignment then
		dieDescription = dieDescription..'Assigned for '..(selectedDie.assignment == 'ATK' and 'attacking' or 'defending')..'. '
	elseif selectedDiceIndex == 1 then
		ttsInstructions = 'Press A to use for Attacking, D to use for Defending, and C to clear the assignment and save the die.'
		dieDescription = dieDescription..'Not currently assigned. '..ttsInstructions
	end
	ttsText = dieSlot..' Die, a '..dieDescription
	printTTS()
end

function tts.readAssignmentResult(type)
	ttsText = 'Assigned for '..(type == 'ATK' and 'attacking' or 'defending')
	printTTS()
end

function tts.readClearAssignment()
	ttsText = 'Cleared assignment for die'
	printTTS()
end

function tts.readEnemyActionStart()
	ttsText = enemyConfig.name.."'s turn."
	printTTS()
end

function tts.readEnemyDefeated()
	ttsText = 'You defeated '..enemyConfig.name
	printTTS()
end

function tts.readAttack(die)
	local nextTtsText = die.value..' damage!'
	if ttsText == nextTtsText then
		nextTtsText = 'another '..nextTtsText
	end
	ttsText = nextTtsText
	printTTS()
end

function tts.readBlock(die)
	local nextTtsText = die.value..' guard!'
	if ttsText == nextTtsText then
		nextTtsText = 'another '..nextTtsText
	end
	ttsText = nextTtsText
	printTTS()
end

function tts.readEnemyAttack(action)
	local nextTtsText = action.value..' damage!'
	if ttsText == nextTtsText then
		nextTtsText = 'another '..nextTtsText
	end
	ttsText = nextTtsText
	printTTS()
end

function tts.readEnemyGuard(action)
	local nextTtsText = action.value..' guard!'
	if ttsText == nextTtsText then
		nextTtsText = 'another '..nextTtsText
	end
	ttsText = nextTtsText
	printTTS()
end

return tts
