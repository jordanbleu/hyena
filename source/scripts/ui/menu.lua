local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"

--[[
    Used for any menu that displays on the UI.

    You can only have up to four items.
]]
class("Menu").extends(gfx.sprite)

local STATE = {
    ANIMATING_IN =1,
    SHOWN =2 ,
    ANIMATING_OUT =3,
    DISMISSED =4
}

function Menu:init(item1Text, item2Text, item3Text, item4Text)
    self.items = {}
    self.items[1] = item1Text
    self.items[2] = item2Text
    self.items[3] = item3Text
    self.items[4] = item4Text

    self.itemW = 120
    self.itemH = 26

    self.selectedIndex = 1
    
    self.selectorAnim = SpriteAnimation("images/ui/menu/selectorAnim/selector",1000, 0,0)
    self.selectorAnim:setZIndex(158)
    self.selectorAnim:moveTo(-500,-500)
    self.selectorAnim:setRepeats(-1)

    self.itemImages = {}
    self.itemSprites = {}

    self.itemImages[1] = gfx.image.new(self.itemW,self.itemH)
    self.itemSprites[1] = gfx.sprite.uiSprite(self.itemImages[1],0,0,159)
    self.itemSprites[1]:add()

    if (item2Text) then
        self.itemImages[2] = gfx.image.new(self.itemW,self.itemH)
        self.itemSprites[2] = gfx.sprite.uiSprite(self.itemImages[2],0,0,159)
        self.itemSprites[2]:add()
    end

    if (item3Text) then
        self.itemImages[3] = gfx.image.new(self.itemW,self.itemH)
        self.itemSprites[3] = gfx.sprite.uiSprite(self.itemImages[3],0,0,159)
        self.itemSprites[3]:add()
    end

    if (item4Text) then
        self.itemImages[4] = gfx.image.new(self.itemW,self.itemH)
        self.itemSprites[4] = gfx.sprite.uiSprite(self.itemImages[4],0,0,159)
        self.itemSprites[4]:add()
    end

    self.animationDuration = 2000

    self.state = STATE.ANIMATING_IN

    -- menu is centered on screen
    self.menuPosition = 120

    -- load the menu frame
    local menuFrameImage = gfx.image.new("images/ui/menu/menu-frame")
    
    self.menuFrameSprite = gfx.sprite.uiSprite(menuFrameImage, 200, 500, 150)
    self.menuFrameSprite:add()

    self.itemFont = gfx.font.new("fonts/big-bleu")
    
    self.selectorMoveAnimator = nil

    -- animator for the menu frame (sorta the items too)
    self.animator = gfx.animator.new(self.animationDuration, 500, self.menuPosition, playdate.easingFunctions.inOutElastic)
    
    self.menuSelectorEasingFunction = playdate.easingFunctions.outElastic
    self:add()

    -- an array of callbacks.  The index of the array will be the selectedIndex of the menu (1-4).
    -- If no callback is specified for an index, the menu will simply close and do nothing.
    self.callbacks = {}
    -- what to do if the user goes back.  If this is nil, don't show the prompt to go back,
    -- and don't show the B button prompt
    self.goBackCallback = nil

    -- the callback to invoke once the menu is done animating.
    self.selectedCallback = nil

end

function Menu:update()
    self:_updatePositions()
    self:_drawBaseItemText()

    if (self.state == STATE.ANIMATING_IN) then
        if (self.animator:ended()) then
            self.selectorMoveAnimator = gfx.animator.new(10, self.menuPosition-50, self.menuPosition-50, self.menuSelectorEasingFunction)
            self.state = STATE.SHOWN
        end
    elseif (self.state == STATE.SHOWN) then
        self:_checkForInput()
    elseif (self.state == STATE.ANIMATING_OUT) then
        if (self.animator:ended()) then
            self.state = STATE.DISMISSED
            if (self.selectedCallback) then
                self.selectedCallback()
            end
            self:remove()
        end
        
        
    end

end

function Menu:remove()
    self.menuFrameSprite:remove()
    self.selectorAnim:remove()
    if (self.itemSprites[1]) then self.itemSprites[1]:remove() end
    if (self.itemSprites[2]) then self.itemSprites[2]:remove() end
    if (self.itemSprites[3]) then self.itemSprites[3]:remove() end
    if (self.itemSprites[4]) then self.itemSprites[4]:remove() end
    -- remove items
    Menu.super.remove(self)
end

-- draws the items with white text (no selector)
function Menu:_drawBaseItemText()
    gfx.setFont(self.itemFont)

    if (self.itemSprites[1]) then
        gfx.lockFocus(self.itemImages[1])
            if (self.selectedIndex == 1) then
                gfx.drawTextAligned(self.items[1], self.itemW/2,self.itemH/4, kTextAlignment.center)
            else
                gfx.drawTextAlignedWhite(self.items[1], self.itemW/2,self.itemH/4, kTextAlignment.center)
            end
    end

    if (self.itemSprites[2]) then
        gfx.lockFocus(self.itemImages[2])
            if (self.selectedIndex == 2) then
                gfx.drawTextAligned(self.items[2], self.itemW/2,self.itemH/4, kTextAlignment.center)
            else
                gfx.drawTextAlignedWhite(self.items[2], self.itemW/2,self.itemH/4, kTextAlignment.center)
            end
    end

    if (self.itemSprites[3]) then
        gfx.lockFocus(self.itemImages[3])
            if (self.selectedIndex == 3) then
                gfx.drawTextAligned(self.items[3], self.itemW/2,self.itemH/4, kTextAlignment.center)
            else
                gfx.drawTextAlignedWhite(self.items[3], self.itemW/2,self.itemH/4, kTextAlignment.center)
            end
    end

    if (self.itemSprites[4]) then
        gfx.lockFocus(self.itemImages[4])
            if (self.selectedIndex == 4) then
                gfx.drawTextAligned(self.items[4], self.itemW/2,self.itemH/4, kTextAlignment.center)
            else    
                gfx.drawTextAlignedWhite(self.items[4], self.itemW/2,self.itemH/4, kTextAlignment.center)
            end
    end

    gfx.unlockFocus()

end

function Menu:_updatePositions()
    local animValue = self.animator:currentValue()

    -- menu frame 
    self.menuFrameSprite:moveTo(self.menuFrameSprite.x, animValue)

    -- item texts
    if (self.itemSprites[1]) then self.itemSprites[1]:moveTo(self.menuFrameSprite.x, animValue-50) end
    if (self.itemSprites[2]) then self.itemSprites[2]:moveTo(self.menuFrameSprite.x, animValue-20) end
    if (self.itemSprites[3]) then self.itemSprites[3]:moveTo(self.menuFrameSprite.x, animValue+10) end
    if (self.itemSprites[4]) then self.itemSprites[4]:moveTo(self.menuFrameSprite.x, animValue+40) end

    -- if the animator is nil then lock to the proper position, else follow the animator
    if (self.selectorMoveAnimator == nil) then        
        if (self.selectedIndex == 1) then
            self.selectorAnim:moveTo(self.menuFrameSprite.x, animValue-50)
        elseif (self.selectedIndex == 2) then
            self.selectorAnim:moveTo(self.menuFrameSprite.x, animValue-20)
        elseif (self.selectedIndex == 3) then   
            self.selectorAnim:moveTo(self.menuFrameSprite.x, animValue+10)
        elseif (self.selectedIndex == 4) then
            self.selectorAnim:moveTo(self.menuFrameSprite.x, animValue+40)
        end
    else 
        local itemAnimatorValue = self.selectorMoveAnimator:currentValue()
        self.selectorAnim:moveTo(self.menuFrameSprite.x, itemAnimatorValue)
    end

end

function Menu:_checkForInput()

    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        self.selectedCallback =self.callbacks[self.selectedIndex]
        self.selectorMoveAnimator = nil
        self.state = STATE.ANIMATING_OUT
        self.animator = gfx.animator.new(self.animationDuration/4, self.menuPosition, 500, playdate.easingFunctions.inBack)
    end

    if (playdate.buttonJustPressed(playdate.kButtonB)) then
        if (self.goBackCallback) then
            self.selectedCallback = self.goBackCallback
            self.selectorMoveAnimator = nil
            self.state = STATE.ANIMATING_OUT
            -- goback anim is different
            self.selectorAnim:hide()
            self.animator = gfx.animator.new(250, self.menuPosition, 500, playdate.easingFunctions.outSine)
        end
    end

    local updateSelectedIndex = false 
    if (playdate.buttonJustPressed(playdate.kButtonUp)) then
        updateSelectedIndex = true
        self.selectedIndex-=1
    elseif (playdate.buttonJustPressed(playdate.kButtonDown)) then
        updateSelectedIndex = true
        self.selectedIndex+=1
    end

    if (updateSelectedIndex) then
        local animValue = self.animator:currentValue()

        if (self.selectedIndex < 1) then 
            self.selectedIndex = #self.items
        elseif (self.selectedIndex > #self.items) then
            self.selectedIndex = 1
        end

        if (self.selectedIndex == 1) then
            self.selectorMoveAnimator = gfx.animator.new(200, self.selectorAnim.y, animValue-50, self.menuSelectorEasingFunction)
        elseif (self.selectedIndex == 2) then
            self.selectorMoveAnimator = gfx.animator.new(200, self.selectorAnim.y, animValue-20, self.menuSelectorEasingFunction)
        elseif (self.selectedIndex == 3) then   
            self.selectorMoveAnimator = gfx.animator.new(200, self.selectorAnim.y, animValue+10, self.menuSelectorEasingFunction)
        elseif (self.selectedIndex == 4) then
            self.selectorMoveAnimator = gfx.animator.new(200, self.selectorAnim.y, animValue+40, self.menuSelectorEasingFunction)
        end
        
    end

end

function Menu:setCallbackForItemIndex(index, callbackFn)
    self.callbacks[index] = callbackFn
end

function Menu:setCallbackForGoBack(callbackFn) 
    self.goBackCallback = callbackFn
end
