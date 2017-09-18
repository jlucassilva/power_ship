
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local ship
local powerCore1
local powerCore2
local powerCore3
local powerCore4
local backGroup
local mainGroup

local joint


local function dragShip(event)
  local anything = event.target
  local phase = event.phase
  if ("began" == phase) then
    --
    display.currentStage:setFocus(anything)
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


local function endGame()
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  physics.pause()
  backGroup = display.newGroup()
  sceneGroup:insert( backGroup )
  mainGroup = display.newGroup()
  sceneGroup:insert( mainGroup )

  local background = display.newImageRect(backGroup, "background.png", 360, 570)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  ship = display.newImageRect(mainGroup, "ship.png", 62, 52)
  ship.x = display.contentCenterX
  ship.y = display.contentHeight - 100
  physics.addBody( ship, { radius=31, isSensor=true } )
  ship.myName = "ship"

  powerCore1 = display.newImageRect( mainGroup, "pw1.png",22, 33 )
  physics.addBody( powerCore1, "dynamic", {radius = 22, bounce = 0} )
  powerCore1.x = ship.x
  powerCore1.y = ship.y + 30
  powerCore1:toBack()

  powerCore2 = display.newImageRect( mainGroup, "pw1.png",22, 33 )
  physics.addBody( powerCore2, "dynamic", {radius = 22, bounce = 0} )
  powerCore2.x = powerCore1.x
  powerCore2.y = powerCore1.y + 30
  powerCore2:toBack()

  powerCore3 = display.newImageRect( mainGroup, "pw1.png",22, 33)
  physics.addBody( powerCore3, "dynamic", {radius = 22, bounce = 0} )
  powerCore3.x = powerCore2.x
  powerCore3.y = powerCore2.y + 30
  powerCore3:toBack()

  powerCore4 = display.newImageRect( mainGroup, "pw1.png", 22, 33 )
  physics.addBody( powerCore4, "dynamic", {radius = 22, bounce = 0} )
  powerCore4.x = powerCore3.x
  powerCore4.y = powerCore3.y+30
  powerCore4:toBack()

  -- joint = physics.newJoint( "distance", ship, powerCore, ship.x, ship.y, powerCore.x, powerCore.y )
  joint = physics.newJoint( "pivot", ship, powerCore1, ship.x, ship.y)
  joint = physics.newJoint( "pivot", powerCore1, powerCore2, powerCore1.x, powerCore1.y)
  joint = physics.newJoint( "pivot", powerCore2, powerCore3, powerCore2.x, powerCore2.y)
  joint = physics.newJoint( "pivot", powerCore3, powerCore4, powerCore3.x, powerCore3.y)

  local function basicShot()
    local newShot = display.newImageRect( mainGroup, "blue_plazma.png", 33, 108)

    physics.addBody( newShot, "dynamic", { isSensor=true } )
    newShot.isBullet = true
    newShot.myName = "laser"

    newShot.x = ship.x
    newShot.y = ship.y
    newShot:toBack()

    transition.to( newShot, {y=-50, time = 500,
    onComplete = function() display.remove( newShot ) end
  } )
end

background:addEventListener( "tap", basicShot )
background:addEventListener( "touch", dragShip )

end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

    physics.start()
    -- Runtime:addEventListener("collision", onCollision)
    -- gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    timer.cancel( gameLoopTimer )

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    -- Runtime:removeEventListener( "collision", onCollision )
    physics.pause()
    composer.removeScene("game")

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
