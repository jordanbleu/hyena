local gfx <const> = playdate.graphics



class("PressButtonToBegin").extends(gfx.sprite)

function PressButtonToBegin:init(callbackFn)

    self.callback = callbackFn
    self.finalPosition = 215
    self.animator = gfx.animator.new(2000, 280, self.finalPosition, playdate.easingFunctions.outQuint)

    self.blinker = gfx.animation.blinker.new(1000,250, true)
    self.blinker:stop()

    self.textImage = gfx.image.new(400,32)
    self:setIgnoresDrawOffset(true)
    self:setImage(self.textImage)
    self:setZIndex(115)

    local font = gfx.font.new("fonts/big-bleu")

    gfx.pushContext(self.textImage)
        gfx.setFont(font)
        gfx.drawTextAligned(gfx.getString("mainmenu.pressbuttontobegin"), 200, 16, kTextAlignment.center)
    gfx.popContext()

    self.animatorCompleted = false

    self.dismissed = false
    self:moveTo(200,0)
    self:add()
end

function PressButtonToBegin:update()
    self:_updateBlinker()
    self:_updatePosition()
    self:_waitForButtonPress()

    if (self.dismissed and self.animator:ended()) then
        self:remove()
    end

end

function PressButtonToBegin:_updatePosition()
    local animatorValue = self.animator:currentValue()
    self:moveTo(self.x, animatorValue)
    if (not self.animatorCompleted and self.animator:ended()) then
        self.blinker:start()
        self.animatorCompleted = true
    end
end

function PressButtonToBegin:_updateBlinker()
    if (self.blinker.on) then
        self:setVisible(true)
    else
        self:setVisible(false)
    end
end

function PressButtonToBegin:_waitForButtonPress()
    if (self.dismissed) then
        return
    end

    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        self.blinker:stop()
        self:setVisible(true)
        self.animator = gfx.animator.new(250, self.finalPosition-5, 280, playdate.easingFunctions.inBack)
        self.dismissed = true
        self.callback()
    end
end