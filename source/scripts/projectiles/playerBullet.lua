local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

local BULLET_SPEED <const> = -10

--[[ Bullet that damages any enemies. ]]
class("PlayerBullet").extends(Actor)

function PlayerBullet:init(x,y)
    PlayerBullet.super.init(self)
    
    self.isActive = true
    self:setImage(gfx.image.new("images/projectiles/playerBullet"))
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

end


function PlayerBullet:physicsUpdate()
    PlayerBullet.super.physicsUpdate(this)

    if (self.isActive) then 
        local nextY = self.y + BULLET_SPEED
        self:moveTo(self.x, nextY)
    end

end

function PlayerBullet:destroy()

    self.isActive = false
    self:remove()


end
