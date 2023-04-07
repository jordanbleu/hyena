local gfx <const> = playdate.graphics

import "scripts/scenes/base/segmentedScene"
--[[
    Intro cutscene
    Cyber is in prison and he gets his mission. Shit gets real mysterious.
]]


class("Scene0010").extends(SegmentedScene)

function Scene0010:initialize(sceneManager)
    local segments = {}

    -- table.insert(segments, function()
    --     return WaitSegment(3000, "images/black")
    -- end)

    -- table.insert(segments, function()
    --     return CutsceneFrameSegment("", gfx.getString("scene0010.planet"), "images/cutscene/scene0010/planet")
    -- end)

    -- table.insert(segments, function()
    --     return CutsceneFrameSegment("", gfx.getString("scene0010.prison"), "images/cutscene/scene0010/prison")
    -- end)

    -- table.insert(segments, function()
    --     return CutsceneFrameSegment("", gfx.getString("scene0010.hallway"), "images/cutscene/scene0010/hallway", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP, false)
    -- end)

    -- the guard is now talking 
    table.insert(segments, function()
        return CutsceneFrameSegment(gfx.getString("character.guard"), gfx.getString("scene0010.hallway1"), "images/cutscene/scene0010/hallway", CUTSCENE_FRAME_EFFECT.STATIC, false)
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(gfx.getString("character.guard"), gfx.getString("scene0010.hallway2"), "images/cutscene/scene0010/hallway", CUTSCENE_FRAME_EFFECT.STATIC, false)
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(gfx.getString("character.guard"), gfx.getString("scene0010.hallway3"), "images/cutscene/scene0010/hallway", CUTSCENE_FRAME_EFFECT.STATIC, false)
    end)


    Scene0010.super.initialize(self, segments, sceneManager)
end