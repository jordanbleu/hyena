local gfx <const> = playdate.graphics

import 'scripts/sprites/singleSpriteAnimation'

--[[ Laser that damages more enemies. ]]
class("PlayerLaser").extends(SingleSpriteAnimation)

function PlayerLaser:init(x,y,cameraInst)
    self.camera = cameraInst
    
    self.didDamage = false
    self.isDamageEnabled = false
    
    self:setCollideRect(x-2,y-120,4,240)
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    PlayerLaser.super.init(self, 'images/projectiles/playerLaserAnim/playerLaser', 1000, x, y)
    self:add()
end

function PlayerLaser:update()

    PlayerLaser.super.update(self)

    local frame = self:getFrame()

    if (self.didDamage) then
        self.isDamageEnabled = false
    end

    if (frame == 5) then
        -- we do damage for one single update cycle, starting at image frame 6
        if (not self.didDamage) then 
            if (self.camera) then
                self.camera:mediumShake()
            end

            -- enable damage for this frame
            self.isDamageEnabled = true
            self.didDamage = true
        end
    end


end

