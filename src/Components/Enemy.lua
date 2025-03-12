local Button = require('../Components/Button')
local Nameplate = require('../Components/Nameplate')
local Heart = require('../Components/Heart')
local Shield = require('../Components/Shield')
local Attack = require('../Components/Attack')

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
	local enemyX, enemyY = 500, 35
	local enemyScale = 3
	love.graphics.draw(canvas, enemyX, enemyY, 0, enemyScale, enemyScale)

	-- draw the canvas
	Nameplate.draw(enemyX - 50, enemyY + 170, enemyConfig.name, isSelected)

	-- draw the heart and health
	Heart.draw(enemyX + 180, 15, hp, 96)
	Shield.draw(enemyX + 188, 115, block, 80, 8)

	local actionY = -60
	if nextActions then
		for index, action in ipairs(nextActions) do
			if action.type == 'ATK' then
				Attack.draw(425, actionY + (80 * index), action.value, 100)
			elseif action.type == 'DEF' then
				Shield.draw(445, actionY + (80 * index), action.value, 60, -4)
			end
		end
	end
end

return Enemy
