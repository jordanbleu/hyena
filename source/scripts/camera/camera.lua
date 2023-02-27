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
    self.currentSwayYDirection = 1

    self.currentSwayXOffset = 0
    self.currentSwayYOffset = 0

    self.normalSwayAmount = 3 -- change this to determine how far the camera sways
    self.normalSwaySpeed = 0.10 -- change this to determine how fast the camera sways
    self.swayAmount = self.normalSwayAmount -- change this for camera shake (it will slowly return to the normal sway amount)
    self.swaySpeed = self.normalSwaySpeed -- change this to determine how fast to shake / sway

    self:setIgnoresDrawOffset(true)
    self:moveTo(0,0)

    self:add()
end


function Camera:delayedUpdate()
    self:_sway()
    gfx.setDrawOffset(-self.x + -self.currentSwayXOffset, -self.y + -self.currentSwayYOffset)
end

--[[ Applies a basic camera sway effect ]]
function Camera:_sway()

    local xDestination = self.x
    if (self.currentSwayXDirection ~= 0) then 
        xDestination = self.x + (self.swayAmount * self.currentSwayXDirection)
    end
    
    local yDestination = self.y
    if (self.currentSwayYDirection ~= 0) then 
        yDestination = self.y + (self.swayAmount * self.currentSwayYDirection)
    end

    if (self.currentSwayXOffset == xDestination and self.currentSwayYOffset == yDestination) then

        -- if we've reached the sway destination, set the directions to either -1 or 1
        local dir = math.random(0,2)
    
        if (dir == 0) then 
            self.currentSwayXDirection = -1
        elseif (dir == 1) then
            self.currentSwayXDirection = 0 
        elseif (dir == 2) then 
            self.currentSwayXDirection = 1
        end
      
        dir = math.random(0,2)

        if (dir == 0) then 
            self.currentSwayYDirection = -1
        elseif (dir == 1) then
            self.currentSwayYDirection = 0 
        elseif (dir == 2) then 
            self.currentSwayYDirection = 1
        end

    end

    self.currentSwayXOffset = math.moveTowards(self.currentSwayXOffset, xDestination, self.swaySpeed)
    self.currentSwayYOffset = math.moveTowards(self.currentSwayYOffset, yDestination, self.swaySpeed)

    self.swayAmount = math.moveTowards(self.swayAmount, self.normalSwayAmount, 0.1)
    self.swaySpeed = math.moveTowards(self.swaySpeed, self.normalSwaySpeed, 0.1)
end

-- function Camera:_resetSway()

-- end