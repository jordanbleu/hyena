local gfx <const> = playdate.graphics


--[[
    An actor object is a sprite that exists in the game world.  Adds extended 
    fucntionality from a normal sprite including time scaling.
  ]]
class("Actor").extends(gfx.sprite)

function Actor:init()
    --self.updateTimer = playdate.timer.performAfterDelay(GLOBAL_TIME_DELAY,function() self:physicsUpdate() end)
    --self.updateTimer.repeats = true
end

function Actor:update()
    if (GLOBAL_PHYSICS_ENABLED) then
        self:physicsUpdate()
    end
end

--[[ 
    Called each frame but only if physics are enabled.

    Things that should be in physicsUpdate:
    * Movement logic
    * Drawing stuff
    * Timers 

    Things that should NOT be in physicsUpdate
    * collision detection
    * UI stuff
    * things that have to always run
 ]]
function Actor:physicsUpdate()
end
