local Button = {}

local canvasMult = 4
function ButtonCanvas(width, height, color, selected)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	if selected then
		-- Draw just the rectangle
		love.graphics.setColor(color[1], color[2], color[3])
		love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 5, 5)
	else
		-- Draw a shadow first
		love.graphics.setColor(color[1], color[2], color[3], 0.4)
		love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 5, 5)

		-- Draw a rounded rectangle
		love.graphics.setColor(color[1], color[2], color[3])
		love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 5, 5)
	end

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	return canvas
end

function Button.draw(x, y, width, height, isSelected, text)
	local canvas = ButtonCanvas(width, height, lospecColors[15], isSelected)
	love.graphics.draw(canvas, x, y, 0, canvasMult, canvasMult)

	local fontSize = 31
	local font = newWhackyFont(fontSize)

	newLospecColor(2)
	love.graphics.setFont(font)
	local xOffset = isSelected and -4 or 0
	local yOffset = (4*canvasMult) + (isSelected and 8 or 0)
	love.graphics.printf(text, x + xOffset, y + yOffset, width + (6*canvasMult), 'center')
end

return Button
