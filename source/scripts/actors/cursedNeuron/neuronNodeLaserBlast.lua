local gfx <const> = playdate.graphics

import "scripts/projectiles/enemyProjectileSprite"

--[[ 
    There are four neuron nodes that protect the cursed neuron
]] 
class("NeuronNodeLaserBlast").extends(EnemyProjectileSprite) 


function NeuronNodeLaserBlast:init(x, y, cameraInst, playerInst)
    self.camera = cameraInst
    self.player = playerInst

    self.didDamage = false
    self.isDamageEnabled = false

    self:setCollideRect(x-2,y-120,4,240)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()
    PlayerLaser.super.init(self, 'images/projectiles/playerLaserAnim/playerLaser', 1500, x, y)
end

function NeuronNodeLaserBlast:update()

    NeuronNodeLaserBlast.super.update(self)

    local frame = self:getFrame()

    self.isDamageEnabled = false
    if (frame == 5) then
        -- we do damage for one single update cycle, starting at image frame 6
        if (not self.didDamage) then

            if (self.camera) then
                self.camera:smallShake()
            end
            self.isDamageEnabled = true
            self.didDamage = true
        end
    end

end

function NeuronNodeLaserBlast:getDamageAmount()
    return 20
end

function NeuronNodeLaserBlast:damageEnabled()
    return self.isDamageEnabled
end