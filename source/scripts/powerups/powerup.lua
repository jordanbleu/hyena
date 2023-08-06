local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"


class("Powerup").extends(SpriteAnimation)

function Powerup:init(imageTablePath, duration, x, y)
    Powerup.super.init(self,imageTablePath, duration, x,y)

    self.yVelocity = 2

    local w,h = self:getSize()

    self:setCollideRect(0,0,w,h)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setRepeats(-1)

    -- if true, powerup resets to top of the screen when it goes out of bounds, otherwise it destroys itself.
    self.resetOnOutOfBounds = false
    self.w = w
    self.h = h

    self.collected = false

    self:add()
end

function Powerup:update()
    local newY = self.y + self.yVelocity
    self:moveTo(self.x, newY)

    if (self.y > 300) then
        if (self.resetOnOutOfBounds) then
            self.y = -(self.h*2)
        else
            self:remove()
        end
    end

end

function Powerup:collect(player)
    self.collected = true
    self:_onCollected(player)
    self:remove()
end

---Apply the powerup effect to the player.  Called when the player collects the item.
function Powerup:_onCollected(player)
end

function Powerup:isCollected()
    return self.collected
end