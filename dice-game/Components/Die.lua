DICE_SIZE = 60
PIP_RADIUS = 5

local Die = {}

-- Define pip positions relative to the dice
local pip_positions = {
	[1] = {{0.5, 0.5}}, -- Center
	[2] = {{0.25, 0.25}, {0.75, 0.75}}, -- Diagonal
	[3] = {{0.25, 0.25}, {0.5, 0.5}, {0.75, 0.75}}, -- Diagonal + Center
	[4] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}}, -- Four corners
	[5] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}, {0.5, 0.5}}, -- Four corners + Center
	[6] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.5}, {0.75, 0.5}, {0.25, 0.75}, {0.75, 0.75}} -- Three per side
}

function Die.draw(x, y, value, type)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle('fill', x, y, DICE_SIZE, DICE_SIZE, 5, 5)

	-- Set color for pips
	love.graphics.setColor(0, 0, 0)

	-- Draw pips based on value
	local pips = pip_positions[value]
	if pips then
		for _, pip in ipairs(pips) do
			local px = x + pip[1] * DICE_SIZE
			local py = y + pip[2] * DICE_SIZE
			love.graphics.circle('fill', px, py, PIP_RADIUS)
		end
	end
end

return Die
