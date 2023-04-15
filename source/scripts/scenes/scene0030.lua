local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
--[[
    First gameplay scene.

    Player learns the basics, no bosses in this scene.  Lots of dialogue.
]]
class("Scene0030").extends(SegmentedScene)


function Scene0030:initialize(sceneManager)

    ScreenFlash(1000, gfx.kColorWhite)
    sceneHelper.addBlackBackground()
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
    plax2:setZIndex(2)

    local sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local player = sceneItems.player
    local camera = sceneItems.camera
    player:moveTo(200,200)

    local segments = {}

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0030/cyberMonologue.txt", player)
    end)

    table.insert(segments, function()
        Tutorial(gfx.getString("tutorial.move"))
        return WaitSegment(8000)
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0030/cyberMonologue1.txt", player)
    end)
    
    table.insert(segments, function()
        Tutorial(gfx.getString("tutorial.shoot"))
        local enemies = {}
        table.insert(enemies, Grunt(200,-10, camera, player))
        table.insert(enemies, Grunt(100,-20, camera, player))
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(2000)
    end)

    table.insert(segments, function()
        Tutorial(gfx.getString("tutorial.dash"))
        local enemies = {}
        table.insert(enemies, Grunt(300,-50, camera, player))
        table.insert(enemies, Grunt(120,-10, camera, player))
        table.insert(enemies, Grunt(50,-30, camera, player))
        table.insert(enemies, DiveBomb(100, -20, camera, player))
        table.insert(enemies, DiveBomb(30, -30, camera, player))
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(1000)
    end)


    table.insert(segments, function()
        return DialogueSegment("scene0030/introductions.txt", player)
    end)



    Scene0030.super.initialize(self, segments, sceneManager)

end