local gfx <const> = playdate.graphics


--[[ Single scrolling background layer. ]]
class("ParallaxLayer").extends(gfx.sprite)

function ParallaxLayer:init(image, scrollY)

    self:setImage(image)
    
    self:moveTo(200,120)

    self.upperImage = gfx.sprite.new(image)
    self.upperImage:add()
    
    self.lowerImage = gfx.sprite.new(image)
    self.lowerImage:add()

    self.scrollY = scrollY


end

function ParallaxLayer:update()

    local halfHeight = self:getImage():getSize() / 2
    self:moveTo(self.x, self.y + self.scrollY)   

    if (self.y > halfHeight or self.y < -halfHeight) then
        self.y = 0
    end

    self:_setUpperAndLowerImagePositions()
end

function ParallaxLayer:_setUpperAndLowerImagePositions()

    local halfHeight = self:getImage():getSize() / 2
    self.upperImage:moveTo(self.x, self.y - halfHeight)
    self.lowerImage:moveTo(self.x, self.y + halfHeight)
    
end