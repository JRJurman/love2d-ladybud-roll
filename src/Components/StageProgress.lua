local PlayerConfig = require('../Data/PlayerConfig')

local StageProgress = {}

function StageProgress.draw()
	local pathWidth = 700
	local pathX = getXForWidth(pathWidth)
	local pathY = 30
	local maxStages = 13

	-- draw the path we are going
	love.graphics.setColor(1, 1, 1)
	love.graphics.line(pathX, pathY, pathX + pathWidth, pathY)

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
		local circleSize = stageIndex % 2 == 0 and restStageSize or enemyStageSize

		love.graphics.circle('fill', circleX, pathY, circleSize)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle('line', circleX, pathY, circleSize)
	end
end

return StageProgress
