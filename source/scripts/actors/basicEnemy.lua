local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/enemyBullet"

local INTERNAL_STATE <const> = 
{
    -- Enemy is moving towwards the player 
    IDLE = 0,
    -- Enemy took damage, and is  stopped for a sec
    DAMAGE = 1,
    -- Enemy died
    DYING = 2
}

--[[
    This is my attempt at merging many enemy behaviors into one single enemy class.  

    This should be subclassed and tweaked for different enemies.
]]
class("BasicEnemy").extends(Enemy)

function BasicEnemy:init(maxHealth, cameraInst, playerInst)
    BasicEnemy.super.init(self, maxHealth)

    self.idleSprite = nil
    self.doubleW = 0
    self.doubleH = 0
    -- should be set to the single sprite animation params for the damage anim
    self.damageSpriteAnimParameters = nil
    -- should be set to the single sprite animation params for the death anim
    self.deathSpriteAnimParameters = nil

    self.internalState = INTERNAL_STATE.IDLE
    self.camera = cameraInst
    self.player = playerInst

    self.xVelocity = 0
    self.yVelocity = 2
    
    -- Enemy doesn't move during these cycles while in damage state
    self.damageWaitCycleCounter = 0
    self.damageWaitCycles = 15

    -- bullet dropz
    self.bulletDropBehavior = SHOOT_BEHAVIOR.NONE
    self.bulletDropCycles = 500
    self.bulletDropCounter = 0

    self.resetOnOutOfBounds = true

    -- make x and y not nil (I hate Lua)
    self:moveTo(-100,-100)
end

--[[ Physics Update ]]--
function BasicEnemy:physicsUpdate()
    BasicEnemy.super.physicsUpdate(self)
    self:_velocityUpdate()
    self:_updateMovement()
    self:_updateDamageState()
    self:_checkCollisions()
    self:_shootAtPlayer()
end

function BasicEnemy:_shootAtPlayer()

    if (self.bulletDropBehavior == SHOOT_BEHAVIOR.LINEAR) then
        self.bulletDropCounter +=1 
        if (self.bulletDropCounter > self.bulletDropCycles) then
            self:_dropBullet()            
            self.bulletDropCounter = 0
        end
    elseif (self.bulletDropBehavior == SHOOT_BEHAVIOR.RANDOM) then
        local rando = math.random(self.bulletDropCycles)
        local winner = math.floor(self.bulletDropCycles/2)
        
        if (rando == winner) then
            self:_dropBullet()
        end
    end

end

function BasicEnemy:_dropBullet()
    EnemyBullet(self.x, self.y)
end

function BasicEnemy:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    local tookDamage = false

    if (#collisions > 0) then
        local col = collisions[1]

        if (col:isa(PlayerBullet)) then
            tookDamage= true
            -- create a new explosion object at the bullets position
            local sp = SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500, col.x, col.y)
            sp:setZIndex(50)
            col:destroy()
            self:damage(1)

            if (self.camera and self:isAlive()) then
                self.camera:smallShake()
            end

        elseif (col:isa(PlayerLaser)) then
            if (col.isDamageEnabled) then
                tookDamage= true
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

        if (tookDamage) then
            local willDie = (self:getHealth() <= 0)

            if (not willDie) then
                local spr = SingleSpriteAnimation(self.damageSpriteAnimParameters.imageTablePath, self.damageSpriteAnimParameters.duration, self.x, self.y)
                spr:setZIndex(self:getZIndex() + 1)
                spr:attachTo(self)
            end
        end
    end
    

end

-- Basic movement logic using x / y velocity as well as boundary checks
function BasicEnemy:_updateMovement()
    local newX = self.x
    local newY = self.y
    if (self.internalState == INTERNAL_STATE.IDLE) then
        newX = self.x + self.xVelocity
        newY = self.y + self.yVelocity
    end

    if (self.resetOnOutOfBounds) then
        -- boundary logic.  If actor goes outside boundaries, he loops around the other side
        local yMax = 240 + self.doubleH
        local yMin = 0 - self.doubleH
        local xMax = 400 + self.doubleW
        local xMin = 0 - self.doubleW
        
        -- note that we don't check for boundaries above the top of the screen
        if (self.y > yMax) then 
            newY = -self.doubleH
        end

        if (self.x > xMax) then
            newX = -self.doubleW
        elseif (self.x < xMin) then
            newX = 400 + self.doubleW
        end
        self:moveTo(newX, newY)
    end
end


-- waits for damage state to end and swaps states
function BasicEnemy:_updateDamageState()

    if (self.internalState ~= INTERNAL_STATE.DAMAGE) then
        return 
    end

    self.damageWaitCycleCounter += 1
    if (self.damageWaitCycleCounter > self.damageWaitCycles) then
        self.internalState = INTERNAL_STATE.IDLE
        self.damageWaitCycleCounter = 0
    end
end

--[[ Update ]]--
function BasicEnemy:update()
    BasicEnemy.super.update(self)

     if (self.idleSprite ~= nil) then
        self.idleSprite:moveTo(self.x,self.y)
     end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end
end

function BasicEnemy:setIdleSprite(imagePath)
    local sm = gameContext.getSceneManager()

    self.idleSprite = gfx.sprite.new(sm:getImageFromCache(imagePath))
    self.idleSprite:setZIndex(self:getZIndex())
    self.idleSprite:add()
    local w,h = self.idleSprite:getSize()
    
    self.doubleW = w*2
    self.doubleH = h*2

    self:setCollideRect(-w/2,-h/2,w,h)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

end

---Sets the idle animation parameters for the enemy.  Will also automatically set up sprite rect and collision stuff.
function BasicEnemy:setIdleAnimation(imageTablePath, duration)
    self.idleSpriteAnim = spriteAnim
    self.idleSpriteAnim = SpriteAnimation(imageTablePath, duration, self.x, self.y)
    self.idleSpriteAnim:attachTo(self)

    self.idleSpriteAnim:setRepeats(-1)
    local w,h = self.idleSpriteAnim:getSize()
    self.doubleW = w*2
    self.doubleH = h*2

    self:setCollideRect(-w/2,-h/2,w,h)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
end

---Sets the death animation parameters for the enemy.  Idle sprite gets removed 
function BasicEnemy:setDeathAnimation(imageTablePath, duration)
    self.deathSpriteAnimParameters = {
        imageTablePath = imageTablePath,
        duration = duration
    }
end

---Sets the damage animation parameters for the enemy.  Sprite gets overlayed on top of idle image.
function BasicEnemy:setDamageAnimation(imageTablePath, duration)
    self.damageSpriteAnimParameters = {
        imageTablePath = imageTablePath,
        duration = duration
    }
end

function BasicEnemy:_onDead()
    
    if (self.idleSprite ~= nil) then
        self.idleSprite:remove()
    elseif (self.idleSpriteAnim ~= nil) then
        self.idleSpriteAnim:remove()
    end

    SingleSpriteAnimation(self.deathSpriteAnimParameters.imageTablePath, self.deathSpriteAnimParameters.duration, self.x, self.y)
    self:remove()
end

---Overridable function that is meant for implementing movement patterns.  Called on each physics update.
function BasicEnemy:_velocityUpdate()
end

function BasicEnemy:remove()
    BasicEnemy.super.remove(self)
end

-- function BasicEnemy:setVelocity(xv, yv)
--     self.xVelocity = xv
--     self.yVelocity = yv
-- end

---Set up the shooting behvaior for this enemy
---@param behavior any Use the SHOOT_BEHAVIOR enum.  Determines what pattern to follow for shooting.
---@param cycles any Meaning kinda depends on behavior, but basically higher number = less shooting.
function BasicEnemy:setShooterBehavior(behavior, cycles)
    self.bulletDropBehavior = behavior
    self.bulletDropCycles = cycles
end