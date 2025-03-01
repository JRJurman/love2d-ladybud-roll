local Music = {
	introMusic = love.audio.newSource('Assets/track-intro.wav', 'stream'),
	breakMusic = love.audio.newSource('Assets/track-break.wav', 'stream'),
	battleMusic = love.audio.newSource('Assets/track-battle.wav', 'stream'),
}

function updateMusicVolume()
	music:setVolume(masterVolume * musicVolume)
end

function introMusic()
	if music then music:stop() end
	music = Music.introMusic
	Music.introMusic:setLooping(true)
	Music.introMusic:setVolume(masterVolume * musicVolume)
	music:play()
end

function breakMusic()
	if music then music:stop() end
	music = Music.breakMusic
	Music.breakMusic:setLooping(true)
	Music.breakMusic:setVolume(masterVolume * musicVolume)
	music:play()
end

function battleMusic()
	if music then music:stop() end
	music = Music.battleMusic
	Music.battleMusic:setLooping(true)
	Music.battleMusic:setVolume(masterVolume * musicVolume)
	music:play()
end
