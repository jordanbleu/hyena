local gfx <const> = playdate.graphics

--[[
    flashes white on the screen.
]]
class("HardCutBlack").extends(gfx.sprite)

function HardCutBlack:init(durationMs)
    local img = gfx.image.new(400,240, gfx.kColorBlack)
    self:setImage(img)
    self:moveTo(200,120)
    self:setZIndex(999)
    self:setIgnoresDrawOffset(true)
    self:add()

    playdate.timer.performAfterDelay(durationMs, function() self:remove() end)
end