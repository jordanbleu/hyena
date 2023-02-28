local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/effects/playerBulletExplosion"
--[[
    The grunt enemy moves vaguely downwards and towards the player in bursts
]]
class("Grunt").extends(Enemy)

function Grunt:init() 

    Grunt.super.init(self, 3)

    local image = gfx.image.new("images/enemies/grimidean-grunt")
    self:setImage(image)

    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
    self:add()

end

function Grunt:update()
    Grunt.super.update(self)
    self:_checkCollisions()
end

function Grunt:_checkCollisions()

    local collisions = self:overlappingSprites()

    for i, col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            print "ouch"

            -- create a new explosion object at the bullets position
            local explosion = PlayerBulletExplosion(col.x, col.y)

            col:destroy()
            self:damage(1)
            
        end
    end

end

function Grunt:_onDead()
    print "i'm dead"
end