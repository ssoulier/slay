local draw = {}
local game_settings = require 'config/game_settings'


function draw.center(x, y)

	local h = s * math.sqrt(3) / 2


	local cx = 2*h*(x - 1) + ( y % 2) * h
	local cy = s + 3*(y-1)*s/2

	return draw.worldToScreen(cx, cy)
end

function draw.worldToScreen(wx, wy)
	--return wx*scaleX + translationX, wy * scaleY + translationY
	--return wx - translationX,  wy - translationY
	return wx, wy
end

function draw.screenToWorld(sx, sy)
	return (sx-translationX)/scaleX, (sy-translationY)/scaleY
	--return (sx-translationX)/scaleX, (sy-translationY)/scaleY
	--return sx, sy
end

function draw.worldVerticesToScreen(vertices)

	local result = {}
	for i = 1, #vertices, 2 do

		local sx, sy = draw.worldToScreen(vertices[i], vertices[i+1])
		table.insert(result, sx)
		table.insert(result, sy)
	end

	return result

end

return draw