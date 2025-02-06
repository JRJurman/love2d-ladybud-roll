local Die = require('Die')

local DiceTray = {}
function DiceTray.draw(x, y, dice)

	local padding = 10
	for index, die in pairs(dice) do
		Die.draw(x + (index * DICE_SIZE + padding), y, die.value, nil)
	end
end

return DiceTray
