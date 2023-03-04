local gfx <const> = playdate.graphics


--[[
    Basically a decorator for the normal animator object that is affected by GLOBAL_TIME_DELAY.
]]
class("PhysicsAnimator").extends(gfx.sprite)

function PhysicsAnimator:init(standardDelay, startValue, endValue, easingFunc, startTimeOffset)

    self.standardDelay = standardDelay
    self.animator = gfx.animator.new(self:_calculateRealDelay(), startValue, endValue, easingFunc, startTimeOffset)
    self.globalTimeDelay = GLOBAL_TIME_DELAY
    self:add()
end

function PhysicsAnimator:update()
    if (self.globalTimeDelay ~= GLOBAL_TIME_DELAY) then
        
        local percentage = self.animator:progress()

        self.animator.duration = self:_calculateRealDelay()
        self.globalTimeDelay = GLOBAL_TIME_DELAY

        self:setPercentComplete(percentage)
    end
end

function PhysicsAnimator:_calculateRealDelay()
    return (self.standardDelay + (6 * GLOBAL_TIME_DELAY))
end

-- this doesn't do anything because i don't think this is possible.
function PhysicsAnimator:setPercentComplete(percent)
    -- local val = self.animator.endValue * percent
    -- self.animator.value
end

function PhysicsAnimator:remove()
    self.animator:remove()
end

function PhysicsAnimator:ended()
    return self.animator:ended()
end

function PhysicsAnimator:currentValue()
    return self.animator:currentValue()
end

function PhysicsAnimator:setRepeatCount(num) 
    self.animator.repeatCount = num
end