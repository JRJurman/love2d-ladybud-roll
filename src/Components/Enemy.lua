local Button = require('../Components/Button')
local Nameplate = require('../Components/Nameplate')
local Heart = require('../Components/Heart')
local Shield = require('../Components/Shield')

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

function Enemy.draw(enemyConfig, isSelected, hp, block, nextActions)
	love.graphics.setColor(1,1,1)

	-- draw the enemy
	local canvas = enemyConfig.canvas
	local enemyX, enemyY = 500, 70
	local enemyScale = 3
	love.graphics.draw(canvas, enemyX, enemyY, 0, enemyScale, enemyScale)

	-- draw the canvas
	Nameplate.draw(enemyX - 50, 240, enemyConfig.name, isSelected)

	-- draw the heart and health
	Heart.draw(enemyX + 180, 50, hp)
	Shield.draw(enemyX + 188, 150, block)

	-- if nextActions then
	-- 	for index, action in ipairs(nextActions) do
	-- 		love.graphics.printf(action.type..' '..action.value, 500, 70 + (28 * index), 170, 'center')
	-- 	end
	-- end
end

return Enemy
