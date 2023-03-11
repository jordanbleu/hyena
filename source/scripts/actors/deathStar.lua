local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"

local STATE <const> = 
{
    -- Enemy is moving towwards the player 
    IDLE = 0,
    -- Enemy took damage, and is stopped for a sec
    DAMAGE = 1,
    -- Enemy died
    DYING = 2
}

--[[
    The death star is a big chungus huge enemy that moves slow.  It won't be called death star in game.
]]
class("DeathStar").extends(Enemy)

function DeathStar:init(x,y, playerInst)
    DeathStar.super.init(self, 30)

    self.player = playerInst
    self.ySpeed = math.random() * 1.5

    -- idle image animation
    self.animator = SpriteAnimation("images/enemies/deathStarAnim/idle", 8000, self.x, self.y)
    self.animator:setRepeats(-1)

    self.damageAnimator = nil

    self:setCollideRect(-32,-32,64,64)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

    self.ySpeed = 0.5

    self.state = STATE.IDLE

    self:moveTo(x,y)
    self:add()

end

function DeathStar:physicsUpdate()
    DeathStar.super.physicsUpdate(self)

    local newY = self.y + self.ySpeed
    self:moveTo(self.x, newY)
end

function DeathStar:update()
    DeathStar.super.update(self)

    self:_checkCollisions()

    self.animator:moveTo(self.x, self.y)

    if (self.y > 432) then
        local newX = self.player.x + math.random(-24,24)
        local newY = math.random(-64, -32)
        self:moveTo(newX, newY)
    end

end


function DeathStar:_checkCollisions()
    local collisions = self:overlappingSprites()

    local tookDamage = false
    local showImpactAnimation = false

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            print ("player bullet => death star healh - " .. self.health)
            -- player bullet doesn't affect death star
            SingleSpriteAnimation("images/effects/hardImpactAnim/hard-impact", 1000,col.x, col.y)
            col:ricochet()

        elseif (col:isa(PlayerLaser)) then
            if (col.isDamageEnabled) then
                tookDamage = true
                print ("laser => death star healh - " .. self.health)
                showImpactAnimation = true
                self:damage(5)
            end

        elseif (col:isa(PlayerMissile)) then
            print ("missile -> death star healh - " .. self.health)
            showImpactAnimation = true
            col:explode()

        elseif (col:isa(PlayerMissileExplosion)) then
            if (col.isDamageEnabled) then
                tookDamage = true
                print ("missile explosion -> death star healh - " .. self.health)
                showImpactAnimation = true
                self:damage(15)
            end
        
        elseif (col:isa(PlayerMine)) then
            print ("mine -> death star healh - " .. self.health)
            col:explode()

        elseif (col:isa(PlayerMineExplosion)) then
            if (col.isDamageEnabled) then
                tookDamage = true
                print ("mine explosion -> death star healh - " .. self.health)
                showImpactAnimation = true
                self:damage(10)
            end
        end

    end

    if (showImpactAnimation) then
        local ix = math.random(math.floor(self.x-24),math.floor(self.x+24))
        local iy = math.random(math.floor(self.y-24), math.floor(self.y+24))
        local spr = SingleSpriteAnimation("images/effects/hardImpactAnim/hard-impact", 1000,ix, iy)
        spr:setZIndex(50)
    end

    if (tookDamage) then
        self.state = STATE.DAMAGE
        
        self.damageAnimator = SingleSpriteAnimation("images/enemies/deathStarAnim/damage", 1000, self.x, self.y, function() self:swapToIdleState() end)
    end

end

function DeathStar:_onDead()
    SingleSpriteAnimation("images/enemies/deathStarAnim/death", 2000, self.x, self.y)
    self:remove()
end

function DeathStar:remove()
    self.animator:remove()
    DeathStar.super.remove(self)
end

function DeathStar:swapToIdleState()
    self.state = STATE.IDLE
    
    self.damageAnimator = nil
end