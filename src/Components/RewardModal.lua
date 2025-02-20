local Modal = require('../Components/Modal')
local Button = require('../Components/Button')

local RewardModal = {}

function RewardModal.draw()
	Modal.draw(350, 350, {1,1,1}, {0,0,0})

	love.graphics.setColor({1,1,1})
	love.graphics.printf('Rewards', 228, 148, 350, 'center')

	local isSkipSelected = false
	Button.draw(270, 385, 240, 50, isSkipSelected, 'Skip Rewards')
end

return RewardModal
