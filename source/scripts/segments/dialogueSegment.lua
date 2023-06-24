local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/actors/enemy"

--[[ a bunch of dialogue will be shown during gameplay, and the segment will be completed once it has all been dismissed. ]]
class("DialogueSegment").extends(Segment)

function DialogueSegment:init(dialogueCsv, playerInst, cameraInst)
    self.dialogue = GameplayDialogue(dialogueCsv, playerInst, cameraInst)
end

function DialogueSegment:isCompleted()

    if (self.dialogue == nil or self.dialogue:isCompleted()) then
        return true
    end
    
    return false 
    
end

function DialogueSegment:cleanup()
    self.dialogue = nil
end