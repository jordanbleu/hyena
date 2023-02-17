import "CoreLibs/graphics"

import "scene"

local gfx <const> = playdate.graphics

class("Test1Scene").extends(Scene)

function Test1Scene:initialize(sceneManager)
    print "hello test1scene"
    local textImage = gfx.image.new("images/test-scene1")
    local textSprite = gfx.sprite.new(textImage)
    textSprite:moveTo(120,200)
    textSprite:add()
end

function Test1Scene:update()
    print "test scene 1 is running"
end
