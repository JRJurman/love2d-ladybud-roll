local DiceTray = require('../Components/DiceTray')

local TitleScreen = {}
TitleScreen.screen = 0

function TitleScreen.load()
	screen = TitleScreen.screen
	print('tts: Dice game, created by Jesse Jurman. Press enter or space to start.')
end

function TitleScreen.update(dt)
	if screen ~= TitleScreen.screen then return end
end

function TitleScreen.keypressed(key)
	if screen ~= TitleScreen.screen then return end
end

function TitleScreen.draw()
	if screen ~= TitleScreen.screen then return end

	local font = love.graphics.newFont(40)
	love.graphics.setFont(font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('DICE GAME', 265, 200)

	-- DiceTray.draw(90, 430, {{value: 1}, {value: 2}, {value: 3}, {value: 4}})
end

return TitleScreen
