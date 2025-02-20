local Button = require('../Components/Button')

local Enemy = {}

function Enemy.createCanvas(graphic)
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(64, 64)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(graphic, 0, 0)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to fix aliasing when we enlarge the image
	canvas:setFilter("nearest", "nearest")

	return canvas
end

function Enemy.draw(enemyConfig, isSelected, hp, block, buff, nextActions)
	love.graphics.setColor(1,1,1)

	local canvas = enemyConfig.canvas
	love.graphics.draw(canvas, 500, 160, 0, 2, 2)

	if hp then love.graphics.printf('HP: '..hp, 500, 188, 170, 'center') end
	if block then love.graphics.printf('BLK: '..block, 500, 216, 170, 'center') end
	if buff then love.graphics.printf('BUFF: '..buff, 500, 230, 170, 'center') end

	if nextActions then
		for index, action in ipairs(nextActions) do
			love.graphics.printf(action.type..' '..action.value, 500, 70 + (28 * index), 170, 'center')
		end
	end
end

return Enemy
