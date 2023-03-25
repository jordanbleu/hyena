local gfx <const> = playdate.graphics

import "scripts/ui/typer"
import "scripts/effects/hardCutBlack"

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

    if (title and title ~= "") then 
        self.title = title
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

        self.titleTextFont = gfx.font.new("fonts/bleu")
        self:_drawTitle()
    end
    
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

    self.fullText = text
    

    self:add()
end

function CutsceneFrame:update()

    CutsceneFrame.super.update(self)

    if (self.state == STATE.TRANSITIONING_IN) then
        self:_applyPanningEffect()
        self.preDelayCycleCounter+=1
        if (self.preDelayCycleCounter>self.waitCycles) then
            self.typer = Typer(15,183,self.fullText, 3, 42)
            self.transitionSprite:setVisible(false)
            self.state = STATE.SHOWN
        end
    
    elseif (self.state == STATE.SHOWN) then
        self:_applyPanningEffect()
        if (self.typer:isDismissed()) then
            self.state = STATE.TRANSITIONING_OUT
            self.cutsceneSprite:setVisible(false)
            self.transitionSprite:setVisible(true)
        end

    elseif (self.state == STATE.TRANSITIONING_OUT) then
        self.postDelayCycleCounter+=1
        if (self.postDelayCycleCounter > self.waitCycles) then
            self.cutsceneSprite:setVisible(false)
            self.isComplete = true
            -- this is a silly hack that covers up any potential delay
            -- in showing the black transition between this and the next 
            -- cutscene frame.
            HardCutBlack(250)
            self:remove()
        end

    end
end

function CutsceneFrame:_drawTitle()
    gfx.pushContext(self.titleTextImage)
        gfx.setFont(self.titleTextFont)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawTextAligned(self.title, 64,13,kTextAlignment.center)
    gfx.popContext()
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


    CutsceneFrame.super.remove(self)
end

function CutsceneFrame:isCompleted()
    return self.isComplete
end