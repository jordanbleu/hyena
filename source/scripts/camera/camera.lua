local gfx <const> = playdate.graphics

local SWAY_DECELERATION <const> = 0.5

--[[
    The camera basically just set the global draw offset to it's x / y position.
]]
class("Camera").extends(Actor)


function Camera:init()
    Camera.super.init(self)
    self.shakeTimer = playdate.timer.new(0)

    self.currentSwayXDirection = 1
    self.currentSwayYDirection = math.random(-1,1)
    
    if (self.currentSwayXDirection == 0 and self.currentSwayYDirection == 0) then 
        self.currentSwayXDirection = -1
    end

    self.currentSwayXOffset = 0
    self.currentSwayYOffset = 0

    self.normalSwayAmount = 3 -- change this to determine how far the camera sways normally.  Determines the bounds of the camera.
    self.normalSwaySpeed = 0.10 -- change this to determine how fast the camera sways

    self.swayAmount = self.normalSwayAmount -- change this for camera shake (it will slowly return to the normal sway amount)
    self.swaySpeed = self.normalSwaySpeed -- change this to determine how fast to shake / sway

    self:setIgnoresDrawOffset(true)
    self:moveTo(0,0)

    self:add()
end


function Camera:physicsUpdate()
    self:_sway()
    gfx.setDrawOffset(-self.x + -self.currentSwayXOffset, -self.y + -self.currentSwayYOffset)
end

--[[ Applies a basic camera sway effect ]]
function Camera:_sway()

    local xDestination = self:_xSwayDestination()
    local yDestination = self:_ySwayDestination()

    self.currentSwayXOffset = math.moveTowards(self.currentSwayXOffset, xDestination, self.swaySpeed)
    self.currentSwayYOffset = math.moveTowards(self.currentSwayYOffset, yDestination, self.swaySpeed)

    -- x position bounces back and forth (so it is always moving horizontally)
    if (self.currentSwayXOffset == xDestination) then
        self.currentSwayXDirection = -self.currentSwayXDirection
    end

    -- y position randomizes smoothly 
    if (self.currentSwayYOffset == yDestination) then
        self.currentSwayYDirection = math.random(-1,1)
    end

    self.swayAmount = math.moveTowards(self.swayAmount, self.normalSwayAmount, 0.15)
    self.swaySpeed = math.moveTowards(self.swaySpeed, self.normalSwaySpeed, 0.15)
end

function Camera:_xSwayDestination()
    return self.x + (self.swayAmount * self.currentSwayXDirection)
end

function Camera:_ySwayDestination()
    return self.y + (self.swayAmount * self.currentSwayYDirection)
end

-- suitable for tiny impacts, bullets, etc
function Camera:smallShake()
    self.swayAmount = 2
    self.swaySpeed = 2
end

-- suitable for medium to heavy impacts
function Camera:mediumShake()
    self.swayAmount = 5
    self.swaySpeed = 5
end

-- suitable for explosions
function Camera:bigShake()
    self.swayAmount = 10
    self.swaySpeed = 10
end

-- suitable for sudden movements / jolts
function Camera:wideSway()
    self.swayAmount = 25
    self.swaySpeed = 4
end

-- avoid this one except for a few key places lol
function Camera:massiveSway()
    self.swayAmount = 25
    self.swaySpeed = 8
end

-- changes the camera to static (but still responds to shake)
function Camera:removeNormalSway()
    self.normalSwayAmount = 0
    self.normalSwaySpeed  =0
    self.currentSwayXOffset = 0
    self.currentSwayYOffset = 0
end
