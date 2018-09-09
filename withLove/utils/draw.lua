local draw = {}


function draw.center(x, y, delta_x, delta_y, s)

	local h = s * math.sqrt(3) / 2


	local cx = 2*h*(x - 1) + ( y % 2) * h
	local cy = s + 3*(y-1)*s/2

	return cx - delta_x, cy - delta_y 
end

return draw