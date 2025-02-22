local FatRect = require('../Components/FatRect')

local TextArea = {}

local font = buildWhackyFont(18)
function TextArea.draw(x, y, width, height, defaultColor, isSelected, text)
	local alpha = isSelected and 1 or 0.7
	FatRect.draw(x, y, width, height, defaultColor, {0,0,0}, isSelected)
	love.graphics.setColor(defaultColor[1], defaultColor[2], defaultColor[3], alpha)

	love.graphics.setFont(font)

	love.graphics.setColor(defaultColor[1], defaultColor[2], defaultColor[3], alpha)

	-- set the text width based on the size of a graphic (if there is one)
	local padding = 10
	local textWidth = width - padding*2

	love.graphics.printf(text, x + padding, y + padding, textWidth, 'left')
end

return TextArea
