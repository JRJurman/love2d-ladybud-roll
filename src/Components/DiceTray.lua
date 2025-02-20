local Die = require('../Components/Die')

local DiceTray = {}

local canvasMult = 4
function DiceTrayCanvas(width, height, color, selected)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	if (selected) then
		-- Draw just the rounded rectangle
		love.graphics.setColor(color[1], color[2], color[3])
		love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 12, 12)
	else
		-- Draw a shadow first
		love.graphics.setColor(color[1], color[2], color[3], 0.4)
		love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 12, 12)

		-- Draw a rounded rectangle
		love.graphics.setColor(color[1], color[2], color[3])
		love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 12, 12)
	end

	-- Reset canvas
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()

	-- Apply nearest neighbor filter to force pixelated look
	canvas:setFilter("nearest", "nearest")

	return canvas
end

function DiceTray.draw(x, y, width, dice, selectedIndex, assignable)
	local diceSize = math.min(width/#dice, 80)
	local diceTotalWidth = diceSize * #dice
	local totalPadding = (width - diceTotalWidth) * 0.8
	local paddingPerDie = totalPadding / #dice

	local height = diceSize

	local canvas = DiceTrayCanvas(width, height, lospecColors[15], selectedIndex)
	love.graphics.draw(canvas, x, y + (diceSize / 6), 0, canvasMult, canvasMult)

	local xSelectedOffset = selectedIndex and -4 or 0
	local ySelectedOffset = selectedIndex and 8 or 0
	-- draw dice
	for index, die in ipairs(dice) do
		local dx = x + xSelectedOffset + (diceSize / 2.5) +  ((index - 1) * (diceSize + paddingPerDie))
		local dy = y + ySelectedOffset

		local dieConfig = die.dieConfig

		-- draw the die
		Die.draw(dx, dy, diceSize, die.value, dieConfig.color, index == selectedIndex)

		-- draw assignments, if they exist
		if (die.assignment) then
			if die.assignment == 'ATK' then
				love.graphics.setColor(1, 0, 0)
			elseif die.assignment == 'DEF' then
				love.graphics.setColor(0, 0, 1)
			end
			love.graphics.rectangle('fill', dx, dy + diceSize * 1.125, diceSize, 10)
		end
	end

end

return DiceTray
