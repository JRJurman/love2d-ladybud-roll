local BlueDie = {
	label="Blue Die", buff="+2 when assigned for Defense",
	shortLabel="Blue",
	min=1, max=3, color={0,0,1},
	resolve=function(assignment, value)
		if assignment == 'DEF' then
			return 2
		end
		return 0
	end
}

local RedDie = {
	label="Red Die", buff="+2 when assigned for Attacking",
	shortLabel="Red",
	min=1, max=3, color={1,0,0},
	resolve=function(assignment, value)
		if assignment == 'ATK' then
			return 2
		end
		return 0
	end
}

local Ladybug = {
	label="Ladybug", buff="+7 when assigned for Attacking",
	shortLabel="Ladybug",
	min=0, max=0, color={1,0,0},
	resolve=function(assignment, value)
		if assignment == 'ATK' then
			return 7
		end
		return 0
	end
}

return {
	BlueDie = BlueDie,
	RedDie = RedDie,
	Ladybug = Ladybug,
}
