local utils = require('utils')
local mapData = require('mapData')
local gameConfig = require('gameConfig')
local gameDisplay = require('gameDisplay')
hex = {}

local highlightFrontier
highlightFrontier = function(x, y, colorName , done, selectedCounty, worldCoordinates)
	
	if x == 0 or x == gameConfig.xSize + 1 then 
		return nil
	end

	if y == 0 or y == gameConfig.ySize + 1 then
		return nil
	end

	local scaleSize = gameConfig.scale * gameConfig.size

	local h = scaleSize * math.sqrt(3) / 2
	local centerX = 3 * scaleSize / 2 * (x - 1) + scaleSize + gameDisplay.map.x
	local centerY =  h * ( 2 * (y - 1) + (x - 1) % 2) + h + gameDisplay.map.y
	local strokeColor = {0,0,0}
	local strokeWidth = 20

	local lag = x % 2


	if(done[utils.hashCoordinate(x-1, y - lag)] == nil) then
		if((x-1) ~= 0 and (y-lag) ~= 0 and worldCoordinates[x - 1][y - lag].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x - 1, y - lag, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX - scaleSize, centerY, centerX - scaleSize/2, centerY - h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end


	if(done[utils.hashCoordinate(x, y-1)] == nil) then
		if((y-1) ~= 0 and worldCoordinates[x][y - 1].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x, y - 1, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX - scaleSize/2, centerY - h, centerX + scaleSize/2, centerY - h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[utils.hashCoordinate(x+1, y - lag)] == nil) then 
		if(x ~= gameConfig.xSize and (y-lag) ~= 0 and worldCoordinates[x + 1][y - lag].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x + 1, y - lag, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX + scaleSize/2, centerY - h, centerX + scaleSize, centerY)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[utils.hashCoordinate(x+1, y+1- lag)] == nil) then
		if(x ~= gameConfig.xSize  and (y - lag) ~= gameConfig.ySize and worldCoordinates[x +1][y+1- lag].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x + 1, y+1- lag, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX + scaleSize, centerY, centerX + scaleSize/2, centerY + h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[utils.hashCoordinate(x, y+1)] == nil) then
		if(y ~= gameConfig.ySize and worldCoordinates[x][y+1].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x, y + 1, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX + scaleSize/2, centerY + h,centerX - scaleSize/2, centerY + h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[utils.hashCoordinate(x-1, y+1- lag)] == nil) then
		if((x-1) ~= 0 and (y -lag) ~= gameConfig.ySize and worldCoordinates[x-1][y+1- lag].colorName == colorName) then
			done[utils.hashCoordinate(x, y)] = true
			highlightFrontier(x-1, y+1- lag, colorName, done, selectedCounty, worldCoordinates)
		else
			local line = display.newLine(selectedCounty,centerX - scaleSize/2, centerY + h, centerX - scaleSize, centerY)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end
end


local function Hex(x, y, color, colorName, sprite)
	function sprite:tap(event)
		if(selectedCounty ~= nil) then
			gameDisplay.selectedCounty:removeSelf()
		end
		gameDisplay.selectedCounty = display.newGroup()
		highlightFrontier(x, y, colorName, {}, gameDisplay.selectedCounty, mapData.mapCoordinates)
	end

	return {x = x, y = y, color = color, colorName = colorName, sprite = sprite}
end


local function drawHex(group, x, y, color, colorName)

	local h = gameConfig.size * math.sqrt(3) / 2

	local vertices = {
		-gameConfig.size, y,
		- gameConfig.size / 2, y - h,
		gameConfig.size / 2, y - h,
		gameConfig.size, y,
		gameConfig.size / 2, y + h,
		- gameConfig.size / 2, y + h,
	}

	local centerX = 3 * gameConfig.size / 2 * (x - 1) + gameConfig.size
	local centerY =  h * ( 2 * (y -1) + (x - 1) % 2) + h

	local hex = display.newPolygon(group, centerX, centerY, vertices)
	local myText = display.newText(group, "(" .. tostring(x) .. ", " .. tostring(y) .. ")", centerX, centerY, native.systemFont, 56)
	hex:setFillColor(unpack(color))
	hex:setStrokeColor(unpack(strokeGray))
	hex.strokeWidth = 3
	return Hex(x, y, color, colorName, hex)
end


hex.drawHex = drawHex

return hex