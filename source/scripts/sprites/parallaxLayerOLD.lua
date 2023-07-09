-- local gfx <const> = playdate.graphics

-- --[[ Single scrolling background layer. ]]
-- class("ParallaxLayer").extends(gfx.sprite)

-- function ParallaxLayer:init(image, scrollX, scrollY)
--     ParallaxLayer.super.init(self, image)

--     scrollX = scrollX or 0
--     scrollY = scrollY or 0

--     self:setCenter(0,0)
--     self:moveTo(0,0)

--     self.upperImage = FastSprite(image)
--     self.upperImage:setCenter(0,0)
--     self.upperImage:add()

--     self.lowerImage = FastSprite(image)
--     self.lowerImage:setCenter(0,0)
--     self.lowerImage:add() 
    

--     self.leftImage = FastSprite(image)
--     self.leftImage:setCenter(0,0)
--     self.leftImage:add() 
    
--     self.rightImage = FastSprite(image)
--     self.rightImage:setCenter(0,0)
--     self.rightImage:add() 
    

--     self.scrollY = scrollY
--     self.scrollX = scrollX

--     local w,h = self:getImage():getSize()
--     self.width = w
--     self.height = h

--     self:add()

-- end

-- function ParallaxLayer:update()

--     ParallaxLayer.super.update(self)

--     self:moveTo(self.x + self.scrollX, self.y + self.scrollY)

--     if (self.y > self.height or self.y < -self.height) then
--         self:moveTo(self.x, 0)
--     end

--     if (self.x > self.width or self.x < -self.width) then
--         self:moveTo(0, self.y)
--     end

--     self:_setUpperAndLowerImagePositions()
--     self:_setLeftAndRightImagePositions()

-- end

-- function ParallaxLayer:_setUpperAndLowerImagePositions()
--     self.upperImage:moveTo(self.x, self.y - self.height)
--     self.lowerImage:moveTo(self.x, self.y + self.height)
    
-- end

-- function ParallaxLayer:_setLeftAndRightImagePositions()
--     self.leftImage:moveTo(self.x - self.width, self.y)
--     self.rightImage:moveTo(self.x + self.width, self.y)

-- end

-- function ParallaxLayer:remove()
--     self.leftImage:remove()
--     self.rightImage:remove()
--     self.upperImage:remove()
--     self.lowerImage:remove()
--     ParallaxLayer.super.remove(self)
-- end

-- function ParallaxLayer:setScrollX(sx) 
--     self.scrollX = sx
-- end

-- function ParallaxLayer:setScrollY(sy)
--     self.scrollY = sy
-- end

-- function ParallaxLayer:setZIndex(z)
--     ParallaxLayer.super.setZIndex(self,z)
--     self.leftImage:setZIndex(z)
--     self.rightImage:setZIndex(z)
--     self.upperImage:setZIndex(z)
--     self.lowerImage:setZIndex(z)
-- end




--------
----

---- NEW CODE 

-- local gfx <const> = playdate.graphics

-- import "scripts/objects/gameObject"

-- --[[ Single scrolling background layer. ]]
-- class("ParallaxLayer").extends(GameObject)

-- function ParallaxLayer:init(image, scrollX, scrollY)
--     scrollX = scrollX or 0
--     scrollY = scrollY or 0

--     --[[ X / Y are where the main image is ]]

--     self.x = 0
--     self.y = 0

--     -- Set up the image 
--     self.image = image
--     local w,h = image:getSize()
--     self.w = w
--     self.h = h

--     self:setScroll(scrollX, scrollY)
--     self:add()
-- end

-- function ParallaxLayer:update()
--     self:_scroll()
--     self:_drawSelf()
--     self:_drawBuffers()
-- end

-- function ParallaxLayer:_scroll()
--     self.y += self.scrollY
--     self.x += self.scrollX

--     if (self.y > self.h or self.y <-self.h) then
--         self.y = 0
--     end

--     if (self.x < -self.w or self.x > self.w) then
--         self.x = 0
--     end
-- end

-- function ParallaxLayer:_drawSelf()
--     self.image:draw(self.x, self.y)
-- end

-- function ParallaxLayer:_drawBuffers()
--     if (self.drawLeftBuffer) then
--         self.image:draw(self.x-self.w, self.y)
--     end

--     if (self.drawRightBuffer) then
--         self.image:draw(self.x+self.w, self.y)
--     end

--     if (self.drawUpperBuffer) then
--         self.image:draw(self.x, self.y-self.h)
--     end

--     if (self.drawLowerBuffer) then
--         self.image:draw(self.x, self.y+self.h)
--     end
-- end

-- -- can theoretically be called on the fly to swap images out
-- function ParallaxLayer:setScroll(sx,sy)

--     self.x = 0
--     self.y = 0

--     self.scrollX = sx
--     self.scrollY = sy

--     local w= self.w
--     local h = self.h
    
--     --[[ 
--         Buffer images are drawn on the outside of the center image as needed
--         based on image width and scroll
--     ]]

--     self.drawLeftBuffer = sx > 0 or w < 400
--     self.drawRightBuffer = sx < 0 or w < 400
--     self.drawUpperBuffer = sy > 0 or h < 240
--     self.drawLowerBuffer = sy < 0 or h < 240
-- end