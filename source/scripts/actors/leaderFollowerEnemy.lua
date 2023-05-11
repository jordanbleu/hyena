local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"

--[[
    The leader / follower enemy works like a linked list of enemies.  

    If the enemy is a leader, he will follow movement patterns based on what the child class override says.
    If the enemy is a follower, he will follow it's leader.

    Using this pattern, neat snake-like movement patterns can be created
]]
class("LeaderFollowerEnemy").extends(Enemy)

function LeaderFollowerEnemy:init(x, y, leader, maxHealth, cameraInst, playerInst)
    LeaderFollowerEnemy.super.init(self, maxHealth)
    
    self.player = playerInst
    self.camera = cameraInst
    self.leader = leader
    self:moveTo(x,y)

    -- Follower Behavior
    self.followerUpdateCycles = 8
    self.followerUpdateCycleCounter = math.random(1,self.followerUpdateCycles)
    self.followerXDestination = 0
    self.followerYDestination = 0
    self.followerSpeed = 2

    self.dead = false
    self.wasLeader = self:isLeader()
    self.leaderUpdatedFunc = nil

    self.autoResetOnOutOfBounds = true

    --[[ make sure to call self:add() from a child class ]]--
end

function LeaderFollowerEnemy:update()
    LeaderFollowerEnemy.super.update(self)
    local isLeader = self:isLeader()
    if (self.wasLeader ~= isLeader) then
        if (self.leaderUpdatedFunc) then
            self.leaderUpdatedFunc()
        end
        self.wasLeader = isLeader
    end

    if (self.autoResetOnOutOfBounds) then
        if (self.y > 250) then
            self:moveTo(self.x, -60)
        end
    end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end

    self:_checkCollisions()
end

function LeaderFollowerEnemy:physicsUpdate()
    -- It is the leader
    if (self:isLeader()) then
        self:_leaderUpdate()
    else 
        self:_followerUpdate()
    end
end

function LeaderFollowerEnemy:isLeader() 
    return (self.leader == nil) or (self.leader.dead)
end

---Override this function in child class
function LeaderFollowerEnemy:_leaderUpdate()
end


function LeaderFollowerEnemy:_followerUpdate()
    self.followerUpdateCycleCounter+=1
    
    -- defer update to destination
    if (self.followerUpdateCycleCounter > self.followerUpdateCycles) then        
        self.followerXDestination = self.leader.x
        self.followerYDestination = self.leader.y
        self.followerUpdateCycleCounter = 0
    end

    -- if the enemy has teleported to the top again, teleport as well
    if (math.abs(self.y - self.leader.y) > 50 and self.leader.y < 0) then 
        self:moveTo(self.leader.x, self.leader.y-10)
    end

    -- move towards the current destination 
    local newX = self.x
    local newY = self.y 

    if (self.x > self.followerXDestination) then
        newX -= self.followerSpeed
    elseif (self.x < self.followerXDestination) then
        newX += self.followerSpeed
    end

    if (self.y > self.followerYDestination) then
        newY -= 1
    elseif (self.y < self.followerYDestination) then
        newY += 1
    end
    

    newX = math.snap(newX, self.followerSpeed, self.followerXDestination) 
    newY = math.snap(newY, 1, self.followerYDestination)

    self:moveTo(newX, newY)
end


function LeaderFollowerEnemy:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    if (#collisions < 1) then
        return
    end

    local col = collisions[1]
    local tookDamage = false 

    if (col:isa(PlayerBullet)) then
        SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500,col.x, col.y)
        col:destroy()
        self:damage(1)
        tookDamage=true
        
    elseif (col:isa(PlayerLaser)) then
        if (col.isDamageEnabled) then
            self:damage(5)
            tookDamage=true
        end
        
    elseif (col:isa(PlayerMissile)) then
        col:explode()
        
    elseif (col:isa(PlayerMissileExplosion)) then
        if (col.isDamageEnabled) then
            self:damage(15)
            tookDamage=true
        end
        
    elseif (col:isa(PlayerMine)) then
        col:explode()
        
    elseif (col:isa(PlayerMineExplosion)) then
        if (col.isDamageEnabled) then
            self:damage(10)
            tookDamage=true
        end
    end
    
    if (tookDamage) then
        if (self:getHealth() >0) then
            local spr = SingleSpriteAnimation(self.damageSpriteAnimParameters.imageTablePath, self.damageSpriteAnimParameters.duration, col.x, col.y)
            spr:setZIndex(self:getZIndex()+1)
            spr:attachTo(self)
        end

        if (self.camera) then
            self.camera:smallShake()
        end
    end
    
end

function LeaderFollowerEnemy:_onDead()
    self.dead = true
    self:setVisible(false)
    SingleSpriteAnimation(self.deathSpriteAnimParameters.imageTablePath, self.deathSpriteAnimParameters.duration, self.x, self.y)
    self:remove()
end

---Set up the follower behavior
---@param updateWaitCycles integer How often the enemy should wait to retarget the leader position.  Smaller sprites should have a smaller value here.
---@param movementSpeed integer How fast the enemy moves towards the target position (the leader's position).  Decrease this value if movement is jerky.
function LeaderFollowerEnemy:setFollowerBehavior(updateWaitCycles, movementSpeed)
    self.followerUpdateCycles = updateWaitCycles
    self.followerSpeed = movementSpeed
end

---Set the idle image and collider automatically. 
---Not required if you override it in the child class.
function LeaderFollowerEnemy:setIdleImage(image)
    self:setImage(image)
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setZIndex(25)
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
end

---Sets the death animation parameters for the enemy.  Idle sprite gets removed 
function LeaderFollowerEnemy:setDeathAnimation(imageTablePath, duration)
    self.deathSpriteAnimParameters = {
        imageTablePath = imageTablePath,
        duration = duration
    }
end

---Sets the damage animation parameters for the enemy.  Sprite gets overlayed on top of idle image.
function LeaderFollowerEnemy:setDamageAnimation(imageTablePath, duration)
    self.damageSpriteAnimParameters = {
        imageTablePath = imageTablePath,
        duration = duration
    }
end

function LeaderFollowerEnemy:onLeaderUpdated(leaderUpdateFunc) 
    self.leaderUpdatedFunc = leaderUpdateFunc
end

function LeaderFollowerEnemy:setAutoResetOnOutOfBounds(enable)
    self.autoResetOnOutOfBounds = enable
end