local FatRect = require('../Components/FatRect')
local Die = require('../Components/Die')

local DieRow = {}

function DieRow.draw(x, y, width, height, isSelected, dieConfig)
	local defaultColor = {0.8,0.8,0.8}
	local focusColor = {1,1,1}
	local confirmBorder = isSelected and focusColor or defaultColor

	FatRect.draw(x, y, width, height, confirmBorder, {0,0,0}, true)

	Die.draw(x + 5, y + 5, dieConfig.max, dieConfig.color)
end

return DieRow
