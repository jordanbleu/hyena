local gfx <const> = playdate.graphics

import 'scripts/projectiles/playerMissileExplosion'

--[[ Slow moving missile that is affected by player movement (slightly) ]]
class("PlayerMissile").extends(SpriteAnimation)

local ACCEL_RATE <const> = -0.03

-- using left and right buttons move the missile slightly
local HORIZONTAL_MOVE_RATE = 0.025
local MAX_X_VELOCITY = 3

function PlayerMissile:init(cameraInst, x,y)
    PlayerMissile.super.init(self,"images/projectiles/playerMissileAnim/player-missile",1000, x, y)
    self.camera = cameraInst
    self:setRepeats(-1)

    self.yVelocity = -0.5
    self.xVelocity = 0
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
end

function PlayerMissile:update()
    PlayerMissile.super.update(self)

    if (self.y < -40) then
        self:remove()
    end
end

function PlayerMissile:physicsUpdate()
    PlayerMissile.super.physicsUpdate(self)

    self.yVelocity += ACCEL_RATE
    local nextY = self.y + self.yVelocity
    local nextX = self.x + self.xVelocity
    self:moveTo(nextX, nextY)

    if (playdate.buttonIsPressed(playdate.kButtonLeft)) then
        if (self.xVelocity > -MAX_X_VELOCITY) then
            self.xVelocity -= HORIZONTAL_MOVE_RATE
        end
    elseif (playdate.buttonIsPressed(playdate.kButtonRight)) then
        if (self.xVelocity < MAX_X_VELOCITY) then
            self.xVelocity += HORIZONTAL_MOVE_RATE
        end
    end
end

-- called externally when the missile explodes
function PlayerMissile:explode()
    self.camera:bigShake()
    PlayerMissileExplosion(self.x, self.y)
    self:remove()
end
