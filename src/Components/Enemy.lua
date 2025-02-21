local Button = require('../Components/Button')
local Nameplate = require('../Components/Nameplate')
local Heart = require('../Components/Heart')

local Enemy = {}

function Enemy.createCanvas(graphic)
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

	-- draw the enemy
	local canvas = enemyConfig.canvas
	local enemyX, enemyY = 500, 70
	local enemyScale = 3
	love.graphics.draw(canvas, enemyX, enemyY, 0, enemyScale, enemyScale)

	-- draw the canvas
	Nameplate.draw(450, 240, enemyConfig.name, isSelected)

	-- draw the heart and health
	Heart.draw(660, 50, hp)
	-- if block then love.graphics.printf('BLK: '..block, 500, 216, 170, 'center') end
	-- if buff then love.graphics.printf('BUFF: '..buff, 500, 230, 170, 'center') end

	-- if nextActions then
	-- 	for index, action in ipairs(nextActions) do
	-- 		love.graphics.printf(action.type..' '..action.value, 500, 70 + (28 * index), 170, 'center')
	-- 	end
	-- end
end

return Enemy
