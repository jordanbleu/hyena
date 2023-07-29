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

import "scripts/ui/typer"

local gfx <const> = playdate.graphics

class("TestingScene").extends(Scene)

function TestingScene:initialize(sceneManager)
    TestingScene.super.initialize(self, sceneManager)
    
    local blackground = sceneHelper.addBlackBackground()

    local pLayer1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    local pLayer2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)

    local sceneItems = sceneHelper.setupGameplayScene()
    local player = sceneItems.player
    player:moveTo(200,player.y)

    SquidGrunt(200,50, player, sceneItems.camera)


end

function TestingScene:update()
    

end

function TestingScene:cleanup()
end
