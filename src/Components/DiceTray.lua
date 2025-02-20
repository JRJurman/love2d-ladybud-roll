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

function DiceTray.draw(x, y, width, dice, selectedIndex, numOfDiceOverride)
	local numOfDice = numOfDiceOverride or #dice
	local paddingPerDie = 15
	local totalPaddingSize = paddingPerDie * (2 + numOfDice)
	local totalDieSize = width - totalPaddingSize
	local diceSize = totalDieSize / numOfDice

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
		local isSelected = index == selectedIndex

		-- draw the die
		Die.draw(dx, dy, diceSize, die.value, dieConfig.color, isSelected)

		-- draw assignments, if they exist
		if (die.assignment) then
			-- if this is also the selected die, draw an outline
			if isSelected then
				newLospecColor(2)
				love.graphics.rectangle('line', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
			end
			if die.assignment == 'ATK' then
				newLospecColor(38)
			elseif die.assignment == 'DEF' then
				newLospecColor(28)
			end
			love.graphics.rectangle('fill', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
		elseif isSelected then
			newLospecColor(2)
			local selectSize = diceSize / 8
			love.graphics.rectangle('fill', dx + (diceSize / 2) - (selectSize / 2), dy + diceSize * 1.125, selectSize, 10, 2, 2)
		end
	end

end

return DiceTray
