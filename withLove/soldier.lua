local Object = require 'utils/classic'
local draw = require 'utils/draw'
local game_settings = require 'config/game_settings'

local soldier = Object:extend()


function soldier:new(x, y)

	self.x = x
	self.y = y

end

function soldier:center(delta_x, delta_y)

	local s = game_settings.size
	return draw.center(self.x, self.y, delta_x, delta_y, s)

end

function soldier:draw(delta_x, delta_y)

	local s = game_settings.size
	local c_x, c_y = self:center(delta_x, delta_y)

	love.graphics.setColor(0,0,0,0.4)
	love.graphics.ellipse('fill', c_x, c_y, s / 2, s / 2)
	love.graphics.setColor(0,0,0, 1)

end

return soldier