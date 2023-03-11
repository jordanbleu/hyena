local gfx <const> = playdate.graphics

import "scripts/actors/enemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"
import "scripts/projectiles/enemyBullet"

--[[
    The ranged grunt enemy stays back and fires bullets at the player
]]
class("RangedGrunt").extends(Enemy)

-- this is the general y position for ranged enemies
local STANDARD_Y_POSITION <const> = 60
-- how far above or below the standard Y the enemy can move 
local Y_POSITION_VARIANCE <const> = 20

local Y_MOVE_WAIT_TIME_MIN <const> = 30
local Y_MOVE_WAIT_TIME_MAX <const> = 100


function RangedGrunt:init(x,y, playerInst) 

    RangedGrunt.super.init(self, 3)
    self:moveTo(x,y)

    self.player = playerInst

     -- note that the range grunt IS it's own image...which differs from the other (animated) enemy classes
    self:setImage(gfx.image.new ("images/enemies/ranged-enemy"))
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

    -- behavior stuff
    self.moveSpeed = 1
    self.yDestination = STANDARD_Y_POSITION + math.random(-Y_POSITION_VARIANCE, Y_POSITION_VARIANCE)

    -- enemy chooses a new y position after a wait time 
    self.yMoveWaitCycleCounter = 0
    self.yMoveWaitCycles = math.random(Y_MOVE_WAIT_TIME_MIN,Y_MOVE_WAIT_TIME_MAX)

    -- how long before enemy can shoot 
    self.coolDownCycleCounter = 0
    self.coolDownCycles = math.random(100,300)

    self:add()
    
end

function RangedGrunt:update()
    RangedGrunt.super.update(self)

    if (self.yMoveWaitCycleCounter > self.yMoveWaitCycles) then
        self.yDestination = STANDARD_Y_POSITION + math.random(-Y_POSITION_VARIANCE, Y_POSITION_VARIANCE)

        self.yMoveWaitCycles = math.random(Y_MOVE_WAIT_TIME_MIN,Y_MOVE_WAIT_TIME_MAX)
        self.yMoveWaitCycleCounter = 0
    end

     if (self.coolDownCycleCounter >= self.coolDownCycles) then
        -- once cooldown is ready we actually wait until the player enters 
        -- our field of view:

        if (math.isWithin(self.player.x, 3, self.x)) then
            EnemyBullet(self.x, self.y)
            self.coolDownCycles = math.random(30,200)
            self.coolDownCycleCounter = 0
        end
            
     end

end


function RangedGrunt:physicsUpdate()
    RangedGrunt.super.physicsUpdate(self)
    self.yMoveWaitCycleCounter+= 1
    
    if (self.coolDownCycleCounter < self.coolDownCycles) then
        self.coolDownCycleCounter += 1
    end

    self:_moveToDestination()

end

-- move towards the player
function RangedGrunt:_moveToDestination()
    local newX = self.x
    local newY = self.y

    if (self.x > self.player.x) then
        newX -= self.moveSpeed
    elseif (self.x < self.player.x) then
        newX += self.moveSpeed    
    end

    if (self.y > self.yDestination) then
        newY -= self.moveSpeed
    elseif (self.x < self.yDestination) then
        newY += self.moveSpeed
    end

    newX = math.snap(newX, self.moveSpeed/2, self.player.x)
    newY = math.snap(newY, self.moveSpeed/2, self.yDestination)

    self:moveTo(newX, newY)

end