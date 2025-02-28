function getXForWidth(width)
	local winWidth, winHeight = love.graphics.getDimensions()
	local x = (winWidth - width) / 2
	return math.floor(x)
end

function getYForHeight(height)
	local winWidth, winHeight = love.graphics.getDimensions()
	local y = (winHeight - height) / 2
	return math.floor(y)
end
