local gfx <const> = playdate.graphics

--[[ Custom one-off segments where the criteria for completion is specified in the scene itself. ]]
class("CustomSegment").extends(Segment)

function CustomSegment:init(isCompleteFn)
    self.isCompleteFn = isCompleteFn
end

---Run this once per frame.  Return true if the segment is completed, or true if it is done. 
function CustomSegment:isCompleted()
    return self.isCompleteFn ~= nil and self.isCompleteFn()
end


