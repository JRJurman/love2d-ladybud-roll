local Sandbag = {
	name='Sandbag',
	startingHP=20, startingBLK=5,
	ready=function(round, hp, blk)
		if hp < 5 then
			return {{ type='ATK', value=13 }}
		end
		if hp < 10 then
			return {{ type='DEF', value=10 }}
		end
		if hp == 20 then
			return {{ type='ATK', value=5 }, { type='DEF', value=5 }}
		end
		return {{ type='ATK', value=7 }}
	end
}

return {
	Sandbag=Sandbag
}
