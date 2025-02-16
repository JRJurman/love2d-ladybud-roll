local FatRect = require('../Components/FatRect')

local Button = {}

function Button.draw(x, y, width, height, defaultColor, isSelected, text)
	local padding = 4
	local alpha = isSelected and 1 or 0.7
	FatRect.draw(x, y, width, height, defaultColor, {0,0,0}, isSelected)
	love.graphics.setColor(defaultColor[1], defaultColor[2], defaultColor[3], alpha)

	-- if the button is not wide, make the font size based on width
	local fontSizeBasedOnWidth = width / #text
	local fontSizeBasedOnHeight = height * 0.8

	local fontSize = math.min(31)
	local font = love.graphics.newFont(fontSize)

	love.graphics.setColor(defaultColor[1], defaultColor[2], defaultColor[3], alpha)
	love.graphics.setFont(font)
	love.graphics.printf(text, x, y + padding, width, 'center')
end

return Button
