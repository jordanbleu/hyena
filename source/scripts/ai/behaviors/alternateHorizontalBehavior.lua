import "scripts/ai/behaviors/enemyBase"

--[[
    Enemy moves straight downwards while moving horizontally left and right.
]]
class("AlternateHorizontalBehavior").extends(EnemyBase)

function AlternateHorizontalBehavior:init(idleImageTablePath, animationTime, x, y, maxHealth, playerInst, cameraInst)
    AlternateHorizontalBehavior.super.init(self, idleImageTablePath, animationTime, x, y, maxHealth, playerInst, cameraInst)

    self.ySpeed = 2

    self.moveCycleCounter = 0
    self.moveCycles = 30

end


-------------------
-- Setup methods --
-------------------

function AlternateHorizontalBehavior:withHorizontalMoveDelay(amount)
    self.moveCycles = amount
    return self
end

function AlternateHorizontalBehavior:withVerticalSpeed(amount)
    self.ySpeed = amount
    return self
end