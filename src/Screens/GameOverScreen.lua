local GameOverScreen = {}
GameOverScreen.screen = 8

function GameOverScreen.load()
	screen = GameOverScreen.screen
	tts.readGameOverScreen()
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

local largeFont = buildWhackyFont(40)
local smallFont = buildWhackyFont(30)
function GameOverScreen.draw()
	if screen ~= GameOverScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	love.graphics.setFont(largeFont)
	love.graphics.setColor(1, 1, 1)

	local startHeight = (winHeight/2) - 80
	love.graphics.printf('GAME OVER', 0, startHeight, winWidth, 'center')

	love.graphics.setFont(smallFont)

	love.graphics.printf('You defeated all the enemies!', 0, startHeight + 50, winWidth, 'center')
	love.graphics.printf('Press X key to Play Again', 0, startHeight + 130, winWidth, 'center')
end

return GameOverScreen
