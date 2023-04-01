local gfx <const> = playdate.graphics

import "scripts/powerups/powerup"
import "scripts/sprites/singleSpriteAnimation"

class("HealthPowerup").extends(Powerup)

function HealthPowerup:init(x,y)
    HealthPowerup.super.init(self, "images/powerups/healthPickupAnim/health", 2000, x,y)
end

function HealthPowerup:_onCollected(player)
    HealthPowerup.super._onCollected(self, player)
    -- do a lil animation
    player:addHealth(15)
    local absorb = SingleSpriteAnimation("images/powerups/healthPickupAnim/collect", 100, player.x, player.y)
    absorb:setZIndex(50)
    local healing = SingleSpriteAnimation("images/effects/healingAnim/heal", 2000, player.x, player.y)
    healing:attachTo(player)
    healing:setZIndex(50)
end