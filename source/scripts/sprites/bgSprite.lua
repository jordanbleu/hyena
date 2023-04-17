local gfx <const> = playdate.graphics

--[[ 
    Object that will automatically spawn objects in the background.
]] 
class("BgSprite").extends(Actor)

function BgSprite:init(image, x,y, velocity)
    BgSprite.super.init(self)
    local w,h = image:getSize()

    self:setImage(image)
    self:moveTo(x,y)
    self:setZIndex(2)

    self.yMax = 240 + h
    self.yVelocity = velocity
    self:add()
end

function BgSprite:update()
    if (self.y > self.yMax) then
        self:remove()
    end
    BgSprite.super.update(self)
end

function BgSprite:physicsUpdate()
    local newY = self.y + self.yVelocity
    self:moveTo(self.x, newY)
    BgSprite.super.physicsUpdate(self)
end