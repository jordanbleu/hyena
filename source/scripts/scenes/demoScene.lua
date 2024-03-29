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
import "scripts/scenes/base/segmentedScene"
import "scripts/scenes/test2Scene"

import "scripts/ui/hud"
import "scripts/ui/weaponSelector"

local gfx <const> = playdate.graphics

class("DemoScene").extends(SegmentedScene)

function DemoScene:init()
    DemoScene.super.init(self)
    self.sceneManager = nil
end

function DemoScene:initialize(sceneManager)
    self.sceneManager = sceneManager
        
    ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)

    sceneHelper.addBlackBackground()
    local stuff = sceneHelper.setupGameplayScene(sceneManager)
    local player = stuff.player
    player:moveTo(200, 200)

    
    --< segments >-- 

    local segments = {}

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        return DialogueSegment("demoDialogue1.txt",player)
    end)

    table.insert(segments, function()
        local enemies = {}
        enemies[1] = TinyGuy(200,-10,nil, camera, player)
        enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
        enemies[3] = TinyGuy(200,-10,enemies[2], camera, player)
        enemies[4] = TinyGuy(200,-40,enemies[3], camera, player)
        enemies[5] = TinyGuy(200,-50,enemies[4], camera, player)
        enemies[6] = TinyGuy(200,-60,enemies[5], camera, player)
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(2000)
    end)

    table.insert(segments, function()
        return DialogueSegment("demoDialogue2.txt", player)
    end)

    table.insert(segments, function()
        local enemies = {}
        enemies[1] = ShieldRangedGrunt(200,50, camera, player)
        return HordeSegment(enemies)
    end)

    -- no wait time in between
    table.insert(segments, function()
        return DialogueSegment("demoDialogue3.txt",player)
    end)

    table.insert(segments, function()
        return WaitSegment(3000)
    end)
    


    -- table.insert(segments, function()
    --     return WaitSegment(3000)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = RangedGrunt(200,-30, camera, player)
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = ShieldRangedGrunt(200,-30, camera, player)
    --     enemies[2] = DiveBomb(60, -50, camera, player)
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = DeathStar(200,-50, player)
    --     return HordeSegment(enemies)
    -- end)

    DemoScene.super.initialize(self, segments, sceneManager)

    -- local guy1 = TinyGuy(200,-10,nil, camera, player)
    -- local guy2 = TinyGuy(200,-10,guy1, camera, player)
    -- local guy3 = TinyGuy(200,-10,guy2, camera, player)
    -- local guy4 = TinyGuy(200,-40,guy3, camera, player)
    -- local guy5 = TinyGuy(200,-50,guy4, camera, player)
    -- local guy6 = TinyGuy(200,-60,guy5, camera, player)
    -- local guy7 = TinyGuy(200,-70,guy6, camera, player)
    -- local guy8 = TinyGuy(200,-80,guy7, camera, player)
    -- local guy9 = TinyGuy(200,-40,guy8, camera, player)
    -- local guy10 = TinyGuy(200,-50,guy9, camera, player)
    -- local guy11 = TinyGuy(200,-60,guy10, camera, player)
    -- local guy12 = TinyGuy(200,-70,guy11, camera, player)
    -- local guy13 = TinyGuy(200,-80,guy12, camera, player)


    -- DiveBomb(100, -20, camera, player)
    -- DiveBomb(20, -30, camera, player)
    -- DiveBomb(40, -40, camera, player)
    -- DiveBomb(60, -50, camera, player)

    -- ShieldRangedGrunt(200,50, camera, player)
    -- RangedGrunt(200,50, camera, player)

    -- DeathStar(200,-10, player)

    -- Grunt(150,-40,camera, player)
    -- Grunt(200,-30,camera, player)
    -- Grunt(200,-10,camera, player)
    -- Grunt(250,-30,camera, player)

    -- Grunt(150,-70,camera, player)
    -- Grunt(200,-80,camera, player)
    -- Grunt(200,-100,camera, player)
    -- Grunt(250,-120,camera, player)
    -- Grunt(150,-140,camera, player)
    -- Grunt(200,-170,camera, player)
    -- Grunt(200,-200,camera, player)
    -- Grunt(250,-300,camera, player)
end

function DemoScene:completeScene()
    self.sceneManager:switchScene(Test2Scene(), SCENE_TRANSITION.FADE_IO)
end