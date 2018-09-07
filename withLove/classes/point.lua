local Object = require 'utils/classic'

local point = Object:extend()

function point:new(x, y)
	self.x = x
	self.y = y
end

return point