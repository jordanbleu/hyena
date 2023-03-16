local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

--[[ Makes bullets ricochet. ]]
class("Deflector").extends(SingleSpriteAnimation)

function Deflector:init(playerInst)
    Deflector.super.init(self, "images/projectiles/deflectorAnim/deflector", 750, playerInst.x, playerInst.y)
    self.didDamage = false

    -- really this is 'isDeflectionEnabled' 
    self.isDamageEnabled = false

    self.hasBegunShield = false
    self.hasFinishedShield = false

    self.shieldCycleCounter = 0
    self.shieldCycles = 120

    self:moveTo(playerInst.x,playerInst.y)
    self:setCollideRect(-24,-24,48,48)
    self:setGroups({COLLISION_LAYER.PROJECTILE_DEFLECTOR})
    self:add()
    self:attachTo(playerInst)
end

function Deflector:update()
    Deflector.super.update(self)

    local frame = self:getFrame()

    -- once we hit frame 7, pause the animation 
    if (frame==7) then
        
        if (not self.hasFinishedShield and not self.hasBegunShield) then
            -- the first time we hit frame 7, pause animation
            self:pause()
            self.hasBegunShield = true
        else 
            -- wait for a bit
            self.shieldCycleCounter += 1
            -- once we've finished waiting, play the animation again
            if (self.shieldCycleCounter > self.shieldCycles) then
                self.hasFinishedShield = true
                self:play()
            end

        end


    end

    if (frame > 4 and frame <= 7) then
        self.isDamageEnabled = true
    else
        self.isDamageEnabled = false
    end

end