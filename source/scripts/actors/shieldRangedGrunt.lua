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
    The shieldRangedGrunt is the same as the ranged enemy but he has a shield
]]
class("ShieldRangedGrunt").extends(Enemy)


-- this is the general y position for ranged enemies
local STANDARD_Y_POSITION <const> = 60
-- how far above or below the standard Y the enemy can move 
local Y_POSITION_VARIANCE <const> = 20

local Y_MOVE_WAIT_TIME_MIN <const> = 20
local Y_MOVE_WAIT_TIME_MAX <const> = 50


function ShieldRangedGrunt:init(x,y, cameraInst, playerInst) 

    ShieldRangedGrunt.super.init(self, 4)
    self:moveTo(x,y)

    self.player = playerInst
    self.camera = cameraInst

     -- note that the range grunt IS it's own image...which differs from the other (animated) enemy classes
    self:setImage(gfx.image.new ("images/enemies/shieldGruntAnim/idle"))
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

    -- behavior stuff
    self.moveSpeed = 1
    self.yDestination = STANDARD_Y_POSITION + math.random(-Y_POSITION_VARIANCE, Y_POSITION_VARIANCE)

    -- enemy chooses a new y position after a wait time 
    self.yMoveWaitCycleCounter = 0
    self.yMoveWaitCycles = math.random(Y_MOVE_WAIT_TIME_MIN,Y_MOVE_WAIT_TIME_MAX)

    -- how long before enemy can shoot 
    self.coolDownCycleCounter = 0
    self.coolDownCycles = math.random(100,300)

    self:add()

    self.shieldHealth = 1
    self.shieldSprite = SingleSpriteAnimation("images/enemies/shieldGruntAnim/shield", 1000, self.x, self.y)
    self.shieldSprite:attachTo(self)
    self.shieldSprite:pause() -- shield animation starts paused
    
end

function ShieldRangedGrunt:update()
    ShieldRangedGrunt.super.update(self)

    if (self.yMoveWaitCycleCounter > self.yMoveWaitCycles) then
        self.yDestination = STANDARD_Y_POSITION + math.random(-Y_POSITION_VARIANCE, Y_POSITION_VARIANCE)

        self.yMoveWaitCycles = math.random(Y_MOVE_WAIT_TIME_MIN,Y_MOVE_WAIT_TIME_MAX)
        self.yMoveWaitCycleCounter = 0
    end

    if (self.coolDownCycleCounter >= self.coolDownCycles) then
    -- once cooldown is ready we actually wait until the player enters 
    -- our field of view:

        if (math.isWithin(self.player.x, 3, self.x)) then
            EnemyBullet(self.x, self.y)
            self.coolDownCycles = math.random(30,200)
            self.coolDownCycleCounter = 0
        end
        
    end

    if (self.player:didUseEmp()) then
        if (self.shieldHealth <= 0) then
            self:damage(3)
        else
            self:_destroyShield()
        end
    end

    self:_checkCollisions()
end

function ShieldRangedGrunt:_destroyShield()
    SingleSpriteAnimation("images/effects/shieldAbsorbAnim/absorb", 500,self.x, self.y) 
    self.shieldHealth -= 1
    self.shieldSprite:play()
end 

function ShieldRangedGrunt:physicsUpdate()
    ShieldRangedGrunt.super.physicsUpdate(self)
    self.yMoveWaitCycleCounter+= 1
    
    if (self.coolDownCycleCounter < self.coolDownCycles) then
        self.coolDownCycleCounter += 1
    end

    self:_moveToDestination()

end

-- move towards the player
function ShieldRangedGrunt:_moveToDestination()
    local newX = self.x
    local newY = self.y

    if (self.x > self.player.x) then
        newX -= self.moveSpeed
    elseif (self.x < self.player.x) then
        newX += self.moveSpeed    
    end

    if (self.y > self.yDestination) then
        newY -= self.moveSpeed
    elseif (self.x < self.yDestination) then
        newY += self.moveSpeed
    end

    newX = math.snap(newX, self.moveSpeed/2, self.player.x)
    newY = math.snap(newY, self.moveSpeed/2, self.yDestination)

    self:moveTo(newX, newY)

end

function ShieldRangedGrunt:_onDead()
    SingleSpriteAnimation("images/enemies/shieldGruntAnim/death", 1000, self.x, self.y)
    self:remove()
end

function ShieldRangedGrunt:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    local tookDamage = false

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            if (self.shieldHealth <= 0) then
                tookDamage= true
                SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 1000,col.x, col.y)
                col:destroy()
                self:damage(1)

                if (self.camera) then
                    self.camera:smallShake()
                end
            else 
                col:ricochet()
                SingleSpriteAnimation("images/effects/shieldAbsorbAnim/absorb", 500,col.x, col.y)
            end

        elseif (col:isa(PlayerLaser)) then
            if (self.shieldHealth <= 0) then
                tookDamage= true
                if (col.isDamageEnabled) then
                    self:damage(5)
                end
            else
                if (col.isDamageEnabled) then
                    self:_destroyShield()
                end
            end

        elseif (col:isa(PlayerMissile)) then
            col:explode()

        elseif (col:isa(PlayerMissileExplosion)) then
            if (self.shieldHealth <= 0) then
                tookDamage= true
                if (col.isDamageEnabled) then
                    self:damage(15)
                end
            end
        
        elseif (col:isa(PlayerMine)) then
            col:explode()

        elseif (col:isa(PlayerMineExplosion)) then
            if (self.shieldHealth <= 0) then
                tookDamage= true
                if (col.isDamageEnabled) then
                    self:damage(10)
                end
            end
        end

        if (tookDamage and self.health > 0) then
            local dmgSprite = SingleSpriteAnimation("images/enemies/shieldGruntAnim/damage", 1000, self.x, self.y)
            dmgSprite:attachTo(self)
        end
    end
end