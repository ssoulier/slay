local tower = Class{}

function tower:init(x, y)

	self.x = x
	self.y = y
	self.level = 2

end

function tower:draw()

	local x, y = Utils.center(self.x, self.y)
	local asset_width, asset_height = assets['tower']:getDimensions()
	local scale_factor = (tile_size / Settings.tile_size) * Settings.asset_scaling
	love.graphics.draw(assets['tower'], x - asset_width * scale_factor / 2, y  - asset_height * scale_factor / 2, 0, scale_factor)

end


return tower