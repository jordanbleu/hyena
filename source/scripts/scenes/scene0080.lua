local gfx <const> = playdate.graphics

import "scripts/scenes/scene0070"


--[[
    Cutscene - Cyber learns more about Grimideans
]]
class("Scene0080").extends(SegmentedScene)

function Scene0080:initialize(sceneManager)

    local man = gfx.getString("character.man")
    local cyber = gfx.getString("character.cyber")

    sceneHelper.addBlackBackground()

    local segments = {}

    table.insert(segments, function()
        local c = CutsceneFrameSegment("", gfx.getString("scene0080.earlier"), "images/black")
        c:append("", gfx.getString("scene0080.earlier1"))
        return c
    end)

    table.insert(segments, function()
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.viewship"), "images/cutscene/scene0080/look-at-ship-middle", CUTSCENE_FRAME_EFFECT.PAN_UP_DOWN)
        c:append(man, gfx.getString("scene0080.viewship1"))
        c:append(man, gfx.getString("scene0080.viewship2"))
        return c
    end)

    table.insert(segments, function()
        -- beaufiful, isn't she?
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.viewship3"), "images/cutscene/scene0080/look-at-ship-bottom", CUTSCENE_FRAME_EFFECT.PAN_UP_DOWN)
        c:append(man, gfx.getString("scene0080.viewship4"))
        c:append(man, gfx.getString("scene0080.viewship5"))
        c:append(man, gfx.getString("scene0080.viewship6"))
        c:append(man, gfx.getString("scene0080.viewship7"))
        c:append(man, gfx.getString("scene0080.viewship8"))
        c:append(cyber, gfx.getString("scene0080.viewship9"))
        return c
    end)

    table.insert(segments, function()
        -- the war has left us weak
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.faces"), "images/cutscene/scene0080/talk-to-each-other")
        c:append(man, gfx.getString("scene0080.faces1"))
        c:append(man, gfx.getString("scene0080.faces2"))
        c:append(cyber, gfx.getString("scene0080.faces3"))
        c:append(man, gfx.getString("scene0080.faces4"))
        c:append(cyber, gfx.getString("scene0080.faces5"))
        return c
    end)

    table.insert(segments, function()
        -- if they talk to u, they can't know you're with us
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.ship"), "images/cutscene/scene0080/look-at-ship-middle", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
        c:append(man, gfx.getString("scene0080.ship1"))
        c:append(man, gfx.getString("scene0080.ship2"))
        c:append(man, gfx.getString("scene0080.ship4"))
        return c
    end)

    table.insert(segments, function()
        -- if they talk to u, they can't know you're with us
        local c = CutsceneFrameSegment(cyber, gfx.getString("scene0080.ship5"), "images/cutscene/scene0080/talk-to-each-other", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
        c:append(man, gfx.getString("scene0080.ship6"))
        c:append(cyber, gfx.getString("scene0080.ship7"))
        c:append(cyber, gfx.getString("scene0080.ship8"))

        return c
    end)

    table.insert(segments, function()
        -- the war has left us weak
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.climbin"), "images/cutscene/scene0080/climb", CUTSCENE_FRAME_EFFECT.PAN_DOWN_UP)
        c:append(man, gfx.getString("scene0080.climbin1"))
        return c
    end)

    table.insert(segments, function()
        -- the war has left us weak
        local c = CutsceneFrameSegment(man, gfx.getString("scene0080.cockpit1"), "images/cutscene/scene0080/cyber-cockpit", CUTSCENE_FRAME_EFFECT.CONSTANT_SHAKING)
        c:append(man, gfx.getString("scene0080.cockpit2"))
        c:append(man, gfx.getString("scene0080.cockpit3"))
        c:append(man, gfx.getString("scene0080.cockpit4"))
        c:append(cyber, gfx.getString("scene0080.cockpit5"))
        return c
    end)

    Scene0080.super.initialize(self, segments, sceneManager)

end


function Scene0080:completeScene()
    self.sceneManager:switchScene(Scene0090(), SCENE_TRANSITION.FADE_IO)
end