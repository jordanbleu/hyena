local gfx <const> = playdate.graphics

import "scripts/actors/actor"

--[[
    Small explosion sprite for player bullets
]]
class("PlayerBulletExplosion").extends(Actor)

function PlayerBulletExplosion:init(x, y)

    -- loads a set of sprites for the animation and creates an animator to automatically animate them
    self.imageTable = gfx.imagetable.new("images/effects/playerBulletExplosionAnim/player-bullet-explosion")
    self:setImage(self.imageTable:getImage(1))
    
    self.animator = gfx.animator.new(250, 1, self.imageTable:getLength())

    self:moveTo(x,y)
    self:add()
end

-- TODO: so, animators aren't going to be affected by the time scaler...i need to decide if that'll be an issue or not.  
-- We could potentially fix this by delaying the timer updates in main.lua

function PlayerBulletExplosion:update() 
    PlayerBulletExplosion.super.physicsUpdate(self)

    local animatorValue = math.floor(self.animator:currentValue())
    local img = self.imageTable:getImage(animatorValue)
    print (animatorValue)
    self:setImage(img)

    if (self.animator:ended()) then
        self:remove()
    end

end