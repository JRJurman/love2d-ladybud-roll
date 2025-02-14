tts = require('tts')
TitleScreen = require('Screens/TitleScreen')
GameScreen = require('Screens/GameScreen')
MapScreen = require('Screens/MapScreen')
InstructionScreen = require('Screens/InstructionScreen')
DebuggingScreen = require('Screens/DebuggingScreen')
TransitionScreen = require('Screens/TransitionScreen')

screen = 0
function love.load()
	TitleScreen.load()
end

function love.update(dt)
	DebuggingScreen.update(dt)
	TransitionScreen.update(dt)
	if loading > 0 then
		return
	end

	if repeatingText > 0 then
		repeatingText = repeatingText - dt
		if repeatingText <= 0 then
			repeatingText = 0
			print('tts: '..ttsText)
		end
	end

	TitleScreen.update(dt)
	InstructionScreen.update(dt)
	GameScreen.update(dt)
	MapScreen.update(dt)
end

function love.keypressed(key)
	TitleScreen.keypressed(key)
	InstructionScreen.keypressed(key)
	GameScreen.keypressed(key)
	MapScreen.keypressed(key)
	DebuggingScreen.keypressed(key)

	if (key == 'r') then
		tts.repeatText()
	end
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
	MapScreen.draw()
	DebuggingScreen.draw()

	TransitionScreen.draw()
end
