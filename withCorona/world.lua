local utils = require('utils')
local mapData = require('mapData')
local hex = require('hex')
local gameConfig = require('gameConfig')
local gameDisplay = require('gameDisplay')

world = {}

local mapCoordinates = mapData.mapCoordinates


function gameDisplay.map:touch(event)

	if event.phase == "began" then
		transition.cancel()
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
			local currentHex = hex.drawHex(gameDisplay.map, i, j, mapCoordinates[i][j].color, mapCoordinates[i][j].colorName, mapCoordinates[i][j].soldier)
			currentHex.sprite:addEventListener("tap", mapCoordinates[i][j].sprite)
		end
	end

	gameDisplay.map:addEventListener("touch", gameDisplay.map)

	gameDisplay.map:scale(gameConfig.scale, gameConfig.scale)

	gameDisplay.map.x = display.contentCenterX / 2
	gameDisplay.map.y = display.contentCenterY /2
	gameDisplay.map.anchor = 0.5

end


local function drawMiniMap()

	for i=1,gameConfig.xSize do
		for j=1,gameConfig.ySize do
			local currentHex = hex.drawHex(gameDisplay.miniMap, i, j, mapCoordinates[i][j].color, mapCoordinates[i][j].colorName, false)
			currentHex.sprite:addEventListener("tap", mapCoordinates[i][j].sprite)
		end
	end

	gameDisplay.miniMap:addEventListener("touch", gameDisplay.miniMap)

	--gameDisplay.x = 0
	--gameDisplay.y = display.contentHeight * (1-gameDisplay.miniMapScale)
	gameDisplay.miniMap:scale(gameConfig.miniMapScale, gameConfig.miniMapScale)
	gameDisplay.miniMap.x = display.contentWidth - gameDisplay.miniMap.contentWidth
	gameDisplay.miniMap.y = 0
	print("contentHeight: " .. gameDisplay.miniMap.contentHeight)
	print("contentWidth: " ..gameDisplay.miniMap.contentWidth)
	print("contentHeight: " .. display.contentHeight)
	print("contentWidth: " .. display.contentWidth)
	


end

world.drawMap = drawMap
world.drawMiniMap = drawMiniMap

return world