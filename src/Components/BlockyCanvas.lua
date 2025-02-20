local BlockyCanvas = {}

local canvasMult = 4
function BlockyCanvas.draw(x, y, width, height, color)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	-- Draw a shadow first
	print(unpack(color))
	love.graphics.setColor(unpack(color, 0.4))
	love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 8, 8) -- rounded corners

	-- Draw a rounded rectangle (initially smooth)
	love.graphics.setColor(unpack(color))
	love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 8, 8) -- rounded corners

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	-- Draw the pixelated canvas with scaling for a crisp blocky look
	love.graphics.draw(canvas, x, y, 0, canvasMult, canvasMult)
end

return BlockyCanvas
