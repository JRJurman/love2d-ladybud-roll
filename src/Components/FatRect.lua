local FatRect = {}

function FatRect.draw(x, y, width, height, padding, borderColor, backgroundColor)
	love.graphics.setColor(unpack(borderColor))
	love.graphics.rectangle('fill', x, y, width, height)
	love.graphics.setColor(unpack(backgroundColor))
	love.graphics.rectangle('fill', x + padding, y + padding, width - (padding*2), height - (padding*2))
end

return FatRect
