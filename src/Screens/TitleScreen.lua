local PlayerConfig = require('../Data/PlayerConfig')
local TitleScreen = {}

TitleScreen.screen = 0

stage = 0
seed = 0

-- initial character state
playerConfig = nil
playerHP = nil
playerMaxHP = nil
playerStartingBLK = nil
playerBLK = nil
playerDiceCapBonus = nil
playerDiceFloorBonus = nil
enemyStartingBLKBonus = nil
diceBag = nil

local readoutDelay = nil

function TitleScreen.load()
	screen = TitleScreen.screen

	-- the screen reader isn't always immediately ready
	-- so, wait some amount of time before updating the aria readout
	readoutDelay = 1

	playerConfig = PlayerConfig.Ladybud
	playerHP = playerConfig.startingHP
	playerMaxHP = playerConfig.startingHP
	playerStartingBLK = playerConfig.startingBLK
	playerBLK = playerStartingBLK
	playerDiceCapBonus = 0
	playerDiceFloorBonus = 0
	enemyStartingBLKBonus = 0
	diceBag = {}
	for index, dieConfig in ipairs(playerConfig.diceBag) do table.insert(diceBag, dieConfig) end
end

function TitleScreen.update(dt)
	if screen ~= TitleScreen.screen then return end
	seed = seed + dt*1000

	if readoutDelay > 0 then
		readoutDelay = readoutDelay - dt
		if readoutDelay <= 0 then
			readoutDelay = 0
			tts.readTitleScreen()
		end
	end
end

function TitleScreen.keypressed(key)
	if screen ~= TitleScreen.screen then return end

	if key == 'x' then
		print('seed: '..seed)
		math.randomseed(seed)
		TransitionScreen.load(IntroScreen, false)
	end
end

local largeFont = buildWhackyFont(40)
local smallFont = buildWhackyFont(30)
function TitleScreen.draw()
	if screen ~= TitleScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	love.graphics.setFont(largeFont)
	love.graphics.setColor(1, 1, 1)

	local startHeight = (winHeight/2) - 80
	love.graphics.printf('LADYBUD ROLL', 0, startHeight, winWidth, 'center')

	love.graphics.setFont(smallFont)

	love.graphics.printf('Created by Jesse Jurman', 0, startHeight + 50, winWidth, 'center')
	love.graphics.printf('Art by Ethan Jurman', 0, startHeight + 80, winWidth, 'center')
	love.graphics.printf('Press X key to Start', 0, startHeight + 130, winWidth, 'center')
end

return TitleScreen
