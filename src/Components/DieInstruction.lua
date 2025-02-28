local FatRect = require('../Components/FatRect')
local Die = require('../Components/Die')

local DieInstruction = {}

local rectHeight = 50
local xPadding = 10

function DieInstruction.draw(x, y, width, die, includeSides, buffType)
	FatRect.draw(x, y, width, rectHeight, {1,1,1}, {0,0,0}, true)

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
	love.graphics.printf(buffText, x + (xPadding*2) + diceSize, y + 10, width, 'left')
end

return DieInstruction
