local gfx <const> = playdate.graphics

import "scripts/scenes/base/segmentedScene"
--[[
    Intro cutscene
    Cyber is in prison and he gets his mission. Shit gets real mysterious.
]]


class("Scene0010").extends(SegmentedScene)

function Scene0010:initialize(sceneManager)
    local segments = {}

    table.insert(segments, function()
        return WaitSegment(3000, "images/black")
    end)

    local nobody = ""
    local guard = gfx.getString("character.guard")

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0010.planet"), "images/cutscene/scene0010/planet")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0010.prison"), "images/cutscene/scene0010/prison")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0010.hallway"), "images/cutscene/scene0010/hallway", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
    end)

    -- the guard is now talking 
    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0010.hallway1"), "images/cutscene/scene0010/guard")
        c:append(guard, gfx.getString("scene0010.hallway2"))
        c:append(guard, gfx.getString("scene0010.hallway3"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0010.grabcyber"), "images/cutscene/scene0010/cell", CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT)
        c:append(guard, gfx.getString("scene0010.cell1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0010.grabcyber1"), "images/cutscene/scene0010/grab-cyber", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
        c:append(guard, gfx.getString("scene0010.grabcyber"))
        c:append(guard, gfx.getString("scene0010.grabcyber1"))
        return c
    end)



    Scene0010.super.initialize(self, segments, sceneManager)
end