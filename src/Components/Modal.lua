local Modal = {}

function Modal.draw(width, height, borderColor, backgroundColor)
	local winWidth, winHeight = love.graphics.getDimensions()

	-- draw the backdrop
	love.graphics.setColor(0, 0, 0, 0.4)
	love.graphics.rectangle('fill', 0, 0, winWidth, winHeight)

	local padding = 4

	-- determine x and y based on width and height, and the window frame
	local x = (winWidth - width) / 2
	local y = (winHeight - height) / 2

	love.graphics.setColor(unpack(borderColor))
	love.graphics.rectangle('fill', x, y, width, height)
	love.graphics.setColor(unpack(backgroundColor))
	love.graphics.rectangle('fill', x + padding, y + padding, width - (padding*2), height - (padding*2))
end

return Modal
