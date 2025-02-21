local Nameplate = {}

local namePlateWidth = 250
local namePlateHeight = 50
local canvasMult = 4

function Nameplate.createCanvas()
	local canvasWidth = namePlateWidth / canvasMult
	local canvasHeight = namePlateHeight / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	-- Draw a shadow first
	love.graphics.setColor(1, 1, 1, 0.4)
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

Nameplate.canvas = Nameplate.createCanvas()

function Nameplate.draw(x, y, text)
	newLospecColor(42)
	love.graphics.draw(Nameplate.canvas, x, y, 0, canvasMult, canvasMult)

	local fontSize = 31
	local font = newWhackyFont(fontSize)

	newLospecColor(2)
	love.graphics.setFont(font)
	local xOffset = 0
	local yOffset = (4*canvasMult) - 4
	love.graphics.printf(text, x + xOffset, y + yOffset, namePlateWidth + (6*canvasMult), 'center')
end

return Nameplate
