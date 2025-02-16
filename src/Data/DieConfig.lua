local BlueDie = {
	label="Blue Die", buff="+2 when assigned for Defending",
	shortLabel="Blue",
	min=1, max=3, color={0,0,1},
	resolveAssignment=function(die)
		if die.assignment == 'DEF' then
			die.value = die.value + 2
		end
	end
}

local RedDie = {
	label="Red Die", buff="+2 when assigned for Attacking",
	shortLabel="Red",
	min=1, max=3, color={1,0,0},
	resolveAssignment=function(die)
		if die.assignment == 'ATK' then
			die.value = die.value + 2
		end
	end
}

local GreenDie = {
	label="Green Die", buff="+2 to player's health when assigned",
	shortLabel="Green",
	min=1, max=3, color={0.5,0.9,0.3},
	resolveAssignment=function(die)
		playerHP = math.min(playerHP + 1, playerConfig.startingHP)
	end
}

local WhiteDie = {
	label="White Die", buff=nil,
	shortLabel="White",
	min=2, max=4, color={1,1,1},
}

local Battery = {
	label="Battery", buff="+1 when left unassigned",
	shortLabel="Battery",
	min=1, max=3, color={0.9,0.7,0.5},
	onSave=function(die)
		die.value = math.min(die.value + 1, 6)
	end,
}

local Ladybug = {
	label="Ladybug", buff="+7 when assigned for Attacking",
	shortLabel="Ladybug",
	min=0, max=0, color={1,0,0},
	resolveAssignment=function(die)
		if die.assignment == 'ATK' then
			die.value = die.value + 7
		end
	end
}

return {
	BlueDie = BlueDie,
	RedDie = RedDie,
	GreenDie = GreenDie,
	WhiteDie = WhiteDie,
	Battery = Battery,
	Ladybug = Ladybug,
}
