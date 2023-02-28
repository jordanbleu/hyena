local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/effects/playerBulletExplosion"
--[[
    The grunt enemy moves vaguely downwards and towards the player in bursts
]]
class("Grunt").extends(Enemy)

function Grunt:init() 

    Grunt.super.init(self, 3)

    self.imageTable = gfx.imagetable.new("images/enemies/grimideanGruntAnim/grimidean-grunt")

    self:setImage(self.imageTable:getImage(1))
    self.animator = PhysicsAnimator(650, 1, self.imageTable:getLength())
    self.animator:setRepeatCount(-1)

    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
    self:add()

end

function Grunt:update()
    Grunt.super.update(self)

    -- update sprite frame 
    local animatorValue = math.floor(self.animator:currentValue())
    local img = self.imageTable:getImage(animatorValue)
    self:setImage(img)

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