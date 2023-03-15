local gfx <const> = playdate.graphics

import "scripts/scenes/base/scene"

class("SegmentedScene").extends(Scene)

function SegmentedScene:init()
    SegmentedScene.super.init(self)
end

function SegmentedScene:initialize(segments, sceneManager)
    -- segments is actually a list of functions that create the segment and return it
    self.segments = segments
    self.segmentIndex = 1
    local func = self.segments[1]
    self.activeSegment = func()

    self.sceneWasCompleted = false

    SegmentedScene.super.initialize(self, sceneManager)
end

function SegmentedScene:update()
    SegmentedScene.super.update()

    if (self.sceneWasCompleted) then 
        return
    end
    
    if (self.activeSegment:isCompleted()) then
        self.activeSegment:cleanup()
        self.segmentIndex+=1

        if (self.segmentIndex > #self.segments) then
            self.sceneWasCompleted = true
            self:completeScene()
        else
            self.activeSegment = self.segments[self.segmentIndex]()
        end
    end

end

---Called when there are no more segemnts to run.  This should only be called once!
function SegmentedScene:completeScene()
end