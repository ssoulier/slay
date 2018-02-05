local utils = require('utils')
local gameConfig = require('gameConfig')

mapData = {}

local function generateMap()

	local mapCoordinates = {}
	local soldiersAttributed = {}
	for i=1,gameConfig.xSize do
		mapCoordinates[i] = {}
		for j=1,gameConfig.ySize do
			local index = utils.randomIndex(gameConfig.colors)
			local colorName = gameConfig.colorNames[index]
			local soldier = true

			if (soldiersAttributed[colorName] == nil) then
				soldiersAttributed[colorName] = soldier
			else
				soldier = false
			end

			mapCoordinates[i][j] = {color=gameConfig.colors[index], colorName=gameConfig.colorNames[index], soldier=soldier}
		end
	end

	return mapCoordinates

end

mapData.mapCoordinates = generateMap()

return mapData