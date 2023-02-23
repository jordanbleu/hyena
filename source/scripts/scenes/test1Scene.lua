import "scene"
import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/environment/parallaxLayer"

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


    local plax0 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),1)
    plax0:add()
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),3)
    plax1:add()

    local player = Player()
    player:moveTo(200, 200)
    player:add()

    local camera = Camera()
    camera:add()
end

function Test1Scene:update()
    --print ("test scene 1 is running")

    if (not self:getSceneManager():isReady()) then
        return
    end

    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        local nextScene = Test2Scene()
        self:getSceneManager():switchScene(nextScene, SCENE_TRANSITION.FADE_IO)
    
    end

end
