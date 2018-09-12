local Object = require 'utils/classic'
local draw = require 'utils/draw'
local game_settings = require 'config/game_settings'

local soldier = Object:extend()


function soldier:new(x, y)

	self.x = x
	self.y = y

end

function soldier:center()

	return draw.center(self.x, self.y)

end

function soldier:draw()

	local c_x, c_y = self:center()

	love.graphics.push()
	love.graphics.setColor(0,0,0,0.4)
	love.graphics.circle('fill', c_x, c_y, s / 2)
	love.graphics.push(pop)


end

return soldier