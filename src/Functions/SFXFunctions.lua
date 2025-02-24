SFX = {
	selectSFX = love.audio.newSource('Assets/sfx-select.wav', 'static'),
	selectBackSFX = love.audio.newSource('Assets/sfx-select-back.wav', 'static'),
	invalidSelectSFX = love.audio.newSource('Assets/sfx-invalid-select.wav', 'static'),
	transitionSFX = love.audio.newSource('Assets/sfx-transition.wav', 'static'),
}

function selectSFX(key)
	love.audio.play(SFX.selectSFX)
end

function selectBackSFX()
	love.audio.play(SFX.selectBackSFX)
end

function invalidSelectSFX()
	love.audio.play(SFX.invalidSelectSFX)
end

function transitionSFX()
	love.audio.play(SFX.transitionSFX)
end
