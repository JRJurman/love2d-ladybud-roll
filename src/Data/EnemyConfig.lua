local Enemy = require('../Components/Enemy')

local centipedeGraphic=love.graphics.newImage('Assets/enemy-centipede.png')
local Centipede = {
	name='Centipede',
	canvas=Enemy.createCanvas(centipedeGraphic),
	visualDescription='a bag full of sand with stitched buttons everywhere. it makes a distinct sound when attacked.',
	startingHP=20, startingBLK=0,
	ready=function(round, hp, blk)
		return {{ type='ATK', value=4 + math.random(0, 4) }}
	end
}

return {
	Centipede=Centipede
}
