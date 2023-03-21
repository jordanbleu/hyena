local gfx <const> = playdate.graphics

import "scripts/ui/typer"

--[[ 
    A custcene frame will display an image that is either static or slowly pans. 

    At the bottom of the screen will be a typer object, no avatars though.
]]
class("CutsceneFrame").extends(gfx.sprite)


function CutsceneFrame:init(title, text, imagePath, effect)

    self.effect = effect or CUTSCENE_FRAME_EFFECT.STATIC

    -- todo: for some reason the sprite isn't showing 
    self.image = gfx.image.new(imagePath)
    self.sprite = gfx.sprite.new(image)
    self.sprite:setZIndex(50)

    
    -- set the sprite's starting position based on chosen effect
    -- todo: for now just leave it at the center 
    self:moveTo(200,120)


    self.sprite:add()

    -- this doesn't need to be loaded for each instance
    -- the sprite for the dialogue text frame
    self.dialogueFrame = gfx.sprite.new(gfx.image.new("images/ui/dialogue/cutscene-dialogue-frame"))
    self.dialogueFrame:setZIndex(109)
    self.dialogueFrame:moveTo(200, 200)
    self.dialogueFrame:add()

    self.isComplete = false

    self.typer = Typer(215,220,text, 3, 42)

    self:add()
end

function CutsceneFrame:update()

    -- todo: this will be more robust once we add in the effects

    if (self.typer:isDismissed()) then
        self.isComplete = true
        self:remove()
    end




end

function CutsceneFrame:remove()

    self.dialogueFrame:remove()
    self.sprite:remove()
    self.typer:remove()

    CutsceneFrame.super.remove(self)
end

function CutsceneFrame:isCompleted()
    return self.isComplete
end