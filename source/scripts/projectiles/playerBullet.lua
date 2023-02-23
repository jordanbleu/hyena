local gfx <const> = playdate.graphics

local BULLET_SPEED <const> = -10

--[[ Bullet that damages any enemies. ]]
class("PlayerBullet").extends(gfx.sprite)

function PlayerBullet:init(x,y)

    self.isActive = true
    self:setImage(gfx.image.new("images/projectiles/playerBullet"))
    self:moveTo(x,y)
    self:add()

end

function PlayerBullet:update()

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

