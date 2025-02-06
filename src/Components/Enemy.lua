local Button = require('../Components/Button')

local Enemy = {}

function Enemy.draw(enemyName, isSelected, hp, block, buff)
	Button.draw(500, 100, 170, 190, 4, {0.7,0,0}, {1,0,0}, isSelected, enemyName)
	if hp then love.graphics.printf('HP: '..hp, 500, 124, 170, 'center') end
	if block then love.graphics.printf('BLK: '..block, 500, 148, 170, 'center') end
	if buff then love.graphics.printf('BUFF: '..buff, 500, 176, 170, 'center') end
end

return Enemy
