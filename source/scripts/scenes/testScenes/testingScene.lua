import "scripts/scenes/base/scene"
import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/sprites/parallaxLayer"

import "scripts/actors/grunt"
import "scripts/actors/rangedGrunt"
import "scripts/actors/tinyGuy"
import "scripts/actors/tinyShip"

import "scripts/actors/deathStar"
import "scripts/actors/diveBomb"
import "scripts/actors/shieldRangedGrunt"

import "scripts/ui/hud"
import "scripts/ui/weaponSelector"
import "scripts/ui/gameplayDialogue"

import "scripts/ai/squidGrunt"
import "scripts/ai/millipede"


import "scripts/ui/typer"

local gfx <const> = playdate.graphics

class("TestingScene").extends(Scene)

function TestingScene:initialize(sceneManager)
    TestingScene.super.initialize(self, sceneManager)
    

    local audioTest = playdate.sound.fileplayer.new("sounds/music/test3")
    audioTest:play(0)

    local blackground = sceneHelper.addBlackBackground()

    local pLayer1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    local pLayer2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)

    local sceneItems = sceneHelper.setupGameplayScene()
    local player = sceneItems.player
    player:moveTo(200,player.y)

    --SquidGrunt(200,50, player, sceneItems.camera)
    Millipede(200,50, player, sceneItems.camera)

    Millipede(50,50, player, sceneItems.camera)
    Millipede(80,50, player, sceneItems.camera)
    Millipede(100,50, player, sceneItems.camera)
    Millipede(120,50, player, sceneItems.camera)
    Millipede(160,50, player, sceneItems.camera)
    Millipede(180,50, player, sceneItems.camera)
    Millipede(200,50, player, sceneItems.camera)
    Millipede(220,50, player, sceneItems.camera)

    Millipede(50, 150, player, sceneItems.camera)
    Millipede(80, 150, player, sceneItems.camera)
    Millipede(100,150, player, sceneItems.camera)

    Millipede(50, 250, player, sceneItems.camera)
    Millipede(80, 250, player, sceneItems.camera)
    Millipede(100,250, player, sceneItems.camera)

    Millipede(50, 250, player, sceneItems.camera)
    Millipede(80, 250, player, sceneItems.camera)
    Millipede(100,250, player, sceneItems.camera)

end

function TestingScene:update()
    

end

function TestingScene:cleanup()
end
