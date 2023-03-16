local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/physics/smartTimer"

class("WaitSegment").extends(Segment)

function WaitSegment:init(waitTime)
    print ("Enter wait segment.  Wait time is " .. tostring(waitTime))
    self.timerCompleted = false

    self.timer = SmartTimer(waitTime)
    self.timer:setRepeats(false)
    self.timer:onCompleted(function() self.timerCompleted = true end)
end

function WaitSegment:isCompleted()
    return self.timerCompleted
end

function WaitSegment:cleanup()
    self.timer:remove()
end