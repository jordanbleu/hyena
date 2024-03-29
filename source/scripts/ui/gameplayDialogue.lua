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

function GameplayDialogue:init(csvFile, playerInst, cameraInst)

    self.player = playerInst 
    self.camera = cameraInst

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
    self.titleFrameSprite:add()

    self.titleTextImage = gfx.image.new(self.titleFrameImage:getSize())
    self.titleTextSprite = gfx.sprite.new(self.titleTextImage)
    self.titleTextSprite:setIgnoresDrawOffset(true)
    self.titleTextSprite:setZIndex(110)
    self.titleTextSprite:moveTo(200,110)
    self.titleTextSprite:setVisible(false)
    self.titleTextSprite:add()

    self.titleTextFont = gfx.font.new("fonts/big-bleu")
    self.showTitleText = false

    self.aButtonImage = gfx.image.new("images/ui/aButton")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSprite:setIgnoresDrawOffset(true)
    self.aButtonSprite:setZIndex(120)
    self.aButtonSprite:moveTo(345,175)
    self.aButtonSprite:setVisible(false)
    self.aButtonSprite:add();

    self.aButtonBlinker = gfx.animation.blinker.new(500,500, true)
    self.aButtonBlinker:start()

    self.avatarAnim = nil

    self.isFullyCompleted = false
    self:add()
end 



function GameplayDialogue:update()
    self:_updateTitleVisibility()
    
    if (self.state == STATE.ANIMATING_IN) then
        self:_animateIn()

    elseif (self.state == STATE.SHOWN) then
        self:_updateDialogues()
        self:_blinkAButton()

    elseif (self.state == STATE.ANIMATING_OUT) then
        self:_animateOut()
    end

end

function GameplayDialogue:_blinkAButton()
    if (self.currentTyper and self.currentTyper:isFinishedTyping()) then 
        if (self.aButtonBlinker.on) then
            self.aButtonSprite:setVisible(true)
        else
            self.aButtonSprite:setVisible(false)
        end
    elseif (self.currentTyper) then
        self.aButtonSprite:setVisible(false) 
  
    end
end

function GameplayDialogue:_animateIn()

    local clipHeight = 80 * self.frameAnimator:currentValue()

    self.frameSprite:setClipRect(0,self.frameSprite.y-40,400,clipHeight)

    if (self.frameAnimator:ended()) then
        -- enter shown state
        if (self.player) then
            self.player:lockControls()
        end
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
        self.isFullyCompleted = true
        if (self.player) then
            self.player:unlockControls()
        end
        self:remove()
    end

end

function GameplayDialogue:remove()
    self.frameSprite:remove()
    self.titleFrameSprite:remove()
    self.titleTextSprite:remove()
    self.aButtonSprite:remove()
    GameplayDialogue.super.remove(self)
end

function GameplayDialogue:_loadCurrentTyper()
    
    if (self.avatarAnim ~= nil) then
        self.avatarAnim:remove()    
    end

    local dialogueInfo = self.allDialogues[self.dialogueIndex]

    
    if (self.camera) then
        if (dialogueInfo.camShakeLevel == 1) then
            self.camera:smallShake()
        elseif (dialogueInfo.camShakeLevel == 2) then
            self.camera:bigShake()    
        end        
    end
    
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
        gfx.drawTextAligned(dialogueInfo.title, 64,11,kTextAlignment.center)
        gfx.popContext()
    end
    
    -- avatar anim
    
    local typerX = 55
    local typerY = 130
    
    if (dialogueInfo.avatarId ~= "[N/A]") then
        -- dialogue text will be slightly to the right to accomodate for the avatar sprite 
        self.currentTyper = Typer(typerX + 50,typerY, dialogueInfo.text, 3, 21)
        
        local imageTablePath = "images/ui/dialogue/avatars/" .. dialogueInfo.avatarId .. "/avatar"
        self.avatarAnim = SpriteAnimation(imageTablePath, 500, 75, 150)
        self.avatarAnim:setRepeats(-1)
        self.avatarAnim:setZIndex(110)
        self.avatarAnim:setIgnoresDrawOffset(true)
    else 
        -- dialogue text shifts to the left and allows for more charactes per line since we have more space.
        self.currentTyper = Typer(typerX,typerY, dialogueInfo.text, 3, 25)
        
        self.avatarAnim = nil
    end
    self.currentTyper:setDelayCycles(dialogueInfo.textDelay)
    
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

function GameplayDialogue:isCompleted()
    return self.isFullyCompleted
end