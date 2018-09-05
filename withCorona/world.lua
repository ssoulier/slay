local utils = require('utils')
local mapData = require('mapData')
local hex = require('hex')
local gameConfig = require('gameConfig')
local gameDisplay = require('gameDisplay')

world = {}

local mapCoordinates = mapData.mapCoordinates

local function onMouseScroll( event )

	if event.type == 'scroll' then

		if event.scrollY > 0 then -- Zoom OUT

			if gameDisplay.map.xScale > gameConfig.scaleMin then
				gameDisplay.map.xScale = math.max(gameDisplay.map.xScale - gameConfig.scaleTick, gameConfig.scaleMin)
				gameDisplay.map.yScale = math.max(gameDisplay.map.yScale - gameConfig.scaleTick, gameConfig.scaleMin)
			else
				gameDisplay.map.xScale = gameConfig.scaleMin
				gameDisplay.map.yScale = gameConfig.scaleMin
			end

		elseif event.scrollY < 0  then -- Zoom IN

			if gameDisplay.map.xScale < gameConfig.scaleMax then
				gameDisplay.map.xScale = math.min(gameDisplay.map.xScale  + gameConfig.scaleTick, gameConfig.scaleMax)
				gameDisplay.map.yScale = math.min(gameDisplay.map.yScale  + gameConfig.scaleTick, gameConfig.scaleMax)
			else
				gameDisplay.map.xScale = gameConfig.scaleMax
				gameDisplay.map.yScale = gameConfig.scaleMax
			end

		end

		print(event.scrollY)
		print(gameDisplay.map.xScale, gameDisplay.map.yScale)
	end

end

Runtime:addEventListener("mouse", onMouseScroll)


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
			local currentHex = hex.drawHex(gameDisplay.map, i, j, mapCoordinates[i][j].color, mapCoordinates[i][j].colorName, mapCoordinates[i][j].soldier, 'normal')
			currentHex.sprite:addEventListener("tap", mapCoordinates[i][j].sprite)
		end
	end

	gameDisplay.map:addEventListener("touch", gameDisplay.map)

	gameDisplay.map:scale(gameConfig.scale, gameConfig.scale)


end


local function drawMiniMap()

	for i=1,gameConfig.xSize do
		for j=1,gameConfig.ySize do
			local currentHex = hex.drawHex(gameDisplay.miniMap, i, j, mapCoordinates[i][j].color, mapCoordinates[i][j].colorName, false, 'mini')
			currentHex.sprite:addEventListener("tap", mapCoordinates[i][j].sprite)
		end
	end

	gameDisplay.miniMap:scale(gameConfig.miniMapScale, gameConfig.miniMapScale)
	gameDisplay.miniMap.x = display.contentWidth - gameDisplay.miniMap.contentWidth
	gameDisplay.miniMap.y = 0

	


end

world.drawMap = drawMap
world.drawMiniMap = drawMiniMap

return world