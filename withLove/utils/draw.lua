local draw = {}
local game_settings = require 'config/game_settings'
local utils = require 'utils/utils'


function draw.center(x, y)

	local h = s * math.sqrt(3) / 2


	local cx = 2*h*(x - 1) + ( y % 2) * h
	local cy = s + 3*(y-1)*s/2

	return cx, cy
end

function draw.pixelTocenter(px, py)

	local wx, wy = draw.screenToWorld(px, py)
	local y = utils.round(2*(wy - s) / (3 * s) + 1, 0)
	local h = s * math.sqrt(3) / 2
	local x = utils.round((wx - (y % 2)*h)/(2*h) + 1)

	return x, y
end

function draw.screenToWorld(sx, sy)
	return sx-translationX, sy-translationY
end

return draw