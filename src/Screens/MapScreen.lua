local PlayerConfig = require('../Data/PlayerConfig')

local MapScreen = {}
MapScreen.screen = 3 -- set number here!

stage = 0

-- initial character state
playerHP = PlayerConfig.Seven.startingHP
playerBLK = PlayerConfig.Seven.startingBLK
diceBag = PlayerConfig.Seven.diceBag

function MapScreen.load()
	screen = MapScreen.screen
	stage = stage + 1
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

	local pathX = 90
	local pathY = 70
	local pathWidth = 610

	-- draw the path we are going
	love.graphics.setColor(1, 1, 1)
	love.graphics.line(90, pathY, pathX + pathWidth, pathY)

	local maxStages = 11
	local distBetweenStages = pathWidth / (maxStages - 1)
	local enemyStageSize = distBetweenStages / 3
	local restStageSize = distBetweenStages / 4

	-- draw circles for progress
	for stageIndex=1,maxStages do
		if stageIndex == stage then
			love.graphics.setColor(0.4, 0.4, 1)
		elseif stageIndex < stage then
			love.graphics.setColor(0.4, 0.4, 0.4)
		else
			love.graphics.setColor(0, 0, 0)
		end

		local circleX = pathX + ((stageIndex - 1) * distBetweenStages)
		local circleSize = stageIndex % 2 == 0 and enemyStageSize or restStageSize

		love.graphics.circle('fill', circleX, pathY, circleSize)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle('line', circleX, pathY, circleSize)
	end
end

return MapScreen
