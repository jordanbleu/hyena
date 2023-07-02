local gfx <const> = playdate.graphics

import "scripts/powerups/powerup"
import "scripts/sprites/singleSpriteAnimation"

class("LaserPowerup").extends(Powerup)

function LaserPowerup:init(x,y)
    LaserPowerup.super.init(self, "images/powerups/laserPickupAnim/idle", 500, x,y)
    self.resetOnOutOfBounds = true
end

function LaserPowerup:_onCollected(player)
    LaserPowerup.super._onCollected(self, player)

    -- unlock the laser and equip it
    -- weapon selector remains locked
    DATA.GAME.HasLaser = true

    -- force equip it (especially since the player can't on their own yet)
    player:setSelectedWeaponId(WEAPON.LASER)

    -- do a lil animation
    local absorb = SingleSpriteAnimation("images/powerups/laserPickupAnim/collect", 500, player.x, player.y)
    absorb:setZIndex(50)
    absorb:attachTo(player)

end