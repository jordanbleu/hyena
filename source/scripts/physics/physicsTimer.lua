local gfx <const> = playdate.graphics

--[[
    Basically a decorator for the normal timer object that will alter the timer by 
    the global time scale.
]]
class("PhysicsTimer").extends(gfx.sprite)

function PhysicsTimer:init(standardDelay, callbackFunc)
    self.timer = playdate.timer.performAfterDelay(standardDelay + GLOBAL_TIME_DELAY, callbackFunc)
    self.timer.repeats = true

    self.standardDelay = standardDelay
    self.globalTimeDelay = GLOBAL_TIME_DELAY
    self:add()
end

function PhysicsTimer:update()
    -- this just alters the current delay automatically based on changes to global time delay
    if (self.globalTimeDelay ~= GLOBAL_TIME_DELAY) then
        self.globalTimeDelay = GLOBAL_TIME_DELAY
        self.timer.duration = self.standardDelay + self.globalTimeDelay
    end
end

function PhysicsTimer:remove()
    self.timer:remove()
    PhysicsTimer.super.remove(this)
end