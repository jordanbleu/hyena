local gfx <const> = playdate.graphics

import "scripts/projectiles/playerBullet"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/deflector"
import "scripts/actors/actor"
import "scripts/physics/physicsTimer"
import "scripts/effects/screenFlash"
import "scripts/ui/livesIndicator"
import "scripts/scenes/ui/deathScreen"
import "scripts/powerups/powerup"

-- How much speed increases per frame when accelerating 
local MOVE_SPEED <const> = 1
-- Max speed overall of your ship
local MAX_VELOCITY <const> = 4
-- Deceleration rate.  Higher numbers make ship stop faster, lower makes the ship more floaty
local DECELERATION_RATE = 0.2
-- speed of the dash
local DASH_SPEED <const> = 25

-- how long to hold the A button before using weapon.
local HOLD_A_CYCLES_TO_WAIT <const> = 10
local HOLD_B_CYCLES_TO_WAIT<const> = 5

local STATE <const> = {
    ALIVE = 1,
    WAITING_TO_DIE =2,
    DYING = 3, 
    WAITING_TO_REVIVE = 4,
    REVIVING = 5
}

--[[
    This is the player object, for normal gameplay
]]
class("Player").extends(Actor)

function Player:init(cameraInst, sceneManagerInst)
    Player.super.init(self)
   
    self.sceneManager = sceneManagerInst

    -- blocks attacking for the weapon selector or cinematic moments
    self.allowAttacks = true

    -- how long the user has held A without releasing it.
    self.holdACycles = 0
    -- how long the user has held B without releasing it.
    self.holdBCycles = 0

    self.maxHealth = 100
    self.health = self.maxHealth
    self.maxEnergy = 100
    self.energy = self.maxEnergy

    self.dashVelocity = 0
    self.lastHorizontalDirection = 1

    self.camera = cameraInst

    self.selectedWeapon = WEAPON.NONE

    self.energyRefillTimer = PhysicsTimer(50, function() self:_refillEnergy() end)
    self.xVelocity = 0
    self.yVelocity = 0
    self:setImage(gfx.image.new("images/player"))
    self:setZIndex(25)
    self:setGroups({COLLISION_LAYER.PLAYER})
    self:setCollidesWithGroups(COLLISION_LAYER.ENEMY, COLLISION_LAYER.ENEMY_PROJECTILE, COLLISION_LAYER.POWERUP)
    self:add()

    local blackScreenImage = gfx.image.new("images/black")
    self.blackScreenSprite = gfx.sprite.new(blackScreenImage)
    self.blackScreenSprite:setZIndex(24)
    self.blackScreenSprite:setIgnoresDrawOffset(true)
    self.blackScreenSprite:setVisible(false)
    self.blackScreenSprite:moveTo(200,120)
    self.blackScreenSprite:add()
    
    local w,h = self:getSize()
    self:setCollideRect(0,0,self:getSize())

    -- set to true when some UI element or something has taken focus.
    self.isControlsLocked = false

    self.iframeCounter = 0
    self.iframes = 50

    self.lives = 3
    self.state = STATE.ALIVE
    
    -- generic cycle counter for death animation and stuff (depends on state)
    self.cycleCounter = 0
    -- time to wait between death animation and revive animation 
    self.postDeathWaitCycles = 100
    -- time to wait before showing death animation
    self.preDeathWaitCycles = 50

    self.usedEmp = false

    self.invincible = false
end

function Player:update()
    Player.super.update(self)

    if (self.state == STATE.ALIVE) then

        if (self.health <= 0) then
            self:_beginToDie()
        end

        if (self.usedEmp) then
            self.usedEmp = false
        end
    
        self:_handlePlayerInput()
        self:_checkCollisions()
    elseif (self.state == STATE.WAITING_TO_REVIVE) then
        self.cycleCounter += 1
        if (self.cycleCounter > self.postDeathWaitCycles) then
            self.cycleCounter = 0
            self:_revive()
        end
    elseif (self.state == STATE.WAITING_TO_DIE) then
        self.cycleCounter+=1
        if (self.cycleCounter > self.preDeathWaitCycles) then
            self.cycleCounter = 0
            self:_die()
        end
    elseif (self.state == STATE.REVIVING) then
        -- neat little health increasing animation 
        if (self.health < self.maxHealth) then
            self.health += 5
        end

        if (self.energy < self.maxEnergy) then
            self.energy += 5
        end

    end
end

function Player:physicsUpdate()
    Player.super.physicsUpdate(self)

    if (self.state == STATE.ALIVE) then
        if (self.iframeCounter > 0) then
            self.iframeCounter -= 1
        end
        
        self:_handleMovement()
        self:_decelerate()
    end
end

-- player died, show the death animation
function Player:_beginToDie()
    ScreenFlash(500, gfx.kColorWhite)
    self.lives -= 1
    self.state = STATE.WAITING_TO_DIE
    self.blackScreenSprite:setVisible(true)
end

function Player:_die()
    self.camera:massiveSway()
    self.state = STATE.DYING
    self:setVisible(false)
    local deathAnimation = SingleSpriteAnimation("images/playerAnim/death", 500, self.x, self.y, function() self:_beginWaitingToRevive() end)
    deathAnimation:setZIndex(27)

    if (self.lives >=0) then
        LivesIndicator(self.lives)
    end
end

-- death animation finished, now we wait a sec before reviving
function Player:_beginWaitingToRevive() 
    self.state = STATE.WAITING_TO_REVIVE
end

-- show revive animation
function Player:_revive()
    if (self.lives <0) then
        self.sceneManager:switchScene(DeathScreen(), SCENE_TRANSITION.FADE_IO)
        self.state = STATE.REVIVING
    else
        self.blackScreenSprite:setVisible(false)
        self.state = STATE.REVIVING
        local sf = ScreenFlash(1000, gfx.kColorBlack)
        sf:setZIndex(24)
    
        local reviveAnimation = SingleSpriteAnimation("images/playerAnim/revive", 1000, self.x, self.y, function() self:_alive() end)
        reviveAnimation:setZIndex(27)
    end
end

-- revivve animation completed, now we're alive again 
function Player:_alive()
    Deflector(self)
    self.iframeCounter = self.iframes
    self.state = STATE.ALIVE
    self.health = 100
    self:setVisible(true)
end

--[[

    Common collisions are checked here.  This includes common enemies, projectiles, etc.

    This is to limit most collision logic to a single check.

    Uncommon projectiles such as those in boss battles should be checked from those objects instead,
    so that this method is not bogged down.

]]
function Player:_checkCollisions()
    
    local tookDamage = false
    local totalDamageAmount = 0
    local collisions = self:overlappingSprites()

    for i,col in ipairs(collisions) do
        if (col:isa(Enemy) or col:isa(EnemyProjectileSprite)) then
            if (col:damageEnabled()) then
                totalDamageAmount += col:getDamageAmount()
                tookDamage = true
            end

        elseif (col:isa(HealthPowerup)) then
            col:collect(self)
        end
    end

    -- player is inviisble 
    if (self.iframeCounter > 0 or self.invincible) then 
        tookDamage = false
    end


    if (tookDamage) then
        self.health -= totalDamageAmount

        if (self.health > 0) then
            self.camera:bigShake()
            self.iframeCounter = self.iframes
        end

        local spr = SingleSpriteAnimation("images/playerAnim/damage", 1000, self.x, self.y)
        spr:setZIndex(25)
        spr:attachTo(self)
    end

end

function Player:_handlePlayerInput()

    if (self.isControlsLocked) then
        return
    end

    if (playdate.buttonIsPressed(playdate.kButtonB)) then
        self.holdBCycles += 1
    end

    -- if player releases B before the wait cycles, do a dash
    if (playdate.buttonJustReleased(playdate.kButtonB)) then
        if (self.holdBCycles < HOLD_B_CYCLES_TO_WAIT) then
            if (self.energy > 25) then
                self.energy -= 25
                SingleSpriteAnimation("images/effects/playerDashShadowAnim/dash-shadow", 1000, self.x, self.y)
                self.dashVelocity = self.lastHorizontalDirection * DASH_SPEED
                self.camera:wideSway()
            end
        end
        self.holdBCycles = 0
    end

    -- if player holds A, wait for 10 cycles
    if (playdate.buttonIsPressed(playdate.kButtonA)) then
        if (self.holdACycles < HOLD_A_CYCLES_TO_WAIT) then
            self.holdACycles += 1
        end
    end

    -- if player releases A, reset the counter or shoot normal bullet
    if (playdate.buttonJustReleased(playdate.kButtonA)) then
        if (self.holdACycles < HOLD_A_CYCLES_TO_WAIT) then
            if (self.allowAttacks) then
                PlayerBullet(self.x, self.y)
            end
        end
        self.holdACycles =0 
    end

    if (self.holdACycles == HOLD_A_CYCLES_TO_WAIT) then
        
        -- settin this makes this action only happen on one frame.
        self.holdACycles = HOLD_A_CYCLES_TO_WAIT + 1
        
        if(self.allowAttacks) then
            if (self.selectedWeapon == WEAPON.LASER) then
                if (self.energy > 33) then
                    self.energy -= 33
                    PlayerLaser(self.x, self.y - 130, self.camera)  
                end

            elseif (self.selectedWeapon == WEAPON.MISSILE) then
                if (self.energy > 25) then 
                    self.energy -= 25
                    PlayerMissile(self.camera, self.x, self.y)
                                    
                end

            elseif (self.selectedWeapon == WEAPON.MINE) then 
                if (self.energy > 50) then
                    self.energy -= 50
                    PlayerMine(self.camera, self.x, self.y)
                end

            elseif (self.selectedWeapon == WEAPON.SHIELD) then
                if (self.energy > 33) then
                    self.energy -= 33
                    Deflector(self)
                end
            
            elseif (self.selectedWeapon == WEAPON.EMP) then
                if (self.energy >= 100) then
                    self.energy -= 100
                    self.camera:massiveSway()
                    ScreenFlash(500, gfx.kColorWhite)
                    self.usedEmp = true
                end
            end
        end
    end
end

function Player:_refillEnergy()
    if (self.energy < self.maxEnergy) then
        self.energy += 1
    end
end

--[[ handles movement from controls ]]
function Player:_handleMovement()
    -- Get inputs values, will be between -1 and 1.
    local leftInput = playdate.buttonIsPressed(playdate.kButtonLeft) and -1 or 0
    local rightInput = playdate.buttonIsPressed(playdate.kButtonRight) and 1 or 0
    local upInput = playdate.buttonIsPressed(playdate.kButtonUp) and -1 or 0
    local downInput = playdate.buttonIsPressed(playdate.kButtonDown) and 1 or 0

    local hInput = (leftInput + rightInput)
    local vInput = (upInput + downInput)

    if (hInput > 0) then 
        self.lastHorizontalDirection =1 
    elseif (hInput < 0) then
        self.lastHorizontalDirection = -1
    end

    self.xVelocity += (MOVE_SPEED * hInput)
    self.yVelocity += (MOVE_SPEED * vInput)

    self.xVelocity = math.clamp(self.xVelocity, -MAX_VELOCITY, MAX_VELOCITY)
    self.yVelocity = math.clamp(self.yVelocity, -MAX_VELOCITY, MAX_VELOCITY)

    local nextXPosition = self.x + self.xVelocity + self.dashVelocity
    local nextYPosition = self.y + self.yVelocity

    -- apply boundary areas
    if (nextXPosition < 0) then 
        nextXPosition = 0
    elseif (nextXPosition > 400) then
        nextXPosition = 400
    end

    if (nextYPosition < 180) then 
        nextYPosition = 180
    elseif (nextYPosition > 240) then
        nextYPosition = 240
    end

    
    self:moveTo(nextXPosition, nextYPosition)
end

--[[ Handles deceleration of ship's velocities back to zero ]]
function Player:_decelerate()

    -- stabilize normal velocity
    if (self.xVelocity < 0) then
        self.xVelocity += DECELERATION_RATE
    elseif (self.xVelocity > 0) then
        self.xVelocity -= DECELERATION_RATE
    end

    if (self.yVelocity < 0) then 
        self.yVelocity += DECELERATION_RATE
    elseif(self.yVelocity > 0) then 
        self.yVelocity -= DECELERATION_RATE
    end

    -- snap velocity to zero if we're close enough 
    self.xVelocity = math.snap(self.xVelocity, DECELERATION_RATE, 0)
    self.yVelocity = math.snap(self.yVelocity, DECELERATION_RATE, 0)

    -- do the same thing with dash velocity but it slows down faster
    self.dashVelocity = math.moveTowards(self.dashVelocity, 0, DECELERATION_RATE*12)
end

function Player:getSelectedWeaponId()
    return self.selectedWeapon
end

function Player:setSelectedWeaponId(weaponId)
    self.selectedWeapon = weaponId
end

function Player:getHealth()
    return self.health
end

function Player:getEnergy()
    return self.energy
end

function Player:addHealth(amount)
    self.health += amount
    if (self.health > self.maxHealth) then
        self.health = self.maxHealth
    end
end

function Player:depleteHealth(amount) 
    self.health -= amount
    if (self.health < 0) then
        self.health = 0
    end
end

function Player:setAllowAttacks(enable)
    self.allowAttacks = enable
end

function Player:getHoldBCycles()
    return HOLD_B_CYCLES_TO_WAIT
end

function Player:didUseEmp() 
    return self.usedEmp
end

function Player:lockControls()
    self.isControlsLocked = true
end

function Player:unlockControls()
    self.isControlsLocked = false
end

function Player:controlsAreLocked()
    return self.isControlsLocked
end

function Player:setInvincibility(enable) 
    self.invincible = enable
end