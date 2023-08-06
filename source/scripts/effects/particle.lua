local gfx <const> = playdate.graphics

--[[
    Sprite that has velocity / acceleration and flies off screen.
]]
class("Particle").extends(gfx.sprite)

function Particle:init(imagePath, x, y, xv, yv)

    local sm = gameContext.getSceneManager()
    self:setImage(sm:getImageFromCache(imagePath))

    self:moveTo(x, y)
    self.xv = xv
    self.yv = yv
    
    local w,h = self:getSize()
    self.w = w
    self.h = h

    self.xaccel = 0
    self.yaccel = 0

    self:add()
end

function Particle:update()
    self:updateMovement()
    self:checkBounds()
end

function Particle:updateMovement()
    local newX = self.x + self.xv
    local newY = self.y + self.yv

    self.xv += self.xaccel
    self.yv += self.yaccel

    self:moveTo (newX, newY)
end

function Particle:checkBounds()
    local halfW = self.w/2
    local halfH = self.h/2

    if (self.x < -halfW or self.x > 400 + halfW) then
        self:remove()
    end

    if (self.y < -halfH or self.y > 240 + halfH) then
        self:remove()
    end
end

function Particle:withAcceleration(xaccel, yaccel)
    self.xaccel = xaccel
    self.yaccel = yaccel
    return self
end