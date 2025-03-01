local Enemy = require('../Components/Enemy')

local beetleGraphic=love.graphics.newImage('Assets/enemy-beetle.png')
local Beetle = {
	name='Beetle',
	canvas=Enemy.createCanvas(beetleGraphic),
	visualDescription='an insect with a large front horn and wings.',
	startingHP=12, startingBLK=10,
	ready=function(round, hp, blk)
		if blk == 0 then
			return {
				{ type='ATK', value=4 + math.random(0, 4) },
				{ type='DEF', value=9 },
			}
		end
		return {
			{ type='ATK', value=3 + math.random(0, 4) }
		}
	end
}

local centipedeGraphic=love.graphics.newImage('Assets/enemy-centipede.png')
local Centipede = {
	name='Centipede',
	canvas=Enemy.createCanvas(centipedeGraphic),
	visualDescription='an insect with many segments poised and ready to attack.',
	startingHP=12, startingBLK=6,
	ready=function(round, hp, blk)
		if round % 4 == 1 then
			return {
				{ type='ATK', value=5 + math.random(0, 4) },
				{ type='DEF', value=1 + math.random(0, 4) },
			}
		elseif round % 4 == 2 then
			return {
				{ type='ATK', value=4 + math.random(0, 4) },
				{ type='DEF', value=2 + math.random(0, 4) },
			}
		elseif round % 4 == 3 then
			return {
				{ type='ATK', value=3 + math.random(0, 4) },
				{ type='DEF', value=3 + math.random(0, 4) },
			}
		else
			return {
				{ type='ATK', value=2 + math.random(0, 4) },
				{ type='DEF', value=4 + math.random(0, 4) },
			}
		end
	end
}

local ladyBeetleGraphic=love.graphics.newImage('Assets/enemy-ladybeetle.png')
local LadyBeetle = {
	name='LadyBeetle',
	canvas=Enemy.createCanvas(ladyBeetleGraphic),
	visualDescription='an insect with large wings covered in red spots and splotches.',
	startingHP=12, startingBLK=6,
	ready=function(round, hp, blk)
		if playerTotalATK > playerTotalDEF then
			return {
				{ type='ATK', value=4 + math.random(0, 4) },
				{ type='DEF', value=3 + math.random(0, 4) },
			}
		else
			return {
				{ type='ATK', value=3 + math.random(0, 4) },
				{ type='DEF', value=4 + math.random(0, 4) },
			}
		end
	end
}

local mantisGraphic=love.graphics.newImage('Assets/enemy-mantis.png')
local Mantis = {
	name='Mantis',
	canvas=Enemy.createCanvas(mantisGraphic),
	visualDescription="an insect with a long body and thin legs, it's arms ready to extend and attack.",
	startingHP=04, startingBLK=0,
	ready=function(round, hp, blk)
		return {
			{ type='ATK', value=2 + math.random(0, 4) },
		}
	end
}

local mothGraphic=love.graphics.newImage('Assets/enemy-moth.png')
local Moth = {
	name='Moth',
	canvas=Enemy.createCanvas(mothGraphic),
	visualDescription='an insect floating with giant round wings, with red ring patterns.',
	startingHP=08, startingBLK=0,
	ready=function(round, hp, blk)
		if round == 1 then
			return {
				{ type='DEF', value=8 + math.random(0, 2) },
			}
		end
		if round % 2 == 0 then
			return {{ type='ATK', value=4 + math.random(0, 2) }}
		else
			return {
				{ type='ATK', value=3 + math.random(0, 2) },
				{ type='DEF', value=3 + math.random(0, 2) }
			}
		end
	end
}

local spiderGraphic=love.graphics.newImage('Assets/enemy-spider.png')
local Spider = {
	name='Spider',
	canvas=Enemy.createCanvas(spiderGraphic),
	visualDescription='a fat insect with many thin legs and many red eyes.',
	startingHP=8, startingBLK=2,
	ready=function(round, hp, blk)
		if round == 1 then
			return {
				{ type='ATK', value=7 + math.random(0, 2) },
			}
		end
		if playerTotalATK > playerTotalDEF then
			return {
				{ type='ATK', value=4 + math.random(0, 2) },
				{ type='DEF', value=3 + math.random(0, 2) },
			}
		else
			return {
				{ type='ATK', value=3 + math.random(0, 2) },
				{ type='DEF', value=4 + math.random(0, 2) },
			}
		end
	end
}

return {
	Beetle = Beetle,
	Centipede = Centipede,
	LadyBeetle = LadyBeetle,
	Mantis = Mantis,
	Moth = Moth,
	Spider = Spider,
}
