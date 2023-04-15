local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
--[[
    First gameplay scene.

    Player learns the basics, no bosses in this scene.  Lots of dialogue.
]]
class("Scene0030").extends(SegmentedScene)


function Scene0030:initialize(sceneManager)

    ScreenFlash(1000, gfx.kColorWhite)
    sceneHelper.addBlackBackground()
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
    plax2:setZIndex(2)

    local sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local player = sceneItems.player
    local camera = sceneItems.camera
    player:moveTo(200,200)

    local segments = {}

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        Tutorial(gfx.getString("tutorial.move"), player)
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        Tutorial(gfx.getString("tutorial.shoot"), player)
        return WaitSegment(3000)
    end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     table.insert(enemies, Grunt(200,-10, camera, player))
    --     table.insert(enemies, Grunt(100,-20, camera, player))
    --     return HordeSegment(enemies)
    -- end)

    Scene0030.super.initialize(self, segments, sceneManager)

end