local line = Class{}

function line:init(p1, p2)

	self.p1 = p1
	self.p2 = p2

end

function line:toTable()
	return {self.p1.x, self.p1.y, self.p2.x, self.p2.y}
end

function line:draw()

	love.graphics.line(self:toTable())

end


return line