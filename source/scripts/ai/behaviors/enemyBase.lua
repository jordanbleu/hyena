local gfx <const> = playdate.graphics

--[[
    EnemyBase is the base class for any enemy that is a sprite animation and has health,
    and also responds to player attacks.

    It provides many many hooks for different events.

    Note that default implementations are provided for collision events, these should be 
    appropriate for most enemy types.  However, if logic neesd to be EXTENDED, override the 
    method and call the base impl. If logic neesd to be OVERRIDDEN then just override the method
    and don't call base impl.
]]
class("EnemyBase").extends(SpriteAnimation)

function EnemyBase:init(idleImageTablePath, animationTime, x, y, maxHealth, playerInst, cameraInst)
    EnemyBase.super.init(self, idleImageTablePath, animationTime, x, y, false, true)
    self.player = playerInst
    self.camera = cameraInst
    self:setRemoveOnComplete(false)
    self:setRepeats(-1)

    self.maxHealth = maxHealth
    self.health = maxHealth

    local w,h = self:getSize()
    self.w = w
    self.h = h

    self:setCollideRect(0,0,w,h)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
    self.collisionsEnabled = true
end

function EnemyBase:physicsUpdate()
    EnemyBase.super.physicsUpdate(self)
    self:_checkCollisions()
    self:_checkForEmp()
end

function EnemyBase:_checkCollisions()

    if (not self.collisionsEnabled) then return end

    local collisions = self:overlappingSprites()

    if (#collisions > 0) then
        local col = collisions[1]

        if (col:isa(PlayerBullet)) then
            self:_onCollideWithBullet(col)
        elseif (col:isa(PlayerLaser)) then
            self:_onCollideWithLaser(col)
        elseif (col:isa(PlayerMissile)) then
            self:_onCollideWithMissile(col)
        elseif (col:isa(PlayerMissileExplosion)) then
            self:_onCollideWithMissileAoe(col)
        elseif (col:isa(PlayerMine)) then
            self:_onCollideWithMine(col)
        elseif (col:isa(PlayerMineExplosion)) then
            self:_onCollideWithMineAoe(col)
        end
    end
end

function EnemyBase:_checkForEmp()
    if (self.player and self.player:didUseEmp()) then
        self:_onPlayerEmp()
    end
end

function EnemyBase:damage(amount)
    self.health -= amount
    local willDie = self.health <= 0
    self:_onTakeDamage(amount,willDie)
    if (willDie) then
        self:_onDead()
    end
end


-----------------------------------------------------------------
-- Overridables -------------------------------------------------
-----------------------------------------------------------------

---Called when the enemy was attacked, and is now dead.
function EnemyBase:_onDead() end

---Called when enemy was hit with a player bullet.
function EnemyBase:_onCollideWithBullet(col)
    -- create a new explosion object at the bullets position
    local sp = SingleSpriteAnimation("images/effects/playerBulletExplosionAnim/player-bullet-explosion", 500, col.x, col.y)
    sp:setZIndex(50)
    col:destroy()
    self:damage(1)
    self.camera:smallShake()
end

---hit with a player laser
function EnemyBase:_onCollideWithLaser(col) 
    if (col.isDamageEnabled) then
        self:damage(5)
        self.camera:smallShake()
    end
end

---hit with a missile
function EnemyBase:_onCollideWithMissile(col)
    col:explode()
end

---hit with a missile AOE, or the 'explodey' part.
function EnemyBase:_onCollideWithMissileAoe(col)
    if (col.isDamageEnabled) then
        self:damage(15)
    end
end

---hit with a mine
function EnemyBase:_onCollideWithMine(col)
    col:explode()
end

---hit with a mine AOE / explodey part
function EnemyBase:_onCollideWithMineAoe(col)
    if (col.isDamageEnabled) then
        self:damage(10)
    end
end

---hit with a mine AOE / explodey part
function EnemyBase:_onPlayerEmp()
    self:damage(30)
end

function EnemyBase:_onTakeDamage(amount, willDie) end

---return true if the enemy hurts the player on collision
function EnemyBase:damageEnabled()
    return true
end

---returns an integer for how much damage the player takes on collision
function EnemyBase:getDamageAmount()
    return 5
end