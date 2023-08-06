local gfx <const> = playdate.graphics

import "scripts/effects/playerSplotcher"
import "scripts/scenes/scene0080"
import "scripts/segments/customSegment"
import "scripts/powerups/laserPowerup"
--[[
    Second gameplay scene, cyber unlocks the laser
]]
class("Scene0080").extends(SegmentedScene)

function Scene0080:initialize(sceneManager)
    self.sceneManager = sceneManager

    local segments = {}
    local blackBg = sceneHelper.addBlackBackground()

    local sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local camera = sceneItems.camera
    local player = sceneItems.player

    player:moveTo(200,200)
    
    local segments = {}
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,4)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,6)
    plax2:setZIndex(2)

    -- table.insert(segments, function()
    --     return WaitSegment(7000)
    -- end)

    -- -- Things start getting weird 
    -- table.insert(segments, function()
    --     ScreenFlash(250, gfx.kColorBlack)
    --     plax1:remove()
    --     plax2:setScrollY(-0.5)
    --     return WaitSegment(3000)
    -- end)

    -- table.insert(segments, function()
    --     return DialogueSegment("scene0080/feelingStrange.txt", player, camera)
    -- end)

    -- -- screen harshly cuts to black
    -- table.insert(segments, function()
    --     HardCutBlack(3000)
    --     return WaitSegment(3000)
    -- end)

    -- local plax3 = nil
    -- local splotcher = nil

    -- -- ok now things are really trippy
    -- table.insert(segments, function()
    --     plax2:remove()
    
    --     blackBg:remove()
    --     ScreenFlash(250, gfx.kColorWhite)
    --     splotcher = PlayerSplotcher(player)
    --     plax3 = ParallaxLayer(gfx.image.new("images/backgrounds/patterns/abstract"),0,-2)
    --     camera:setNormalSway(6, 0.20)
    --     return DialogueSegment("scene0080/freakingOut.txt", player, camera)
    -- end)

    -- -- Create a powerup to enable the laser and wait for the player to pick it up
    -- table.insert(segments, function()
    --     local pup = LaserPowerup(200, -40)

    --     return CustomSegment(function ()
    --         return pup ~= nil and pup:isCollected()
    --     end)
    -- end)

    -- -- Collected the powerup, now wait a bit
    -- table.insert(segments, function()
    --     return WaitSegment(3000)
    -- end)

    -- -- screen harshly cuts to black again
    -- table.insert(segments, function()
    --     HardCutBlack(1500)
    --     return WaitSegment(1500)
    -- end)
    
    -- table.insert(segments, function()
    --     local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,4)
    --     plax1:setZIndex(1)
    --     local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,6)
    --     plax2:setZIndex(2)

    --     plax1:setScrollY(4)
    --     plax2:setScrollY(6)
    --     blackBg:add()

    --     plax3:remove()
    --     splotcher:remove()

    --     return WaitSegment(2000)
    -- end)

    -- table.insert(segments, function()
    --     return DialogueSegment("scene0080/wtfHappened.txt", player, camera)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     Tutorial(gfx.getString("tutorial.weapon"))

    --     enemies[1] = TinyShip(100, -20, camera, player):withHorizontalDistance(20):withHorizontalSpeed(0.5)
    --     enemies[2] = TinyShip(100, -40, camera, player):withHorizontalDistance(20):withHorizontalSpeed(0.5)
    --     enemies[3] = TinyShip(100, -60, camera, player):withHorizontalDistance(20):withHorizontalSpeed(0.5)
    --     enemies[4] = TinyShip(100, -80, camera, player):withHorizontalDistance(20):withHorizontalSpeed(0.5)

    --     enemies[5] = TinyShip(200, -80, camera, player):withHorizontalDistance(40):withHorizontalSpeed(1)
    --     enemies[6] = TinyShip(200, -100, camera, player):withHorizontalDistance(40):withHorizontalSpeed(1)
    --     enemies[7] = TinyShip(200, -120, camera, player):withHorizontalDistance(40):withHorizontalSpeed(1)
    --     enemies[8] = TinyShip(200, -140, camera, player):withHorizontalDistance(40):withHorizontalSpeed(1)

    --     enemies[9] =  TinyShip(300, -60, camera, player):withHorizontalDistance(30):withHorizontalSpeed(0.5)
    --     enemies[10] = TinyShip(300, -80, camera, player):withHorizontalDistance(30):withHorizontalSpeed(0.5)
    --     enemies[11] = TinyShip(300, -100, camera, player):withHorizontalDistance(30):withHorizontalSpeed(0.5)
    --     enemies[12] = TinyShip(300, -120, camera, player):withHorizontalDistance(30):withHorizontalSpeed(0.5)

    --     return HordeSegment(enemies)
    -- end)

    table.insert(segments, function()
        local enemies = {}
        
        enemies[1] = ShieldRangedGrunt(200,-50, camera, player)
        enemies[2] = DiveBomb(100, -10, camera, player)
        enemies[3] = DiveBomb(305, -10, camera, player)
        return HordeSegment(enemies)
    end)
    
    Scene0080.super.initialize(self, segments, sceneManager)
end

function Scene0080:completeScene()
    self.sceneManager:switchScene(Scene0080(), SCENE_TRANSITION.FADE_IO)
end