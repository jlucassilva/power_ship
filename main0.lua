-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local ship
local backGroup = display.newGroup()
local mainGroup = display.newGroup()

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local background = display.newImageRect(backGroup, "background.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

ship = display.newImageRect(mainGroup, "ship.png", 112, 112)
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody(ship, { radius = 30, isSensor = true })
ship.myName = "ship"

--ship:addEventListener("tap")

local function dragShip(event)
    local ship = event.target
    local phase = event.phase
    if ("began" == phase) then
        --
        display.currentStage:setFocus(ship)
        --
        ship.touchOffsetX = event.x - ship.x
        ship.touchOffsetY = event.y - ship.y

    elseif ("moved" == phase) then
        --
        ship.x = event.x - ship.touchOffsetX
        ship.y = event.y - ship.touchOffsetY

    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end
    return true
end

ship:addEventListener( "touch", dragShip )
