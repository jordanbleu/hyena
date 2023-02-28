local gfx <const> = playdate.graphics

import "scripts/projectiles/playerBullet"
import "scripts/actors/actor"

-- How much speed increases per frame when accelerating 
local MOVE_SPEED <const> = 0.5
-- Max speed overall of your ship
local MAX_VELOCITY <const> = 2
-- Deceleration rate.  Higher numbers make ship stop faster, lower makes the ship more floaty
local DECELERATION_RATE = 0.1

--[[
    This is the player object, for normal gameplay
]]
class("Player").extends(Actor)

function Player:init()
    Player.super.init(self)
    self.xVelocity = 0
    self.yVelocity = 0
    self:setImage(gfx.image.new("images/player"))
    self:setZIndex(25)
    self:setGroups({COLLISION_LAYER.PLAYER})
    self:add()
end


function Player:update()
    Player.super.update(self)
    self:_handlePlayerInput()
end

function Player:physicsUpdate()
    Player.super.physicsUpdate(self)
    self:_handleMovement()
    self:_decelerate()
end

function Player:_handlePlayerInput() 

    
    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        -- instantiate a new player bullet
        PlayerBullet(self.x, self.y)
    end

    -- temp 
    if (playdate.buttonJustPressed(playdate.kButtonB)) then

        if (GLOBAL_TIME_DELAY == 0) then
            GLOBAL_TIME_DELAY = 150
        else 
            GLOBAL_TIME_DELAY = 0
        end
        
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

    self.xVelocity += (MOVE_SPEED * hInput)
    self.yVelocity += (MOVE_SPEED * vInput)

    self.xVelocity = math.clamp(self.xVelocity, -MAX_VELOCITY, MAX_VELOCITY)
    self.yVelocity = math.clamp(self.yVelocity, -MAX_VELOCITY, MAX_VELOCITY)

    local nextXPosition = self.x + self.xVelocity
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

    self.xVelocity = math.snap(self.xVelocity, DECELERATION_RATE, 0)
    self.yVelocity = math.snap(self.yVelocity, DECELERATION_RATE, 0)
end