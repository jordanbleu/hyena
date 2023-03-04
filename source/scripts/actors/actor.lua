local gfx <const> = playdate.graphics


--[[
    An actor object is a sprite that exists in the game world.  Adds extended 
    fucntionality from a normal sprite including time scaling.
  ]]
class("Actor").extends(gfx.sprite)

function Actor:init()
    self.updateTimer = playdate.timer.performAfterDelay(GLOBAL_TIME_DELAY,function() self:physicsUpdate() end)
    self.updateTimer.repeats = true
end

function Actor:update()
    if (self.updateTimer.duration ~= GLOBAL_TIME_DELAY) then
        self.updateTimer.duration = GLOBAL_TIME_DELAY
        self.updateTimer:reset()
    end
end

--[[ Called each frame but is affected by the current timeScaler ]]
function Actor:physicsUpdate()
end

function Actor:remove()
    self.updateTimer:remove()
    Actor.super.remove(self)
end