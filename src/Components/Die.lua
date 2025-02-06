
local Die = {}

Die.DICE_SIZE = 80
PIP_RADIUS = 10

-- Define pip positions relative to the dice
local pip_positions = {
	[1] = {{0.5, 0.5}},
	[2] = {{0.25, 0.25}, {0.75, 0.75}},
	[3] = {{0.25, 0.25}, {0.5, 0.5}, {0.75, 0.75}},
	[4] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}},
	[5] = {{0.25, 0.25}, {0.75, 0.25}, {0.25, 0.75}, {0.75, 0.75}, {0.5, 0.5}},
	[6] = {{0.25, 0.2}, {0.75, 0.2}, {0.25, 0.5}, {0.75, 0.5}, {0.25, 0.80}, {0.75, 0.80}},
}

function Die.draw(x, y, value, color, selected)
	-- if selected, have a white border
	if selected then
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle('fill', x - 5, y - 5, Die.DICE_SIZE + 10, Die.DICE_SIZE + 10, 5, 5)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('fill', x - 3, y - 3, Die.DICE_SIZE + 6, Die.DICE_SIZE + 6, 5, 5)
	end


	love.graphics.setColor(unpack(color or {1,1,1}))
	love.graphics.rectangle('fill', x, y, Die.DICE_SIZE, Die.DICE_SIZE, 5, 5)

	-- Set color for pips
	love.graphics.setColor(0, 0, 0)

	-- Draw pips based on value
	local pips = pip_positions[value]
	if pips then
		for _, pip in ipairs(pips) do
			local px = x + pip[1] * Die.DICE_SIZE
			local py = y + pip[2] * Die.DICE_SIZE
			love.graphics.circle('fill', px, py, PIP_RADIUS)
		end
	end
end

return Die
