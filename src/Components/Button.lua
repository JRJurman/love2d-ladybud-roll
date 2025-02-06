local FatRect = require('../Components/FatRect')

local Button = {}

function Button.draw(x, y, width, height, padding, defaultColor, focusColor, isSelected, text)
	local confirmBorder = isSelected and focusColor or defaultColor
	FatRect.draw(x, y, width, height, padding, confirmBorder, {0,0,0})
	love.graphics.setColor(unpack(focusColor))

	-- if the button is not wide, make the font size based on width
	local fontSizeBasedOnWidth = width / #text
	local fontSizeBasedOnHeight = height * 0.8

	local fontSize = math.min(fontSizeBasedOnWidth, fontSizeBasedOnHeight)
	local font = love.graphics.newFont(fontSize)

	love.graphics.setColor(confirmBorder)
	love.graphics.setFont(font)
	love.graphics.printf(text, x, y , width, 'center')
end

return Button
