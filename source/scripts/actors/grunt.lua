local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"
import "scripts/powerups/healthPowerup"
--[[
    The grunt enemy moves vaguely downwards and towards the player
]]
class("Grunt").extends(Enemy)

local STATES <const> = 
{
    -- Enemy is moving towwards the player 
    IDLE = 0,
    -- Enemy took damage, and is stopped for a sec
    DAMAGE = 1,
    -- Enemy died
    DYING = 2
}


---comment
---@param x integer x coordinate to start in 
---@param y integer y coordinate to start in
function Grunt:init(x,y, cameraInst, playerInst) 

    Grunt.super.init(self, 3)

    self:moveTo(x,y)

    self.camera = cameraInst
    self.player = playerInst

    self.state = STATES.IDLE

    -- idle image animation
    -- self.animator = SpriteAnimation("images/enemies/grimideanGruntAnim/idle", 1000, self.x, self.y)
    -- self.animator:setRepeats(-1)

    local sm = gameContext.getSceneManager()
    self:setImage(sm:getImageFromCache("images/testingSprite"))

    self:setCollideRect(-8,-8,16,16)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    

    ---
    -- idle state variables
    ---
    -- how fast the guy goes
    self.ySpeed = math.random(2,3)
    self.xSpeed = math.random(1,2)

    -- how fast he goin
    self.xVelocity = 0
    self.yVelocity = 0

    -- how long he wait between bursts
    self.waitCycleCounter = 0
    self.waitCycles = math.random(20,50)
    
    -- how fast he slow down
    self.drag = 0.1

    ---
    -- damage state variables
    ---
    self.damageWaitCycles = 50
    self.damageWaitCycleCounter = 0

    self:add()
end

function Grunt:update()
    Grunt.super.update(self)

    if (self.y > 260) then 
        self:moveTo(self.x, -20)
    end

    if (self.player:didUseEmp()) then
        self:damage(3)
    end
    
    --self.animator:moveTo(self.x, self.y)
    self:_checkCollisions()

end

function Grunt:physicsUpdate()

    Grunt.super.physicsUpdate(self)
    
    if (self.state == STATES.IDLE) then
        self:_move()

    elseif (self.state == STATES.DAMAGE) then
        self.damageWaitCycleCounter += 1
        if (self.damageWaitCycleCounter > self.damageWaitCycles) then
            self.damageWaitCycleCounter = 0
            self.state = STATES.IDLE
        end

    elseif (self.state == STATES.DYING) then
        self.xVelocity = 0
        self.yVelocity = 0

    end

end

function Grunt:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    local tookDamage = false

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            tookDamage= true
            -- create a new explosion object at the bullets position
            SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500,col.x, col.y)
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

        if (tookDamage) then
            self.state = STATES.DAMAGE
        end
    end
end

function Grunt:_move()
    
    self.xVelocity = math.moveTowards(self.xVelocity, 0, self.drag)
    self.yVelocity = math.moveTowards(self.yVelocity, 0, self.drag)

    self.waitCycleCounter += 1

    if (self.waitCycleCounter > self.waitCycles) then
        self.waitCycleCounter = 0

        self.yVelocity = self.ySpeed

        if (self.player.x > self.x) then
            self.xVelocity = self.xSpeed
        else 
            self.xVelocity = -self.xSpeed
        end
    end

    local newX = self.x + self.xVelocity 
    local newY = self.y + self.yVelocity 
    self:moveTo(newX, newY)


end

function Grunt:_onDead()
    --self.animator:remove()
    HealthPowerup(self.x, self.y)
    SingleSpriteAnimation("images/enemies/grimideanGruntAnim/death", 500, self.x, self.y)
    self:remove()
end

function Grunt:remove()
    --self.animator:remove()
    Grunt.super.remove(self)
end