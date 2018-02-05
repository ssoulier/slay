local utils = require('utils')
local mapData = require('mapData')
local hex = require('hex')
local gameConfig = require('gameConfig')
local gameDisplay = require('gameDisplay')

world = {}

local mapCoordinates = mapData.mapCoordinates


function gameDisplay.map:touch(event)

	if event.phase == "began" then
		if gameDisplay.selectedCounty ~= nil then
			gameDisplay.selectedCounty:removeSelf()
			gameDisplay.selectedCounty = nil
		end

		display.getCurrentStage():setFocus(self, event.id)
		self.isFocus = true

		self.markX = self.x
		self.markY = self.y
	elseif self.isFocus then

		if (event.phase == "moved") then
			self.x = event.x - event.xStart + self.markX
			self.y = event.y - event.yStart + self.markY
		elseif (event.phase == "ended" or event.phase == "cancelled") then
			display.getCurrentStage():setFocus(self, nil)
			self.isFocus = false
		end
	end

	return true
end

local function drawMap()


	for i=1,gameConfig.xSize do
		for j=1,gameConfig.ySize do
			local currentHex = hex.drawHex(gameDisplay.map, i, j, mapCoordinates[i][j].color, mapCoordinates[i][j].colorName)
			currentHex.sprite:addEventListener("tap", mapCoordinates[i][j].sprite)
		end
	end

	gameDisplay.map:addEventListener("touch", gameDisplay.map)

	gameDisplay.map:scale(gameConfig.scale, gameConfig.scale)

	return mapCoordinates

end

world.drawMap = drawMap

return world