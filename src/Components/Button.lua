local Button = {}

local canvasMult = 4
function Button.createCanvas(width, height)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	-- Draw a shadow first
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 5, 5)

	-- Draw a rounded rectangle
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 5, 5)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	return canvas
end

function Button.draw(canvas, x, y, width, height, padding, isSelected, text)
	if isSelected then
		setLospecColor(42)
	else
		setLospecColor(15)
	end
	love.graphics.draw(canvas, x, y, 0, canvasMult, canvasMult)

	love.graphics.setFont(getFont(36))

	setLospecColor(2)
	local xOffset = 2
	local yOffset = 10 + padding + (isSelected and 4 or 0)
	love.graphics.printf(text, x + xOffset, y + yOffset, width + (6*canvasMult) + 8, 'center')
end

return Button
