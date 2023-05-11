local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
import "scripts/scenes/scene0040"
import "scripts/sprites/bgSpriteEmitter"
import "scripts/actors/saucer"

--[[
    First gameplay scene.

    Player learns the basics, no bosses in this scene.  Lots of dialogue.
]]
class("Scene0030").extends(SegmentedScene)


function Scene0030:initialize(sceneManager)

    self.sceneManager = sceneManager

    ScreenFlash(1000, gfx.kColorWhite)
    sceneHelper.addBlackBackground()
    
    local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,3)
    plax1:setZIndex(1)
    local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,9)
    plax2:setZIndex(2)

    -- emit randmo background stuff
    local bgEmitter = BgSpriteEmitter(1)
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/blanet3"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/satellite"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/satellite2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/asteroid"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/asteroid2"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/mist"))
    bgEmitter:addImage(gfx.image.new("images/backgrounds/bg-sprites/mist2"))

    self.sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local player = self.sceneItems.player
    local camera = self.sceneItems.camera

    player:moveTo(200,200)

    local segments = {}

    -- table.insert(segments, function()
    --     return WaitSegment(3000)
    -- end)

    -- table.insert(segments, function()
    --     -- back in the cokpit again
    --     return DialogueSegment("scene0030/cyberMonologue.txt", player)
    -- end)

    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.move"))
    --     return WaitSegment(8000)
    -- end)

    -- table.insert(segments, function()
    --     -- what the hell are these things?
    --     return DialogueSegment("scene0030/cyberMonologue1.txt", player)
    -- end)
    
    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.shoot"))
    --     local enemies = {}
    --     table.insert(enemies, Grunt(200,-10, camera, player))
    --     table.insert(enemies, Grunt(100,-20, camera, player))
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(3000)
    -- end)

    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.shoot"))
    --     local enemies = {}
    --     table.insert(enemies, Grunt(100,-10, camera, player))
    --     table.insert(enemies, Grunt(150,-17, camera, player))
    --     table.insert(enemies, Grunt(200,-20, camera, player))
    --     table.insert(enemies, Grunt(350,-25, camera, player))
    --     return HordeSegment(enemies)
    -- end)


    -- table.insert(segments, function()
    --     return WaitSegment(2000)
    -- end)

    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.dash"))
    --     local enemies = {}
    --     table.insert(enemies, Grunt(300,-50, camera, player))
    --     table.insert(enemies, Grunt(120,-10, camera, player))
    --     table.insert(enemies, DiveBomb(100, -20, camera, player))
    --     table.insert(enemies, DiveBomb(30, -30, camera, player))
    --     table.insert(enemies, DiveBomb(player.x, -30, camera, player))
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(2000)
    -- end)
    
    -- table.insert(segments, function()
    --     local enemies = {}

    --     local spd = 0.5
    --     local dist = 6
        
    --     enemies[1] = TinyShip(100, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[2] = TinyShip(120, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[3] = TinyShip(140, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[4] = TinyShip(160, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[5] = TinyShip(180, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[6] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[7] = TinyShip(220, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[8] = TinyShip(240, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[9] = TinyShip(100, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[10] = TinyShip(120, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[11] = TinyShip(140, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[12] = TinyShip(160, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[13] = TinyShip(180, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[14] = TinyShip(200, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[15] = TinyShip(220, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
    --     enemies[16] = TinyShip(240, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd)
        
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
        
    --     local spd = 0.5
    --     local dist = 24

    --     enemies[1] = Saucer(50, -50, camera, player)
    --     enemies[2] = TinyShip(120, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[3] = TinyShip(140, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[4] = TinyShip(160, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[5] = TinyShip(180, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[6] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[7] = TinyShip(220, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
 
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(1000)
    -- end)


    -- table.insert(segments, function()
    --     local enemies = {}
        
    --     enemies[1] = TinyGuy(200,-10,nil, camera, player)
    --     enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
    --     enemies[3] = TinyGuy(200,-20,enemies[2], camera, player)
    --     enemies[4] = TinyGuy(200,-30,enemies[3], camera, player)
    --     enemies[5] = TinyGuy(200,-40,enemies[4], camera, player)
    --     enemies[6] = TinyGuy(200,-50,enemies[5], camera, player)
    --     enemies[7] = TinyGuy(200,-60,enemies[6], camera, player)
    --     enemies[8] = TinyGuy(200,-70,enemies[7], camera, player)
        
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
        
    --     enemies[1] = TinyGuy(200,-10,nil, camera, player)
    --     enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
    --     enemies[3] = TinyGuy(200,-20,enemies[2], camera, player)

    --     enemies[4] = TinyGuy(200,-30,nil, camera, player)
    --     enemies[5] = TinyGuy(200,-40,enemies[4], camera, player)
    --     enemies[6] = TinyGuy(200,-50,enemies[5], camera, player)

    --     enemies[7] = RangedGrunt(200,-25, camera, player):withCooldownRangeBetween(25,100)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(4000)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}        
    --     enemies[1] = Grunt(20,-10, camera, player)
    --     enemies[2] = Grunt(380,-30, camera, player)
    --     return HordeSegment(enemies)
    -- end)

    table.insert(segments, function()
        local enemies = {}

        local spd = 1
        local dist = 50
        
        enemies[1] = TinyShip(100, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)
        enemies[2] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)
        enemies[3] = TinyShip(300, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)

        enemies[4] = TinyShip(100, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        enemies[5] = TinyShip(200, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        enemies[6] = TinyShip(300, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        enemies[7] = TinyShip(380, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)

        enemies[8] =  TinyShip(20,  -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)
        enemies[9] = TinyShip(100, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)
        enemies[10] = TinyShip(200, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)
        enemies[11] = TinyShip(300, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd):withShootingDelay(2000)

        enemies[12] = TinyShip(100,  -80, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        enemies[13] = TinyShip(200, -80, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        enemies[14] = TinyShip(300, -80, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(-spd):withShootingDelay(2000)
        
        return HordeSegment(enemies)
    end)

 
    table.insert(segments, function()
        return DialogueSegment("scene0030/introductions.txt", player)
    end)
 
    table.insert(segments, function()
        local enemies = {}
        enemies[1] = RangedGrunt(200,-50, camera, player)
        table.insert(enemies, DiveBomb(25, -40, camera, player))
        table.insert(enemies, DiveBomb(50, -20, camera, player))
        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0030/ending.txt", player)
    end)

    Scene0030.super.initialize(self, segments, sceneManager)
end

function Scene0030:completeScene()
    self.sceneManager:switchScene(Scene0040(), SCENE_TRANSITION.FADE_IO)
end

