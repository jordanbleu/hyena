
import "scripts/ai/behaviors/squidBehavior"

--[[
    The millipede inches straight downward, and ignores the player 
]]
class("Millipede").extends(SquidBehavior)

function Millipede:init(x,y, playerInst, cameraInst)

    local idleImagePath = "images/enemies/centipedeAnim/idle"
    local deathImagePath = "images/enemies/centipedeAnim/death"
    local damageImagePath = "images/enemies/centipedeAnim/damage"
    local maxHealth = 15

    Millipede.super.init(self, idleImagePath, 500, x, y, maxHealth, playerInst, cameraInst)

    self.deathAnimationImagePath = deathImagePath
    self.damageAnimationImagePath = damageImagePath

    -- millipede doesn't actually move left or right, just straight
    self:withHorizontalBurstSpeed(0)
    
    -- millipede doesn't give a damn about your bullets
    self:withDamageDelay(0)

    self:withVerticalBurstSpeed(3)
    self:withBurstDelay(30)
    self:withDrag(0.3)

    --self:withShootingBehavior(SHOOT_BEHAVIOR.RANDOM, 60)
end


-- Overrides --------------------------------

function Millipede:_onOutOfBounds()
    self:moveTo(self.player.x, -(self.h*2))
end