local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
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

function Grunt:init(x,y) 

    Grunt.super.init(self, 3)

    self:moveTo(x,y)

    self.state = STATES.IDLE

    -- idle image animation
    self.animator = SpriteAnimation("images/enemies/grimideanGruntAnim/idle", 1500, self.x, self.y)
    self.animator:setRepeats(-1)

    self:setCollideRect(-8,-8,16,16)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
    self:add()

end

function Grunt:update()
    Grunt.super.update(self)

    if (self.state == STATES.IDLE) then
        self:_checkCollisions()
    end

end

function Grunt:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            print "ouch"
            -- create a new explosion object at the bullets position
            local explosion = SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 1000,col.x, col.y)
            col:destroy()
            self:damage(1)
        end
    end
end

function Grunt:_onDead()
    --self.animator:remove()
    SingleSpriteAnimation("images/enemies/grimideanGruntAnim/death", 1000, self.x, self.y)
    self:remove()
end

function Grunt:remove()
    self.animator:remove()
    Grunt.super.remove(self)
end