gameConfig = {}

gameConfig.size = 120
gameConfig.scale = 0.8
gameConfig.xSize = 15
gameConfig.ySize = 25

gameConfig.selectedCounty = display.newGroup()
gameConfig.map = display.newGroup()

blue = {66 / 255, 134 / 255, 244 / 255}
green = {66 / 255, 244 / 255, 143 / 255}
orange = {244 / 255, 131 / 255, 66 / 255}
pink = {244 / 255, 66 / 255, 167 / 255}
yellow = {244 / 255, 235 / 255, 66 / 255}
strokeGray = {135 / 255, 135 / 255, 135 / 255}
strokeWhite = {224 / 255, 224 / 255, 224 / 255}

gameConfig.colors = {blue, green, orange, pink, yellow}
gameConfig.colorNames = {"blue", "green", "orange", "pink", "yellow"}

return gameConfig