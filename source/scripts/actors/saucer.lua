local gfx <const> = playdate.graphics

import "scripts/actors/basicEnemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"

--[[
    The saucer enemy (as the leader)
    will move into a random x and y position slowly, then
    it will divebomb towards the bottom.
]]
class("Saucer").extends(BasicEnemy)

local STATE <const> =
{
    -- enemy will seek out its pre-dive position
    SEEK_POSITION = 1,
    -- enemy freezes in position for a sec, giving the player time to react
    FREEZE = 2,
    -- enemy dives downwards quickly
    DIVE = 3
}


function Saucer:init(x,y,cameraInst, playerInst)
    Saucer.super.init(self, 4, cameraInst, playerInst)

    self:moveTo(x,y)

    self:setIdleSprite("images/enemies/saucer")
    self:setDeathAnimation("images/enemies/saucerAnim/death", 750)
    self:setDamageAnimation("images/enemies/saucerAnim/damage", 750)

    self.xVelocity = 0
    self.yVelocity = 0

    self.xStartPosition = 0
    self.yStartPosition = 0
    self:_chooseNewStartPosition()

    self.seekPositionSpeed = 2
    self.preDiveWaitCycles = 50
    self.preDiveWaitCycleCounter = 0

    self.yDiveSpeed = 7
    self.xDiveSpeed = 1
    self.state = STATE.SEEK_POSITION
    self:add()
end


function Saucer:_velocityUpdate()
    if (self.state == STATE.SEEK_POSITION) then
        self:_seekPosition()
    elseif (self.state == STATE.FREEZE) then
        self:_waitForDive()
    elseif (self.state == STATE.DIVE) then
        self:_dive()
    end
    
    self:_checkBounds()
end

function Saucer:_seekPosition()

    local atX = math.isWithin(self.x, self.seekPositionSpeed, self.xStartPosition)
    local atY = math.isWithin(self.y, self.seekPositionSpeed, self.yStartPosition)
    
    if (atX and atY) then
        self.state = STATE.FREEZE
    end

    if (atX) then
        self.xVelocity = 0
    elseif (self.x < self.xStartPosition) then
        self.xVelocity = self.seekPositionSpeed
    else
        self.xVelocity = -self.seekPositionSpeed
    end

    if (atY) then
        self.yVelocity = 0
    elseif (self.y < self.yStartPosition) then
        self.yVelocity = self.seekPositionSpeed
    else
        self.yVelocity = -self.seekPositionSpeed
    end
end

function Saucer:_waitForDive()
    self.xVelocity = 0
    self.yVelocity = 0
    self.preDiveWaitCycleCounter += 1

    if (self.preDiveWaitCycleCounter > self.preDiveWaitCycles) then
        self.state = STATE.DIVE
        self.preDiveWaitCycleCounter = 0
    end
end

function Saucer:_dive()
    self.yVelocity = self.yDiveSpeed

    self.xVelocity = 0

    if (math.isWithin(self.x, self.xDiveSpeed, self.player.x)) then
        return
    end
    
    if (self.x > self.player.x) then
        self.xVelocity = -self.xDiveSpeed
    else 
        self.xVelocity = self.xDiveSpeed
    end
end

function Saucer:_updateMovement()
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity

    self:moveTo (newX, newY)
end

function Saucer:_chooseNewStartPosition()
    self.xStartPosition = math.random(50,350)
    self.yStartPosition = math.random(25,75)
end

function Saucer:_checkBounds()

    if (self.y > 300) then
        self:moveTo(200, -50)
        self:_chooseNewStartPosition()
        self.state = STATE.SEEK_POSITION
    end

end

function Saucer:_whenLeaderDies()
    -- if the follower's leader dies, he will slowly fly back up 
    -- to the top, up through the screen.
    self.state = STATE.SEEK_POSITION
    self:_chooseNewStartPosition()
end

---How fast the enemy moves into its pre-diving position
function Saucer:withPositionSeekSpeed(speed)
    self.seekPositionSpeed = speed
    return self
end

---How fast the enemy dives.  Keep xspeed low, it is how fast the enemy moves towards player
function Saucer:withDiveSpeed(xspd, yspd)
    self.xDiveSpeed = xspd
    self.yDiveSpeed = yspd
    return self
end



