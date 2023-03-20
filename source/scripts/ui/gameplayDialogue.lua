local gfx <const> = playdate.graphics

import "scripts/extensions/playdate"
import "scripts/ui/typer"

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

    -- self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, 0, 1, playdate.easingFunctions.outCubic)
    
    self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, 0, 1)
    self.currentTyper = nil

    -- images
    self.frameImage = gfx.image.new("images/ui/dialogue/gameplay-dialogue-frame")
    self.frameSprite = gfx.sprite.new(self.frameImage)
    self.frameSprite:setIgnoresDrawOffset(true)
    self.frameSprite:setZIndex(108)
    self.frameSprite:moveTo(200,150)
    self.frameSprite:setClipRect(0,0,0,0)
    self.frameSprite:add()

    self.titleFrameImage =gfx.image.new("images/ui/dialogue/gameplay-title-frame")
    self.titleFrameSprite = gfx.sprite.new(self.titleFrameImage)
    self.titleFrameSprite:setZIndex(109)
    self.titleFrameSprite:moveTo(200,110)
    self.titleFrameSprite:setIgnoresDrawOffset(true)
    self.titleFrameSprite:setVisible(false)
    self.titleFrameSprite:add();

    self.titleTextImage = gfx.image.new(self.titleFrameImage:getSize())
    self.titleTextSprite = gfx.sprite.new(self.titleTextImage)
    self.titleTextSprite:setIgnoresDrawOffset(true)
    self.titleTextSprite:setZIndex(110)
    self.titleTextSprite:moveTo(200,110)
    self.titleTextSprite:setVisible(false)
    self.titleTextSprite:add()

    self.titleTextFont = gfx.font.new("fonts/bleu")
    self.showTitleText = false

    self.avatarAnim = nil

    self:add()
end 



function GameplayDialogue:update()
    self:_updateTitleVisibility()
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
        -- enter shown state
        self:_loadCurrentTyper()
        self.state = STATE.SHOWN
    end

end

function GameplayDialogue:_updateDialogues()

    if (self.currentTyper:isFinishedTyping()) then
        if (self.avatarAnim ~= nil) then
            -- reset the frame back to 1 and pause it.
            self.avatarAnim:reset()
            self.avatarAnim:pause()
        end    
    end

    if (self.currentTyper:isDismissed()) then
        self.currentTyper:remove()
        self.currentTyper = nil

        self.dialogueIndex += 1

        if (self.dialogueIndex > #self.allDialogues) then
            self.frameAnimator = gfx.animator.new(TRANSITION_DURATION, 1, 0)
            self.state = STATE.ANIMATING_OUT
            if (self.avatarAnim) then 
                self.avatarAnim:remove()
            end
        else 
            self:_loadCurrentTyper()
        end
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
    self.titleFrameSprite:remove()
    self.titleTextSprite:remove()
    GameplayDialogue.super.remove(self)
end

function GameplayDialogue:_loadCurrentTyper()
    
    if (self.avatarAnim ~= nil) then
        self.avatarAnim:remove()
    end

    local dialogueInfo = self.allDialogues[self.dialogueIndex]
    self.currentTyper = Typer(320,175, dialogueInfo.text)

    -- populate the title thing 
    if (dialogueInfo.title == nil or dialogueInfo.title == "[N/A]") then
        self.showTitleText = false

    else 
        self.showTitleText = true
 
        -- draw title text onto the image (this only needs to be done when it changes)
        gfx.pushContext(self.titleTextImage)
            gfx.setFont(self.titleTextFont)
            gfx.clear(gfx.kColorClear)
            gfx.setColor(gfx.kColorBlack)
            gfx.drawTextAligned(dialogueInfo.title, 64,13,kTextAlignment.center)
        gfx.popContext()
    end

    -- avatar anim
    if (dialogueInfo.avatarId ~= "[N/A]") then
        local imageTablePath = "images/ui/dialogue/avatars/" .. dialogueInfo.avatarId .. "/avatar"
        self.avatarAnim = SpriteAnimation(imageTablePath, 500, 75, 150)
        self.avatarAnim:setRepeats(-1)
        self.avatarAnim:setZIndex(110)
        self.avatarAnim:setIgnoresDrawOffset(true)
    else 
        self.avatarAnim = nil
    end
    
end

function GameplayDialogue:_updateTitleVisibility()
    if (self.state == STATE.SHOWN) then
        if (self.showTitleText) then
            self.titleFrameSprite:setVisible(true)
            self.titleTextSprite:setVisible(true)
        else 
            self.titleFrameSprite:setVisible(false)
            self.titleTextSprite:setVisible(false)
        end
    else 
        self.titleFrameSprite:setVisible(false)
        self.titleTextSprite:setVisible(false)
    end
end