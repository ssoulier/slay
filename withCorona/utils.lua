local json = require("json")
local size = 120
local result = {}
local utils = {}
local xSize = 15
local ySize = 25

local selectedCounty = nil

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end


local function coordinateToString(x,y)
	return x .. y
end

local blue = {66 / 255, 134 / 255, 244 / 255}
local green = {66 / 255, 244 / 255, 143 / 255}
local orange = {244 / 255, 131 / 255, 66 / 255}
local pink = {244 / 255, 66 / 255, 167 / 255}
local yellow = {244 / 255, 235 / 255, 66 / 255}
local strokeGray = {135 / 255, 135 / 255, 135 / 255}
local strokeWhite = {224 / 255, 224 / 255, 224 / 255}

local colors = {blue, green, orange, pink, yellow}
local colorNames = {"blue", "green", "orange", "pink", "yellow"}


local highlightFrontier
highlightFrontier = function(x, y, colorName , done, selectedCounty)

	--print(to_string(done))
	--print(to_string(selectedCounty))
	
	if x == 0 or x == xSize + 1 then 
		return nil
	end

	if y == 0 or y == ySize + 1 then
		return nil
	end

	local h = size * math.sqrt(3) / 2
	local centerX = 3 * size / 2 * (x - 1) + size
	local centerY =  h * ( 2 * (y - 1) + (x - 1) % 2) + h
	local strokeColor = {0,0,0}
	local strokeWidth = 20

	local lag = x % 2


	if(done[coordinateToString(x-1, y - lag)] == nil) then
		if((x-1) ~= 0 and (y-lag) ~= 0 and result[x - 1][y - lag].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x - 1, y - lag, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX - size, centerY, centerX - size/2, centerY - h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end


	if(done[coordinateToString(x, y-1)] == nil) then
		if((y-1) ~= 0 and result[x][y - 1].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x, y - 1, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX - size/2, centerY - h, centerX + size/2, centerY - h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[coordinateToString(x+1, y - lag)] == nil) then 
		if((x+1) ~= xSize and (y-lag) ~= 0 and result[x + 1][y - lag].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x + 1, y - lag, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX + size/2, centerY - h, centerX + size, centerY)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[coordinateToString(x+1, y+1- lag)] == nil) then
		if((x+1) ~= xSize and (y+1 - lag) ~= ySize and result[x +1][y+1- lag].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x + 1, y+1- lag, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX + size, centerY, centerX + size/2, centerY + h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[coordinateToString(x, y+1)] == nil) then
		if((y+1) ~= ySize and result[x][y+1].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x, y + 1, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX + size/2, centerY + h,centerX - size/2, centerY + h)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end

	if(done[coordinateToString(x-1, y+1- lag)] == nil) then
		if((x-1) ~= 0 and (y +1 -lag) ~= ySize and result[x-1][y+1- lag].colorName == colorName) then
			done[coordinateToString(x, y)] = true
			highlightFrontier(x-1, y+1- lag, colorName, done, selectedCounty)
		else
			local line = display.newLine(selectedCounty,centerX - size/2, centerY + h, centerX - size, centerY)
			line.strokeWidth = strokeWidth
			line:setStrokeColor(unpack(strokeColor))
		end
	end
end

local selectedCounty = display.newGroup()

local function Hex(x, y, color, colorName, sprite)
	function sprite:tap(event)
		if(selectedCounty ~= nil) then
			selectedCounty:removeSelf()
		end
		selectedCounty = display.newGroup()
		highlightFrontier(x, y, colorName, {}, selectedCounty)
	end

	return {x = x, y = y, color = color, colorName = colorName, sprite = sprite}
end


local function drawHex(group, x, y, color, colorName)

	local h = size * math.sqrt(3) / 2

	local vertices = {
		-size, y,
		- size / 2, y - h,
		size / 2, y - h,
		size, y,
		size / 2, y + h,
		- size / 2, y + h,
	}

	local centerX = 3 * size / 2 * (x - 1) + size
	local centerY =  h * ( 2 * (y -1) + (x - 1) % 2) + h

	local myText = display.newText("(" .. tostring(x) .. ", " .. tostring(y) .. ")", centerX, centerY, native.systemFont, 56)

	local hex = display.newPolygon(group, centerX, centerY, vertices)
	hex:setFillColor(unpack(color))
	hex:setStrokeColor(unpack(strokeGray))
	hex.strokeWidth = 3
	return Hex(x, y, color, colorName, hex)
end

local function randomIndex(array)
	return math.random(#array)
end



local function drawMap()

	local map = display.newGroup()

	for i=1,xSize do
		result[i] = {}
		for j=1,ySize do
			local index = randomIndex(colors)
			result[i][j] = drawHex(map, i, j, colors[index], colorNames[index])
			result[i][j].sprite:addEventListener("tap", result[i][j].sprite)
		end
	end

	return result

end



local function loadTiles()

	local filePath = system.pathForFile("assets/hexagon-pack/Spritesheets/hex_spritesheets_saly.json")
	local file = io.open(filePath, "r")

	local tilesSheetOptions = {}
	if file then
		local contents = file:read("*a")
		io.close(file)
		tilesSheetOptions = json.decode(contents)
	end

	return graphics.newImageSheet("assets/hexagon-pack/Spritesheets/hexagonAll_sheet.png", tilesSheetOptions)

end

local function loadTerrain()

	local terrains = {"grass_05.png", "dirt_06.png"}

	local result = display.newGroup()
	for i, terrainName in ipairs(terrains) do
		print(filePath)
		local tmp = display.newImageRect(result, "assets/" .. terrainName, 120, 140)
		print(tmp)
		result:insert( tmp )
	end

	return result

end


utils.loadTiles = loadTiles
utils.loadTerrain = loadTerrain
utils.drawHex = drawHex
utils.drawMap = drawMap

return utils