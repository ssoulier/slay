local soldier = Class{}

function soldier:init(player_id, floating, level, x, y)

	if not floating then
		self.x = x
		self.y = y
	end
	self.player_id = player_id
	self.floating = floating
	self.level = level

end

function soldier:increaseLevel()

	if self.level < Settings.level_max then
		self.level = self.level + 1
	end

end


function soldier:draw()

	local x, y
	if self.floating then
		x, y = Utils.center(pixelTocenter(love.mouse.getX(), love.mouse.getY()))
	else
		x, y = Utils.center(self.x, self.y)
	end
	
	local asset_name = 'soldier_' .. self.level	
	local asset_width, asset_height = assets[asset_name]:getDimensions()
	local scale_factor = (tile_size / Settings.tile_size) * Settings.asset_scaling
	local x0 = x - asset_width * scale_factor / 2
	local y0 = y - asset_width * scale_factor / 2
	love.graphics.draw(assets[asset_name], x0, y0, 0, scale_factor)
	

end


return soldier