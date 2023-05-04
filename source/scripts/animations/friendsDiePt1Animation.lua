local gfx <const> = playdate.graphics

import "scripts/animations/animationDirector"

--[[
    Cyber flies up to meet his friends
]]
class("FriendsDiePt1Animation").extends(AnimationDirector)

function FriendsDiePt1Animation:init(leftActor, middleActor, rightActor)

    self.leftActor = leftActor
    self.centerActor = middleActor
    self.rightActor = rightActor

    self.leftAnimation = gfx.animator.new(1000, 270, 220, playdate.easingFunctions.outCubic, 1000)
    self.centerAnimation = gfx.animator.new(900, 270, 200, playdate.easingFunctions.outCubic, 3000)
    self.rightAnimation = gfx.animator.new(1200, 270, 210, playdate.easingFunctions.outCubic, 1500)
    
    self:add()
end

function FriendsDiePt1Animation:update()

    self.leftActor:moveTo(self.leftActor.x, self.leftAnimation:currentValue())
    self.centerActor:moveTo(self.centerActor.x, self.centerAnimation:currentValue())
    self.rightActor:moveTo(self.rightActor.x, self.rightAnimation:currentValue())

end

function FriendsDiePt1Animation:isCompleted()
    return self.centerAnimation:ended()
end


function FriendsDiePt1Animation:cleanup()
    self.leftAnimation = nil
    self.centerAnimation = nil
    self.rightAnimation = nil
end