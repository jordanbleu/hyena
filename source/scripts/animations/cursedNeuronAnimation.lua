local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"
import "scripts/actors/cursedNeuron/neuronNode"
import "scripts/actors/diveBomb"
import "scripts/actors/grunt"
import "scripts/effects/screenFlash"

--[[ 
    Used for cinematics around the cursed neuron, cuz the main lua class is already too huge.
]] 
class("CursedNeuronAnimation").extends(Actor)

local STATE = {
    -- enemy flies in from the top
    APPEAR_ONSCREEN = 1,
    -- after some dialogue, the nodes / shield appear 
    NODES_FLY_IN = 2,
    DEATH = 3
}

function CursedNeuronAnimation:init(cameraInst)

    self.camera = cameraInst
    self.animationComplete = false
    self.state = STATE.APPEAR_ONSCREEN

    CursedNeuronAnimation.super.init(self)

    self:moveTo(200, -100)
    -- parts

    self.animator = gfx.animator.new(3000, -100, 40, playdate.easingFunctions.outBack)

    -- the 'eye' / nucleus thing
    self.eyeSprite = SpriteAnimation("images/bosses/cursedNeuron/eyeAnim/idle", 1000, self.x, self.y)
    self.eyeSprite:setZIndex(23)
    self.eyeSprite:setRepeats(-1)
    
    -- outer bits, or 'flesh' or whatever you call it is really just separate independent animations

    local centerImg = gfx.image.new("images/bosses/cursedNeuron/flesh-middle")
    local fleshAnimSpeed = 750

    -- 2d array of the flesh sprites, first index being the row and second being the column
    self.fleshSprites = {}

    for i=1, 4 do
        self.fleshSprites[i] = {}
    end

    -- top left corner
    self.fleshSprites[1][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-left", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[2][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y, false, false)

    self.fleshSprites[2][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][2]:add()

    self.fleshSprites[2][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][3]:add()

    self.fleshSprites[2][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[3][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y, false, false)

    self.fleshSprites[3][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][2]:add()

    self.fleshSprites[3][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][3]:add()
    
    self.fleshSprites[3][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-left", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-right", fleshAnimSpeed, self.x, self.y, false, false)

    self.armTopRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topright", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armTopRightSprite:setZIndex(22)
    self.armTopRightSprite:setRepeats(-1)

    self.armTopLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topleft", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armTopLeftSprite:setZIndex(22)
    self.armTopLeftSprite:setRepeats(-1)

    self.armBottomLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomleft", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armBottomLeftSprite:setZIndex(22)
    self.armBottomLeftSprite:setRepeats(-1)

    self.armBottomRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomright", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armBottomRightSprite:setZIndex(22)
    self.armBottomRightSprite:setRepeats(-1)

    -- kinda lazy code below
    for r,row in ipairs(self.fleshSprites) do
        for c,col in ipairs(row) do
            local o = self.fleshSprites[r][c]
            o:setZIndex(21)
            o:setCenter(0,0)
            if (o:isa(SpriteAnimation)) then
                o:setRepeats(-1)
            end
        end   
    end

    self.leftNode = gfx.sprite.new(gfx.image.new("images/bosses/cursedNeuron/node/node-idle"))
    self.leftNode:add()
    self.leftNode:setVisible(false)
    self.bottomNode = gfx.sprite.new(gfx.image.new("images/bosses/cursedNeuron/node/node-idle"))
    self.bottomNode:add()
    self.bottomNode:setVisible(false)
    self.rightNode = gfx.sprite.new(gfx.image.new("images/bosses/cursedNeuron/node/node-idle"))
    self.rightNode:add()
    self.rightNode:setVisible(false)

    self.shieldSprite = gfx.sprite.new(gfx.image.new("images/bosses/cursedNeuron/shield"))
    self.shieldSprite:setVisible(false)
    self.shieldSprite:setZIndex(24)
    self.shieldSprite:add()

    self.leftConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/horizontal", 200, self.x, self.y, false, false)
    self.leftConnector:setRepeats(-1)
    self.leftConnector:setVisible(false)
    self.rightConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/horizontal", 200, self.x, self.y, false, false)
    self.rightConnector:setRepeats(-1)
    self.rightConnector:setVisible(false)
    self.bottomConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/vertical", 200, self.x, self.y, false, false)
    self.bottomConnector:setRepeats(-1)
    self.bottomConnector:setVisible(false)

    self.deathCycleCounter = 0
    self.deathCycles = 150

    self.timer = nil
    self:_moveAllSprites()
    self:add()
end

function CursedNeuronAnimation:update()
    self:_moveAllSprites()

    if(not self.state == STATE.DEATH) then
        self:moveTo(self.x, self.animator:currentValue())
    end
    
    if (self.state == STATE.NODES_FLY_IN) then
        self:_updateNodesAnimation()
        return
    end

    if (self.state == STATE.DEATH) then

        self.deathCycleCounter += 1

        local boomRecurrence = 10
        if (math.fmod(self.deathCycleCounter, boomRecurrence) == 0) then
            local eX = self.x + math.random(-32, 32)
            local eY = self.y + math.random(-32, 32)
            local spr = SingleSpriteAnimation('images/effects/explosionAnim/explosion', 500, eX, eY)
            spr:setZIndex(50)
            self.camera:bigShake()
        end

    end
end

function CursedNeuronAnimation:startNodeAnimation()
    self.state = STATE.NODES_FLY_IN
    -- using the animator as a timer here because it has more of the method i need lol 
    self.animator = gfx.animator.new(3000, self.y,50)
end

function CursedNeuronAnimation:startDeathAnimation()
    self:moveTo (self.x, 40)
    self.leftNode:setVisible(true)
    self.rightNode:setVisible(true)
    self.bottomNode:setVisible(true)
    self.state = STATE.DEATH
end

function CursedNeuronAnimation:_updateNodesAnimation()
    local percent = self.animator:progress()

    if (percent > 0.95) then
        if (not self.rightNode:isVisible()) then
            self.camera:smallShake()
        end
        self.shieldSprite:setVisible(true)
        self.rightNode:setVisible(true)
        self.rightConnector:setVisible(true)
    elseif (percent > 0.5) then
        if (not self.bottomNode:isVisible()) then
            self.camera:smallShake()
        end
        self.bottomNode:setVisible(true)
        self.bottomConnector:setVisible(true)
    elseif (percent > 0.1) then 
        if (not self.leftNode:isVisible()) then
            self.camera:smallShake()
        end
        self.leftNode:setVisible(true)
        self.leftConnector:setVisible(true)
    end

end

function CursedNeuronAnimation:_moveAllSprites()
    -- this assumes that each section of the flesh portion is 16x16
    local startX = -32
    local startY = -32
    local size = 16

    for r,row in ipairs(self.fleshSprites) do
        for c,col in ipairs(row) do
           
            -- -- unadjusted locations
            local xx = self.x + ((c-1) * size)
            local yy = self.y + ((r-1) * size)

            local newX = xx + startX
            local newY = yy + startY
            self.fleshSprites[r][c]:moveTo(newX,newY)
        end   
    end

    self.eyeSprite:moveTo(self.x, self.y) -- this will eventaully be different
    self.armTopRightSprite:moveTo(self.x+36,self.y-36)
    self.armTopLeftSprite:moveTo(self.x-36,self.y-36)
    self.armBottomLeftSprite:moveTo(self.x-36,self.y+36)
    self.armBottomRightSprite:moveTo(self.x+36,self.y+36)

    self.leftNode:moveTo(self.x - 100, self.y)
    self.rightNode:moveTo(self.x + 100, self.y)
    self.bottomNode:moveTo(self.x, self.y + 100)
    self.shieldSprite:moveTo(self.x, self.y)

    self.leftConnector:moveTo(self.x-80, self.y)
    self.rightConnector:moveTo(self.x+80, self.y)
    self.bottomConnector:moveTo(self.x, self.y+80)
end

function CursedNeuronAnimation:remove()
    for r,row in ipairs(self.fleshSprites) do
        for c,col in ipairs(row) do
            self.fleshSprites[r][c]:remove()
        end
    end

    self.leftNode:remove()
    self.eyeSprite:remove()
    self.rightNode:remove()
    self.bottomNode:remove()
    self.leftConnector:remove()
    self.rightConnector:remove()
    self.bottomConnector:remove()
    self.armTopLeftSprite:remove()
    self.armTopRightSprite:remove()
    self.armBottomLeftSprite:remove()   
    self.armBottomRightSprite:remove()

    CursedNeuronAnimation.super.remove(self)
end


function CursedNeuronAnimation:isCompleted()
    if (self.state == STATE.DEATH) then
        return self.deathCycleCounter == self.deathCycles
    end
    return self.animator:ended()
end

