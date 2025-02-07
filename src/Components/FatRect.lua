local FatRect = {}

function FatRect.draw(x, y, width, height, padding, borderColor, backgroundColor, isSelected)
	local alpha = isSelected and 1 or 0.7
	love.graphics.setColor(borderColor[1], borderColor[2], borderColor[3], alpha)
	love.graphics.rectangle('fill', x, y, width, height)
	love.graphics.setColor(unpack(backgroundColor))
	love.graphics.rectangle('fill', x + padding, y + padding, width - (padding*2), height - (padding*2))
end

return FatRect
