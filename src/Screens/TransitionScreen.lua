local ScreenOrder = require('../Data/ScreenOrder')

local TransitionScreen = {}

local nextScreen
local loadingDelay = 1
loading = 0
screenLoaded = false
advanceStage = false

function TransitionScreen.next()
	print('next stage: '..stage + 1)
	print('screen: ', ScreenOrder[stage + 1])
	local nextScreenConfig = ScreenOrder[stage + 1]
	TransitionScreen.load(nextScreenConfig, true)
end

function TransitionScreen.load(next, shouldAdvanceStage)
	nextScreen = next
	loading = loadingDelay
	screenLoaded = false
	advanceStage = shouldAdvanceStage
end

function TransitionScreen.update(dt)
	if loading > 0 then
		loading = loading - dt

		if loading < loadingDelay/2 and not screenLoaded then
			stage = stage + 1
			nextScreen.load()
			screenLoaded = true
		end

		if loading <= 0 then
			loading = 0
			if advanceStage then
			end
		end
	end
end

function TransitionScreen.keypressed(key)
end

function TransitionScreen.draw()
	if loading == 0 then return end

	local winWidth, winHeight = love.graphics.getDimensions()

	-- we want to start 1 window's width back, so that is -winWidth
	-- loading / loadingDelay normalizes loading between 1 and 0
	-- doing 1 - (loading / lodaingDelay) makes it between 0 and 1
	-- we want this to end (when the normalized loading delay is 1) at 2 * winWidth
	local x = -winWidth + (1 - (loading / loadingDelay)) * 2 * winWidth

	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle('fill', x, 0, winWidth, winHeight)
end

return TransitionScreen
