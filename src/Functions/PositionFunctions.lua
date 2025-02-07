function getXForWidth(width)
	local winWidth, winHeight = love.graphics.getDimensions()
	local x = (winWidth - width) / 2
	return x
end

function getYForHeight(height)
	local winWidth, winHeight = love.graphics.getDimensions()
	local y = (winHeight - height) / 2
	return y
end

return {
	getXForWidth=getXForWidth,
	getYForHeight=getYForHeight,
}
