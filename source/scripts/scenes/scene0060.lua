local gfx <const> = playdate.graphics

import "scripts/scenes/scene0070"


--[[
    Cursed Neuron death
]]
class("Scene0060").extends(SegmentedScene)

function Scene0060:initialize(sceneManager)
    self.sceneManager = sceneManager

    local segments = {}

    self.bgSprite = gfx.sprite.new(gfx.image.new("images/black"))
    self.bgSprite:moveTo(200,120)
    self.bgSprite:setZIndex(0)
    self.bgSprite:add()

    self.parallax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
    self.parallax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,2)

    self.camera = Camera()

    local image = gfx.image.new("images/player")
    self.leftActor = gfx.sprite.new(image)
    self.leftActor:setZIndex(50)
    self.leftActor:moveTo(100, 290)
    self.leftActor:add()

    local player = gfx.sprite.new(gfx.image.new("images/player"))
    player:moveTo(200, 200)
    player:setZIndex(31)
    player:add()

    self.cursedNeuron = CursedNeuronAnimation(self.camera)
    self.cursedNeuron:startDeathAnimation()

    ScreenFlash(250, gfx.kColorWhite)

    table.insert(segments, function()
        ScreenFlash(1500, gfx.kColorWhite)
        return WaitSegment(3000)
    end)

    table.insert(segments, function()
        return AnimationSegment({self.cursedNeuron})
    end)

    table.insert(segments, function()
        SingleSpriteAnimation("images/bosses/cursedNeuron/deathAnim/death", 1500, self.cursedNeuron.x, self.cursedNeuron.y)
        ScreenFlash(500, gfx.kColorWhite)
        self.cursedNeuron:remove()
        return WaitSegment(5000)
    end)

    Scene0060.super.initialize(self, segments, sceneManager)
end

function Scene0060:completeScene()
    self.sceneManager:switchScene(Scene0070(), SCENE_TRANSITION.FADE_IO)
end