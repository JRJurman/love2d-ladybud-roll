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

local paddingPerDie = 15
function DiceTray.getHeight(width, numOfDice)
	local totalPaddingSize = paddingPerDie * (2 + numOfDice)
	local totalDieSize = width - totalPaddingSize
	local diceSize = totalDieSize / numOfDice
	local height = diceSize

	return height
end

function DiceTray.draw(canvas, canvasSelected, height, x, y, dice, selectedIndex)
	local diceSize = height

	love.graphics.setColor(1,1,1)
	if selectedIndex then
		love.graphics.draw(canvasSelected, x, y + (diceSize / 6), 0, canvasMult, canvasMult)
	else
		love.graphics.draw(canvas, x, y + (diceSize / 6), 0, canvasMult, canvasMult)
	end

	local xSelectedOffset = selectedIndex and -4 or 0
	local ySelectedOffset = selectedIndex and 8 or 0
	-- draw dice
	for index, die in ipairs(dice) do
		local dx = x + xSelectedOffset + (diceSize / 2.5) +  ((index - 1) * (diceSize + paddingPerDie))
		local dy = y + ySelectedOffset

		local dieConfig = die.dieConfig
		local isSelected = index == selectedIndex

		-- draw the die
		Die.draw(die.canvas, dx, dy, diceSize, isSelected)

		-- if this is the selected die, draw an outline
		-- if isSelected then
		-- 	newLospecColor(29)
		-- 	love.graphics.rectangle('line', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
		-- end

		-- draw assignments, if they exist
		if (die.assignment) then
			if die.assignment == 'ATK' then
				newLospecColor(38)
			elseif die.assignment == 'DEF' then
				newLospecColor(28)
			end
			love.graphics.rectangle('fill', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
		end
	end

end

return DiceTray
