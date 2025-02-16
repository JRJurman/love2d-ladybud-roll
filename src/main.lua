tts = require('tts')
TitleScreen = require('Screens/TitleScreen')
GameScreen = require('Screens/GameScreen')
MapScreen = require('Screens/MapScreen')
InstructionScreen = require('Screens/InstructionScreen')
DebuggingScreen = require('Screens/DebuggingScreen')
TransitionScreen = require('Screens/TransitionScreen')
IntroScreen = require('Screens/IntroScreen')

screen = 0
function love.load()
	TitleScreen.load()
end

function love.update(dt)
	DebuggingScreen.update(dt)
	TransitionScreen.update(dt)

	-- if we are in the middle of transitioning
	-- don't run any update logic
	if loading > 0 then
		return
	end

	-- if we triggered a text repeat, we need to
	-- wait a short while, and then re-set the text
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
	IntroScreen.update(dt)
end

function love.keypressed(key)
	TitleScreen.keypressed(key)
	InstructionScreen.keypressed(key)
	GameScreen.keypressed(key)
	MapScreen.keypressed(key)
	IntroScreen.keypressed(key)
	DebuggingScreen.keypressed(key)

	-- key binding we want everywhere,
	-- if they press r, repeat whatever the tts text is
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
	IntroScreen.draw()
	DebuggingScreen.draw()

	TransitionScreen.draw()
end
