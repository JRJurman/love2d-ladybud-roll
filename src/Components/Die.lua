local Die = {}

local pip_positions = {
	[1] = {{0.5, 0.5}},
	[2] = {{0.25, 0.25}, {0.75, 0.75}},
	[3] = {{0.25, 0.25}, {0.5, 0.5}, {0.75, 0.75}},
	[4] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}},
	[5] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}, {0.5, 0.5}},
	[6] = {{0.25, 0.2}, {0.75, 0.2}, {0.25, 0.5}, {0.75, 0.5}, {0.25, 0.80}, {0.75, 0.80}},
}

local dieCanvasMultiplier = 1
-- Function to create a canvas with a rendered die face
function Die.createCanvas(size, value, color)
	local canvasSize = size / dieCanvasMultiplier
	local canvas = love.graphics.newCanvas(canvasSize, canvasSize)

	love.graphics.setCanvas(canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setColor(unpack(color))
	love.graphics.rectangle('fill', 0, 0, canvasSize, canvasSize, 10, 10)

	-- Draw pips
	love.graphics.setColor(0, 0, 0, 0.8)
	local pips = pip_positions[value]
	if pips then
		for _, pip in ipairs(pips) do
			local px = pip[1] * canvasSize
			local py = pip[2] * canvasSize
			love.graphics.circle('fill', px, py, canvasSize / 8)
		end
	end

	love.graphics.setCanvas()
	canvas:setFilter("nearest", "nearest") -- Pixelated effect

	return canvas
end

function Die.draw(x, y, size, value, color, selected)
	-- Create and store the canvas for reuse
	local dieCanvas = Die.createCanvas(size, value, color)

	-- If selected, draw a border
	if selected then
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle('fill', x - 5, y - 5, size * 1.125, size * 1.125, 5, 5)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('fill', x - 3, y - 3, size * 1.075, size * 1.075, 5, 5)
	end

	-- Draw the cached die image
	love.graphics.setColor(1, 1, 1) -- Ensure full brightness
	love.graphics.draw(dieCanvas, x, y, 0, dieCanvasMultiplier, dieCanvasMultiplier)
end

return Die
