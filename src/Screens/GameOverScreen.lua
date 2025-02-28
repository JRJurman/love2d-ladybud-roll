local KeyInstruction = require('../Components/KeyInstruction')

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

function GameOverScreen.draw()
	if screen ~= GameOverScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	love.graphics.setFont(getFont(40))
	love.graphics.setColor(1, 1, 1)

	local startHeight = (winHeight/2) - 80
	love.graphics.printf('GAME OVER', 0, startHeight, winWidth, 'center')

	love.graphics.setFont(getFont(30))

	love.graphics.printf('You were defeated by the '..enemyConfig.name, 0, startHeight + 50, winWidth, 'center')

	local startWidth = 500
	local startX = getXForWidth(startWidth)
	local startY = 330
	KeyInstruction.draw(startX, startY, startWidth, 'x', 'to Play Again', true)
end

return GameOverScreen
