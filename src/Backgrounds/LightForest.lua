LightForest = {}

function LightForest.draw()
	-- Canvas size (lower res to force pixelation)
	local canvasWidth, canvasHeight = 160, 120
	local backgroundCanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)

	-- Draw on the canvas
	love.graphics.setCanvas(backgroundCanvas)
	love.graphics.clear()

	-- Background (Sky)
	setLospecColor(29)
	love.graphics.rectangle("fill", 0, 0, canvasWidth, canvasHeight)

	-- Darker hill in the back
	setLospecColor(18)
	love.graphics.circle("fill", 130, canvasHeight + 10, 90)

	-- Lighter hill in the front
	setLospecColor(20)
	love.graphics.circle("fill", 40, canvasHeight + 40, 90)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()
	backgroundCanvas:setFilter("nearest", "nearest") -- Pixelated effect

	-- Scale the canvas for pixelation effect
	love.graphics.draw(backgroundCanvas, 0, 0, 0, 5, 5) -- Scales up to fit the screen
end

return LightForest
