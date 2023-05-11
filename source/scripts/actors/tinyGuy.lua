local gfx <const> = playdate.graphics

import "scripts/actors/leaderFollowerEnemy"
import "scripts/sprites/singleSpriteAnimation"
import "scripts/sprites/spriteAnimation"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/playerMissileExplosion"
import "scripts/projectiles/playerMine"
import "scripts/projectiles/playerMineExplosion"

--[[
    Enemies that flow in a sorta snake-like fashion left to right
]]
class("TinyGuy").extends(LeaderFollowerEnemy)


function TinyGuy:init(x,y,leader, cameraInst, playerInst)
    TinyGuy.super.init(self, x, y, leader, 2, cameraInst, playerInst)

    self:moveTo(x,y)

    -- idle image
    local sm = gameContext.getSceneManager()
    local idleSprite = sm:getImageFromCache("images/enemies/bubble-guy")

    self:setIdleImage(idleSprite)
    self:setDeathAnimation("images/enemies/bubbleGuyAnim/death", 750)
    self:setDamageAnimation("images/enemies/bubbleGuyAnim/damage", 750)
    self:setFollowerBehavior(8,2)

    -- behavior stuff - leader
    self.xSpeed = 2
    self.ySpeed = 0.5
    self.xVelocity = self.xSpeed
    self.yVelocity = self.ySpeed

    self:add()
end


function TinyGuy:_leaderUpdate()
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    
    -- bounce left and right, but each time you bounce,
    -- y position moves up a bit
    if (newX > 400 or newX < 0) then
        self.xVelocity = -self.xVelocity
        self.yVelocity = -self.ySpeed * 2
    end
    
    -- move velocity towards y speed so the tiny guy starts going downward again 
    self.yVelocity = math.moveTowards(self.yVelocity, self.ySpeed, 0.02)
    
    self:moveTo(newX, newY)
end
