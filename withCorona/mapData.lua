local utils = require('utils')
local gameConfig = require('gameConfig')

mapData = {}

local function generateMap()

	local mapCoordinates = {}
	for i=1,gameConfig.xSize do
		mapCoordinates[i] = {}
		for j=1,gameConfig.ySize do
			local index = utils.randomIndex(gameConfig.colors)
			mapCoordinates[i][j] = {color=gameConfig.colors[index], colorName=gameConfig.colorNames[index]}
		end
	end

	return mapCoordinates

end

mapData.mapCoordinates = generateMap()

return mapData