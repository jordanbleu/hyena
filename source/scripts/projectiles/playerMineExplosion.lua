local gfx <const> = playdate.graphics

--[[
    This shows the explosion sprite and handles the AOE 
]]
class("PlayerMineExplosion").extends(SingleSpriteAnimation)

function PlayerMineExplosion:init(x,y)
    PlayerMineExplosion.super.init(self, 'images/effects/playerMineExplosionAnim/player-mine-explosion', 1500, x, y)

    self.didDamage = false
    self.isDamageEnabled = false

    self:moveTo(x,y)
    self:setCollideRect(-80,-32,160,64)
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()

end

function PlayerMineExplosion:update()

    PlayerMineExplosion.super.update(self)

    -- damage is enabled for a single frame.
    if (self.isDamageEnabled) then
        self.isDamageEnabled = false
    end

    if (not self.didDamage) then
        self.isDamageEnabled = true
        self.didDamage = true
    end

end



