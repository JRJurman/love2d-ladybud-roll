local GameScreen = {}
GameScreen.screen = 2

function GameScreen.load()
	screen = GameScreen.screen
end

function GameScreen.update(dt)
	if screen ~= GameScreen.screen then return end
end

function GameScreen.keypressed(key)
	if screen ~= GameScreen.screen then return end
end

function GameScreen.draw()
	if screen ~= GameScreen.screen then return end
end

return GameScreen
