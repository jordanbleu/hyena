local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

--[[ Bullet that damages player. ]]
class("EnemyBullet").extends(Actor)

function EnemyBullet:init(x,y)
    EnemyBullet.super.init(self)
    
    self.yVelocity = 4
    self.xVelocity = 0

    self.isActive = true
    self:setImage(gfx.image.new("images/projectiles/enemy-bullet"))
    self:moveTo(x,y)
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY_PROJECTILE})
    self:add()

end

function EnemyBullet:update()
    EnemyBullet.super.update(self)

    if (self.y < -40) then
        self:destroy()
    end

    if (self.y > 250) then
        self:destroy()
    end

end


function EnemyBullet:physicsUpdate()
    EnemyBullet.super.physicsUpdate(self)

    if (self.isActive) then 
        local newX = self.x + self.xVelocity
        local newY = self.y + self.yVelocity
        self:moveTo(newX, newY)
    end

end

function EnemyBullet:destroy()
    self.isActive = false
    self:remove()
end

function EnemyBullet:ricochet()
    self.yVelocity = -self.yVelocity
    self.xVelocity = math.random(-3, 3)
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    self:moveTo(newX, newY)
end
