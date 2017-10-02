
local composer = require( "composer" )
local gameSpeed = 400
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local explosionSheetInfo = require("explosionSheet")
local explosionSheet = graphics.newImageSheet( "explosionSheet.png", explosionSheetInfo:getSheet() )

local sequence_explosion = {
  {
    name = "explosion",
    start = 1,
    count = 8,
    time = 700,
    loopCount = 1,
    loopDirection = "forward"
  }
}

local ship
local backGroup
local mainGroup
local gameLoopTimer

local enemyTable = {}

local function createAsteroid()

  local newEnemy = display.newImageRect( mainGroup, "ufoBlue.png", 61, 61 )
  table.insert( enemyTable, newEnemy )
  physics.addBody( newEnemy, "dynamic", { radius=25, bounce=0.8 } )
  newEnemy.myName = "enemy"

  local spawnPoint = math.random( 3 )

  if ( spawnPoint == 1 ) then
    -- From the top position 1
    local contentWidth = (display.contentWidth/3)/2
    print(contentWidth)
    newEnemy.x = ( display.contentWidth/3)/2
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end
  if ( spawnPoint == 2 ) then
    -- From the top position 1
    newEnemy.x = ( display.contentWidth)/2
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end
  if ( spawnPoint == 3 ) then
    -- From the top position 1
    newEnemy.x = ( display.contentWidth/2 ) + ( display.contentWidth/3)
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end

end

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

local function basicShot()
  local newShot = display.newImageRect( mainGroup, "blue_plazma.png", 33, 108)

  physics.addBody( newShot, "dynamic", { isSensor=true } )
  newShot.isBullet = true
  newShot.myName = "laser"

  newShot.x = ship.x
  newShot.y = ship.y
  newShot:toBack()

  transition.to( newShot, {y=-250, time = 800,
  onComplete = function() display.remove( newShot ) end
} )
end

local function specialShoot( event )

    if ( event.numTaps == 2 ) then
      local newSpecialShot = display.newImageRect( mainGroup, "blue_plazma.png", 33, 108)

      physics.addBody( newSpecialShot, "dynamic", { isSensor=true } )
      newSpecialShot.isBullet = true
      newSpecialShot.myName = "specialShoot"

      newSpecialShot.x = ship.x
      newSpecialShot.y = ship.y
      newSpecialShot:toBack()

      transition.to( newSpecialShot, {y=-250, time = 1100,
      onComplete = function() display.remove( newShot ) end
    } )

  --   local animation = display.newSprite( explosionSheet, sequence_explosion )
  --   animation.x = display.contentCenterX
  --   animation.y = display.contentCenterY
  --   animation:play()
  --
  --   local function animationListener( event )
  --     if ( event.phase == "ended" ) then
  --       animation:removeSelf()
  --       animation = nil
  --     end
  --   end
  --   animation:addEventListener("sprite", animationListener)
  else
    return true
  end
end

local function gameLoop()
  basicShot()
  createAsteroid()

  for i = #enemyTable, 1, -1 do
    local thisEnemy = enemyTable[i]

    if ( thisEnemy.x < -100 or
       thisEnemy.x > display.contentWidth + 100 or
       thisEnemy.y < -100 or
       thisEnemy.y > display.contentHeight + 100 )
    then
      display.remove( thisEnemy )
      table.remove( enemyTable, i )
    end
  end

end

local function onCollision( event )
  if ( event.phase == "began" ) then
    local obj1 = event.object1
    local obj2 = event.object2

    -- Laser and Enemy collision
    if ( ( obj1.myName == "laser" and obj2.myName == "enemy") or
         ( obj1.myName == "enemy" and obj2.myName == "laser" ))
         then
           --
           display.remove( obj1 )
           display.remove( obj2 )

           for i=#enemyTable, 1, -1 do
             if (enemyTable[i] == obj1 or enemyTable[i] == obj2) then
               table.remove( enemyTable, i )
               break
             end
           end
    end

    --SpecialShoot end Enemy collision
    if ( ( obj1.myName == "specialShoot" and obj2.myName == "enemy") or
         ( obj1.myName == "enemy" and obj2.myName == "specialShoot" ))
         then
           --
           display.remove( obj1 )
           display.remove( obj2 )

           local animation = display.newSprite( explosionSheet, sequence_explosion )
           animation.x = event.x
           animation.y = event.y
           animation:play()

           local function animationListener( event )
             if ( event.phase == "ended" ) then
               animation:removeSelf()
               animation = nil
             end
           end
           animation:addEventListener("sprite", animationListener)

           for i=#enemyTable, 1, -1 do
             if (enemyTable[i] == obj1 or enemyTable[i] == obj2) then
               table.remove( enemyTable, i )
               break
             end
           end
    end

  end
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
  mainGroup = display.newGroup()

  sceneGroup:insert( backGroup )
  sceneGroup:insert( mainGroup )

  local background = display.newImageRect(backGroup, "background.png", 360, 570)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  ship = display.newImageRect(mainGroup, "ship.png", 62, 52)
  ship.x = display.contentCenterX
  ship.y = display.contentHeight - 100
  physics.addBody( ship, { radius=31, isSensor=true } )
  ship.myName = "ship"

background:addEventListener( "tap", specialShoot )
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
    Runtime:addEventListener("collision", onCollision)
    gameLoopTimer = timer.performWithDelay( gameSpeed, gameLoop, 0 )

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