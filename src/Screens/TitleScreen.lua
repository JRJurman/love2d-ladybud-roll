local TitleScreen = {}

TitleScreen.screen = 0
local seed = 0

function TitleScreen.load()
	screen = TitleScreen.screen
	print('tts: Ladybug Roll, created by Jesse Jurman. Press enter or space to start.')
end

function TitleScreen.update(dt)
	if screen ~= TitleScreen.screen then return end
	seed = seed + dt*1000
end

function TitleScreen.keypressed(key)
	if screen ~= TitleScreen.screen then return end

	if key == 'enter' or key == 'space' then
		print('seed: '..seed)
		math.randomseed(seed)
		TransitionScreen.load(MapScreen)
	end
end

function TitleScreen.draw()
	if screen ~= TitleScreen.screen then return end

	local winWidth, winHeight = love.graphics.getDimensions()
	local font = love.graphics.newFont(40)
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf('LADYBUG ROLL', 0, (winHeight/2) - 40, winWidth, 'center')
end

return TitleScreen
