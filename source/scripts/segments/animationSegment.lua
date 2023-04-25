local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/ui/cutsceneFrame"


class("AnimationSegment").extends(Segment)

---Awaits completion of the passed in animations.  Animations should inherit from the 'animationDirector' object.
---@param animations table array of animations to wait for 
function AnimationSegment:init(animations)
    self.animations = animations
end

function AnimationSegment:isCompleted()

    for i,anim in ipairs(self.animations) do
        if (not anim:isCompleted()) then
            return false
        end
    end

    return true 
end

function AnimationSegment:cleanup()

end
