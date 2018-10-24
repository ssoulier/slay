local town = Class{}

function town:init(x, y)

	self.x = x
	self.y = y

end

function town:vertices()

	return Utils.vertices(self.x, self.y, 3 * tile_size / 4)
end

function town:draw()

	
	local x, y = Utils.center(self.x, self.y)
	local asset_width, asset_height = assets['house']:getDimensions()
	local scale_factor = (tile_size / Settings.tile_size) * Settings.asset_scaling
	love.graphics.draw(assets['house'], x - asset_width * scale_factor / 2, y  - asset_height * scale_factor / 2, 0, scale_factor)

end


return town