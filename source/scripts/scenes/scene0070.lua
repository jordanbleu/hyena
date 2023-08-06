local gfx <const> = playdate.graphics

import "scripts/scenes/base/segmentedScene"
import "scripts/scenes/scene0020"
import "scripts/helpers/sceneHelper"

--[[
    This is the first cutscene explaining how cyber got into his position
]]
class("Scene0070").extends(SegmentedScene)

function Scene0070:initialize(sceneManager)
    local segments = {}
    self.sceneManager = sceneManager

    local nobody = ""
    local guard = gfx.getString("character.guard")
    local mystery = gfx.getString("character.?")
    local man = gfx.getString("character.man")
    local cyber = gfx.getString("character.cyber")

    table.insert(segments, function()
        return WaitSegment(3000, "images/black")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0070.planet"), "images/cutscene/scene0070/planet")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0070.prison"), "images/cutscene/scene0070/prison")
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(nobody, gfx.getString("scene0070.hallway"), "images/cutscene/scene0070/hallway", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
    end)

    -- the guard is now talking 
    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0070.hallway1"), "images/cutscene/scene0070/guard")
        c:append(guard, gfx.getString("scene0070.hallway2"))
        c:append(guard, gfx.getString("scene0070.hallway3"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0070.cell"), "images/cutscene/scene0070/cell", CUTSCENE_FRAME_EFFECT.PAN_LEFT_RIGHT)
        c:append(guard, gfx.getString("scene0070.cell1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(guard, gfx.getString("scene0070.grabcyber"), "images/cutscene/scene0070/grab-cyber", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
        c:append(guard, gfx.getString("scene0070.grabcyber1"))
        c:append(guard, gfx.getString("scene0070.grabcyber2"))

        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(mystery, gfx.getString("scene0070.legs"), "images/cutscene/scene0070/legs")
        c:append(guard, gfx.getString("scene0070.legs1"))
        c:append(mystery, gfx.getString("scene0070.legs2"))
        c:append(guard, gfx.getString("scene0070.legs3"))

        return c
    end)

    table.insert(segments, function()
        return CutsceneFrameSegment(guard, gfx.getString("scene0070.zap"), "images/cutscene/scene0070/kill-guard", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0070.topdown"), "images/cutscene/scene0070/topdown")
        c:append(man, gfx.getString("scene0070.topdown1"))
        c:append(man, gfx.getString("scene0070.topdown2"))
        c:append(man, gfx.getString("scene0070.topdown3"))
        return c
    end)


    table.insert(segments, function()
        return WaitSegment(6000, "images/black")
    end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.cybersit"), "images/cutscene/scene0070/cyber-sit", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
    --     c:append(cyber, gfx.getString("scene0070.cybersit1"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.pour"), "images/cutscene/scene0070/pour")
    --     c:append(man, gfx.getString("scene0070.pour1"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.chug"), "images/cutscene/scene0070/chug")
    --     c:append(man, gfx.getString("scene0070.chug1"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.slam-drink"), "images/cutscene/scene0070/slamdrink", CUTSCENE_FRAME_EFFECT.SINGLE_SHAKE)
    --     c:append(man, gfx.getString("scene0070.slam-drink1"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.man-desk"), "images/cutscene/scene0070/man-desk", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
    --     c:append(man, gfx.getString("scene0070.man-desk1"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(cyber, gfx.getString("scene0070.cybersit3"), "images/cutscene/scene0070/cyber-sit-static")
    --     c:append(man, gfx.getString("scene0070.cybersit4"))
    --     c:append(cyber, gfx.getString("scene0070.cybersit5"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     local c = CutsceneFrameSegment(man, gfx.getString("scene0070.man-desk-cropped"), "images/cutscene/scene0070/man-desk-cropped")
    --     c:append(cyber, gfx.getString("scene0070.man-desk-cropped1"))
    --     c:append(cyber, gfx.getString("scene0070.man-desk-cropped2"))
    --     c:append(cyber, gfx.getString("scene0070.man-desk-cropped3"))
    --     c:append(man, gfx.getString("scene0070.man-desk-cropped4"))
    --     c:append(man, gfx.getString("scene0070.man-desk-cropped5"))
    --     return c
    -- end)

    -- table.insert(segments, function()
    --     return CutsceneFrameSegment(man, gfx.getString("scene0070.cybersit6"), "images/cutscene/scene0070/cyber-sit")
    -- end)

    table.insert(segments, function()
        return WaitSegment(3000, "images/black")
    end)

    Scene0070.super.initialize(self, segments, sceneManager)
end

function Scene0070:completeScene()
    self.sceneManager:switchScene(Scene0020(), SCENE_TRANSITION.FADE_IO)
end



