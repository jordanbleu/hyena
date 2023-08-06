local gfx <const> = playdate.graphics

import "scripts/actors/basicEnemy"
import "scripts/effects/particle"

--[[
    Tiny ship is a basic enemy that moves downwards but also alternates left / right 
    
    I'm trying a chaining pattern for some of the functions here
]]
class("Centipede").extends(BasicEnemy)

function Centipede:init(x, y, cameraInst, playerInst)

    Centipede.super.init(self, 32, cameraInst, playerInst)

    x = x or 0
    y = y or 0

    -- load images
    self:setIdleAnimation("images/enemies/centipedeAnim/idle", 500)
    self:setDamageAnimation("images/enemies/centipedeAnim/damage", 500)
    self:setDeathAnimation("images/enemies/centipedeAnim/death", 500)

    self:moveTo(x,y)
    self:add()

    self.moveCycleCounter = 0
    self.moveCycles = 30

    self.speed = 3
    self.deceleration = 0.2
    self.yVelocity = 0.5

    self:setShooterBehavior(SHOOT_BEHAVIOR.LINEAR, 100)
end

function Centipede:_velocityUpdate()

    self.moveCycleCounter += 1

    if (self.moveCycleCounter > self.moveCycles) then
        self.yVelocity = self.speed
        self.moveCycleCounter = 0
    end

    if (self.yVelocity > 0) then
        self.yVelocity -= self.deceleration
        self.yVelocity = math.snap(self.yVelocity, self.deceleration, 0)
    end

end

function Centipede:_onDead()
    self.camera:bigShake()
    Centipede.super._onDead(self)
end