local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
import "scripts/actors/tinyGuyVertical"

--[[
    This is strictly an animation sequence.  The first boss appears and destroys the two allies.
]]
class("Scene0040").extends(SegmentedScene)

function Scene0040:initialize(sceneManager)

    self.sceneManager = sceneManager

    sceneHelper.addBlackBackground()
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
    plax2:setZIndex(2)

    local segments = {}

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    Scene0040.super.initialize(self, segments, sceneManager)
end

function Scene0040:completeScene()
    self.sceneManager:switchScene(Scene0040())
end

