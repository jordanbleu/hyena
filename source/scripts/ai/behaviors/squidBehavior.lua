import "scripts/ai/behaviors/enemyBase"

--[[
    Enemy will propel vaguely towards the player.  
    It moves in short bursts, with smooth deceleration.
    On each burst it will always move diagonally towards the player.
]]
class("SquidBehavior").extends(EnemyBase)

local STATES <const> = 
{
    -- Enemy is moving towwards the player 
    IDLE = 0,
    -- Enemy took damage, and is stopped for a sec
    DAMAGE = 1,
    -- Enemy died
    DYING = 2
}


function SquidBehavior:init(idleImageTablePath, animationTime, x, y, maxHealth, playerInst, cameraInst)
    SquidBehavior.super.init(self, idleImageTablePath, animationTime, x, y, maxHealth, playerInst, cameraInst)

    self.state = STATES.IDLE

    self.xVelocity = 0
    self.yVelocity = 0

    -- how long enemy freezes when damaged 
    self.damageWaitCycles = 50
    self.damageWaitCycleCounter = 0

    -- how long he wait between bursts
    self.waitCycleCounter = 0
    self.waitCycles = math.random(20,50)

    -- how fast he slow down
    self.drag = 0.1

    -- speed of vertical burst towards bottom of screen
    self.ySpeed = math.random(2,3)
    -- speed of horizontal burst towards player 
    self.xSpeed = math.random(1,2)

    ----
    -- Override the below in child classes, aniamtions will play automatically.
    ----

    self.damageAnimationImagePath = nil
    self.damageAnimationTime = 500
    
    self.deathAnimationImagePath = nil
    self.deathAnimationTime = 500

end

function SquidBehavior:physicsUpdate()
    SquidBehavior.super.physicsUpdate(self)

    if (self.state == STATES.IDLE) then
        self:_checkBounds()
        self:_move()

    elseif (self.state == STATES.DAMAGE) then
        self.damageWaitCycleCounter += 1
        if (self.damageWaitCycleCounter > self.damageWaitCycles) then
            self.damageWaitCycleCounter = 0
            self.state = STATES.IDLE
        end

    elseif (self.state == STATES.DYING) then
        self.xVelocity = 0
        self.yVelocity = 0

    end
end

function SquidBehavior:_move()

    self.xVelocity = math.moveTowards(self.xVelocity, 0, self.drag)
    self.yVelocity = math.moveTowards(self.yVelocity, 0, self.drag)

    self.waitCycleCounter += 1

    if (self.waitCycleCounter > self.waitCycles) then
        self.waitCycleCounter = 0

        self.yVelocity = self.ySpeed

        if (self.player.x > self.x) then
            self.xVelocity = self.xSpeed
        else 
            self.xVelocity = -self.xSpeed
        end
    end

    local newX = self.x + self.xVelocity 
    local newY = self.y + self.yVelocity 
    self:moveTo(newX, newY)
end

function SquidBehavior:_checkBounds()
    if (self.y > 240) then
        self:moveTo(self.x, -(self.h*2))
    end
end

-------------------
-- Overrides     --
-------------------

function SquidBehavior:_onTakeDamage(amount, willDie) 
    if (willDie) then return end

    if (self.damageAnimationImagePath ~= nil) then
        SingleSpriteAnimation(self.damageAnimationImagePath, self.damageAnimationTime, self.x, self.y)
    end

    self.state = STATES.DAMAGE
end

function SquidBehavior:_onDead()
    self.collisionsEnabled = false
    self.state = STATES.DYING

    if (self.deathAnimationImagePath ~= nil) then
        SingleSpriteAnimation(self.deathAnimationImagePath, self.deathAnimationTime, self.x, self.y)
    end

    self:remove()
end


-------------------
-- Setup methods --
-------------------

function SquidBehavior:withDrag(dragAmount)
    self.drag = dragAmount
    return self
end

function SquidBehavior:withHorizontalBurstSpeed(amt)
    self.xSpeed = amt
    return self
end

function SquidBehavior:withVerticalBurstSpeed(amt)
    self.ySpeed = amt
    return self
end

function SquidBehavior:withBurstDelay(time)
    self.waitCycles = time
    return self
end
