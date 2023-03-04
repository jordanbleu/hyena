import "scene"
import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/sprites/parallaxLayer"
import "scripts/actors/grunt"

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

    Grunt(150,100,camera)
    Grunt(200,70,camera)
    Grunt(200,100,camera)
    Grunt(250,100,camera)
end

function Test1Scene:update()
end
