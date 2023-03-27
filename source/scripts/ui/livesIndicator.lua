local gfx <const> = playdate.graphics

import "scripts/sprites/singleSpriteAnimation"

--[[
    Shown when the player loses a life.  Displays current lives, then removes a life to illustrate this.
]]
class("LivesIndicator").extends(gfx.sprite)

local STATE <const> = {
    ANIMATING_IN = 1,
    WAITING_TO_REMOVE_LIFE = 2,
    REMOVING_LIFE = 3,
    WAITING_TO_ANIMATE_OUT = 4,
    ANIMATING_OUT = 5
}

function LivesIndicator:init(lives)

    self.maxLives = 3
    self.lives = lives

    self.animationDurationMs = 3000
    self.state = STATE.ANIMATING_IN
    
    self.yPosition = 100
    
    self.animators = {}
    self.sprites = {}

    self.hasLifeImage = gfx.image.new("images/ui/hud/lives/lives-indicator")
    self.noLifeImage =  gfx.image.new("images/ui/hud/lives/lives-indicator-gone") 
    
    self.sprites = {}

    self.sprites[1] = gfx.sprite.new(self.hasLifeImage)
    self.sprites[1]:setIgnoresDrawOffset(true)
    self.sprites[1]:moveTo(150, 450)
    self.sprites[1]:setZIndex(120)
    self.sprites[1]:add()

    local oldLives = lives + 1
    local img = self.hasLifeImage
    if (oldLives < 2) then
        img = self.noLifeImage
    end

    self.sprites[2] = gfx.sprite.new(img)
    self.sprites[2]:setIgnoresDrawOffset(true)
    self.sprites[2]:moveTo(200, 450)
    self.sprites[2]:setZIndex(120)
    self.sprites[2]:add()

    local img = self.hasLifeImage
    if (oldLives < 3) then
        img = self.noLifeImage
    end

    self.sprites[3] = gfx.sprite.new(img)
    self.sprites[3]:setIgnoresDrawOffset(true)
    self.sprites[3]:moveTo(250, 450)
    self.sprites[3]:setZIndex(120)
    self.sprites[3]:add()

    -- these animators correspond to the spites above
    self.animators = {}
    self.animators[1] = gfx.animator.new(1500, 0, 1, playdate.easingFunctions.outCubic)
    self.animators[2] = gfx.animator.new(1700, 0, 1, playdate.easingFunctions.outCubic)
    self.animators[3] = gfx.animator.new(2000, 0, 1, playdate.easingFunctions.outCubic)

    self.cycleCounter = 0
    -- how long to display the lives indicators before removing one
    self.preWaitCycles = 50
    -- how long to display the lives indicators before animating out 
    self.postWaitCycles = 20

    self:add()
end

function LivesIndicator:update()
    if (self.state == STATE.ANIMATING_IN) then
        self:_animateIn()
        if (self.animators[3]:ended()) then
            self.state = STATE.WAITING_TO_REMOVE_LIFE
        end
    elseif (self.state == STATE.WAITING_TO_REMOVE_LIFE) then
        self.cycleCounter+=1
        if (self.cycleCounter > self.preWaitCycles) then
            self.cycleCounter = 0
            self.state = STATE.REMOVING_LIFE
            self:_removeLife()
        end
    elseif (self.state == STATE.WAITING_TO_ANIMATE_OUT) then 
        self.cycleCounter+=1
        if (self.cycleCounter > self.postWaitCycles) then
            self.cycleCounter = 0
            self.state = STATE.ANIMATING_OUT
            self.animators[1]:reset()
            self.animators[2]:reset()
            self.animators[3]:reset()
        end
    elseif (self.state == STATE.ANIMATING_OUT) then
        self:_animateOut()
        if (self.animators[3]:ended()) then
            self:remove()
        end
    end
end

function LivesIndicator:_animateIn()
    for i,spr in ipairs(self.sprites) do
        local percent = self.animators[i]:currentValue()
        local offset = (1-percent) * 400
        local newY = 100 + offset
        spr:moveTo(spr.x, newY)
    end
end

function LivesIndicator:_animateOut()
    for i,spr in ipairs(self.sprites) do
        local percent = self.animators[i]:currentValue()
        local offset = (percent * 400)
        local newY = 100 + offset
        spr:moveTo(spr.x, newY)
    end
end

function LivesIndicator:_removeLife()
    local ssa = nil
    -- create the single sprite animation for the life going away to cover this transition
    if (self.lives < 1) then
        self.sprites[1]:setImage(self.noLifeImage)
        ssa = SingleSpriteAnimation("images/ui/hud/lives/livesIndicatorAnim/remove", 500, self.sprites[1].x, self.sprites[1].y, function() self.state= STATE.WAITING_TO_ANIMATE_OUT end)
        ssa:attachTo(self.sprites[1])
    elseif (self.lives < 2) then
        self.sprites[2]:setImage(self.noLifeImage)
        ssa = SingleSpriteAnimation("images/ui/hud/lives/livesIndicatorAnim/remove", 500, self.sprites[2].x, self.sprites[2].y, function() self.state= STATE.WAITING_TO_ANIMATE_OUT end)
        ssa:attachTo(self.sprites[2])
    elseif (self.lives < 3) then 
        self.sprites[3]:setImage(self.noLifeImage)
        ssa =SingleSpriteAnimation("images/ui/hud/lives/livesIndicatorAnim/remove", 500, self.sprites[3].x, self.sprites[3].y, function() self.state= STATE.WAITING_TO_ANIMATE_OUT end)
        ssa:attachTo(self.sprites[3])
    end

    ssa:setIgnoresDrawOffset(true)
    ssa:setZIndex(121)
end

function LivesIndicator:remove()
    self.sprites[1]:remove()
    self.sprites[2]:remove()
    self.sprites[3]:remove()

    LivesIndicator.super.remove(self)
end