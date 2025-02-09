local DieConfig = require('../Data/DieConfig')

local Seven = {
	name='Seven',
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
	Seven=Seven
}
