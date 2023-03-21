import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/sprites/parallaxLayer"

import "scripts/actors/grunt"
import "scripts/actors/rangedGrunt"
import "scripts/actors/tinyGuy"

import "scripts/actors/deathStar"
import "scripts/actors/diveBomb"
import "scripts/actors/shieldRangedGrunt"

import "scripts/segments/hordeSegment"
import "scripts/segments/waitSegment"
import "scripts/segments/dialogueSegment"
import "scripts/segments/cutsceneFrameSegment"
import "scripts/scenes/base/segmentedScene"
import "scripts/scenes/test2Scene"

import "scripts/ui/hud"
import "scripts/ui/weaponSelector"

local gfx <const> = playdate.graphics

class("CutsceneDemo").extends(SegmentedScene)

function CutsceneDemo:init()
    CutsceneDemo.super.init(self)
    self.sceneManager = nil
end

function CutsceneDemo:initialize(sceneManager)
    self.sceneManager = sceneManager

    local segments = {}

    table.insert(segments, function()
        return CutsceneFrameSegment("title", "this is a text hello there i love you i also love salad because salad is so damn delicious omg this is a lot of text.", "images/cutscene/badCutscene2")
    end)


    CutsceneDemo.super.initialize(self, segments, sceneManager)


end