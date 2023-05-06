local gfx <const> = playdate.graphics

import "scripts/actors/actor"
import 'scripts/sprites/spriteAnimation'

--[[
    This will play a single animation, then destroy itself on complete.
    Good for one time effects such as explosions, etc.
]]
class("SingleSpriteAnimation").extends(Actor)

---comment
---@param imageTablePath string Path to the image table
---@param duration integer Overall animation time in milliseconds
---@param x integer x position
---@param y integer y position
function SingleSpriteAnimation:init(imageTablePath, duration,x, y, onComplete, useCache)
    SingleSpriteAnimation.super.init(self)

    x = x or 0
    y = y or 0

    self.animation = SpriteAnimation(imageTablePath, duration, x,y, false, useCache)

    if (onComplete) then
        self.completedCallback = onComplete
    end

    self:moveTo(x,y)
    self.animation:moveTo(x,y)
    self.animation:setAnimationCompletedCallback(function() self:_onCompleted() end)
end

function SingleSpriteAnimation:getFrame()
    return self.animation:getFrame()
end

function SingleSpriteAnimation:moveTo(x, y) 
    self.animation:moveTo(x,y)
    SingleSpriteAnimation.super.moveTo(self, x,y)
end

function SingleSpriteAnimation:setZIndex(z) 
    self.animation:setZIndex(z)
    SingleSpriteAnimation.super.setZIndex(self, z)
end

function SingleSpriteAnimation:_onCompleted()
    if (self.completedCallback) then
        self.completedCallback()
    end
    self:remove()
end

function SingleSpriteAnimation:attachTo(otherSprite)
    self.animation:attachTo(otherSprite)
end

function SingleSpriteAnimation:pause()
    self.animation:pause()
end

function SingleSpriteAnimation:play()
    self.animation:play()
end

function SingleSpriteAnimation:setIgnoresDrawOffset(ignore) 
    self.animation:setIgnoresDrawOffset(ignore)
end

function SingleSpriteAnimation:getSize()
    return self.animation:getSize()
end