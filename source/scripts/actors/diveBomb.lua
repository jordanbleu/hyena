--[[
    The divebomb enemy moves downwards quickly.  Each time it reaches the bottom it hard set to the player's x position.
]]
class("DiveBomb").extends(Enemy)

function DiveBomb:init(x,y,cameraInst, playerInst)
    DiveBomb.super.init(self, 1)
    self.player = playerInst
    self.camera = cameraInst

    -- idle image animation
    self.animator = SpriteAnimation("images/enemies/celluloidAnim/idle", 1500, self.x, self.y)
    self.animator:setRepeats(-1)

    self:setCollideRect(-8,-8,16,16)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})

    self.ySpeed = 2.5

    self:moveTo(x,y)
    self:add()
end


function DiveBomb:physicsUpdate()
    DiveBomb.super.physicsUpdate(self)

    self.animator:moveTo(self.x, self.y)
    local newY = self.y + self.ySpeed
    self:moveTo(self.x, newY)
end

function DiveBomb:update()
    DiveBomb.super.update(self)

    if (self.y > 250) then
        local newY = math.random(-50,-20)
        local newX = self.player.x + math.random(-20, 20)

        self:moveTo(newX, newY)
    end

    self:_checkCollisions()

end


function DiveBomb:_checkCollisions()
    local collisions = self:overlappingSprites()

    for i,col in ipairs(collisions) do
        if (col:isa(PlayerBullet)) then
            col:destroy()
            self:damage(2)

            if (self.camera) then
                self.camera:smallShake()
            end

        elseif (col:isa(PlayerLaser)) then
            if (col.isDamageEnabled) then
                self:damage(5)
            end

        elseif (col:isa(PlayerMissile)) then
            col:explode()

        elseif (col:isa(PlayerMissileExplosion)) then
            if (col.isDamageEnabled) then
                self:damage(15)
            end
        
        elseif (col:isa(PlayerMine)) then
            col:explode()

        elseif (col:isa(PlayerMineExplosion)) then
            if (col.isDamageEnabled) then
                self:damage(10)
            end
        end

    end
end

function DiveBomb:_onDead()
    SingleSpriteAnimation("images/enemies/celluloidAnim/death", 1000, self.x, self.y)
    self:remove()
end

function DiveBomb:remove()
    self.animator:remove()
    DiveBomb.super.remove(self)
end