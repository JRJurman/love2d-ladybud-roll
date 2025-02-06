local TemplateScreen = {}
TemplateScreen.screen = _ -- set number here!

function TemplateScreen.load()
	screen = TemplateScreen.screen
end

function TemplateScreen.update(dt)
	if screen ~= TemplateScreen.screen then return end
end

function TemplateScreen.keypressed(key)
	if screen ~= TemplateScreen.screen then return end
end

function TemplateScreen.draw()
	if screen ~= TemplateScreen.screen then return end
end

return TemplateScreen
