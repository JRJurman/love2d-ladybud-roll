local fonts = {
	whacky = {},
	atkinson = {}
}

currentFont = 'whacky'
currentFontSrc = 'Assets/font-whacky-joe.ttf'
fontSizeModifier = 0
fontHint = 'mono'

function swapFont()
	if currentFont == 'whacky' then
		currentFont = 'atkinson'
		currentFontSrc = 'Assets/font-atkinson-bold.ttf'
		fontSizeModifier = 8
		fontHint = 'normal'
	else
		currentFont = 'whacky'
		currentFontSrc = 'Assets/font-whacky-joe.ttf'
		fontSizeModifier = 0
		fontHint = 'mono'
	end
end

function buildFont(fontSize)
	local font = love.graphics.newFont(currentFontSrc, fontSize + fontSizeModifier, fontHint)
	fonts[currentFont][fontSize] = font
	return font
end

function getFont(fontSize)
	if not fonts[currentFont][fontSize] then
		buildFont(fontSize)
	end
	return fonts[currentFont][fontSize]
end
