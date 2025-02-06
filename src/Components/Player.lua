local Button = require('../Components/Button')

local Player = {}

function Player.draw(isSelected, hp, block, buff)
	Button.draw(140, 100, 170, 190, 4, {0,0,0.7}, {0,0,1}, isSelected, 'Player')

	if hp then love.graphics.printf('HP: '..hp, 140, 124, 170, 'center') end
	if block then love.graphics.printf('BLK: '..block, 140, 148, 170, 'center') end
	if buff then love.graphics.printf('BUFF: '..buff, 140, 172, 170, 'center') end
end

return Player
