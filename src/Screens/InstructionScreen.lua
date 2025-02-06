local InstructionScreen = {}
InstructionScreen.screen = 1

function InstructionScreen.load()
	screen = InstructionScreen.screen
end

function InstructionScreen.update(dt)
	if screen ~= InstructionScreen.screen then return end
end

function InstructionScreen.keypressed(key)
	if screen ~= InstructionScreen.screen then return end
end

function InstructionScreen.draw()
	if screen ~= InstructionScreen.screen then return end
end

return InstructionScreen
