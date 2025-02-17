local StageProgress = require('../Components/StageProgress')
local TextAndGraphic = require('../Components/TextAndGraphic')
local TextBlocks = require('../Data/TextBlocks')
local DiceTray = require('../Components/DiceTray')

local IntroScreen = {}
IntroScreen.screen = 4

function IntroScreen.load()
	screen = IntroScreen.screen
	stage = 1
end

function IntroScreen.update(dt)
	if screen ~= IntroScreen.screen then return end
end

function IntroScreen.keypressed(key)
	if screen ~= IntroScreen.screen then return end

end

function IntroScreen.draw()
	if screen ~= IntroScreen.screen then return end

	StageProgress.draw()

	local width = 730
	local height = 190
	local x = 30
	local y = 110
	local textSelected = true

	TextAndGraphic.draw(x, y, width, height, {1,1,1}, textSelected, TextBlocks.introLore, 330)

	local dice = {}
	for index, dieConfig in ipairs(diceBag) do
		local newDie = { value = dieConfig.max, assignment = nil, diceBagIndex = index, dieConfig = dieConfig }
		table.insert(dice, newDie)
	end
	DiceTray.draw(x, 315, 730, dice, diceBag, selectedIndex)
end

return IntroScreen
