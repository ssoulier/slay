local menu = {}
local game = require 'states/game'

function menu:update(dt)
	if Suit.Button("New Game", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 10, 100, 20).hit then
		Gamestate.switch(game)
	end
end

function menu:draw()
	Suit:draw()
end

return menu