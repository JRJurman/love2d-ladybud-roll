local Shield = {}

local shieldAsset = love.graphics.newImage('Assets/ui-shield.png')
local shieldAssetSize = 32

-- Function to create a canvas with a shield icon
function Shield.createCanvas()
	local canvas = love.graphics.newCanvas(32, 32)

	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(shieldAsset, 0, 0)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to fix aliasing when we enlarge the image
	canvas:setFilter("nearest", "nearest")

	return canvas
end

Shield.canvas = Shield.createCanvas()

function Shield.draw(x, y, value, size, padding)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Shield.canvas, x, y, 0, size / shieldAssetSize, size / shieldAssetSize)
	setLospecColor(01)
	love.graphics.setFont(getFont(40))
	love.graphics.printf(value, x, y + padding, size, 'center')
end

return Shield
