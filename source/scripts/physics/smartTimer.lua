local gfx <const> = playdate.graphics


--[[
    This is a timer that is smart enough to scale with the global time scale.  It uses frames 
    internally intead of whatever the normal playdate timers use so it works better for
    our purposes.
]]
class("SmartTimer").extends(Actor)

function SmartTimer:init(timeMs)
    SmartTimer.super.init(self)

    -- convert the milliseconds into total cycles
    self.cycles =  playdate.convertMsToFrames(timeMs)
    self.cycleCounter = 0

    self.updateCallback = nil
    self.completeCallback = nil
    self.repeats = false

    self.isPlaying = true
    self:add()
    print ("timer started at " .. tostring(playdate.getElapsedTime()))
end


function SmartTimer:physicsUpdate()
    SmartTimer.super.physicsUpdate(self)

    if (not self.isPlaying) then
        return
    end

    self.cycleCounter+=1

    if (self.updateCallback) then
        self.updateCallback()
    end

    if (self.cycleCounter > self.cycles) then
        print ("timer ended at: (should be 3 seconds later)" .. tostring(playdate.getElapsedTime()))
  
        if (self.completeCallback) then
            self.completeCallback()
        end

        if (self.repeats) then
            self:reset()
        else
            self:pause()
            self:reset()
        end
    end

end

function SmartTimer:onUpdate(updateFunc)
    self.updateCallback = updateFunc
end

function SmartTimer:onCompleted(completeFunc)
    self.completeCallback = completeFunc
end

function SmartTimer:setRepeats(doesRepeat)
    self.repeats = doesRepeat
end

function SmartTimer:pause()
    self.isPlaying = false
end

function SmartTimer:play()
    self.isPlaying = true
end

function SmartTimer:reset()
    self.cycleCounter = 0
end