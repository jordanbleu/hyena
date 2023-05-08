local gfx <const> = playdate.graphics

--[[
    flashes white on the screen.
]]
class("ScreenFlash").extends(gfx.sprite)


function ScreenFlash:init(durationMs, bgColor)

    self.fadedRects = {}
    local fadedImage
    
    self:moveTo(200,120)
    self:setIgnoresDrawOffset(true)

    self.fadedRects = {}

    if (bgColor == playdate.kColorBlack or playdate.getReduceFlashing()) then
        self.fadedRects = SCREEN_EFFECT_CACHE.Black
    else 
        self.fadedRects = SCREEN_EFFECT_CACHE.White
    end


    self:setImage(self.fadedRects[#self.fadedRects])
    self.animator = gfx.animator.new(durationMs, 1, 0, playdate.easingFunctions.inCubic)
    self:setZIndex(110)
    self:add()
end

function ScreenFlash:update()

    local currentTimerValue = self.animator:currentValue()
    local frameIndex = math.ceil(GLOBAL_TRANSITION_QUALITY * currentTimerValue)
    -- retrieve the cached faded frame based on the progress of the animator
    local currentFrame = self.fadedRects[frameIndex]
    self:setImage(currentFrame)

    if (self.animator:ended()) then
        self:remove()
    end


end

