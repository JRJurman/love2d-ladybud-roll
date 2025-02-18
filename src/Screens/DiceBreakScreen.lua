local DiceBreakScreen = {}
DiceBreakScreen.screen = 6

function DiceBreakScreen.load()
	screen = DiceBreakScreen.screen
end

function DiceBreakScreen.update(dt)
	if screen ~= DiceBreakScreen.screen then return end
end

function DiceBreakScreen.keypressed(key)
	if screen ~= DiceBreakScreen.screen then return end
end

function DiceBreakScreen.draw()
	if screen ~= DiceBreakScreen.screen then return end
end

return DiceBreakScreen
