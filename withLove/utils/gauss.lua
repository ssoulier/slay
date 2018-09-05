local gauss = {}

gauss.random = function(mean, variance)
	return math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

return gauss