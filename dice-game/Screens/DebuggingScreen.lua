local DebuggingScreen = {}
debugging = false
points = {}

function DebuggingScreen.update(dt)
	if screen ~= DebuggingScreen.screen then return end
end

function DebuggingScreen.keypressed(key)
	if key == 'b' then
		debugging = not debugging
		points = {}
	end
end

function DebuggingScreen.mousepressed(x, y)
	if not debugging then return end

	table.insert(points, {x, y})
	print('clicked - '..x..', '..y)
end

function DebuggingScreen.draw()
	if not debugging then return end

	-- draw current mouse position (circle)
	love.graphics.setColor(0, 1, 0)
	local x, y = love.mouse.getPosition()
	love.graphics.circle('fill', x, y, 3)

	-- write current mouse position (text)
	local font = love.graphics.newFont(16)
	love.graphics.setColor(0, 1, 0)
	love.graphics.setFont(font)
	love.graphics.print('mouse '..x..', '..y, 20, 580)

	-- draw all points that have been clicked on
	for key, point in pairs(points) do
		local r = (key * 12345 % 255) / 255
    local g = (key * 54321 % 255) / 255
    local b = (key * 67890 % 255) / 255
		love.graphics.setColor(r, g, b)
		local px, py = point[1], point[2]
		love.graphics.print('point '..px..', '..py, 20, 580 - (key * 16))
		love.graphics.circle('fill', px, py, 3)
	end
end

return DebuggingScreen
