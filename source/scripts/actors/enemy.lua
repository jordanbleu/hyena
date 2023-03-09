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
    if (self.health < 0) then
        self:_onDead()
    end
end

--[[ Called internally when the enemy is dead ]]
function Enemy:_onDead()
end

