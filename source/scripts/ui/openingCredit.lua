local gfx <const> = playdate.graphics


--[[ 
    Animates opening credit on and off, and removes itself automatically.
]]
class("OpeningCredit").extends(gfx.sprite)


local STATE = {
    ANIMATING_IN = 1,
    WAITING = 2,
    ANIMATING_OUT = 3
}

function OpeningCredit:init(imageTablePath)
    self.state = STATE.ANIMATING_IN

    self.imageTablePath = imageTablePath
    -- Animator for the position of the sprite
    self.animator = gfx.animator.new(750, 120, 100, playdate.easingFunctions.inBack)

    -- the opening credit fade in animator itself (will animate forwards, then backwards)
    self.sprite = SpriteAnimation(imageTablePath, 1000, 200, 120)
    self.sprite:setIgnoresDrawOffset(true)
    self.sprite:setZIndex(100)
    self.sprite:setAnimationCompletedCallback(function() self:_animCompleted() end)
    self.sprite:setRemoveOnComplete(false)

    self.cycleCounter = 0
    self.waitCycles = 150

    self.onCompleted = nil
    self:add()
end

function OpeningCredit:update()

    self.sprite:moveTo(self.sprite.x, self.animator:currentValue())

    if (self.state== STATE.WAITING) then
        self.cycleCounter+=1

        if (self.cycleCounter > self.waitCycles) then
            self.animator = gfx.animator.new(2000, self.sprite.y, 120, playdate.easingFunctions.inBack)

            self.sprite:remove()
            self.sprite = SpriteAnimation(self.imageTablePath, 500, 200, 120, true)
            self.sprite:setIgnoresDrawOffset(true)
            self.sprite:setZIndex(999)
            self.sprite:setAnimationCompletedCallback(function() self:_animCompleted() end)
            self.sprite:setRemoveOnComplete(false)
            self.state = STATE.ANIMATING_OUT
        end

    end

end

-- called whenever the animator completes
function OpeningCredit:_animCompleted()

    if (self.state == STATE.ANIMATING_IN) then
        self.sprite:setFrame(15)
        self.sprite:pause()
        self.state = STATE.WAITING
    elseif (self.state == STATE.ANIMATING_OUT) then
        self.sprite:remove()
        if (self.onCompleted ~= nil) then
            self.onCompleted()
        end
        self:remove()
    end 
end

function OpeningCredit:setOnCompleted(fn)
    self.onCompleted = fn
end