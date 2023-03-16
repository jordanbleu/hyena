local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/actors/enemy"

--[[ A group of enemies will be spawned, and the segment will be completed once they are all dead. ]]
class("HordeSegment").extends(Segment)

function HordeSegment:init(enemies)
    print ("Enter HordeSegment.")
    self.enemies = enemies
end

function HordeSegment:isCompleted()

    -- if any enemies are alive, then the segments isn't completed yet.
    if (self.enemies) then
        for i,enemy in ipairs(self.enemies) do
            if (enemy and enemy:getHealth() > 0) then
                return false
            end
        end
    end

    return true
end

function HordeSegment:cleanup()
    self.enemies = nil
end