local DieConfig = require('../Data/DieConfig')

local Ladybud = {
	name='LadyBud',
	visualDescription='A rad ladybug with a red backwards cap - you got your arms up and are ready to give a wallop! ',
	startingHP=10, startingBLK=0,
	diceBag={
		DieConfig.BlueDie,
		DieConfig.RedDie,
		DieConfig.WhiteDie,
		DieConfig.WhiteDie,
		DieConfig.WhiteDie,
	}
}

return {
	Ladybud=Ladybud
}
