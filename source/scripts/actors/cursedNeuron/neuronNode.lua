local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"


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
    self.state = STATE.ALIVE

    self.maxHealth = 3
    self.health = self.maxHealth 

    self.reviveCycleCounter = 0
    self.reviveCycles = 250

    self.idleImage = gfx.image.new("images/bosses/cursedNeuron/node/node-idle")
    self.deadImage = gfx.image.new("images/bosses/cursedNeuron/node/node-dead")
    
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    self:setZIndex(25)
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