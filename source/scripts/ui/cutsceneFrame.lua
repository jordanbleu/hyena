local gfx <const> = playdate.graphics

import "scripts/ui/typer"
import "scripts/effects/hardCutBlack"
import "scripts/camera/camera"
--[[ 
    A custcene frame will display an image that is either static or slowly pans. 

    At the bottom of the screen will be a typer object, no avatars though.
]] 
class("CutsceneFrame").extends(gfx.sprite)

local STATE <const> = 
{
    TRANSITIONING_IN = 1,
    SHOWN = 2,
    TRANSITIONING_OUT = 3
}

local STD_SPRITE_WIDTH <const> = 400
local STD_SPRITE_HEIGHT <const> = 160

function CutsceneFrame:init(title, text, imagePath, effect)

    title = title or ""
    self.effect = effect or CUTSCENE_FRAME_EFFECT.STATIC

    local blackScreenImage = gfx.image.new(400,240,gfx.kColorBlack)
    self.transitionSprite = gfx.sprite.new(blackScreenImage)
    self.transitionSprite:setZIndex(150)
    self.transitionSprite:moveTo(200,120)
    self.transitionSprite:setVisible(true)
    self.transitionSprite:add()

    -- this doesn't need to be loaded for each instance
    -- the sprite for the dialogue text frame
    local dialogueImage = gfx.image.new("images/ui/dialogue/cutscene-dialogue-frame")
    self.dialogueFrame = gfx.sprite.new(dialogueImage)
    self.dialogueFrame:setZIndex(114)
    self.dialogueFrame:moveTo(200, 200)
    self.dialogueFrame:add()

    local img = gfx.image.new(imagePath)
    self.cutsceneSprite = gfx.sprite.new(img)
    self.cutsceneSprite:setZIndex(100)
    self.cutsceneSprite:setCenter(0,0) 
    self.cutsceneSprite:moveTo(0, 0)
    self.cutsceneSprite:add()

    self.titles = {}
    self.titles[1] = title

    self.titleFrameImage =gfx.image.new("images/ui/dialogue/gameplay-title-frame")
    self.titleFrameSprite = gfx.sprite.new(self.titleFrameImage)
    self.titleFrameSprite:setZIndex(114)
    self.titleFrameSprite:moveTo(200,160)
    self.titleFrameSprite:setIgnoresDrawOffset(true)
    self.titleFrameSprite:add()

    self.titleTextImage = gfx.image.new(self.titleFrameImage:getSize())
    self.titleTextSprite = gfx.sprite.new(self.titleTextImage)
    self.titleTextSprite:setIgnoresDrawOffset(true)
    self.titleTextSprite:setZIndex(115)
    self.titleTextSprite:moveTo(200,160)
    self.titleTextSprite:add()

    self.titleTextFont = gfx.font.new("fonts/big-bleu")

    self.camera = Camera()
    self.camera:removeNormalSway()

    local w,h = img:getSize()
    
    -- panning animator == panimator lolz
    
    -- horizontal panning animator
    self.hPanimator = nil
    -- vertical panning animator 
    self.vPanimator = nil
    
    self:_setupPanningAnimators(w, h,self.effect)
    
    self.isComplete = false
    
    self.waitCycles = 10
    self.preDelayCycleCounter = 0
    self.postDelayCycleCounter = 0
    
    self.state = STATE.TRANSITIONING_IN
    
    self.fullTextIndex = 1
    self.fullTexts = {}
    self.fullTexts[1] = text
    
    self.aButtonImage = gfx.image.new("images/ui/aButton")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSprite:setIgnoresDrawOffset(true)
    self.aButtonSprite:setZIndex(999)
    self.aButtonSprite:moveTo(380,225)
    self.aButtonSprite:setVisible(false)
    self.aButtonSprite:add();
    
    self.aButtonBlinker = gfx.animation.blinker.new(500,500, true)
    self.aButtonBlinker:start()

    -- When the title changes, move the title frame a bit to signal to the player that something is different.
    -- Clever psychology tricks ;)
    self.titleAnimator = nil

    self:_drawTitle()
    self:add()
end

function CutsceneFrame:update()

    CutsceneFrame.super.update(self)
    self:_updateTitlePosition()

    if (self.state == STATE.TRANSITIONING_IN) then
        self:_applyPanningEffect()
        self.preDelayCycleCounter+=1
        if (self.preDelayCycleCounter>self.waitCycles) then
            if (self.effect == CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE) then
                self.camera:smallShake()
            end        
            self.typer = Typer(15,183,self.fullTexts[self.fullTextIndex], 3, 31)
            self.transitionSprite:setVisible(false)
            self.state = STATE.SHOWN
        end
    
    elseif (self.state == STATE.SHOWN) then
        self:_applyPanningEffect()
        self:_blinkAButton()
        if (self.typer:isDismissed()) then
            local oldTitle = self.titles[self.fullTextIndex]
            self.fullTextIndex +=1
            local newTitle = self.titles[self.fullTextIndex]

            -- if the next dialogue segment is different from the old one, jiggle the title a big to 
            -- bring attention to it.
            if (oldTitle ~= newTitle) then
                self.titleAnimator = gfx.animator.new(500, self.titleFrameSprite.y - 5, self.titleFrameSprite.y, playdate.easingFunctions.outBounce)
            end

            if (self.fullTextIndex <= #self.fullTexts) then
                self.typer:remove()
                self.typer = Typer(15,183,self.fullTexts[self.fullTextIndex], 3, 31)
                self:_drawTitle()
            else
                self.state = STATE.TRANSITIONING_OUT
                self.aButtonSprite:setVisible(false)
                self.aButtonBlinker:stop()
                self.cutsceneSprite:setVisible(false)
                self.transitionSprite:setVisible(true)
            end
        end

    elseif (self.state == STATE.TRANSITIONING_OUT) then
        self.postDelayCycleCounter+=1
        if (self.postDelayCycleCounter > self.waitCycles) then
            self.isComplete = true

            -- this is a silly hack that covers up any potential delay
            -- in showing the black transition between this and the next 
            -- cutscene frame.
            HardCutBlack(250)
        
            self.cutsceneSprite:setVisible(false)
            self:remove()
        end

    end
end

function CutsceneFrame:_blinkAButton()
    if (self.typer:isFinishedTyping()) then 
        if (self.aButtonBlinker.on) then
            self.aButtonSprite:setVisible(true)
        else
            self.aButtonSprite:setVisible(false)
        end
    else 
        self.aButtonSprite:setVisible(false)
    
    end
end

function CutsceneFrame:_updateTitlePosition()
    if (self.titleAnimator == nil) then return end 
    self.titleFrameSprite:moveTo(self.titleFrameSprite.x, self.titleAnimator:currentValue())
    self.titleTextSprite:moveTo(self.titleTextSprite.x, self.titleAnimator:currentValue())
end

function CutsceneFrame:_drawTitle()
    local title = self.titles[self.fullTextIndex]

    if (title ~= "") then
        self.titleTextSprite:setVisible(true)
        self.titleFrameSprite:setVisible(true)        
        gfx.pushContext(self.titleTextImage)
            gfx.setFont(self.titleTextFont)
            gfx.clear(gfx.kColorClear)
            gfx.setColor(gfx.kColorBlack)
            gfx.drawTextAligned(title, 64,10,kTextAlignment.center)
        gfx.popContext()
    else 
        self.titleTextSprite:setVisible(false)
        self.titleFrameSprite:setVisible(false)
    end

end

-- Confusing math but just trust that it is probably maybe correct.
function CutsceneFrame:_applyPanningEffect()
    local newX = 0
    local newY = 0

    if (self.hPanimator) then
        newX = self.hPanimator:currentValue()
    end

    if (self.vPanimator) then
        newY = self.vPanimator:currentValue()
    end

    self.cutsceneSprite:moveTo(newX, newY)
end

---Sets up the initial values for panning.
function CutsceneFrame:_setupPanningAnimators(width, height, effect)
    local xDifference = width - STD_SPRITE_WIDTH
    local yDifference = height - STD_SPRITE_HEIGHT

    local panDuration = 3000

    if (effect == CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT) then
        self.hPanimator = gfx.animator.new(panDuration, 0, -xDifference, playdate.easingFunctions.inOutSine)

    elseif (effect == CUTSCENE_FRAME_EFFECT.PAN_RIGHT_LEFT) then
        self.hPanimator = gfx.animator.new(panDuration, -xDifference, 0, playdate.easingFunctions.inOutSine)

    elseif (effect == CUTSCENE_FRAME_EFFECT.PAN_UP_DOWN) then 
        self.vPanimator = gfx.animator.new(panDuration, 0, -yDifference, playdate.easingFunctions.inOutSine)

    elseif (effect == CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP) then 
        self.vPanimator = gfx.animator.new(panDuration, -yDifference, 0, playdate.easingFunctions.inOutSine)
    end
    

end

function CutsceneFrame:remove()

    if (self.titleFrameSprite) then 
        self.titleFrameSprite:remove()
    end

    if (self.titleTextSprite) then
        self.titleTextSprite:remove()
    end

    self.dialogueFrame:remove()
    self.cutsceneSprite:remove()
    self.typer:remove()
    self.animator = nil
    self.transitionSprite:remove()
    self.aButtonSprite:remove()

    self.camera:remove()

    CutsceneFrame.super.remove(self)
end

function CutsceneFrame:isCompleted()
    return self.isComplete
end

function CutsceneFrame:append(title, dialogue)
    title = title or ""
    dialogue = dialogue or ""
    table.insert(self.fullTexts, dialogue)
    table.insert(self.titles, title)
end