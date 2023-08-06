local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"
import "scripts/projectiles/enemyBullet"

--[[
    The ranged grunt enemy stays back and fires bullets at the player
]]
class("RangedGrunt").extends(Enemy)

function RangedGrunt:init(x,y, cameraInst, playerInst) 
    
    RangedGrunt.super.init(self, 12)
    
    -- this is the general y position for ranged enemies
    self.standardYPosition = 60
    
    -- how far above or below the standard Y the enemy can move 
    self.yPositionVariance = 20

    self.yMoveWaitTimeMin = 20
    self.yMoveWaitTimeMax = 50

    self:moveTo(x,y)

    self.player = playerInst
    self.camera = cameraInst

     -- note that the range grunt IS it's own image...which differs from the other (animated) enemy classes
    self:setImage(gfx.image.new ("images/enemies/ranged-enemy"))
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

    -- behavior stuff
    self.moveSpeed = 1
    self.yDestination = self.standardYPosition + math.random(-self.yPositionVariance, self.yPositionVariance)

    -- enemy chooses a new y position after a wait time 
    self.yMoveWaitCycleCounter = 0
    self.yMoveWaitCycles = math.random(self.yMoveWaitTimeMin,self.yMoveWaitTimeMax)

    -- how long before enemy can shoot 
    self.coolDownCycleCounter = 0
    self.cooldownMin = 25
    self.cooldownMax = 100
    self.coolDownCycles = math.random(25,100)

    self:add()
    
end

function RangedGrunt:update()
    RangedGrunt.super.update(self)

    if (self.yMoveWaitCycleCounter > self.yMoveWaitCycles) then
        self.yDestination = self.standardYPosition + math.random(-self.yPositionVariance, self.yPositionVariance)

        self.yMoveWaitCycles = math.random(self.yMoveWaitTimeMin,self.yMoveWaitTimeMax)
        self.yMoveWaitCycleCounter = 0
    end

    if (self.coolDownCycleCounter >= self.coolDownCycles) then
    -- once cooldown is ready we actually wait until the player enters 
    -- our field of view:

        if (math.isWithin(self.player.x, 3, self.x)) then
            EnemyBullet(self.x, self.y)
            self.coolDownCycles = math.random(self.cooldownMin,self.cooldownMax)
            self.coolDownCycleCounter = 0
        end
        
    end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end

    self:_checkCollisions()
end


function RangedGrunt:physicsUpdate()
    RangedGrunt.super.physicsUpdate(self)
    self.yMoveWaitCycleCounter+= 1
    
    if (self.coolDownCycleCounter < self.coolDownCycles) then
        self.coolDownCycleCounter += 1
    end

    self:_moveToDestination()

end

-- move towards the player
function RangedGrunt:_moveToDestination()
    local newX = self.x
    local newY = self.y

    if (self.x > self.player.x) then
        newX -= self.moveSpeed
    elseif (self.x < self.player.x) then
        newX += self.moveSpeed    
    end

    if (self.y > self.yDestination) then
        newY -= self.moveSpeed
    elseif (self.y < self.yDestination) then
        newY += self.moveSpeed
    end

    newX = math.snap(newX, self.moveSpeed/2, self.player.x)
    newY = math.snap(newY, self.moveSpeed/2, self.yDestination)

    self:moveTo(newX, newY)

end

function RangedGrunt:_onDead()
    SingleSpriteAnimation("images/enemies/rangedGruntAnim/death", 750, self.x, self.y)
    self:remove()
end

function RangedGrunt:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    local tookDamage = false

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            tookDamage= true
            local spr = SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500,col.x, col.y)
            spr:setZIndex(50)
            col:destroy()
            self:damage(1)

            if (self.camera) then
                self.camera:smallShake()
            end

        elseif (col:isa(PlayerLaser)) then
            tookDamage= true
            if (col.isDamageEnabled) then
                self:damage(5)
            end

        elseif (col:isa(PlayerMissile)) then
            tookDamage= true
            col:explode()

        elseif (col:isa(PlayerMissileExplosion)) then
            tookDamage= true
            if (col.isDamageEnabled) then
                self:damage(15)
            end
        
        elseif (col:isa(PlayerMine)) then
            tookDamage= true
            col:explode()

        elseif (col:isa(PlayerMineExplosion)) then
            tookDamage= true
            if (col.isDamageEnabled) then
                self:damage(10)
            end
        end

        if (tookDamage and self.health > 0) then
            local dmgSprite = SingleSpriteAnimation("images/enemies/rangedGruntAnim/damage", 250, self.x, self.y)
            dmgSprite:attachTo(self)
        end
    end
end

function RangedGrunt:withCooldownRangeBetween(min, max)
    self.cooldownMin = min
    self.cooldownMax = max
    self.coolDownCycles = math.random(self.cooldownMin,self.cooldownMax)    
    return self
end