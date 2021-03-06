---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local sprite = require( "sprite" )


system.setIdleTimer( false )
system.setAccelerometerInterval( 100 )

local physics = require "physics"
local physicsData = (require "myphysics").physicsData(1.0)
physics.setReportCollisionsInContentCoordinates( true )
---------------------------------------------------------------------------------
-- BEGINNING OF  IMPLEMENTATION
---------------------------------------------------------------------------------
local displayTime,background,planet,maze,maze2,borders,exitscn
local startTime=0
local levelTime = 45
local score=0
local now
local exitSound = audio.loadSound("exit.wav")
local backgroundMusicSound = audio.loadStream ( "background.mp3" )
local blackholeSprite = 0
local blackholeSprite2 = 0
local explosionSprite
local planetSprite



function onTilt( event )
	physics.setGravity( (-9.8*event.yGravity), (-9.8*event.xGravity) ) --Το σωστό
end


local function gameOver()
	audio.stop()
	storyboard.gotoScene( "gameover", "fade", 300)
end


function nextScene()
	audio.stop()
	audio.play( exitSound  )
	physics.stop()
    storyboard.state.score =storyboard.state.score+ (levelTime - (now - startTime))*30
    storyboard.state2.level = 6
    storyboard.gotoScene( "loadscene6")
end

local function onCollision( event )
	if ( event.phase == "began" ) then
       	if(event.object1.name =="exitscn" or event.object2.name =="exitscn") then
       		timer.performWithDelay ( 200, nextScene )
        end 
        if((event.object1.name =="blackholeSprite" and event.object2.name =="planet") or (event.object2.name =="blackholeSprite" and event.object1.name =="planet")) then
        	planetSprite.isVisible = false
        	explosionSprite.x=event.x
        	explosionSprite.y=event.y
			explosionSprite:play()
			timer.performWithDelay( 1000, gameOver )    
        end 
	end

end


local function blackholeRotate()
	blackholeSprite:rotate(0.8)
	blackholeSprite2:rotate(-0.8)
end


 


local function checkTime(event)
  now = os.time()
  displayTime.text = levelTime - (now - startTime)
  --change the colour of the timer based on how much time is remaining
  if ( levelTime - (now - startTime)==levelTime/2) then
  	transition.to(displayTime,{time=100,size=30})
  	displayTime:setTextColor( 214,223, 32 )
  end
  if ( levelTime - (now - startTime)==5) then
  	transition.to(displayTime,{time=100,size=40})
  	displayTime:setTextColor( 239,89, 40 )
  end
  --gamve over when there is no remaining time
  if ( levelTime - (now - startTime)==0) then
	planetSprite.isVisible = false
    explosionSprite.x=planetSprite.x
    explosionSprite.y=planetSprite.y
	explosionSprite:play()
	timer.performWithDelay( 3000, gameOver )
  end
end


local function mazeRotate()
	maze:rotate(0.1)
 	maze2:rotate(0.1)
end





-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	physics.start(); 
	physics.setGravity( 0,0 )
	
	displayTime = display.newText(levelTime, display.contentWidth-40, 15)
	displayTime.alpha = 0
	displayTime.size = 20
	displayTime:setTextColor( 0,173, 239 )

	background = display.newImageRect( "background2.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
		
	-- planet=display.newImage("sunsprite.png")
	-- planet.x=30
	-- planet.y=display.contentCenterY
	-- planet.name="ball"

	local planetoptions = {
   		width = 24,
   		height = 24,
   		numFrames = 5
		}

	local planetSheet = graphics.newImageSheet( "earthsprite.png", planetoptions )

	local planetSequenceData =
			{
    		name="blackholeflashing",
		    start=1,
		    count=5,
		    time=500,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 0,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
			}

	planetSprite = display.newSprite( planetSheet, planetSequenceData )
	planetSprite.x = 75
	planetSprite.y = 15
	planetSprite.x = 30
	planetSprite.y = display.contentCenterY
	planetSprite.name = "planet"
	planetSprite:play()


	
	maze=display.newImage( "maze5.png" )
	maze.x=display.contentCenterX
	maze.y=display.contentCenterY
	maze.name="maze"
	
	maze2=display.newImage( "maze5.png" )
	maze2.x=display.contentCenterX
	maze2.y=display.contentCenterY
	maze2.name="maze2"
	
	borderleft = display.newImage( "borderleftright.png" )
	borderleft.x = 1
	borderleft.y = display.contentCenterY

	borderright = display.newImage( "borderleftright.png" )
	borderright.x = display.contentWidth-1
	borderright.y = display.contentCenterY

	borderup = display.newImage( "borderupdown.png")
	borderup.x = display.contentCenterX
	borderup.y = 1

	borderdown = display.newImage( "borderupdown.png")
	borderdown.x = display.contentCenterX
	borderdown.y = display.contentHeight - 1 
	
	exitscn=display.newImage("exit.png")
	exitscn.x=display.contentWidth-70
	exitscn.y=30
	exitscn.name="exitscn"


	
	local blackholeoptions = {
   		width = 32,
   		height = 24,
   		numFrames = 4
		}

	local blackholeSheet = graphics.newImageSheet( "blackholesheet.png", blackholeoptions )

	local blackholeSequenceData =
			{
    		name="blackholeflashing",
		    start=1, --Starting loop
		    count=4,
		    time=800,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 0,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "forward"    -- Optional. Values include: "forward","bounce"
			}

	blackholeSprite = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite.x = display.contentCenterX+40
	blackholeSprite.y = display.contentCenterY
	blackholeSprite.name = "blackholeSprite"
	blackholeSprite:play()

	blackholeSprite2 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite2.x = display.contentCenterX-30
	blackholeSprite2.y = 30 --display.contentCenterY-80
	blackholeSprite2.name = "blackholeSprite"
	blackholeSprite2:play()

	blackholeSprite3 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite3.x = display.contentCenterX-90
	blackholeSprite3.y = 160 --display.contentCenterY-80
	blackholeSprite3.name = "blackholeSprite"
	blackholeSprite3:play()

	local explosionoptions = {
   		width = 32,
   		height = 32,
   		numFrames = 24
		}
		
	local explosionSheet = graphics.newImageSheet( "explosion.png", explosionoptions )

	local explosionSequenceData =
		{
    		name="explosionsequence",
		    start=1,
		    count=24,
		    time=2000,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 1,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "forward"    -- Optional. Values include: "forward","bounce"
		}



	explosionSprite = display.newSprite( explosionSheet, explosionSequenceData )
	explosionSprite.x = 100
	explosionSprite.y = 50
	explosionSprite.name = "explosion"



	
	physics.addBody (planetSprite, "dynamic",physicsData:get("earthphysics"))
	planetSprite.isSleepingAllowed = false
	physics.addBody (maze, "static",physicsData:get("mazelevel5_1"))
	physics.addBody (maze2, "static",physicsData:get("mazelevel5_2"))
	physics.addBody (blackholeSprite, "static",physicsData:get("blackhole"))
	physics.addBody (blackholeSprite2, "static",physicsData:get("blackhole"))
	physics.addBody (blackholeSprite3, "static",physicsData:get("blackhole"))
	blackholeSprite.isSleepingAllowed = false
	blackholeSprite2.isSleepingAllowed = false
	blackholeSprite3.isSleepingAllowed = false
	physics.addBody (borderleft, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderright, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderup, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderdown, "static",{ friction=0.5, bounce=0 })
	physics.addBody (exitscn, "static",physicsData:get("exitscn"))
	
	-- planetSprite:addEventListener ( "touch", nextScene )
	Runtime:addEventListener("enterFrame", checkTime)
	Runtime:addEventListener( "accelerometer", onTilt )
	Runtime:addEventListener( "enterFrame", blackholeRotate)
	Runtime:addEventListener( "enterFrame", mazeRotate)
	-- Runtime:addEventListener( "gyroscope", onGyroscopeDataReceived )
	Runtime:addEventListener( "collision", onCollision )
	-- Runtime:addEventListener( "collision", onBlackHoleCollision )
	
	
	screenGroup:insert( background )
	screenGroup:insert(displayTime)
	screenGroup:insert( planetSprite )	
    screenGroup:insert( blackholeSprite )
	screenGroup:insert( blackholeSprite2 )
	screenGroup:insert( blackholeSprite3 )
	screenGroup:insert( explosionSprite )
	screenGroup:insert( maze )
	screenGroup:insert( maze2 )
	screenGroup:insert( borderleft )
	screenGroup:insert( borderright )
	screenGroup:insert( borderdown)
	screenGroup:insert( borderup)
	screenGroup:insert( exitscn )

	

	print( "\n1: createScene event")
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	print( "1: enterScene event" )
	physics.start()
    audio.play(backgroundMusicSound,{channel = 1,loops=-1})
	startTime = os.time()
	transition.to ( displayTime, {alpha=1,time=500} )
	
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "1: exitScene event" )
	physics.stop( )
    audio.stop()

	Runtime:removeEventListener( "enterFrame", checkTime )
	Runtime:removeEventListener( "accelerometer", onTilt )
    Runtime:removeEventListener( "enterFrame", blackholeRotate)
    Runtime:removeEventListener( "enterFrame", mazeRotate )
    -- Runtime:removeEventListener( "gyroscope", onGyroscopeDataReceived )

    Runtime:removeEventListener( "collision", onCollision )
    -- Runtime:removeEventListener( "collision", onBlackHoleCollision )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )

	print( "((destroying scene 1's view))" )
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene