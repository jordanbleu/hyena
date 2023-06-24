local gfx <const> = playdate.graphics

import "scripts/animations/animationDirector"
import "scripts/sprites/singleSpriteAnimation"

--[[
    Writing these scenes is awkward
]]
class("FriendsDiePt2Animation").extends(AnimationDirector)

function FriendsDiePt2Animation:init(leftActor, middleActor, rightActor, cameraInst)

    self.camera = cameraInst
    self.leftActor = leftActor
    self.centerActor = middleActor
    self.rightActor = rightActor

    self.leftLaser = SingleSpriteAnimation("images/projectiles/playerLaserAnim/playerLaser", 750, self.leftActor.x, 100)
    self.rightLaser = nil
    self.leftExploded = false
    self.rightExploded = false

    self.ended = false
    self:add()
end

function FriendsDiePt2Animation:update()

    if (self.leftLaser:getFrame() == 5) then
        if (not self.leftExploded) then
            -- put explode soudn here
            self.leftActor:remove()
            ScreenFlash(250,gfx.kColorWhite)
            SingleSpriteAnimation("images/playerAnim/death", 500, self.leftActor.x, self.leftActor.y, function() self:_startRightDeath() end)
            self.camera:smallShake()
        end
    end

    if (self.rightLaser ~= nil and self.rightLaser:getFrame() == 5) then
        if (not self.rightExploded) then
            -- put explode soudn here
            ScreenFlash(250,gfx.kColorWhite)
            self.rightActor:remove()
            SingleSpriteAnimation("images/playerAnim/death", 500, self.rightActor.x, self.rightActor.y, function() self.ended = true end)
            self.camera:smallShake()
        end
        
    end
end

function FriendsDiePt2Animation:_startRightDeath()
    self.rightLaser = SingleSpriteAnimation("images/projectiles/playerLaserAnim/playerLaser", 750, self.rightActor.x, 100)
end

function FriendsDiePt2Animation:isCompleted()
    return self.ended
end


function FriendsDiePt2Animation:cleanup()

end