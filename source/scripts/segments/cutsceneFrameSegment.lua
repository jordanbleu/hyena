local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/ui/cutsceneFrame"

--[[ shows a cutscene frame.  Returns completed when the frame is dismissed.. ]]
class("CutsceneFrameSegment").extends(Segment)

function CutsceneFrameSegment:init(title, text, imagePath, effect)
    self.cutsceneFrame = CutsceneFrame(title, text, imagePath, effect)
end

function CutsceneFrameSegment:isCompleted()

    if (self.cutsceneFrame == nil or self.cutsceneFrame:isCompleted()) then
        return true
    end
    
    return false
    
end

function CutsceneFrameSegment:cleanup()
    self.cutsceneFrame = nil
end

function CutsceneFrameSegment:append(title, dialogue)
    self.cutsceneFrame:append(title,dialogue)
end