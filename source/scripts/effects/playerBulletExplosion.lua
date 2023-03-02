local gfx <const> = playdate.graphics

import "scripts/actors/actor"
import 'scripts/sprites/spriteAnimation'

--[[
    Small explosion sprite for player bullets
]]
class("PlayerBulletExplosion").extends(Actor)

function PlayerBulletExplosion:init(x, y)
    PlayerBulletExplosion.super.init(self)
    self.animation = SpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 1000, x,y)
    self.animation.onCompletedCallback = function() self:remove() end
    self:add()
end


