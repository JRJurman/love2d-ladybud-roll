local BlueDie = {
	label="Blue Die",
	shortLabel="Blue",
	min=1, max=3, color=lospecColors[28],

	buff="gets +2 when assigned for Defending",
	resolveAssignment=function(die)
		if die.assignment == 'DEF' then
			die.value = die.value + 2
		end
	end,

	brokenBuff="gives you +5 starting block on every match",
	onBreaking=function()
		playerStartingBLK = playerStartingBLK + 5
	end
}

local RedDie = {
	label="Red Die",
	shortLabel="Red",
	min=1, max=3, color=lospecColors[38],

	buff="gets +2 when assigned for Attacking",
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
	min=1, max=3, color=lospecColors[19],

	buff="heals the player's health by 2 when assigned",
	resolveAssignment=function(die)
		playerHP = math.min(playerHP + 1, playerConfig.startingHP)
	end,

	brokenBuff="heals you by +10 (can go over the starting health)",
	onBreaking=function()
		playerHP = playerHP + 10
	end
}

local WhiteDie = {
	label="White Die",
	shortLabel="White",
	min=2, max=4, color=lospecColors[41],
}

local YellowDie = {
	label="Yellow Die",
	shortLabel="Yellow",
	min=1, max=3, color=lospecColors[9],

	buff="gets +2 when left unassigned",
	onSave=function(die)
		die.value = math.min(die.value + 2, 6)
	end,

	brokenBuff="gives you +1 to maximum dice roll values",
	onBreaking=function()
		playerDiceCapBonus = playerDiceCapBonus + 1
	end
}

local Ladybug = {
	label="Ladybug",
	shortLabel="Ladybug",
	min=0, max=0, color=lospecColors[5],

	buff="gets +7 when assigned for Attacking",
	resolveAssignment=function(die)
		if die.assignment == 'ATK' then
			die.value = die.value + 7
		end
	end,

	-- brokenBuff="Not breakable yet",
	-- onBreaking=function()
	-- end
}

return {
	BlueDie = BlueDie,
	RedDie = RedDie,
	GreenDie = GreenDie,
	WhiteDie = WhiteDie,
	YellowDie = YellowDie,
	Ladybug = Ladybug,
}
