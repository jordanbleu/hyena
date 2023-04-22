local gfx <const> = playdate.graphics

import "scripts/scenes/base/segmentedScene"
import "scripts/segments/doNothingSegment"
import "scripts/segments/playerFlyOnScreenSegment"

import "scripts/ui/openingCredit"
import "scripts/animations/friendsFlyBy"

import "scripts/scenes/scene0030"

--[[
    Opening credits scene.

    Shows 'jordan bleu presents' then the title then it immediately starts the game.
]]

class("Scene0020").extends(SegmentedScene)

--[[
    This scene basically shows the title credits
]]
function Scene0020:initialize(sceneManager)
    local segments = {}

    self.sceneManager = sceneManager

    self.bgSprite = gfx.sprite.new(gfx.image.new("images/black"))
    self.bgSprite:moveTo(200,120)
    self.bgSprite:setZIndex(0)
    self.bgSprite:add()

    self.parallax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,0.5)
    self.parallax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,1)

    self.camera = Camera()
    self.camera:removeNormalSway()

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        OpeningCredit("images/ui/opening-credits/jbleu-presents/jbleu-presents")
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        FriendsFlyBy(self.camera)
        return WaitSegment(6000)
    end)


    table.insert(segments, function()
        OpeningCredit("images/ui/opening-credits/opening-logo/opening-title-logo")
        return WaitSegment(6000)
    end)
    
    table.insert(segments, function()
        --self.camera:setNormalSway(2,2)
        return PlayerFlyOnScreenSegment()
    end)

    Scene0020.super.initialize(self, segments, sceneManager)
end


function Scene0020:cleanup()
    self.bgSprite:remove()
    self.parallax1:remove()
    self.parallax2:remove()
    Scene0020.super.cleanup(self)
end

function Scene0020:completeScene()
    self.sceneManager:switchScene(Scene0030())
end