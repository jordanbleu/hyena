local gfx <const> = playdate.graphics

import "scripts/actors/basicEnemy"

--[[
    Tiny ship is a basic enemy
]]
class("TinyShip").extends(BasicEnemy)

function TinyShip:init(x,y, cameraInst)
    TinyShip.super.init(self, 2, cameraInst)
    x = x or 0
    y = y or 0

    -- load images
    -- self:setIdleAnimation("images/enemies/tinyShipAnim/idle", 250)
    -- self:setDamageAnimation("images/enemies/tinyShipAnim/damage", 500)
    -- self:setDeathAnimation("images/enemies/tinyShipAnim/death", 500)
    
    -- todo: remove these, this is a poc 
    self:setIdleAnimation("images/enemies/bubbleGuyAnim/idle", 250)
    self:setDamageAnimation("images/enemies/bubbleGuyAnim/damage", 500)
    self:setDeathAnimation("images/enemies/bubbleGuyAnim/death", 500)
    
    self:moveTo(x,y)
    self:add()
end

