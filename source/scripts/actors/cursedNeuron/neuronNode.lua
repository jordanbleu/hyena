local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"


--[[ 
    There are four neuron nodes that protect the cursed neuron
]] 
class("NeuronNode").extends(Actor)

local STATE <const> = {
    IDLE = 0,
    DEAD = 1
}

function NeuronNode:init(playerInst, cameraInst)
    NeuronNode.super.init(self)
    self.state = STATE.IDLE

    self.health = 5

    self.reviveCycleCounter = 0
    self.reviveCycles = 150

    self.idleImage = gfx.image.new("images/bosses/cursedNeuron/node/node-idle")
    self.deadImage = gfx.image.new("images/bosses/cursedNeuron/node/node-dead")
    
    self:setImage(self.idleImage)
    self:add()

end