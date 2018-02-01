-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

------------------------------------------
local performance = require('performance')
performance:newPerformanceMeter()
------------------------------------------


-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )
math.random(); math.random(); math.random()

-- Go to menu Scene

composer.gotoScene("game")