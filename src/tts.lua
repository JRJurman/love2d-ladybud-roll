local tts = {}
ttsText = ''
repeatingText = 0

-- repeat at any time
function tts.repeatText()
	print('tts: repeating...')
	repeatingText = 0.5
end

-- title screen
function tts.readTitleScreen()
	ttsText = 'Ladybug Roll, created by Jesse Jurman. Press enter or space to start.'
	print('tts: '..ttsText)
end

-- game screen
function tts.rollingDice()
	ttsText = 'Rolling dice'
	print('tts: '..ttsText)
end

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
			actionText = actionText..'block '..action.value..' damage'
		end
	end
	ttsText = 'You are facing off against a '..enemyConfig.name..'. They are planning to '..actionText..'. Press right to learn more about the enemy, or left to see your own stats. Press down to view your dice.'
	print('tts: '..ttsText)
end

function tts.readDiceTrayPreview()
	local diceOptions = ''
	for index, die in ipairs(activeDice) do
		local dieConfig = diceBag[die.diceBagIndex]
		diceOptions = diceOptions..', a '..dieConfig.shortLabel..' '..die.value
		if (die.assignment == 'ATK') then
			diceOptions = diceOptions..' (for attacking)'
		end
		if (die.assignment == 'DEF') then
			diceOptions = diceOptions..' (for defending)'
		end
	end
	ttsText = 'You have rolled '..#activeDice..' dice;'..diceOptions..'. Press right to scan and assign these dice. Press down after assigning dice to confirm your selection and attack!'
	print('tts: '..ttsText)
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
	ttsText = 'You are attacking with '..assignedAttackDiceText..' and are defending with '..assignedDefenseDiceText
	print('tts: '..ttsText)
end

return tts
