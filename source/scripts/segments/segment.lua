local gfx <const> = playdate.graphics

import "CoreLibs/object"

--[[ A segment is a small section of gameplay within a scene.  Note, this object does not extend 'sprite' for 
easier memory management. ]]
class("Segment").extends(Object)

---Run this once per frame.  Return true if the segment is completed, or true if it is done. 
function Segment:isCompleted()
end

---Run when the segment is done and the scene is ready to move on.
function Segment:cleanup()
end