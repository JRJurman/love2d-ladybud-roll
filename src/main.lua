-- load functions
tts = require('Functions/tts')
require('Functions/PositionFunctions')
require('Functions/FontFunctions')
require('Functions/PaletteFunctions')

-- load screens
TitleScreen = require('Screens/TitleScreen')
GameScreen = require('Screens/GameScreen')
IntroScreen = require('Screens/IntroScreen')
DicePackScreen = require('Screens/DicePackScreen')
DiceBreakScreen = require('Screens/DiceBreakScreen')
VictoryScreen = require('Screens/VictoryScreen')
GameOverScreen = require('Screens/GameOverScreen')
TransitionScreen = require('Screens/TransitionScreen')
DebuggingScreen = require('Screens/DebuggingScreen')

screen = 0

local LightForest = require('../Backgrounds/LightForest')

-- there are some menu options that we'll use throughout multiple screens
-- so we're assigning them here, and they'll be used everywhere else
selectedRow = nil
selectedDiceIndex = nil

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
			printTTS()
		end
	end

	TitleScreen.update(dt)
	GameScreen.update(dt)
	IntroScreen.update(dt)
	DicePackScreen.update(dt)
	DiceBreakScreen.update(dt)
	VictoryScreen.update(dt)
	GameOverScreen.update(dt)
end

function love.keypressed(key)
	-- if we are in the middle of transitioning
	-- don't handle any keypresses
	if loading > 0 then
		return
	end

	TitleScreen.keypressed(key)
	GameScreen.keypressed(key)
	IntroScreen.keypressed(key)
	DicePackScreen.keypressed(key)
	DiceBreakScreen.keypressed(key)
	VictoryScreen.keypressed(key)
	GameOverScreen.keypressed(key)
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
	LightForest.draw()

	TitleScreen.draw()
	GameScreen.draw()
	IntroScreen.draw()
	DicePackScreen.draw()
	DiceBreakScreen.draw()
	VictoryScreen.draw()
	GameOverScreen.draw()
	DebuggingScreen.draw()

	TransitionScreen.draw()
end
