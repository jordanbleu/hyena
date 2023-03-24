local gfx <const> = playdate.graphics

import "scripts/ui/typer"

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
    
    local w,h = img:getSize()
    
    -- panning animator == panimator lolz

    -- horizontal panning animator
    self.hPanimator = nil
    -- vertical panning animator 
    self.vPanimator = nil

    self:_setupPanningAnimators(w, h,self.effect)

    local blackScreenImage = gfx.image.new("images/black")
    self.transitionSprite = gfx.sprite.new(blackScreenImage)
    self.transitionSprite:setZIndex(120)
    self.transitionSprite:moveTo(200,120)
    self.transitionSprite:add()
    self.transitionSprite:setVisible(true)

    self.isComplete = false

    self.waitCycles = 35
    self.preDelayCycleCounter = 0
    self.postDelayCycleCounter = 0

    self.state = STATE.TRANSITIONING_IN

    self.fullText = text
    self.title = title
    
    self:add()
end

function CutsceneFrame:update()

    CutsceneFrame.super.update(self)
    
    if (self.state == STATE.TRANSITIONING_IN) then
        self:_applyPanningEffect()
        self.preDelayCycleCounter+=1
        if (self.preDelayCycleCounter>self.waitCycles) then
            self.typer = Typer(20,180,self.fullText, 3, 42)
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
            self.transitionSprite:setVisible(false)
            self.isComplete = true
        end

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

    if (effect == CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT) then
        self.hPanimator = gfx.animator.new(6000, 0, -xDifference, playdate.easingFunctions.inOutSine)

    elseif (effect == CUTSCENE_FRAME_EFFECT.PAN_RIGHT_LEFT) then
        self.hPanimator = gfx.animator.new(6000, -xDifference, 0, playdate.easingFunctions.inOutSine)

    elseif (effect == CUTSCENE_FRAME_EFFECT.PAN_UP_DOWN) then 
        self.vPanimator = gfx.animator.new(6000, 0, -yDifference, playdate.easingFunctions.inOutSine)

    else 

    end

end

function CutsceneFrame:remove()

    self.dialogueFrame:remove()
    self.cutsceneSprite:remove()
    self.typer:remove()
    self.transitionSprite:remove()
    self.animator = nil

    CutsceneFrame.super.remove(self)
end

function CutsceneFrame:isCompleted()
    return self.isComplete
end