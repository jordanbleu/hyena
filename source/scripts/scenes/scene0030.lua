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

    
    table.insert(segments, function()

        -- First wave flies from left to right
        local guy1 = TinyGuy(200,-10,nil, camera, player)
        local guy2 = TinyGuy(200,-10,guy1, camera, player)
        local guy3 = TinyGuy(200,-10,guy2, camera, player)
        local guy4 = TinyGuy(200,-40,guy3, camera, player)
        local guy5 = TinyGuy(200,-50,guy4, camera, player)
        local guy6 = TinyGuy(200,-60,guy5, camera, player)
        local guy7 = TinyGuy(200,-70,guy6, camera, player)
        local guy8 = TinyGuy(200,-80,guy7, camera, player)

        -- Second wave flies from riht to left
        local wave2_guy1 = TinyGuy(200,-100,nil, camera, player)
        wave2_guy1:setXVelocity(-2)
        local wave2_guy2 = TinyGuy(200,-100,wave2_guy1, camera, player)
        local wave2_guy3 = TinyGuy(200,-100,wave2_guy2, camera, player)
        local wave2_guy4 = TinyGuy(200,-100,wave2_guy3, camera, player)
        local wave2_guy5 = TinyGuy(200,-100,wave2_guy4, camera, player)
        local wave2_guy6 = TinyGuy(200,-100,wave2_guy5, camera, player)
        local wave2_guy7 = TinyGuy(200,-100,wave2_guy6, camera, player)
        local wave2_guy8 = TinyGuy(200,-100,wave2_guy7, camera, player)

        return HordeSegment(enemies)
    end)



    Scene0030.super.initialize(self, segments, sceneManager)

end