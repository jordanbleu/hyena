import "scene"

local gfx <const> = playdate.graphics

class("Test2Scene").extends(Scene)

function Test2Scene:initialize(sceneManager)
    Test2Scene.super.initialize(self, sceneManager)

    print "hello test1scene"
    local textImage = gfx.image.new("images/test-scene2")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(120,200)
    textSprite:add()
end

function Test2Scene:update()
    print("test scene 2!")

    if (playdate.buttonJustPressed(playdate.kButtonA)) then 
        self:getSceneManager():switchScene(Test1Scene())  
    end

end