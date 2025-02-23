local GameOverScreen = {}
GameOverScreen.screen = 8

function GameOverScreen.load()
	screen = GameOverScreen.screen
end

function GameOverScreen.update(dt)
	if screen ~= GameOverScreen.screen then return end
end

function GameOverScreen.keypressed(key)
	if screen ~= GameOverScreen.screen then return end

	if key == 'x' then
		TransitionScreen.load(TitleScreen, false)
	end
end

function GameOverScreen.draw()
	if screen ~= GameOverScreen.screen then return end
end

return GameOverScreen
