local Die = require('../Components/Die')
local FatRect = require('../Components/FatRect')

local DiceTray = {}

function DiceTray.draw(x, y, width, dice, selectedIndex, assignable)
	local diceSize = math.min(width/(#dice * 1.5), 80)
	local padding = diceSize / 3
	-- if there is a selected index, draw the border in a brighter color
	local borderColor = selectedIndex and {1,1,1} or {0.7,0.7,0.7}

	-- draw border
	-- if this has assignable dice, add extra padding
	local extraPadding = assignable and 20 or 0
	local height = diceSize + (padding * 2) + extraPadding
	FatRect.draw(x, y, width, height, borderColor, {0,0,0}, true)

	-- draw dice
	for index, die in ipairs(dice) do
		local dx = (padding + x) + (index - 1) * (diceSize + padding)
		local dy = y + padding

		local dieConfig = die.dieConfig

		-- draw the die
		Die.draw(dx, dy, diceSize, die.value, dieConfig.color, index == selectedIndex)

		-- draw assignments, if they exist
		if (die.assignment) then
			if die.assignment == 'ATK' then
				love.graphics.setColor(1, 0, 0)
			elseif die.assignment == 'DEF' then
				love.graphics.setColor(0, 0, 1)
			end
			love.graphics.rectangle('fill', dx, dy + diceSize * 1.125, diceSize, 10)
		end
	end

end

return DiceTray
