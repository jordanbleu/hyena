local gfx <const> = playdate.graphics

import 'scripts/actors/actor'

--[[ Bullet that damages any enemies. ]]
class("PlayerBullet").extends(Actor)

function PlayerBullet:init(x,y, playerInst)
    PlayerBullet.super.init(self)
    self.player = playerInst
    self.yVelocity = -16
    self.xVelocity = 0

    self.isActive = true

    local sceneManager = gameContext.getSceneManager()
    local image = sceneManager:getImageFromCache("images/projectiles/player-bullet")
    self:setImage(image)

    self:moveTo(x,y)
    self:setCollideRect(0,0,self:getSize())
    self:setGroups({COLLISION_LAYER.PLAYER_PROJECTILE})
    self:add()

end

function PlayerBullet:update()
    PlayerBullet.super.update(self)

    if (self.y < -40) then
        self:remove()
    end

    if (self.y > 250) then
        self:remove()
    end

end


function PlayerBullet:physicsUpdate()
    PlayerBullet.super.physicsUpdate(self)

    if (self.isActive) then 
        local newX = self.x + self.xVelocity
        local newY = self.y + self.yVelocity
        self:moveTo(newX, newY)
    end



end

-- call when the bullet hits something.  enemyHit 
function PlayerBullet:destroy(isEnvironmentalObject)
    isEnvironmentalObject = isEnvironmentalObject or false
    -- if an enemy was hit
    if (not isEnvironmentalObject) then
        DATA.GAME.Statistics.TotalHits+=1
        self.player:addEnergy()
        
    end
    self.isActive = false
    self:remove()
end

function PlayerBullet:ricochet()
    self.yVelocity = -self.yVelocity
    self.xVelocity = math.random(-3, 3)
    local newX = self.x + self.xVelocity
    local newY = self.y + self.yVelocity
    self:moveTo(newX, newY)
end
