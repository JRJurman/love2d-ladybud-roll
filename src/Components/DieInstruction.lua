local FatRect = require('../Components/FatRect')
local Die = require('../Components/Die')

local DieInstruction = {}

local xPadding = 10

function DieInstruction.draw(x, y, width, height, die, includeSides, buffType)
	FatRect.draw(x, y, width, height, {1,1,1}, {0,0,0}, true)

	love.graphics.setColor({1,1,1})

	love.graphics.setFont(getFont(20))
	local diceSize = 30
	Die.draw(die.canvas, die.dieConfig, x + xPadding, y + 10, diceSize, false)

	local buffText = ''
	if includeSides then
		buffText = buffText..die.dieConfig.min..' to '..die.dieConfig.max..'. '
	end
	if die.dieConfig[buffType] then
		buffText = buffText..die.dieConfig[buffType]
	end

	local textX = x + (xPadding*2) + diceSize
	love.graphics.printf(buffText, textX, y + 10, width - (textX / 3), 'left')
end

return DieInstruction
