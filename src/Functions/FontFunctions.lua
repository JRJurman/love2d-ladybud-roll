-- TODO NEXT - creating font objects every render is bad - we should pre-generate whichever ones we need
function buildWhackyFont(fontSize)
	local font = love.graphics.newFont('Assets/Whacky_Joe.ttf', fontSize)
	return font
end
