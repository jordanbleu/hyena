local gfx <const> = playdate.graphics

import "scripts/helpers/sceneHelper"
import "scripts/effects/screenFlash"
import "scripts/ui/tutorial"
import "scripts/actors/cursedNeuron/cursedNeuron"
import "scripts/ui/openingCredit"
import "scripts/ui/bossBar"
import "scripts/segments/animationSegment"
import "scripts/animations/animationDirector"
import "scripts/animations/friendsDiePt1Animation"
import "scripts/animations/friendsDiePt2Animation"
import "scripts/animations/cursedNeuronAnimation"
import "scripts/scenes/scene0050"


--[[
    This is strictly an animation sequence.  The first boss appears and destroys the two allies.
]]
class("Scene0040").extends(SegmentedScene)

function Scene0040:initialize(sceneManager)

    local segments = {}

    self.sceneManager = sceneManager

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

    self.centerActor = gfx.sprite.new(image)
    self.centerActor:setZIndex(50)
    self.centerActor:moveTo(200, 290)
    self.centerActor:add()

    self.rightActor = gfx.sprite.new(image)
    self.rightActor:setZIndex(50)
    self.rightActor:moveTo(300, 290)
    self.rightActor:add()
    self.cursedNeuron = nil

    table.insert(segments, function()
        return AnimationSegment({FriendsDiePt1Animation(self.leftActor, self.centerActor, self.rightActor)})
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0040/friendsPreDeath.txt", player, self.camera)
    end)

    table.insert(segments, function()
        return AnimationSegment({FriendsDiePt2Animation(self.leftActor, self.centerActor, self.rightActor,self.camera)})
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0040/friendsPostDeath.txt", player, self.camera)
    end)

    table.insert(segments, function()
        self.camera:wideSway()
        self.cursedNeuron = CursedNeuronAnimation(self.camera)
        return AnimationSegment({self.cursedNeuron})
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0040/cursedNeuronIntros.txt", player, self.camera)
    end)

    table.insert(segments, function()
        self.cursedNeuron:startNodeAnimation()
        return AnimationSegment({self.cursedNeuron})
    end)

    table.insert(segments, function()
        return DialogueSegment("scene0040/cursedNeuronIntros2.txt", player, self.camera)
    end)

    Scene0040.super.initialize(self, segments, sceneManager)
end

function Scene0040:completeScene()
    self.sceneManager:switchScene(Scene0050())
end

