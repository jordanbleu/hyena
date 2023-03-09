import "scene"
import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/sprites/parallaxLayer"
import "scripts/actors/grunt"
import "scripts/actors/diveBomb"
import "scripts/ui/hud"
import "scripts/ui/weaponSelector"


local gfx <const> = playdate.graphics

class("Test1Scene").extends(Scene)

function Test1Scene:initialize(sceneManager)
    Test1Scene.super.initialize(self, sceneManager)
    
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    print ("test1 scene init")
    local textImage = gfx.image.new("images/black")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(200,120)
    textSprite:add()

    ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),1)
    ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),3)

    local camera = Camera()

    local player = Player(camera)
    player:moveTo(200, 200)

    Hud(player)
    WeaponSelector(player)

    DiveBomb(100, -20, camera, player)
    DiveBomb(220, -30, camera, player)
    DiveBomb(240, -40, camera, player)
    DiveBomb(300, -50, camera, player)
    DiveBomb(350, -60, camera, player)


    -- Grunt(150,-40,camera, player)
    -- Grunt(200,-30,camera, player)
    -- Grunt(200,-10,camera, player)
    -- Grunt(250,-30,camera, player)
end

function Test1Scene:update()
end
