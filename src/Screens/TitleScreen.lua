local PlayerConfig = require('../Data/PlayerConfig')
local TitleScreen = {}

TitleScreen.screen = 0

stage = 0
seed = 0

-- initial character state
playerConfig = PlayerConfig.Ladybug
playerHP = playerConfig.startingHP
playerBLK = playerConfig.startingBLK
diceBag = playerConfig.diceBag

function TitleScreen.load()
	screen = TitleScreen.screen
	tts.readTitleScreen()
end

function TitleScreen.update(dt)
	if screen ~= TitleScreen.screen then return end
	seed = seed + dt*1000
end

function TitleScreen.keypressed(key)
	if screen ~= TitleScreen.screen then return end

	if key then
		print('seed: '..seed)
		math.randomseed(seed)
		TransitionScreen.load(IntroScreen)
	end
end

function TitleScreen.draw()
	if screen ~= TitleScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	local font = love.graphics.newFont(40)
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1)

	love.graphics.printf('LADYBUG ROLL', 0, (winHeight/2) - 60, winWidth, 'center')

	font = love.graphics.newFont(30)
	love.graphics.setFont(font)

	love.graphics.printf('Created by Jesse Jurman', 0, (winHeight/2) - 10, winWidth, 'center')
	love.graphics.printf('Press any button to start.', 0, (winHeight/2) + 20, winWidth, 'center')
end

return TitleScreen
