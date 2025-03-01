local Die = require('../Components/Die')

local BlueDie = {
	label="Blue Die",
	shortLabel="Blue",
	min=1, max=3,
	color=lospecColors[28],

	buff="gets +2 when assigned for Block",
	resolveAssignment=function(die)
		if die.assignment == 'DEF' then
			die.value = die.value + 2
		end
	end,

	brokenBuff="gives you +6 starting block on every match",
	onBreaking=function()
		playerStartingBLK = playerStartingBLK + 6
	end
}

local RedDie = {
	label="Red Die",
	shortLabel="Red",
	min=1, max=3,
	color=lospecColors[5],

	buff="gets +2 when assigned for Attack",
	resolveAssignment=function(die)
		if die.assignment == 'ATK' then
			die.value = die.value + 2
		end
	end,

	brokenBuff="reduces the enemy starting block by 10",
	onBreaking=function()
		enemyStartingBLKBonus = enemyStartingBLKBonus - 10
	end
}

local GreenDie = {
	label="Green Die",
	shortLabel="Green",
	min=1, max=3,
	color=lospecColors[19],

	buff="heals the player's health by 2 when assigned",
	resolveAssignment=function(die)
		playerHP = math.min(playerHP + 1, playerMaxHP)
	end,

	brokenBuff="increases max HP and health by 10",
	onBreaking=function()
		playerMaxHP = playerMaxHP + 10
		playerHP = playerHP + 10
	end
}

local WhiteDie = {
	label="White Die",
	shortLabel="White",
	min=1, max=4,
	color=lospecColors[41],

	buff="has no extra effects",
	brokenBuff="gives no benefits"
}

local YellowDie = {
	label="Yellow Die",
	shortLabel="Yellow",
	min=1, max=3,
	color=lospecColors[9],

	buff="gets +4 when left unassigned",
	onSave=function(die)
		die.value = math.min(die.value + 4, 6)
		die.canvas = Die.createCanvas(die.value)
	end,

	brokenBuff="gives you +1 to maximum dice roll values",
	onBreaking=function()
		playerDiceCapBonus = playerDiceCapBonus + 1
	end
}

return {
	BlueDie = BlueDie,
	RedDie = RedDie,
	GreenDie = GreenDie,
	WhiteDie = WhiteDie,
	YellowDie = YellowDie,
}
