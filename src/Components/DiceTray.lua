local Die = require('../Components/Die')

local DiceTray = {}

local canvasMult = 4
function DiceTray.Canvas(width, height, selected)
	local canvasWidth = width / canvasMult
	local canvasHeight = height / canvasMult
	-- Set up a canvas to draw the shape
	local canvas = love.graphics.newCanvas(canvasWidth + 6, canvasHeight + 6)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	-- Draw a shadow first
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle("fill", 3, 6, canvasWidth, canvasHeight, 12, 12)

	-- Draw a rounded rectangle
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 4, 4, canvasWidth, canvasHeight, 12, 12)


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

function DiceTray.draw(canvas, height, x, y, dice, selectedIndex)
	local diceSize = height

	if selectedIndex == 0 then
		setLospecColor(29)
	else
		setLospecColor(15)
	end
	love.graphics.draw(canvas, x, y + (diceSize / 6), 0, canvasMult, canvasMult)

	local xSelectedOffset = 0
	local ySelectedOffset = selectedIndex and 8 or 0
	-- draw dice
	for index, die in ipairs(dice) do
		local dx = x + xSelectedOffset + (diceSize / 2.5) +  ((index - 1) * (diceSize + paddingPerDie))
		local dy = y + ySelectedOffset

		local dieConfig = die.dieConfig
		local isSelected = index == selectedIndex

		-- draw the die
		Die.draw(die.canvas, die.dieConfig, dx, dy, diceSize, isSelected)

		-- if this is the selected die, draw an outline
		-- if isSelected then
		-- 	setLospecColor(29)
		-- 	love.graphics.rectangle('line', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
		-- end

		-- draw assignments, if they exist
		if (die.assignment) then
			if die.assignment == 'ATK' then
				setLospecColor(38)
			elseif die.assignment == 'DEF' then
				setLospecColor(28)
			end
			love.graphics.rectangle('fill', dx, dy + diceSize * 1.125, diceSize, 10, 4, 4)
		end
	end

end

return DiceTray
