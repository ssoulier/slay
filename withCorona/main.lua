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

---------------------------------------------
-- Called when a mouse event has been received.
local function onMouseEvent( event )
    -- Print the mouse cursor's current position to the log.
    local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
    print( message )
end
                              
-- Add the mouse event listener.
--Runtime:addEventListener( "mouse", onMouseEvent )
----------------------------------------------------

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )
math.random(); math.random(); math.random()

-- Go to menu Scene

composer.gotoScene("game")