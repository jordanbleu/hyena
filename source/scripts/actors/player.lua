local gfx <const> = playdate.graphics

import "scripts/projectiles/playerBullet"
import "scripts/projectiles/playerLaser"
import "scripts/projectiles/playerMissile"
import "scripts/projectiles/deflector"
import "scripts/actors/actor"
import "scripts/physics/physicsTimer"
import "scripts/effects/whiteScreenFlash"

-- How much speed increases per frame when accelerating 
local MOVE_SPEED <const> = 0.5
-- Max speed overall of your ship
local MAX_VELOCITY <const> = 2
-- Deceleration rate.  Higher numbers make ship stop faster, lower makes the ship more floaty
local DECELERATION_RATE = 0.1
-- speed of the dash
local DASH_SPEED <const> = 20

-- how long to hold the A button before using weapon.
local HOLD_A_CYCLES_TO_WAIT <const> = 20
local HOLD_B_CYCLES_TO_WAIT<const> = 10

--[[
    This is the player object, for normal gameplay
]]
class("Player").extends(Actor)

function Player:init(cameraInst)
    Player.super.init(self)
   
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

    self.selectedWeapon = WEAPON.LASER

    
    self.energyRefillTimer = PhysicsTimer(50, function() self:_refillEnergy() end)
    self.xVelocity = 0
    self.yVelocity = 0
    self:setImage(gfx.image.new("images/player"))
    self:setZIndex(25)
    self:setGroups({COLLISION_LAYER.PLAYER})
    self:setCollidesWithGroups(COLLISION_LAYER.ENEMY, COLLISION_LAYER.ENEMY_PROJECTILE)
    self:add()
    
    local w,h = self:getSize()
    self:setCollideRect(0,0,self:getSize())

    -- set to true when some UI element or something has taken focus.
    self.isControlsLocked = false

    self.iframeCounter = 0
    self.iframes = 50

    self.usedEmp = false
end

function Player:update()
    Player.super.update(self)

    if (self.usedEmp) then
        self.usedEmp = false
    end

    

    self:_handlePlayerInput()
    self:_checkCollisions()
end

function Player:_checkCollisions()
    -- player is inviisble 
    if (self.iframeCounter > 0) then 
        return
    end

    local tookDamage = false
    local collisions = self:overlappingSprites()

    if (#collisions > 0) then
        tookDamage = true
    end

    if (tookDamage) then
        self.health -=10
        self.camera:bigShake()
        self.iframeCounter = self.iframes
        local spr = SingleSpriteAnimation("images/playerAnim/damage", 1000, self.x, self.y)
        spr:setZIndex(25)
        spr:attachTo(self)
    end

end

function Player:physicsUpdate()
    Player.super.physicsUpdate(self)

    if (self.iframeCounter > 0) then
        self.iframeCounter -= 1
    end

    self:_handleMovement()
    self:_decelerate()
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
                    WhiteScreenFlash(500)
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