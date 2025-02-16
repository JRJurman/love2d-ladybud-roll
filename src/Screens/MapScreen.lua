local StageProgress = require('../Components/StageProgress')

local MapScreen = {}
MapScreen.screen = 3

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
	local maxStages = 11

	StageProgress.draw(pathX, pathY, pathWidth, maxStages, stage)
end

return MapScreen
