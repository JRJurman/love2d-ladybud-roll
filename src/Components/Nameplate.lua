local Button = require('../Components/Button')

local Nameplate = {}

local namePlateWidth = 250
local namePlateHeight = 50
local canvasMult = 4

function Nameplate.createCanvas()
	return Button.createCanvas(namePlateWidth, namePlateHeight)
end

Nameplate.canvas = Nameplate.createCanvas()

function Nameplate.draw(x, y, text, selected)
	Button.draw(Nameplate.canvas, x, y, namePlateWidth, namePlateHeight, 0, selected, text)
end

return Nameplate
