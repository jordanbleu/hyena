local gfx <const> = playdate.graphics

--[[
    Places shadow splotches behind the player for use in hallucination scenes.
]]
class("PlayerSplotcher").extends(gfx.sprite)

function PlayerSplotcher:init(playerInst)

    self.player = playerInst

    self.cycleCounter = 0

    self.cycles = GLOBAL_TARGET_FPS/2

    self:add()
end

function PlayerSplotcher:update()
    self.cycleCounter += 1

    if (self.cycleCounter > self.cycles) then
        local splotch = SingleSpriteAnimation("images/effects/splotchAnim/splotch", 250, self.player.x, self.player.y)
        splotch:setZIndex(5)
        splotch:attachTo(self.player)
        self.cycleCounter = 0
    end
end