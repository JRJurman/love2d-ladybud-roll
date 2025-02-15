local Button = require('../Components/Button')

local Player = {}

function Player.draw(isSelected, hp, block, buff)
	Button.draw(140, 160, 170, 130, 4, {0,0,1}, isSelected, 'Ladybug')

	if hp then love.graphics.printf('HP: '..hp, 140, 188, 170, 'center') end
	if block then love.graphics.printf('BLK: '..block, 140, 216, 170, 'center') end
	if buff then love.graphics.printf('BUFF: '..buff, 140, 230, 170, 'center') end
end

return Player
