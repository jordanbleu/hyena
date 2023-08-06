local gfx <const> = playdate.graphics

import "scripts/scenes/base/segmentedScene"
import "scripts/segments/doNothingSegment"
import "scripts/segments/playerFlyOnScreenSegment"

import "scripts/ui/openingCredit"
import "scripts/animations/friendsFlyBy"

import "scripts/actors/centipede"

import "scripts/scenes/scene0030"
import "scripts/sprites/bgSpriteEmitter"

--[[
    Player jumps right into the action and shoots some enemies
]]

class("Scene0020").extends(SegmentedScene)

--[[
    This scene basically shows the title credits
]]
function Scene0020:initialize(sceneManager)
    local segments = {}

    self.sceneManager = sceneManager

    ScreenFlash(1000, gfx.kColorWhite)

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

    self.bgSprite = gfx.sprite.new(gfx.image.new("images/black"))
    self.bgSprite:moveTo(200,120)
    self.bgSprite:setZIndex(0)
    self.bgSprite:add()

    self.parallax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,4)
    self.parallax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,6)

    self.sceneItems = sceneHelper.setupGameplayScene(sceneManager)
    local player = self.sceneItems.player
    local camera = self.sceneItems.camera

    player:moveTo(200,200)

    table.insert(segments, function()
        return WaitSegment(1000)
    end)

    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.move"))
    --     return WaitSegment(7000)
    -- end)

    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.shoot"))
    --     local enemies = {}
    --     enemies[1] = TinyGuy(200,-10,nil, camera, player)
    --     enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
    --     enemies[3] = TinyGuy(200,-10,enemies[2], camera, player)
    --     enemies[4] = TinyGuy(200,-40,enemies[3], camera, player)
    --     enemies[5] = TinyGuy(200,-50,enemies[4], camera, player)
    --     enemies[6] = TinyGuy(200,-60,enemies[5], camera, player)
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(3000)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     local spd = 0.5
    --     local dist = 6

    --     enemies[1] = TinyShip(120, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[2] = TinyShip(140, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[3] = TinyShip(160, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[4] = TinyShip(180, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[5] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[6] = TinyShip(220, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
 
    --     return HordeSegment(enemies)
    -- end)


    -- table.insert(segments, function()
    --     Tutorial(gfx.getString("tutorial.dash"))
    --     local enemies = {}
    --     enemies[1] = Saucer(50, -50, camera, player)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = TinyGuy(200,-10,nil, camera, player)
    --     enemies[2] = TinyGuy(200,-10,enemies[1], camera, player)
    --     enemies[3] = TinyGuy(200,-10,enemies[2], camera, player)
    --     enemies[4] = TinyGuy(200,-40,enemies[3], camera, player)

    --     enemies[5] = TinyGuy(200,-50,nil, camera, player):withXVelocity(-2)
    --     enemies[6] = TinyGuy(200,-60,enemies[5], camera, player)
    --     enemies[7] = TinyGuy(200,-60,enemies[6], camera, player)
    --     enemies[8] = TinyGuy(200,-60,enemies[7], camera, player)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(2000)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     local spd = 1
    --     local dist = 60

    --     enemies[1] = TinyShip(20, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[2] = TinyShip(100, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[3] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[4] = TinyShip(300, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[5] = TinyShip(380, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[6] = RangedGrunt(200,-100, camera, player):withCooldownRangeBetween(25,100)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = Saucer(150, -50, camera, player)
    --     enemies[2] = Saucer(50, -150, camera, player)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = Saucer(150, -50, camera, player)
    --     enemies[2] = Saucer(50, -150, camera, player)
    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}
    --     enemies[1] = DiveBomb(25, -10, camera, player)
    --     enemies[2] = DiveBomb(325, -10, camera, player)

    --     enemies[3] = TinyGuy(300,-40,nil, camera, player)
    --     enemies[4] = TinyGuy(300,-40,enemies[3], camera, player)

    --     enemies[5] = TinyGuy(100,-60,nil, camera, player)
    --     enemies[6] = TinyGuy(100,-60,enemies[5], camera, player)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     return WaitSegment(4000)
    -- end)

    table.insert(segments, function()
        return DialogueSegment("scene0020/introductions.txt", player)
    end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     local spd = 0.5
    --     local dist = 30

    --     enemies[1] = TinyShip(160, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[2] = TinyShip(180, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[3] = TinyShip(200, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[4] = TinyShip(220, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)

    --     enemies[5] = TinyShip(170, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[6] = TinyShip(210, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)

    --     enemies[7] = Grunt(20, -50, camera, player)
    --     enemies[8] = Grunt(380,-50, camera, player)

    --     enemies[9] =  TinyShip(160, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[10] = TinyShip(180, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[11] = TinyShip(200, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
    --     enemies[12] = TinyShip(220, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     enemies[1] = Saucer(20, -50, camera, player)
    --     enemies[2] = Saucer(200, -100, camera, player)
    --     enemies[3] = Saucer(300, -150, camera, player)

    --     return HordeSegment(enemies)
    -- end)

        
    -- table.insert(segments, function()
    --     return DialogueSegment("scene0020/goodJob.txt", player)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     enemies[1] = DiveBomb(20, -100, camera, player)
    --     enemies[2] = DiveBomb(100, -120, camera, player)
    --     enemies[3] = DiveBomb(200, -140, camera, player)
    --     enemies[4] = DiveBomb(300, -160, camera, player)
    --     enemies[5] = RangedGrunt(200,-20, camera, player):withCooldownRangeBetween(10,75)

    --     return HordeSegment(enemies)
    -- end)

    -- table.insert(segments, function()
    --     local enemies = {}

    --     enemies[1] = DiveBomb(10, -100, camera, player):withDiveSpeed(8)
    --     enemies[2] = DiveBomb(60, -100, camera, player):withDiveSpeed(7)
    --     enemies[3] = DiveBomb(120, -100, camera, player):withDiveSpeed(5)
    --     enemies[4] = DiveBomb(2400, -100, camera, player):withDiveSpeed(3)

    --     return HordeSegment(enemies)
    -- end)
    
    -- table.insert(segments, function()
    --     return DialogueSegment("scene0020/goodJob2.txt", player)
    -- end)


    -- table.insert(segments, function()
    --     local enemies = {}
        
    --     enemies[1] = Centipede(200, -40, camera, player)
    --     enemies[2] = DiveBomb(10, -40, camera, player):withDiveSpeed(3)
    --     enemies[3] = DiveBomb(60, -40, camera, player):withDiveSpeed(3.5)
    --     enemies[4] = DiveBomb(120, -40, camera, player):withDiveSpeed(4)
    --     enemies[5] = RangedGrunt(100, -20, camera, player):withCooldownRangeBetween(10,75)
        
    --     return HordeSegment(enemies)
    -- end)
    
    
    -- table.insert(segments, function()
    --     return WaitSegment(2000)
    -- end)
    
    
    table.insert(segments, function()
        return DialogueSegment("scene0020/goodJob3.txt", player)
    end)

    table.insert(segments, function()
        local enemies = {}

        local spd = 1.5
        local dist = 30

        enemies[1] = Centipede(100, -40, camera, player)
        enemies[2] = Centipede(300, -70, camera, player)
        enemies[3] = TinyShip(100, -20, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
        enemies[4] = TinyShip(200, -40, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
        enemies[5] = TinyShip(300, -50, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)
        enemies[6] = TinyShip(220, -60, camera, player):withHorizontalDistance(dist):withHorizontalSpeed(spd)

        return HordeSegment(enemies)
    end)

    table.insert(segments, function()
        return WaitSegment(8000)
    end)
    

    table.insert(segments, function()
        return DialogueSegment("scene0020/ending.txt", player)
    end)

    table.insert(segments, function()
        return WaitSegment(3000)
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
    self.sceneManager:switchScene(Scene0030(), SCENE_TRANSITION.FADE_IO)
end