local Nameplate = require('../Components/Nameplate')
local Heart = require('../Components/Heart')
local Shield = require('../Components/Shield')

local Player = {}

local ladybudAsset = love.graphics.newImage('Assets/ladybud.png')

function Player.createCanvas()
	local canvas = love.graphics.newCanvas(64, 64)

	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(ladybudAsset, 0, 0)

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to fix aliasing when we enlarge the image
	canvas:setFilter("nearest", "nearest")

	return canvas
end

Player.canvas = Player.createCanvas()

function Player.draw(isSelected, hp, block)
	love.graphics.setColor(1,1,1)

	-- draw the player graphic
	local canvas = Player.canvas
	local playerX, playerY = 180, 110
	local playerScale = 2
	love.graphics.draw(canvas, playerX, playerY, 0, playerScale, playerScale)

	-- draw the canvas
	Nameplate.draw(100, 205, playerConfig.name, isSelected)

	-- draw the heart and health
	Heart.draw(55, 15, hp, 96)
	Shield.draw(60, 115, block, 80)
end

return Player
