local Music = {
	introMusic = love.audio.newSource('Assets/track-intro.wav', 'stream'),
}

function updateMusicVolume()
	music:setVolume(masterVolume * musicVolume)
end

function introMusic()
	music = Music.introMusic
	Music.introMusic:setLooping(true)
	Music.introMusic:setVolume(masterVolume * musicVolume)
	love.audio.play(Music.introMusic)
end
