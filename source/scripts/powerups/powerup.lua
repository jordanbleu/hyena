local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"


class("Powerup").extends(SpriteAnimation)

function Powerup:init(imageTablePath, duration, x, y)
    Powerup.super.init(self,imageTablePath, duration, x,y)

    self.yVelocity = 2

    self:setCollideRect(0,0,24,24)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setRepeats(-1)
    self:add()
end

function Powerup:update()
    local newY = self.y + self.yVelocity
    self:moveTo(self.x, newY)

    if (self.y > 450) then
        self:remove()
    end

end

function Powerup:collect(player)
    self:_onCollected(player)
    self:remove()
end

---Apply the powerup effect to the player.  Called when the player collects the item.
function Powerup:_onCollected(player)
end