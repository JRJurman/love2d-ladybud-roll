local Enemy = require('../Components/Enemy')

local centipedeGraphic=love.graphics.newImage('Assets/enemy-centipede.png')
local Centipede = {
	name='Centipede',
	canvas=Enemy.createCanvas(centipedeGraphic),
	visualDescription='an insect with many segments poised and ready to attack. It is large, black, and has a red outline and red eyes.',
	startingHP=3, startingBLK=0,
	ready=function(round, hp, blk)
		return {{ type='ATK', value=4 + math.random(0, 4) }}
	end
}

return {
	Centipede=Centipede
}
