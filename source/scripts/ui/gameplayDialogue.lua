local gfx <const> = playdate.graphics

import "scripts/extensions/playdate"

--[[ Takes whatever text you tell it to write and types it out letter by letter.  
    Also listens for key presses so user can acknowledge text. 

    Note that this object doesn't have any of the image frame type stuff or other UI 
    so it shouldn't be used on its own.
]]
class("GameplayDialogue").extends(gfx.sprite)

local STATE = {
    ANIMATING_IN = 1,
    SHOWN = 2,
    ANIMATING_OUT = 3,
    HIDDEN = 4
}

-- how long transition in / out takes (in ms)
local TRANSITION_DURATION = 500

function GameplayDialogue:init(csvFile)

    self.allDialogues = playdate.loadDialogueFromCsv(csvFile)
    self.dialogueIndex = 1
    
    self.state = STATE.ANIMATING_IN

    self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, 0, 1)
    
    -- images
    self.frameImage = gfx.image.new("images/ui/dialogue/gameplay-dialogue-frame")
    self.frameSprite = gfx.sprite.new(self.frameImage)
    self.frameSprite:setIgnoresDrawOffset(true)
    self.frameSprite:setZIndex(110)
    self.frameSprite:moveTo(200,150)
    self.frameSprite:setClipRect(0,0,0,0)
    self.frameSprite:add()

    self:add()
end 



function GameplayDialogue:update()

    if (self.state == STATE.ANIMATING_IN) then
        self:_animateIn()

    elseif (self.state == STATE.SHOWN) then
        self:_updateDialogues()

    elseif (self.state == STATE.ANIMATING_OUT) then
        self:_animateOut()
    end

end

function GameplayDialogue:_animateIn()

    local clipHeight = 80 * self.frameAnimator:currentValue()

    self.frameSprite:setClipRect(0,self.frameSprite.y-40,400,clipHeight)

    if (self.frameAnimator:ended()) then
        self.state = STATE.SHOWN
    end

end

function GameplayDialogue:_updateDialogues()
    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, 1, 0)
        self.state = STATE.ANIMATING_OUT
    end
end

function GameplayDialogue:_animateOut()
    local clipHeight = 80 * self.frameAnimator:currentValue()
    
    self.frameSprite:setClipRect(0,self.frameSprite.y-40,400,clipHeight)

    if (self.frameAnimator:ended()) then
        self:remove()
    end

end

function GameplayDialogue:remove()
    self.frameSprite:remove()
    GameplayDialogue.super.remove(self)
end