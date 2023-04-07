local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/physics/smartTimer"

class("WaitSegment").extends(Segment)

---Waits for the specified Milliseconds 
---@param waitTime integer wait time in ms
---@param imagePath string path to a static image to display (optional)
function WaitSegment:init(waitTime, imagePath)
    self.timerCompleted = false

    self.sprite = nil
    if (imagePath) then
        self.sprite = gfx.sprite.new(gfx.image.new(imagePath))
        self.sprite:moveTo(200,120)
        self.sprite:setIgnoresDrawOffset(true)
        self.sprite:setZIndex(999)
        self.sprite:add()
    end

    self.timer = SmartTimer(waitTime)
    self.timer:setRepeats(false)
    self.timer:onCompleted(function() self.timerCompleted = true end)
end

function WaitSegment:isCompleted()
    return self.timerCompleted
end

function WaitSegment:cleanup()
    if (self.sprite) then
        self.sprite:remove()
    end
    self.timer:remove()
end