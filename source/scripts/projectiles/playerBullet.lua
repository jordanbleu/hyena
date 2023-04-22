local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

--[[ Bullet that damages any enemies. ]]
class("PlayerBullet").extends(Actor)

function PlayerBullet:init(x,y)
    PlayerBullet.super.init(self)
    
    self.yVelocity = -16
    self.xVelocity = 0

    self.isActive = true
    self:setImage(gfx.image.new("images/projectiles/player-bullet"))
    self:moveTo(x,y)
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()

end

function PlayerBullet:update()
    PlayerBullet.super.update(self)

    if (self.y < -40) then
        self:destroy()
    end

    if (self.y > 250) then
        self:destroy()
    end

end


function PlayerBullet:physicsUpdate()
    PlayerBullet.super.physicsUpdate(self)

    if (self.isActive) then 
        local newX = self.x + self.xVelocity
        local newY = self.y + self.yVelocity
        self:moveTo(newX, newY)
    end

end

function PlayerBullet:destroy()
    self.isActive = false
    self:remove()
end

function PlayerBullet:ricochet()
    self.yVelocity = -self.yVelocity
    self.xVelocity = math.random(-3, 3)
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    self:moveTo(newX, newY)
end
