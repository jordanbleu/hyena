local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

--[[
    The enemy class is for common properties related to all enemies:
    * All enemies have health and can be killed
]]
class("Enemy").extends(Actor)

function Enemy:init(health)
    Enemy.super.init(self)
    self.maxHealth = health
    self.health = health
end

function Enemy:update()
    Enemy.super.update(self)
end

--[[ Called when the enemy takes damage.  Make sure you call the parent function. ]]
function Enemy:damage(amount)
    self.health = self.health - amount
    if (self.health <= 0) then
        self:_onDead()
    end
end

--[[ Called internally when the enemy is dead.  Override this in child ]]
function Enemy:_onDead()
end

function Enemy:getHealth()
    return self.health
end

function Enemy:getMaxHealth() 
    return self.maxHealth
end

function Enemy:getHealthPercent()
    return self.health / self.maxHealth
end

function Enemy:isAlive()
    return self.health > 0
end

---Override this to change damage the enemy does to the player
---@return integer
function Enemy:getDamageAmount()
    return 20
end

---Defaults to true.  If true will damage the player, if false will not.
function Enemy:damageEnabled()
    return true
end
