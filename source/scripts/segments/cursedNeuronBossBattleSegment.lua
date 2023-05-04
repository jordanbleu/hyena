local gfx <const> = playdate.graphics

import "scripts/segments/segment"
import "scripts/ui/cutsceneFrame"


class("CursedNeuronBossBattleSegment").extends(Segment)

function CursedNeuronBossBattleSegment:init(bossInst)
    self.boss = bossInst
end

function CursedNeuronBossBattleSegment:isCompleted()
    return not self.boss:isAlive()
end

function CursedNeuronBossBattleSegment:cleanup()

end
