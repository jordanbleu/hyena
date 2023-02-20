local gfx <const> = playdate.graphics

--[[
    This is the player object, for normal gameplay
]]
class("Player").extends(gfx.sprite)

function Player:init()
    self:setImage(gfx.image.new("images/player"))
    self:setZIndex(10)
end
