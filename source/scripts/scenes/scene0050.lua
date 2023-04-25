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

function Scene0050:init()
    
    
        self.sceneManager = sceneManager
    
        sceneHelper.addBlackBackground()
        local sceneItems = sceneHelper.setupGameplayScene(sceneManager)
        sceneItems.bossBar:setIconImage("images/ui/hud/boss-bar/icon-cursed-neuron")
    
        local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
        plax1:setZIndex(1)
        local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
        plax2:setZIndex(2)
    
        local segments = {}
    
        table.insert(segments, function()
            return WaitSegment(3000)
        end)
    
        table.insert(segments, function()
    
            local bossTitle = OpeningCredit("images/ui/boss-logos/cursed-neuron/logo")
            bossTitle:setOnCompleted(function() sceneItems.bossBar:show() end)
        
            CursedNeuron(sceneItems.player, sceneItems.camera, sceneItems.bossBar)
    
            return DoNothingSegment()
        end)

end



