import "scene"
import "scripts/actors/player"
import "scripts/camera/camera"

local gfx <const> = playdate.graphics

class("Test1Scene").extends(Scene)

function Test1Scene:initialize(sceneManager)
    Test1Scene.super.initialize(self, sceneManager)
    
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    print ("test1 scene init")
    local textImage = gfx.image.new("images/test-scene1")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(120,200)
    textSprite:add()

    local bgImageTest = gfx.image.new("images/static-stars")
    local bgImageSprite = gfx.sprite.new(bgImageTest)
    bgImageSprite:moveTo(200,120)
    bgImageSprite:add()
    bgImageSprite:setZIndex(0)

    local player = Player()
    player:moveTo(200, 200)
    player:add()

    local camera = Camera()
    camera:add()
end

function Test1Scene:update()
    print ("test scene 1 is running")

    if (not self:getSceneManager():isReady()) then
        return
    end

    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        local nextScene = Test2Scene()
        self:getSceneManager():switchScene(nextScene, SCENE_TRANSITION.FADE_IO)
    
    elseif (playdate.buttonJustPressed(playdate.kButtonB)) then
        local nextScene = Test2Scene()
        self:getSceneManager():switchScene(nextScene)
    
    end

end
