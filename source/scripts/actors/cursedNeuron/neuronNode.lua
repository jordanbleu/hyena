local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"
import "scripts/actors/cursedNeuron/neuronNodeLaserBlast"


--[[ 
    There are four neuron nodes that protect the cursed neuron
]] 
class("NeuronNode").extends(Actor)

local STATE <const> = {
    ALIVE = 0,
    DEAD = 1
}

function NeuronNode:init(playerInst, cameraInst)
    NeuronNode.super.init(self)
    
    self.camera = cameraInst
    self.player = playerInst

    self.preActiveCycleCounter = 0
    self.preActiveCycles = 150
    
    self.state = STATE.ALIVE

    self.maxHealth = 3
    self.health = self.maxHealth 

    self.reviveCycleCounter = 0
    self.reviveCycles = 300

    self.idleImage = gfx.image.new("images/bosses/cursedNeuron/node/node-idle")
    self.deadImage = gfx.image.new("images/bosses/cursedNeuron/node/node-dead")
    
    -- shooting behavior 
    self.shootCycleCounter = 0
    self.shootCycles = 100
    -- how far to the left / rigth the player can be and the node shoots
    self.shootRange = 32
    self.shootCyclesMin = 100
    self.shootCyclesMax = 300


    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    self:setZIndex(23)
    self:setImage(self.idleImage)
    self:setCollideRect(0,0,self:getSize())
    self:add()

end

function NeuronNode:update()
    NeuronNode.super.update(self)

    if (self.state == STATE.ALIVE) then
        self:setImage(self.idleImage)
        self:_checkCollisions()
        if (self.health < 0) then
            self.state = STATE.DEAD
        end

    elseif (self.state == STATE.DEAD) then
        self:setImage(self.deadImage)

        self.reviveCycleCounter += 1
        if (self.reviveCycleCounter > self.reviveCycles) then
            self.reviveCycleCounter = 0
            SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500, self.x, self.y)
            local anim = SingleSpriteAnimation("images/bosses/cursedNeuron/node/nodeAnim/heal", 500,self.x, self.y, function() self:_revive() end)
            anim:attachTo(self)
            anim:setZIndex(26)
        end
    end

end

function NeuronNode:physicsUpdate()
    NeuronNode.super.physicsUpdate(self)

    if (self.preActiveCycleCounter < self.preActiveCycles) then
        self.preActiveCycleCounter += 1
        return
    end

    if (self.state == STATE.ALIVE) then
        self:_shootAtPlayer()
    end

end

function NeuronNode:_revive()
    self.health = self.maxHealth
    self.state = STATE.ALIVE
end

function NeuronNode:_checkCollisions()
    local collisions = self:overlappingSprites()

    local tookDamage =false

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            local bulletAnim = SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500,col.x, col.y)
            bulletAnim:setZIndex(30)

            col:destroy()
            tookDamage = true
        end
    end

    if (tookDamage) then
        self.camera:smallShake()
        local anim = SingleSpriteAnimation("images/bosses/cursedNeuron/node/nodeAnim/damage", 500,self.x, self.y)
        anim:attachTo(self)
        anim:setZIndex(26)
        self.health -= 1
    end

end

function NeuronNode:isAlive()
    return (self.state == STATE.ALIVE)
end

function NeuronNode:_shootAtPlayer()
    -- first wait for shoot cycles
    if (self.shootCycleCounter < self.shootCycles) then
        self.shootCycleCounter += 1
        return
    end

    local min = self.x - self.shootRange
    local max = self.x + self.shootRange

    if (self.player.x > min and self.player.x < max) then
        NeuronNodeLaserBlast(self.x, self.y+125)
        self.shootCycles = math.random(self.shootCyclesMin, self.shootCyclesMax)
        self.shootCycleCounter = 0
    end

end