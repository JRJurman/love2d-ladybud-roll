local DieConfig = require('../Data/DieConfig')

local Ladybug = {
	name='Ladybug',
	visualDescription='a dark figure in a red hoodie with block spots',
	-- TODO: set hp to 10 for release
	startingHP=5, startingBLK=0,
	diceBag={
		DieConfig.BlueDie,
		DieConfig.BlueDie,
		DieConfig.BlueDie,
		DieConfig.BlueDie,
		DieConfig.BlueDie,
		DieConfig.RedDie,
		DieConfig.RedDie,
		DieConfig.RedDie,
		DieConfig.RedDie,
		DieConfig.RedDie,
		DieConfig.Ladybug,
	}
}

return {
	Ladybug=Ladybug
}
