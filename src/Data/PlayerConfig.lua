local DieConfig = require('../Data/DieConfig')

local Ladybug = {
	name='Ladybug',
	visualDescription='',
	-- TODO: set hp to 10 for release
	startingHP=5, startingBLK=0,
	diceBag={
		DieConfig.BlueDie,
		DieConfig.RedDie,
		DieConfig.WhiteDie,
		DieConfig.WhiteDie,
		DieConfig.WhiteDie,
		DieConfig.Ladybug,
	}
}

return {
	Ladybug=Ladybug
}
