local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/actors/enemy"

--[[ Used in opening credit sequence.  The player flies in from the bottom just before the real game begins ]]
class("PlayerFlyOnScreenSegment").extends(Segment)

function PlayerFlyOnScreenSegment:init()
    PlayerFlyOnScreenSegment.super.init(self)
    self.sprite = gfx.sprite.new(gfx.image.new("images/player"))
    self.sprite:setZIndex(999)
    self.sprite:moveTo(200,260)
    self.sprite:add()
    self.animator = gfx.animator.new(1000, 260, 200)
end

function PlayerFlyOnScreenSegment:isCompleted()
    --is it hacky to use the 'iscompleted' method like an 'update'? idk
    self.sprite:moveTo(self.sprite.x, self.animator:currentValue())
    return self.animator:ended()
end

function PlayerFlyOnScreenSegment:cleanup()
    self.animator = nil
    -- don't remove player sprite, let sceneManager clean that up automatically
end

