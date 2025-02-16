local StageProgress = require('../Components/StageProgress')
local Button = require('../Components/Button')

local IntroScreen = {}
IntroScreen.screen = 4

function IntroScreen.load()
	screen = IntroScreen.screen
end

function IntroScreen.update(dt)
	if screen ~= IntroScreen.screen then return end
end

function IntroScreen.keypressed(key)
	if screen ~= IntroScreen.screen then return end

end

function IntroScreen.draw()
	if screen ~= IntroScreen.screen then return end

	StageProgress.draw()

	local width = 610
	local height = 300
	local height = 300
	local x = getXForWidth(width)
	Button.draw(x, y, width, height, defaultColor, isSelected, text)
end

return IntroScreen
