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
    self:add()

end

function PlayerBullet:delayedUpdate()
    PlayerBullet.super.delayedUpdate(this)

    if (self.isActive) then 
        local nextY = self.y + BULLET_SPEED
        self:moveTo(self.x, nextY)
    end

    if (self.y < -40) then
        self:_destroy()
    end

end

function PlayerBullet:_destroy()

    self:remove()
    self.isActive = false

end

