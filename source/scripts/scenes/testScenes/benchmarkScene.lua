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


import "scripts/ui/typer"

local gfx <const> = playdate.graphics

class("BenchmarkScene").extends(Scene)

function BenchmarkScene:initialize(sceneManager)
    BenchmarkScene.super.initialize(self, sceneManager)
    
    local blackground = sceneHelper.addBlackBackground()
    -- local pLayer1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    -- local pLayer2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)

    local camera = Camera()

    self.camera = camera

    self.player = Player(camera, sceneManager)
    local player = self.player
    self.player:moveTo(200, 200)
    self.player:enableGodMode()

    self.sprites = {}

    local cnt = 30

    -- sprites test
    -- for i = 0, cnt do
    --     local img = sceneManager:getImageFromCache("images/player")
    --     local spr = gfx.sprite.new(img)
    --     spr:add()
    --     table.insert(self.sprites, spr)
    -- end

    -- enemies test
    for i = 0, cnt do
        local spr = Grunt(150,-40,camera, player)
        table.insert(self.sprites, spr)
    end


end

function BenchmarkScene:update()
    
    for i, s in ipairs(self.sprites) do
        s:moveTo(math.random(0,400), math.random(0,240))
    end
end

function BenchmarkScene:cleanup()
end
