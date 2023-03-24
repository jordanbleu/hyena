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
        return CutsceneFrameSegment("title3", gfx.getString("troy1"), "images/cutscene/troy1")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment("title3", gfx.getString("troy2"), "images/cutscene/troy2", CUTSCENE_FRAME_EFFECT.PAN_UP_DOWN)
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment("title3", gfx.getString("troy3"), "images/cutscene/troy3", CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT)
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment("title3", gfx.getString("troy4"), "images/cutscene/troy4")
    end)

    CutsceneDemo.super.initialize(self, segments, sceneManager)


end