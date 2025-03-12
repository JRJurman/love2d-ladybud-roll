-- load functions
tts = require('Functions/tts')
require('Functions/PositionFunctions')
require('Functions/FontFunctions')
require('Functions/PaletteFunctions')
require('Functions/SFXFunctions')
require('Functions/MusicFunctions')

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

-- master volume control for SFX and Music
masterVolume = 0.7
musicVolume = 0.6
sfxVolume = 0.7
music = nil

-- valid key tracker (that we might update across screens)
validKey = false

-- animation counter
prefersReducedAnimation = false
frame = 0

function love.load()
	TitleScreen.load()
end

function love.update(dt)
	frame = frame + dt

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
	validKey = false

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
		selectSFX()
		tts.repeatText()
		validKey = true
	end

	-- if they press f, swap the font
	if (key == 'f') then
		selectSFX()
		swapFont()
		validKey = true
	end

	-- if they press m, update the music volume
	if (key == 'm') then
		if musicVolume == 0 then
			musicVolume = 0.7
		else
			musicVolume = 0
		end

		updateMusicVolume()
		selectSFX()
		validKey = true
	end

	-- if they press 0 - 9, update the master volume
	if (tonumber(key)) then
		masterVolume = tonumber(key)/9
		selectSFX()
		updateMusicVolume()
		validKey = true
	end

	-- if they press t, toggle animation preference
	if (key == 't') then
		selectSFX()
		prefersReducedAnimation = not prefersReducedAnimation
		validKey = true
	end
	-- if they press z, repeat current instructions
	if (key == 'z') then
		selectSFX()
		tts.repeatInstructions()
		validKey = true
	end

	-- if we didn't have a valid key, repeat possible options
	if not validKey then
		invalidSelectSFX()
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
