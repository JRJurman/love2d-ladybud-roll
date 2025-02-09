local PlayerConfig = require('../Data/PlayerConfig')

local MapScreen = {}
MapScreen.screen = 3 -- set number here!

stage = 3

-- initial character state
playerHP = PlayerConfig.Seven.startingHP
playerBLK = PlayerConfig.Seven.startingBLK
diceBag = PlayerConfig.Seven.diceBag

function MapScreen.load()
	screen = MapScreen.screen
end

function MapScreen.update(dt)
	if screen ~= MapScreen.screen then return end
end

function MapScreen.keypressed(key)
	if screen ~= MapScreen.screen then return end

	if key == 'enter' or key == 'space' then
		TransitionScreen.load(GameScreen)
	end
end

function MapScreen.draw()
	if screen ~= MapScreen.screen then return end

	-- draw the path we are going
	love.graphics.setColor(1, 1, 1)
	love.graphics.line(90, 70, 700, 70)

	-- draw circles for progress
	for stageIndex=1,8 do
		if stageIndex < stage then
			love.graphics.setColor(0.4, 0.4, 0.4)
		else
			love.graphics.setColor(0, 0, 0)
		end
		love.graphics.circle('fill', 70 + (stageIndex * 70), 70, 20)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle('line', 70 + (stageIndex * 70), 70, 20)
	end
end

return MapScreen
