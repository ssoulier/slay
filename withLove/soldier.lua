local draw = require 'utils/draw'
local game_settings = require 'config/game_settings'

local soldier = Class{}


soldier.level1 = {}
soldier.level1.cost = 5

function soldier:init()

	self.x = nil
	self.y = nil

end

function soldier:center()

	return draw.center(self.x, self.y)

end

function soldier:draw()

	local c_x, c_y
	if self.x and self.y then
		c_x, c_y = self:center()
	else
		c_x, c_y = draw.screenToWorld(love.mouse.getX(), love.mouse.getY())
	end

	love.graphics.push()
	love.graphics.setColor(0,0,0,0.4)
	love.graphics.circle('fill', c_x, c_y, s / 2)
	love.graphics.pop()

end

return soldier