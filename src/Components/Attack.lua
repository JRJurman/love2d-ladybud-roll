local Attack = {}

local attackAsset = love.graphics.newImage('Assets/ui-attack.png')
local attackAssetSize = 32

-- Function to create a canvas with a attack icon
function Attack.createCanvas()
	local canvas = love.graphics.newCanvas(32, 32)

	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(attackAsset, 0, 0)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to fix aliasing when we enlarge the image
	canvas:setFilter("nearest", "nearest")

	return canvas
end

Attack.canvas = Attack.createCanvas()

local font = buildWhackyFont(40)
function Attack.draw(x, y, value)
	size = 100
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Attack.canvas, x, y, 0, size / attackAssetSize, size / attackAssetSize)
	setLospecColor(01)
	love.graphics.setFont(font)
	love.graphics.printf(value, x, y + 18, size, 'center')
end

return Attack
