local Object = require 'utils/classic'

local line = Object:extend()

function line:new(p1, p2)

	self.p1 = p1
	self.p2 = p2

end

function line:toTable()
	return {self.p1.x, self.p1.y, self.p2.x, self.p2.y}
end

function line:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth(2)
	love.graphics.line(self:toTable())
	love.graphics.setColor(1,1,1)
	love.graphics.setLineWidth(1)
end


return line