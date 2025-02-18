local Die = require('../Components/Die')
local FatRect = require('../Components/FatRect')

local DiceTray = {}

local padding = 20
function DiceTray.draw(x, y, width, dice, selectedIndex, assignable)
	-- if there is a selected index, draw the border in a brighter color
	local borderColor = selectedIndex and {1,1,1} or {0.7,0.7,0.7}

	-- draw border
	-- if this has assignable dice, add extra padding
	local extraPadding = assignable and 20 or 0
	local height = Die.DICE_SIZE + (padding * 2) + extraPadding
	FatRect.draw(x, y, width, height, borderColor, {0,0,0}, true)

	-- draw dice
	for index, die in ipairs(dice) do
		local dx = (padding + x) + (index - 1) * (Die.DICE_SIZE + padding)
		local dy = y + padding

		local dieConfig = die.dieConfig

		-- draw the die
		Die.draw(dx, dy, die.value, dieConfig.color, index == selectedIndex)

		-- draw assignments, if they exist
		if (die.assignment) then
			if die.assignment == 'ATK' then
				love.graphics.setColor(1, 0, 0)
			elseif die.assignment == 'DEF' then
				love.graphics.setColor(0, 0, 1)
			end
			love.graphics.rectangle('fill', dx, dy + Die.DICE_SIZE + 10, Die.DICE_SIZE, 10)
		end
	end

end

return DiceTray
