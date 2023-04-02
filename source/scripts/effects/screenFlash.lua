local gfx <const> = playdate.graphics

--[[
    flashes white on the screen.
]]
class("ScreenFlash").extends(gfx.sprite)

-- tweak this for more frames / worse performance (max is 100)
local TRANSITION_QUALITY <const> = 25

function ScreenFlash:init(durationMs, bgColor)

    self.fadedRects = {}
    local fadedImage
    
    self:moveTo(200,120)
    self:setIgnoresDrawOffset(true)

    -- pre-compute all frames for the fade in effect.
    for i=0, TRANSITION_QUALITY, 1 do

        local alpha = (i/TRANSITION_QUALITY)

        fadedImage = gfx.image.new(400,240)

        if (playdate.getReduceFlashing()) then
            bgColor = gfx.kColorBlack
        end

        -- we are now drawing onto the faded image directly
        gfx.pushContext(fadedImage)
            local filledRect = gfx.image.new(400,240, bgColor)
            filledRect:drawFaded(0, 0, alpha, gfx.image.kDitherTypeBurkes)
        gfx.popContext()

        self.fadedRects[i] = fadedImage

    end

    self:setImage(self.fadedRects[#self.fadedRects])
    self.animator = gfx.animator.new(durationMs, 1, 0, playdate.easingFunctions.inCubic)
    self:setZIndex(110)
    self:add()
end

function ScreenFlash:update()

    local currentTimerValue = self.animator:currentValue()
    local frameIndex = math.ceil(TRANSITION_QUALITY * currentTimerValue)
    -- retrieve the cached faded frame based on the progress of the animator
    local currentFrame = self.fadedRects[frameIndex]
    self:setImage(currentFrame)

    if (self.animator:ended()) then
        self:remove()
    end


end

