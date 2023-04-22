local gfx <const> = playdate.graphics


--[[ Single scrolling background layer. ]]
class("ParallaxLayer").extends(Actor)

function ParallaxLayer:init(image, scrollX, scrollY)

    ParallaxLayer.super.init(self)
    scrollX = scrollX or 0
    scrollY = scrollY or 0

    self:setImage(image)
    
    self:setCenter(0,0)
    self:moveTo(0,0)

    self.upperImage = gfx.sprite.new(image)
    self.upperImage:setCenter(0,0)
    if (scrollY ~= 0) then 
        self.upperImage:add()
     end 
    
    self.lowerImage = gfx.sprite.new(image)
    self.lowerImage:setCenter(0,0)
    if (scrollY ~= 0) then 
        self.lowerImage:add() 
    end 

    self.leftImage = gfx.sprite.new(image)
    self.leftImage:setCenter(0,0)
    if (scrollX ~= 0) then 
        self.leftImage:add() 
    end

    self.rightImage = gfx.sprite.new(image)
    self.rightImage:setCenter(0,0)
    if (scrollX ~= 0) then 
        self.rightImage:add() 
    end

    self.scrollY = scrollY
    self.scrollX = scrollX

    local w,h = self:getImage():getSize()
    self.width = w
    self.height = h

    self:add()

end

function ParallaxLayer:physicsUpdate()

    ParallaxLayer.super.physicsUpdate(self)

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