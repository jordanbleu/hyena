local gfx <const> = playdate.graphics


--[[ Takes whatever text you tell it to write and types it out letter by letter.  
    Also listens for key presses so user can acknowledge text. 

    Note that this object doesn't have any of the image frame type stuff or other UI 
    so it shouldn't be used on its own.
]]
class("Typer").extends(gfx.sprite)

function Typer:init(x, y, text, maxLines, charsPerLine)

    --< Typing Mechanism >-------------   

    -- how many lines the dialogue can be 
    self.maxLines = maxLines or 3
    self.charsPerLine = charsPerLine or 26

    -- the full text that we are typing.  Only used for debugging really.
    self.fullText = text
    -- the text broken up into an array of lines (with word wrap applied)
    self.fullTextLines = string.wordWrap(text, self.charsPerLine, self.maxLines)
    -- how many characters have been typed on each line
    self.typedChars = {}
    for i in ipairs(self.fullTextLines) do
        self.typedChars[i]=0
    end

    -- which line are we currently typing on 
    self.currentLine = 1

    -- the length of each string 
    self.fullTextLengths = {}
    for i,str in ipairs(self.fullTextLines) do
        self.fullTextLengths[i] = string.len(str)
    end

    self.finishedTyping = false

    self.delayCycleCounter = 0
    -- change this for faster text speed 
    self.delayCycles = 5

    -- if true, the user has acknowledged the text and is ready to move on 
    self.acknowledged = false

    self.textFont = gfx.font.new("fonts/test")
    self.textImage = gfx.image.new(400,120)
    self.textSprite = gfx.sprite.new(self.textImage)
    self.textSprite:moveTo(x,y)
    self.textSprite:setZIndex(110)
    self.textSprite:setIgnoresDrawOffset(true)
    self.textSprite:add()

    -- tweak this for spacing in between text lines (in px)
    self.lineSpacing = 18 

    -- self sprite stuff 
    self:moveTo(x,y)
    self:setZIndex(110)
    self:add()
end

function Typer:update()

    self:_updateText()
    self:_checkInput()
    self:_drawText()
end

function Typer:_updateText()
    -- we are done typing all the lines 
    if (self.currentLine > #self.fullTextLines) then
        self.finishedTyping = true
        return
    end

    if (self.delayCycleCounter == self.delayCycles) then
        
        local currentLineLength = self.fullTextLengths[self.currentLine]

        if (self.typedChars[self.currentLine] == currentLineLength) then
            self.currentLine += 1
        else 
            self.typedChars[self.currentLine] += 1
        end

        self.delayCycleCounter = 0
    else 
        self.delayCycleCounter += 1
    end
end

function Typer:_checkInput()
    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        if (not self.finishedTyping) then
            -- set each typed char index to the length of that line
            for i in ipairs(self.typedChars) do
                self.typedChars[i] = self.fullTextLengths[i]
            end
            -- set current line past the last line, so that we are done typing
            self.currentLine = #self.fullTextLines + 1
        else 
            self.acknowledged = true
        end
    end
end

function Typer:_drawText()

    
    gfx.pushContext(self.textImage)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorBlack)
        gfx.setFont(self.textFont)

        for i,txt in ipairs(self.fullTextLines) do
            local yOffset = self.lineSpacing * i
            local typedIndex = self.typedChars[i]
            gfx.drawText(string.sub(txt, 1, typedIndex), 0, yOffset)
        end

    gfx.popContext()


end

function Typer:remove()
    self.textSprite:remove()
    Typer.super.remove(self)
end

function Typer:isDismissed()
    return self.acknowledged
end
