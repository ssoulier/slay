
gameConfig = {}


------- Color -----------
blue = {66 / 255, 134 / 255, 244 / 255}
green = {66 / 255, 244 / 255, 143 / 255}
orange = {244 / 255, 131 / 255, 66 / 255}
pink = {244 / 255, 66 / 255, 167 / 255}
yellow = {244 / 255, 235 / 255, 66 / 255}
strokeGray = {135 / 255, 135 / 255, 135 / 255}
strokeWhite = {224 / 255, 224 / 255, 224 / 255}
------------------

------- MAP
gameConfig.size = 60
gameConfig.scale = 1
gameConfig.xSize = 12
gameConfig.ySize = 6

------ Mini MAP
gameConfig.miniMapScale = 0.2


gameConfig.soldierSize = gameConfig.size / 3
gameConfig.soldiers = 1
gameConfig.towns = 1

------- County
gameConfig.countyStrokeWidth = 5
gameConfig.countyStrokeColor = {0,0,0}


------- Hex
gameConfig.hexStrokeWidth = 3
gameConfig.hexStrokeColor = strokeGray

------- DEBUG
gameConfig.debug = false
gameConfig.coordinateSize = 20


------- Zoom
gameConfig.scaleTick = 0.1
gameConfig.scaleMin = 0.2
gameConfig.scaleMax = 2

gameConfig.colors = {blue, green, orange, pink, yellow}
gameConfig.colorNames = {"blue", "green", "orange", "pink", "yellow"}

return gameConfig