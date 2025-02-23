local VictoryScreen = {}
VictoryScreen.screen = 7

function VictoryScreen.load()
	screen = VictoryScreen.screen
end

function VictoryScreen.update(dt)
	if screen ~= VictoryScreen.screen then return end
end

function VictoryScreen.keypressed(key)
	if screen ~= VictoryScreen.screen then return end
end

function VictoryScreen.draw()
	if screen ~= VictoryScreen.screen then return end
end

return VictoryScreen
