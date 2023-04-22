local gfx <const> = playdate.graphics

--[[ 
    Passthrough segment that is completed right after it is created.  

    Used for situations where everything is done in a single frame and 
    no completion criteria is required.
    
]]
class("DoNothingSegment").extends(Segment)

function DoNothingSegment:init(dialogueCsv, playerInst)
end

function DoNothingSegment:isCompleted()
    return true    
end

function DoNothingSegment:cleanup()
end