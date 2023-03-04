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
function SingleSpriteAnimation:init(imageTablePath, duration,x, y)
    SingleSpriteAnimation.super.init(self)
    self.animation = SpriteAnimation(imageTablePath, duration, x,y)
    self.animation:setAnimationCompletedCallback(function() self:remove() end)
end

function SingleSpriteAnimation:getFrame()
    return self.animation:getFrame()
end

