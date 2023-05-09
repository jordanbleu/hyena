local gfx <const> = playdate.graphics

import "scripts/actors/basicEnemy"

--[[
    Tiny ship is a basic enemy that moves downwards but also alternates left / right 
    
    I'm trying a chaining pattern for some of the functions here
]]
class("TinyShip").extends(BasicEnemy)

function TinyShip:init(x,y, cameraInst,playerInst)
    TinyShip.super.init(self, 2, cameraInst,playerInst)
    x = x or 0
    y = y or 0

    -- load images
    self:setIdleSprite("images/enemies/tinyShip")
    self:setDamageAnimation("images/enemies/tinyShipAnim/damage", 500)
    self:setDeathAnimation("images/enemies/tinyShipAnim/death", 500)
    
    self:moveTo(x,y)
    self:add()

    self.xVelocity = 0.5
    self.yVelocity = 1

    self.moveCycleCounter = 0
    self.moveCycles = 30

    self:setShooterBehavior(SHOOT_BEHAVIOR.RANDOM, 1001)
end

function TinyShip:_velocityUpdate()
    self.moveCycleCounter += 1

    if (self.moveCycleCounter > self.moveCycles) then
        self.xVelocity = -self.xVelocity
        self.moveCycleCounter = 0
    end

end

function TinyShip:withHorizontalDistance(amount)
    self.moveCycles = amount
    return self
end

function TinyShip:withHorizontalSpeed(amount)
    self.xVelocity = amount
    return self
end

function TinyShip:withShootingDelay(amount)
    self:setShooterBehavior(SHOOT_BEHAVIOR.RANDOM, amount)
    return self
end
