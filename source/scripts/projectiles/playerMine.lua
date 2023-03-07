local gfx <const> = playdate.graphics

import 'scripts/sprites/spriteAnimation'
import 'scripts/projectiles/playerMineExplosion'

--[[ Laser that damages more enemies. ]]
class("PlayerMine").extends(SpriteAnimation)

function PlayerMine:init(cameraInst, x, y)

    PlayerMine.super.init(self,'images/projectiles/playerMineAnim/player-mine', 2000, x,y)

    self:setRepeats(-1)

    self.camera = cameraInst

    -- mine has a large collision area because that's it's triggerable area
    self:setCollideRect(-16,-16,64,64)
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})

    -- eventually the mine will just explode itself
    self.cyclesTillBoom = GLOBAL_TARGET_FPS * 12 -- ~12 seconds
    self.cycleCounter = 0

    -- tweak these boys to alter the physics of the mine
    -- it starts with a burst of speed then slowly decelerates to zero.
    self.yVelocity = -8
    self.decelerationRate = 0.2

    self:add()

end

function PlayerMine:physicsUpdate()

    PlayerMine.super.physicsUpdate(self)

    local newY = self.y + self.yVelocity 

    self:moveTo(self.x, newY)

    self.yVelocity = math.moveTowards(self.yVelocity, 0, self.decelerationRate)

    self.cycleCounter = self.cycleCounter + 1

    if (self.cycleCounter > self.cyclesTillBoom) then
        self:explode()
    end

end

function PlayerMine:explode()
    self.camera:bigShake()
    PlayerMineExplosion(self.x, self.y)
    self:remove()
end