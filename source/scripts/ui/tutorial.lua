local gfx <const> = playdate.graphics

import "scripts/extensions/playdate"

--[[ 
    Similar to gameplay dialogue kinda.  Just shows a tutorial message and then waits
        for it to be dismissed.

]]
class("Tutorial").extends(gfx.sprite)

local STATE = {
    ANIMATING_IN = 1,
    SHOWN = 2,
    ANIMATING_OUT = 3,
    HIDDEN = 4
}

-- how long transition in / out takes (in ms)
local TRANSITION_DURATION = 750

function Tutorial:init(message, playerInst)
    self.player = playerInst 

    self.text = message
    
    self.state = STATE.ANIMATING_IN

    -- animate the frame thing on screen
    self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, -20, 50, playdate.easingFunctions.outBack)

    -- images
    self.frameImage = gfx.image.new("images/ui/dialogue/tutorial-frame")
    self.frameSprite = gfx.sprite.new(self.frameImage)
    self.frameSprite:setIgnoresDrawOffset(true)
    self.frameSprite:setZIndex(108)
    self.frameSprite:moveTo(200,-20)
    self.frameSprite:add()

    local w,h = self.frameSprite:getSize()
    self.textImage = gfx.image.new(w,h)

    local font = gfx.font.new("fonts/big-bleu")

    gfx.pushContext(self.textImage)
        gfx.setFont(font)
        gfx.clear(gfx.kColorClear)
        -- this is the weirdest thing, but for some reason only in this very spot 
        -- gfx.setfont no longer works lol.
        gfx.drawTextFromFontWhite(font, message, w/2, h/4, kTextAlignment.center)
    gfx.popContext()

    self.textSprite = gfx.sprite.new(self.textImage)
    self.textSprite:setIgnoresDrawOffset(true)
    self.textSprite:moveTo(200,-20)
    self.textSprite:setZIndex(999)
    self.textSprite:add()

    self.showCycles = 150
    self.cycleCounter = 0

    self.isFullyCompleted = false
    self:add()

    self.player:lockControls()
end

function Tutorial:update()

    self:_animate()
    
    if (self.state == STATE.SHOWN) then
        self.cycleCounter+=1

        if (self.cycleCounter > self.showCycles) then
            self.state = STATE. ANIMATING_OUT
            self.frameAnimator = gfx.animator.new(TRANSITION_DURATION/2, self.frameSprite.y, -50, playdate.easingFunctions.inBack)
        end

    end
end

function Tutorial:_animate()
    -- animate the frame thing 
    local pos = self.frameAnimator:currentValue()
    self.frameSprite:moveTo(self.frameSprite.x, pos)
    self.textSprite:moveTo(self.textSprite.x, pos)

    if (self.frameAnimator:ended()) then
        if (self.state == STATE.ANIMATING_IN) then
            self.state = STATE.SHOWN
        elseif (self.state == STATE.ANIMATING_OUT) then
            self.player:unlockControls()
            self:remove()
        end
    end

end

function Tutorial:remove()
    self.textSprite:remove()
    self.frameSprite:remove()
end