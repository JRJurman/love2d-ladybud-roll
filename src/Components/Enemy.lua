local Button = require('../Components/Button')

local Enemy = {}

function Enemy.draw(enemyName, isSelected, hp, block, buff, nextActions)
	Button.draw(500, 160, 170, 130, 4, {1,0,0}, isSelected, enemyName)
	if hp then love.graphics.printf('HP: '..hp, 500, 188, 170, 'center') end
	if block then love.graphics.printf('BLK: '..block, 500, 216, 170, 'center') end
	if buff then love.graphics.printf('BUFF: '..buff, 500, 230, 170, 'center') end

	if nextActions then
		for index, action in ipairs(nextActions) do
			love.graphics.printf(action.type..' '..action.value, 500, 70 + (28 * index), 170, 'center')
		end
	end
end

return Enemy
