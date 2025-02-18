local BlockyCanvas = {}

function BlockyCanvas.draw()
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(64, 32)  -- Adjust size to match your needs
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

		-- Draw a shadow first
		love.graphics.setColor(1, 1, 0.8, 0.4)
		love.graphics.rectangle("fill", 3, 6, 56, 24, 8, 8) -- rounded corners

	-- Draw a rounded rectangle (initially smooth)
	love.graphics.setColor(1, 1, 0.8)  -- Light yellow color
	love.graphics.rectangle("fill", 4, 4, 56, 24, 8, 8) -- rounded corners


	-- Reset canvas
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	-- Draw the pixelated canvas with scaling for a crisp blocky look
	love.graphics.draw(canvas, 100, 100, 0, 8, 8)  -- Scale up
end

return BlockyCanvas
