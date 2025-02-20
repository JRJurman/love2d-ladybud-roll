local Button = {}

local canvasMult = 4
function ButtonCanvas(width, height, color)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	-- Draw a shadow first
	print(unpack(color), 0.4)
	love.graphics.setColor(color[1], color[2], color[3], 0.4)
	love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 5, 5) -- rounded corners

	-- Draw a rounded rectangle (initially smooth)
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 5, 5) -- rounded corners

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	return canvas
end

function Button.draw(x, y, width, height, isSelected, text)
	local alpha = isSelected and 1 or 0.7

	local canvas = ButtonCanvas(width, height, lospecColors[15])
	love.graphics.draw(canvas, x, y, 0, canvasMult, canvasMult)

	local fontSize = 31
	local font = newWhackyFont(fontSize)

	newLospecColor(2, alpha)
	love.graphics.setFont(font)
	love.graphics.printf(text, x, y + 16, width + 24, 'center')
end

return Button
