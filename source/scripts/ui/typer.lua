local gfx <const> = playdate.graphics


--[[ Takes whatever text you tell it to write and types it out letter by letter.  
    Also listens for key presses so user can acknowledge text. 

    Note that this object doesn't have any of the image frame type stuff or other UI 
    so it shouldn't be used on its own.
]]
class("Typer").extends(gfx.sprite)

function Typer:init(x, y, text)

    --< Typing Mechanism >-------------   

    -- the full text that we are typing 
    self.text = text
    -- the text that is currently displayed on the typer 
    self.displayText = ""

    -- which character index we are typing
    self.charIndex = 0
    self.textLength = string.len(text)
    
    -- how long to wait before typing a character
    self.delayCycles = 3
    self.delayCycleCounter = 0

    -- if true, the user has acknowledged the text and is ready to move on 
    self.isDismissed = false

    self.textImage = gfx.image.new(400,60)
    self.textSprite = gfx.sprite.new(self.textImage)
    self.textSprite:moveTo(x,y)
    self.textSprite:add()

    -- self sprite stuff 
    self:moveTo(x,y)
    self:setZIndex(109)
    self:add()
end

function Typer:update()

    self:_updateText()
    self:_checkInput()
    self:_drawText()
end

function Typer:_updateText()
    if (self.delayCycleCounter == self.delayCycles) then
        
        -- if there's no more text to type then we do nothing.
        if (self.charIndex == self.textLength) then 
            return
        end
    
        self.charIndex += 1
    
        self.displayText = string.sub(self.text, 1, self.charIndex)        
        self.delayCycleCounter = 0
    else 
        self.delayCycleCounter += 1
    end
end

function Typer:_checkInput()
    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        if (self.charIndex < self.textLength) then
            self.charIndex = self.textLength
            self.delayCycleCounter = self.delayCycles
            self.displayText = string.sub(self.text, 1, self.charIndex)        
        else 
            self.isDismissed = true
        end
    end
end

function Typer:_drawText()
    -- todo: fonts
    -- todo: word wrap :(

    gfx.pushContext(self.textImage)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawText(self.displayText, 0,0)
    gfx.popContext()


end

function Typer:remove()
    self.textSprite:remove()
    Typer.super.remove(self)
end