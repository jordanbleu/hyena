local gfx <const> = playdate.graphics


--[[ The boss bar displays the current boss's health. ]]
class("BossBar").extends(gfx.sprite)

local STATES = {
    HIDDEN = 0,
    SHOWN = 1,
}


function BossBar:init()

    self.animator = nil

    self:setImage(gfx.image.new("images/ui/hud/boss-bar/boss-bar-frame"))
    self:setVisible(false)
    self:setZIndex(100)
    self:setIgnoresDrawOffset(true)

    self:moveTo(-20,120)
    self.visible = false

    self.iconSprite = gfx.sprite.new(gfx.image.new(16,16, gfx.kColorWhite))
    self.iconSprite:setCenter(0,0)
    self.iconSprite:setZIndex(101)
    self.iconSprite:setIgnoresDrawOffset(true)
    self.iconSprite:add()

    -- how full health bar is
    self.percent = 1

    self.barImage = gfx.image.new(4,110, gfx.kColorClear)
    self.barSprite = gfx.sprite.new(self.barImage)
    self.barSprite:setCenter(0,0)
    self.barSprite:setZIndex(102)
    self.barSprite:setIgnoresDrawOffset(true)
    self.barSprite:add()

    self:_refresh()
    self:add()
end

function BossBar:update()
    self:_updatePosition()

end

function BossBar:_updatePosition()
    self.iconSprite:moveTo(self.x-6, self.y-62)
    self.barSprite:moveTo(self.x-2, self.y-48)

    -- notice this hooks directly into the sprite itself, not the 'visible' field 
    self.barSprite:setVisible(self:isVisible())
    
    if (self.animator == nil) then
        return
    end

    self:moveTo(self.animator:currentValue(), self.y)

    if (self.animator:ended() and not self.visible) then
        self:setVisible(false)
    else
        self:setVisible(true)
    end


end


function BossBar:show()
    self.visible = true
    self.animator = gfx.animator.new(1500, self.x, 20, playdate.easingFunctions.outBack)
end

function BossBar:hide()
    self.visible = false
    self.animator = gfx.animator.new(1500, self.x, -100, playdate.easingFunctions.inBack)
end

function BossBar:setIconImage(imgPath)
    local img = gfx.image.new(imgPath)
    self.iconSprite:setImage(img)
end

---Sets the current percent of the health bar, between 0 and 1.  DO NOT CALL THIS EVERY FRAME SINCE IT TRIGGERS A REDRAW.
function BossBar:setPercent(amount)
    self.percent = amount
    self:_refresh()
end

function BossBar:_refresh()

    local barTop = 110 - (110 * self.percent)

    gfx.pushContext(self.barImage)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(0,barTop,4,110-barTop)
    gfx.popContext()
end