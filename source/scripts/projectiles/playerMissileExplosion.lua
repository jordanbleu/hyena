local gfx <const> = playdate.graphics

--[[
    This shows the explosion sprite and handle the AOE 
]]
class("PlayerMissileExplosion").extends(SingleSpriteAnimation)

function PlayerMissileExplosion:init(x,y)
    PlayerMissileExplosion.super.init(self, 'images/effects/explosionAnim/explosion', 1000, x, y)

    self.didDamage = false
    self.isDamageEnabled = false

    self:moveTo(x,y)
    self:setCollideRect(-32,-32,64,64)
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()
end

function PlayerMissileExplosion:update()
    PlayerMissileExplosion.super.update(self)

    -- damage is enabled for a single frame.
    if (self.isDamageEnabled) then
        self.isDamageEnabled = false
    end

    if (not self.didDamage) then
        self.isDamageEnabled = true
        self.didDamage = true
    end
end