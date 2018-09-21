local menu = {}
local game = require 'states/game'



function menu:update(dt)
	local b = Suit.Button("New Game", {font=fonts.menu}, love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 30, 200, 60)
	if b.hit then
		Gamestate.switch(game)
	end
end

function menu:draw()
	Suit:draw()
end

return menu