local gfx <const> = playdate.graphics

import "scripts/sprites/fastSprite"

--[[ Single scrolling background layer. ]]
class("ParallaxLayer").extends(FastSprite)

function ParallaxLayer:init(image, scrollX, scrollY)
    ParallaxLayer.super.init(self, image)

    scrollX = scrollX or 0
    scrollY = scrollY or 0

    self:setCenter(0,0)
    self:moveTo(0,0)

    self.upperImage = FastSprite(image)
    self.upperImage:setCenter(0,0)
    self.upperImage:add()

    self.lowerImage = FastSprite(image)
    self.lowerImage:setCenter(0,0)
    self.lowerImage:add() 
    

    self.leftImage = FastSprite(image)
    self.leftImage:setCenter(0,0)
    self.leftImage:add() 
    
    self.rightImage = FastSprite(image)
    self.rightImage:setCenter(0,0)
    self.rightImage:add() 
    

    self.scrollY = scrollY
    self.scrollX = scrollX

    local w,h = self:getImage():getSize()
    self.width = w
    self.height = h

    self:add()

end

function ParallaxLayer:update()

    ParallaxLayer.super.update(self)

    self:moveTo(self.x + self.scrollX, self.y + self.scrollY)

    if (self.y > self.height or self.y < -self.height) then
        self:moveTo(self.x, 0)
    end

    if (self.x > self.width or self.x < -self.width) then
        self:moveTo(0, self.y)
    end

    self:_setUpperAndLowerImagePositions()
    self:_setLeftAndRightImagePositions()

end

function ParallaxLayer:_setUpperAndLowerImagePositions()
    self.upperImage:moveTo(self.x, self.y - self.height)
    self.lowerImage:moveTo(self.x, self.y + self.height)
    
end

function ParallaxLayer:_setLeftAndRightImagePositions()
    self.leftImage:moveTo(self.x - self.width, self.y)
    self.rightImage:moveTo(self.x + self.width, self.y)

end

function ParallaxLayer:remove()
    self.leftImage:remove()
    self.rightImage:remove()
    self.upperImage:remove()
    self.lowerImage:remove()
    ParallaxLayer.super.remove(self)
end

function ParallaxLayer:setScrollX(sx) 
    self.scrollX = sx
end

function ParallaxLayer:setScrollY(sy)
    self.scrollY = sy
end

function ParallaxLayer:setZIndex(z)
    ParallaxLayer.super.setZIndex(self,z)
    self.leftImage:setZIndex(z)
    self.rightImage:setZIndex(z)
    self.upperImage:setZIndex(z)
    self.lowerImage:setZIndex(z)
end