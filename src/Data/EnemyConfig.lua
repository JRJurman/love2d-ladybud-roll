local Sandbag = {
	name='Sandbag',
	startingHP=20, startingBLK=5,
	ready=function(round, hp, blk)
		if (hp + blk) < 10 then
			return {{ type='DEF', value=7 }, { type='ATK', value=3 }}
		end
		return {{ type='ATK', value=7 }, { type='DEF', value=3 }}
	end
}

return {
	Sandbag=Sandbag
}
