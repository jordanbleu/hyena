local gfx <const> = playdate.graphics

import "scripts/scenes/base/scene"

class("SegmentedScene").extends(Scene)

function SegmentedScene:init()
end

function SegmentedScene:initialize(segments, sceneManager)
    SegmentedScene.super.initialize(sceneManager)
end

function SegmentedScene:update()
    SegmentedScene.super.update(self)
end

function SegmentedScene:completeScene()
end