import "scripts/scenes/base/scene"

local gfx <const> = playdate.graphics

class("Test2Scene").extends(Scene)

function Test2Scene:initialize(sceneManager)
    Test2Scene.super.initialize(self, sceneManager)

    print ("test2 scene init")
    local textImage = gfx.image.new("images/test-scene2")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(120,200)
    textSprite:add()
end

function Test2Scene:update()
    print("test scene 2 running!")

    if (not self:getSceneManager():isReady()) then
        return
    end

    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        self:getSceneManager():switchScene(Test1Scene(), SCENE_TRANSITION.FADE_IO)
    
    elseif (playdate.buttonJustPressed(playdate.kButtonB)) then
        local nextScene = Test1Scene()
        self:getSceneManager():switchScene(nextScene)
    
    end

end