local TitleScreen = require('Screens/TitleScreen')
local GameScreen = require('Screens/GameScreen')
local InstructionScreen = require('Screens/InstructionScreen')
local DebuggingScreen = require('Screens/DebuggingScreen')

function love.load()
	screen = 0
	TitleScreen.load()
end

function love.update(dt)
	TitleScreen.update(dt)
	InstructionScreen.update(dt)
	GameScreen.update(dt)
	DebuggingScreen.update(dt)
end

function love.keypressed(key)
	TitleScreen.keypressed(key)
	InstructionScreen.keypressed(key)
	GameScreen.keypressed(key)
	DebuggingScreen.keypressed(key)
end

function love.mousepressed(x, y)
	DebuggingScreen.mousepressed(x, y)
end

function love.mousereleased(x, y)
	DebuggingScreen.mousereleased(x, y)
end

function love.draw()
	TitleScreen.draw()
	InstructionScreen.draw()
	GameScreen.draw()
	DebuggingScreen.draw()
end
