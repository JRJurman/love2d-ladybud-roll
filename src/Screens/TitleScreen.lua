local PlayerConfig = require('../Data/PlayerConfig')
local KeyInstruction = require('../Components/KeyInstruction')

local TitleScreen = {}

TitleScreen.screen = 0

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
brokenDiceBag = nil

local readoutDelay = nil

function TitleScreen.load()
	screen = TitleScreen.screen
	stage = 0
	introMusic()

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
	brokenDiceBag = {}
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
		validKey = true
		math.randomseed(seed)
		TransitionScreen.next()
	end
end

function TitleScreen.draw()
	if screen ~= TitleScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	love.graphics.setFont(getFont(60))
	love.graphics.setColor(1, 1, 1)

	love.graphics.printf('LADYBUD ROLL', 0, 70, winWidth, 'center')

	love.graphics.setFont(getFont(30))

	love.graphics.printf('Created by Jesse Jurman', 0, 180, winWidth, 'center')
	love.graphics.printf('Art by Ethan Jurman', 0, 210, winWidth, 'center')

	-- instructions
	local startWidth = 415
	local startX = getXForWidth(startWidth)
	local startY = 280
	KeyInstruction.draw(startX, startY, startWidth, 'x', 'to Start', true)

	KeyInstruction.draw(40, 340, winWidth - 80, 'r', 'to Repeat Screen Reader',  false)
	KeyInstruction.draw(40, 380, winWidth - 80, 'z', 'to Repeat Instructions',  false)
	KeyInstruction.draw(40, 420, winWidth - 80, 'f', 'to Swap Fonts', false)
	KeyInstruction.draw(40, 460, winWidth - 80, 't', 'to Disable Animations', false)
	KeyInstruction.drawKeyRange(40, 500, winWidth - 80, '0', '9', 'to Adjust Volume',  false)
	KeyInstruction.draw(40, 540, winWidth - 80, 'm', 'to Mute Music', false)
end

return TitleScreen
