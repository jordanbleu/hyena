
local gfx <const> = playdate.graphics

import "scripts/objects/gameObject"

--[[ Single scrolling background layer. ]]
class("ParallaxLayer").extends(GameObject)

function ParallaxLayer:init(image, scrollX, scrollY)
    scrollX = scrollX or 0
    scrollY = scrollY or 0

    --[[ X / Y are where the main image is ]]

    self.x = 0
    self.y = 0

    -- Set up the image 
    self.image = image
    local w,h = image:getSize()
    self.w = w
    self.h = h

    self:setScroll(scrollX, scrollY)
    self:add()
end

function ParallaxLayer:update()
    self:_scroll()
    self:_drawSelf()
    self:_drawBuffers()
end

function ParallaxLayer:_scroll()
    self.y += self.scrollY
    self.x += self.scrollX

    if (self.y > self.h or self.y <-self.h) then
        self.y = 0
    end

    if (self.x < -self.w or self.x > self.w) then
        self.x = 0
    end
end

function ParallaxLayer:_drawSelf()
    self.image:draw(self.x, self.y)
end

function ParallaxLayer:_drawBuffers()
    if (self.drawLeftBuffer) then
        self.image:draw(self.x-self.w, self.y)
    end

    if (self.drawRightBuffer) then
        self.image:draw(self.x+self.w, self.y)
    end

    if (self.drawUpperBuffer) then
        self.image:draw(self.x, self.y-self.h)
    end

    if (self.drawLowerBuffer) then
        self.image:draw(self.x, self.y+self.h)
    end
end

-- can theoretically be called on the fly to swap images out
function ParallaxLayer:setScroll(sx,sy)

    self.x = 0
    self.y = 0

    self.scrollX = sx
    self.scrollY = sy

    local w= self.w
    local h = self.h
    
    --[[ 
        Buffer images are drawn on the outside of the center image as needed
        based on image width and scroll
    ]]

    self.drawLeftBuffer = sx > 0 or w < 400
    self.drawRightBuffer = sx < 0 or w < 400
    self.drawUpperBuffer = sy > 0 or h < 240
    self.drawLowerBuffer = sy < 0 or h < 240
end