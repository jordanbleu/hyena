local gfx <const> = playdate.graphics

import "scripts/actors/actor"
import 'scripts/physics/physicsAnimator'

--[[
    Small explosion sprite for player bullets
]]
class("PlayerBulletExplosion").extends(Actor)

function PlayerBulletExplosion:init(x, y)

    PlayerBulletExplosion.super.init(self)

    -- loads a set of sprites for the animation and creates an animator to automatically animate them
    self.imageTable = gfx.imagetable.new("images/effects/playerBulletExplosionAnim/player-bullet-explosion")
    self:setImage(self.imageTable:getImage(1))
    
    self.animator = PhysicsAnimator(250, 1, self.imageTable:getLength())
    --self.animator = gfx.animator.new(250, 1, self.imageTable:getLength())

    self:moveTo(x,y)
    self:add()
end

function PlayerBulletExplosion:update() 
    PlayerBulletExplosion.super.update(self)

    local animatorValue = math.floor(self.animator:currentValue())
    local img = self.imageTable:getImage(animatorValue)
    print (animatorValue)
    self:setImage(img)

    if (self.animator:ended()) then
        self:remove()
    end

end