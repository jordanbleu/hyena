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
    local mystery = gfx.getString("character.?")
    local man = gfx.getString("character.man")
    local cyber = gfx.getString("character.cyber")

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
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0010.cell"), "images/cutscene/scene0010/cell", CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT)
        c:append(guard, gfx.getString("scene0010.cell1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0010.grabcyber"), "images/cutscene/scene0010/grab-cyber", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
        c:append(guard, gfx.getString("scene0010.grabcyber1"))
        c:append(guard, gfx.getString("scene0010.grabcyber2"))

        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(mystery, gfx.getString("scene0010.legs"), "images/cutscene/scene0010/legs")
        c:append(guard, gfx.getString("scene0010.legs1"))
        c:append(mystery, gfx.getString("scene0010.legs2"))
        c:append(guard, gfx.getString("scene0010.legs3"))

        return c
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0010.zap"), "images/cutscene/scene0010/kill-guard", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.topdown"), "images/cutscene/scene0010/topdown")
        c:append(guard, gfx.getString("scene0010.topdown1"))
        c:append(guard, gfx.getString("scene0010.topdown2"))
        c:append(guard, gfx.getString("scene0010.topdown3"))
        return c
    end)


    table.insert(segments, function()
        return WaitSegment(3000, "images/black")
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.cybersit"), "images/cutscene/scene0010/cyber-sit", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
        c:append(cyber, gfx.getString("scene0010.cybersit1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.pour"), "images/cutscene/scene0010/pour")
        c:append(man, gfx.getString("scene0010.pour1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.chug"), "images/cutscene/scene0010/chug")
        c:append(man, gfx.getString("scene0010.chug1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.slam-drink"), "images/cutscene/scene0010/slamdrink", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
        c:append(man, gfx.getString("scene0010.slam-drink1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.man-desk"), "images/cutscene/scene0010/man-desk", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
        c:append(man, gfx.getString("scene0010.man-desk1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(cyber, gfx.getString("scene0010.cybersit3"), "images/cutscene/scene0010/cyber-sit-static")
        c:append(man, gfx.getString("scene0010.cybersit4"))
        c:append(cyber, gfx.getString("scene0010.cybersit5"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0010.man-desk-cropped"), "images/cutscene/scene0010/man-desk-cropped")
        c:append(cyber, gfx.getString("scene0010.man-desk-cropped1"))
        c:append(cyber, gfx.getString("scene0010.man-desk-cropped2"))
        c:append(cyber, gfx.getString("scene0010.man-desk-cropped3"))
        c:append(man, gfx.getString("scene0010.man-desk-cropped4"))
        c:append(man, gfx.getString("scene0010.man-desk-cropped5"))
        return c
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(man, gfx.getString("scene0010.cybersit6"), "images/cutscene/scene0010/cyber-sit")
    end)

    table.insert(segments, function()
        return WaitSegment(3000, "images/black")
    end)

    Scene0010.super.initialize(self, segments, sceneManager)
end

