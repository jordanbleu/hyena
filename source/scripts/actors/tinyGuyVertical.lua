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
    Similar to other tiny guys but they move straight down
]]
class("TinyGuyVertical").extends(Enemy)

local DISTANCE_FROM_LEADER <const> = 16

function TinyGuyVertical:init(x,y,leader, cameraInst, playerInst)
    TinyGuyVertical.super.init(self, 1)
    
    self.player = playerInst
    self.camera = cameraInst
    self.leader = leader
    self:moveTo(x,y)

    -- idle image animation
    self.animator = SpriteAnimation("images/enemies/tinyGuyAnim/idle", 1000, self.x, self.y)
    self.animator:setRepeats(-1)
    self.animator:attachTo(self)

    self:setCollideRect(-5,-5,10,10)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()

    -- behavior stuff - leader
    self.xSpeed = 1
    self.ySpeed = 0.5
    self.xVelocity = self.xSpeed
    self.yVelocity = self.ySpeed
    local range = math.random(20,40)
    self.xMin = x - range
    self.xMax = x + range

    -- behavior stuff - follower
    self.followerUpdateCycles = 8
    self.followerUpdateCycleCounter = math.random(1,self.followerUpdateCycles)
    self.followerXDestination = 0
    self.followerYDestination = 0
    self.followerSpeed = 2

    self.dead = false

end


function TinyGuyVertical:update()
    TinyGuyVertical.super.update(self)

    if (self.y > 350) then
        self:moveTo(self.x, -60)
    end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end

    self:_checkCollisions()

end

function TinyGuyVertical:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500,col.x, col.y)
            col:destroy()
            self:damage(1)

            if (self.camera) then
                self.camera:smallShake()
            end

        elseif (col:isa(PlayerLaser)) then
            if (col.isDamageEnabled) then
                self:damage(5)
            end

        elseif (col:isa(PlayerMissile)) then
            col:explode()

        elseif (col:isa(PlayerMissileExplosion)) then
            if (col.isDamageEnabled) then
                self:damage(15)
            end
        
        elseif (col:isa(PlayerMine)) then
            col:explode()

        elseif (col:isa(PlayerMineExplosion)) then
            if (col.isDamageEnabled) then
                self:damage(10)
            end
        end
    end
end

function TinyGuyVertical:physicsUpdate()

    -- It is the leader
    if ((self.leader == nil) or (self.leader.dead)) then
        self:_leaderUpdate()
    else 
        self:_followerUpdate()
    end
    
end

function TinyGuyVertical:_leaderUpdate()
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    
    if (newX > self.xMax or newX <self.xMin) then
        self.xVelocity = -self.xVelocity
    end

    self:moveTo(newX, newY)
end

function TinyGuyVertical:_followerUpdate()
    self.followerUpdateCycleCounter+=1
    
    -- defer update to destination
    if (self.followerUpdateCycleCounter > self.followerUpdateCycles) then    
        self.followerXDestination = self.leader.x
        self.followerYDestination = self.leader.y - 16
        self.followerUpdateCycleCounter = 0
    end

    -- if the enemy has teleported to the top again, teleport as well
    if (math.abs(self.y - self.leader.y) > 50) then 
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

function TinyGuyVertical:getXVelocity()
    return self.xVelocity
end

function TinyGuyVertical:_onDead()
    self.dead = true
    SingleSpriteAnimation("images/enemies/tinyGuyAnim/death", 500, self.x, self.y)
    self:remove()
end

function TinyGuyVertical:remove()
    self.animator:remove()
    Grunt.super.remove(self)
end

function TinyGuyVertical:setXVelocity(amount) 
    self.xVelocity = amount
end