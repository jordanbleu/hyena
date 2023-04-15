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
    The tiny guys work like a linked list of enemies.  If it has a leader,
    it will follow behind that leader.  If not, it becomes the leader.

    The leader must be another TinyGuy.
]]
class("TinyGuy").extends(Enemy)

local DISTANCE_FROM_LEADER <const> = 16

function TinyGuy:init(x,y,leader, cameraInst, playerInst)
    TinyGuy.super.init(self, 1)
    
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
    self.xSpeed = 2
    self.ySpeed = 0.5
    self.xVelocity = self.xSpeed
    self.yVelocity = self.ySpeed

    -- behavior stuff - follower
    self.followerUpdateCycles = 6
    self.followerUpdateCycleCounter = math.random(1,self.followerUpdateCycles)
    self.followerXDestination = 0
    self.followerYDestination = 0
    self.followerSpeed = 2

    self.dead = false

end


function TinyGuy:update()
    TinyGuy.super.update(self)

    if (self.y > 250) then
        self:moveTo(self.x, -60)
    end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end

    self:_checkCollisions()

end

function TinyGuy:_checkCollisions()
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

function TinyGuy:physicsUpdate()

    -- It is the leader
    if ((self.leader == nil) or (self.leader.dead)) then
        self:_leaderUpdate()
    else 
        self:_followerUpdate()
    end
    
end

function TinyGuy:_leaderUpdate()
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    
    -- bounce left and right, but each time you bounce,
    -- y position moves up a bit
    if (newX > 400 or newX < 0) then
        self.xVelocity = -self.xVelocity
        self.yVelocity = -self.ySpeed * 2
    end
    
    -- move velocity towards y speed so the tiny guy starts going downward again 
    self.yVelocity = math.moveTowards(self.yVelocity, self.ySpeed, 0.02)
    
    self:moveTo(newX, newY)
end

function TinyGuy:_followerUpdate()
    self.followerUpdateCycleCounter+=1
    
    -- defer update to destination
    if (self.followerUpdateCycleCounter > self.followerUpdateCycles) then        
        self.followerXDestination = self.leader.x
        self.followerYDestination = self.leader.y
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

function TinyGuy:getXVelocity()
    return self.xVelocity
end

function TinyGuy:_onDead()
    self.dead = true
    SingleSpriteAnimation("images/enemies/tinyGuyAnim/death", 500, self.x, self.y)
    self:remove()
end

function TinyGuy:remove()
    self.animator:remove()
    Grunt.super.remove(self)
end

function TinyGuy:setXVelocity(amount) 
    self.xVelocity = amount
end