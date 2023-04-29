local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
import "scripts/actors/tinyGuyVertical"
import "scripts/actors/cursedNeuron/cursedNeuron"
import "scripts/ui/openingCredit"
import "scripts/ui/bossBar"


--[[
    This is strictly an animation sequence.  The first boss appears and destroys the two allies.
]]
class("Scene0050").extends(SegmentedScene)

function Scene0050:initialize(sceneManager)

        self.sceneManager = sceneManager
    
        sceneHelper.addBlackBackground()
        local sceneItems = sceneHelper.setupGameplayScene(sceneManager)
        sceneItems.bossBar:setIconImage("images/ui/hud/boss-bar/icon-cursed-neuron")
        sceneItems.player:moveTo(200, 40)
        local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
        plax1:setZIndex(1)
        local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
        plax2:setZIndex(2)
    
        local segments = {}

        CursedNeuron(sceneItems.player, sceneItems.camera, sceneItems.bossBar)
    
        table.insert(segments, function()
            ScreenFlash(1000, gfx.kColorWhite)
            return WaitSegment(3000)
        end)
    
        table.insert(segments, function()
    
            local bossTitle = OpeningCredit("images/ui/boss-logos/cursed-neuron/logo")
            bossTitle:setOnCompleted(function() sceneItems.bossBar:show() end)
    
            return DoNothingSegment()
        
        end)

        Scene0050.super.initialize(self, segments, sceneManager)


end



