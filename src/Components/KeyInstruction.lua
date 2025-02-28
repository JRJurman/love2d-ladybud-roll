local FatRect = require('../Components/FatRect')

local KeyInstruction = {}

local keyFont = love.graphics.newFont('Assets/font-enter-input.ttf', 36, 'mono')
local keyFontPressed = love.graphics.newFont('Assets/font-enter-input-pressed.ttf', 36, 'mono')

local rectHeight = 50
local xPadding = 10

function KeyInstruction.draw(x, y, width, instruction, key, animate)
	FatRect.draw(x, y, width, rectHeight, {1,1,1}, {0,0,0}, true)

	love.graphics.setColor({1,1,1})

	love.graphics.setFont(getFont(30))
	if (currentFont == 'whacky') then
		love.graphics.printf('Press ', x + xPadding, y + 0, width, 'left')

		if (animate and not prefersReducedAnimation and frame % 1 > 0.5) then
			love.graphics.setFont(keyFontPressed)
		else
			love.graphics.setFont(keyFont)
		end
		love.graphics.printf(key, x + xPadding + 112, y - 11, width, 'left')

		love.graphics.setFont(getFont(30))
		love.graphics.printf('key to '..instruction, x + xPadding + 158, y + 0, width, 'left')
	else
		love.graphics.setFont(getFont(30))
		love.graphics.printf('Press ['..string.upper(key)..'] key to '..instruction, x + xPadding, y + 0, width, 'left')
	end
end

function KeyInstruction.drawKeyRange(x, y, width, instruction, key1, key2, animate)
	FatRect.draw(x, y, width, rectHeight, {1,1,1}, {0,0,0}, true)

	love.graphics.setColor({1,1,1})

	if (currentFont == 'whacky') then
		love.graphics.setFont(getFont(30))
		love.graphics.printf('Press ', x + xPadding, y + 0, width, 'left')

		if (animate and not prefersReducedAnimation and frame % 1 > 0.5) then
			love.graphics.setFont(keyFontPressed)
		else
			love.graphics.setFont(keyFont)
		end
		love.graphics.printf(key1, x + xPadding + 112, y - 11, width, 'left')
		love.graphics.printf(key2, x + xPadding + 172, y - 11, width, 'left')

		love.graphics.setFont(getFont(30))
		love.graphics.printf('-', x + xPadding + 150, y + 4, width, 'left')
		love.graphics.printf('keys to '..instruction, x + xPadding + 219, y + 0, width, 'left')
	else
		love.graphics.setFont(getFont(30))
		love.graphics.printf('Press ['..string.upper(key1)..'] - ['..string.upper(key2)..'] keys to '..instruction, x + xPadding, y + 0, width, 'left')
	end
end



return KeyInstruction
