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

class("Test1Scene").extends(Scene)

function Test1Scene:initialize(sceneManager)
    Test1Scene.super.initialize(self, sceneManager)
    
    local textImage = gfx.image.new("images/black")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(200,120)
    textSprite:add()

    local pLayer1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    local pLayer2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)

    local camera = Camera()

    self.camera = camera

    self.player = Player(camera, sceneManager)
    local player = self.player
    self.player:moveTo(200, 200)

    self.hud = Hud(player)
    self.weaponSelector = WeaponSelector(player)

    self.frameCounter = 0

    local dist = 40
    local spd = 0.5
    TinyShip(100, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(120, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(140, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(160, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(180, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(220, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(240, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)

    TinyShip(100, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(120, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(140, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(160, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(180, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(200, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(220, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    TinyShip(240, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    
    TinyShip(100, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(120, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(140, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(160, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(180, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(200, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(220, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    TinyShip(240, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)




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

    --ShieldRangedGrunt(200,50, camera, player)
    --RangedGrunt(200,50, camera, player)

    --DeathStar(200,40, player)

    -- Grunt(150,-40,camera, player)
    -- Grunt(200,-30,camera, player)
    -- Grunt(100,80,camera, player)
    --Grunt(250,-30,camera, player)

    -- Grunt(150,-70,camera, player)
    -- Grunt(200,-80,camera, player)
    -- Grunt(200,-100,camera, player)
    -- Grunt(250,-120,camera, player)
    -- Grunt(150,-140,camera, player)
    -- Grunt(200,-170,camera, player)
    -- Grunt(200,-200,camera, player)
    -- Grunt(250,-300,camera, player)
end

function Test1Scene:update()

    -- local time2Wait = 120
    -- if (self.frameCounter < time2Wait) then
    --     self.frameCounter += 1

    --     if (self.frameCounter == time2Wait-1) then
    --         GameplayDialogue("testDialogue.txt", self.player)
    --         self.frameCounter = time2Wait
            
    --     end
    -- end
end

function Test1Scene:cleanup()
    -- in a real scene we would clean EVERYTHING up here but i m lazy
    self.camera:remove()

    Test1Scene.super.cleanup(self)
end
