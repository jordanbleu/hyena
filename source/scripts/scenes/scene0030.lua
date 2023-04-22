local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
import "scripts/actors/tinyGuyVertical"
import "scripts/scenes/scene0040"
import "scripts/sprites/bgSpriteEmitter"


--[[
    First gameplay scene.

    Player learns the basics, no bosses in this scene.  Lots of dialogue.
]]
class("Scene0030").extends(SegmentedScene)


function Scene0030:initialize(sceneManager)

    self.sceneManager = sceneManager

    ScreenFlash(1000, gfx.kColorWhite)
    sceneHelper.addBlackBackground()
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
    plax2:setZIndex(2)

    -- emit randmo background stuff
    local bgEmitter = BgSpriteEmitter(1)
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet3"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/satellite"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/satellite2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/asteroid"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/asteroid2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/mist"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/mist2"))




    self.sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local player = self.sceneItems.player
    local camera = self.sceneItems.camera

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
        local enemies = {}

        enemies[1] = TinyGuy(200,-10,nil, camera, player)
        enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
        enemies[3] = TinyGuy(200,-20,enemies[2], camera, player)
        enemies[4] = TinyGuy(200,-30,enemies[3], camera, player)
        enemies[5] = TinyGuy(200,-40,enemies[4], camera, player)
        enemies[6] = TinyGuy(200,-50,enemies[5], camera, player)
        enemies[7] = TinyGuy(200,-60,enemies[6], camera, player)
        enemies[8] = TinyGuy(200,-70,enemies[7], camera, player)

        enemies[9] =  TinyGuy(200,-100,nil, camera, player)
        enemies[10] = TinyGuy(200,-110,enemies[9], camera, player)
        enemies[11] = TinyGuy(200,-120,enemies[10], camera, player)
        enemies[12] = TinyGuy(200,-130,enemies[11], camera, player)
        enemies[13] = TinyGuy(200,-140,enemies[12], camera, player)
        enemies[14] = TinyGuy(200,-150,enemies[13], camera, player)
        enemies[15] = TinyGuy(200,-160,enemies[14], camera, player)
        enemies[16] = TinyGuy(200,-170,enemies[15], camera, player)

        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        local enemies = {}

        enemies[1] = TinyGuyVertical(200,-10,nil, camera, player)
        enemies[2] = TinyGuyVertical(200,-10,enemies[1], camera, player)
        enemies[3] = TinyGuyVertical(200,-20,enemies[2], camera, player)
        enemies[4] = TinyGuyVertical(200,-30,enemies[3], camera, player)
        enemies[5] = TinyGuyVertical(200,-40,enemies[4], camera, player)
        enemies[6] = TinyGuyVertical(200,-50,enemies[5], camera, player)
        enemies[7] = TinyGuyVertical(200,-60,enemies[6], camera, player)
        enemies[8] = TinyGuyVertical(200,-70,enemies[7], camera, player)

        table.insert(enemies, Grunt(300,-50, camera, player))
        table.insert(enemies, Grunt(120,-10, camera, player))

        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        local enemies = {}

        table.insert(enemies, DiveBomb(10, -20, camera, player))
        table.insert(enemies, DiveBomb(50, -20, camera, player))
        table.insert(enemies, DiveBomb(90, -20, camera, player))
        table.insert(enemies, DiveBomb(130, -20, camera, player))
        table.insert(enemies, DiveBomb(170, -20, camera, player))
        table.insert(enemies, DiveBomb(230, -20, camera, player))
        table.insert(enemies, DiveBomb(280, -20, camera, player))
        table.insert(enemies, DiveBomb(330, -20, camera, player))
        table.insert(enemies, DiveBomb(380, -20, camera, player))

        table.insert(enemies, DiveBomb(20,  -40, camera, player))
        table.insert(enemies, DiveBomb(50,  -40, camera, player))
        table.insert(enemies, DiveBomb(100,  -40, camera, player))
        table.insert(enemies, DiveBomb(150, -40, camera, player))
        table.insert(enemies, DiveBomb(200, -40, camera, player))
        table.insert(enemies, DiveBomb(250, -40, camera, player))
        table.insert(enemies, DiveBomb(300, -40, camera, player))
        table.insert(enemies, DiveBomb(350, -40, camera, player))
        table.insert(enemies, DiveBomb(380, -40, camera, player))
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        local enemies = {}

        enemies[1] = TinyGuyVertical(200,-100,nil, camera, player)
        enemies[2] = TinyGuyVertical(200,-120,enemies[1], camera, player)
        enemies[3] = TinyGuyVertical(200,-140,enemies[2], camera, player)

        enemies[4] = TinyGuyVertical(200,-230,nil, camera, player)
        enemies[5] = TinyGuyVertical(200,-240,enemies[4], camera, player)
        enemies[6] = TinyGuyVertical(200,-250,enemies[5], camera, player)

        enemies[7] = TinyGuyVertical(200,-60,nil, camera, player)
        enemies[8] = TinyGuyVertical(200,-70,enemies[7], camera, player)
        enemies[9] = TinyGuyVertical(200,-70,enemies[8], camera, player)

        enemies[10] = TinyGuyVertical(200,-60,nil, camera, player)
        enemies[11] = TinyGuyVertical(200,-70,enemies[10], camera, player)
        enemies[12] = TinyGuyVertical(200,-70,enemies[11], camera, player)

        table.insert(enemies, DiveBomb(300, -20, camera, player))
        table.insert(enemies, DiveBomb(50, -20, camera, player))

        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        local enemies = {}
        enemies[1] = RangedGrunt(200,-50, camera, player)
        table.insert(enemies, DiveBomb(25, -40, camera, player))
        table.insert(enemies, DiveBomb(50, -20, camera, player))
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0030/ending.txt", player)
    end)

    Scene0030.super.initialize(self, segments, sceneManager)
end

function Scene0030:completeScene()
    self.sceneManager:switchScene(Scene0040(), SCENE_TRANSITION.FADE_IO)
end

