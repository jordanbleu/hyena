local gfx <const> = playdate.graphics

--[[
    Sprite animator that has better controls than the build in playdate one.
    This doesn't use the timer system which gives us more flexibility (probs worse performance tho).

    It doesn't support easing.
]]
class("SpriteAnimation").extends(Actor)

--- Creates a new instance of a SpriteAnimation
---@param imageTablePath string path to the image table
---@param animationTime integer how long the overall animation should be in ms
---@param x integer x coordinate
---@param y integer y coordinate 
function SpriteAnimation:init(imageTablePath, animationTime, x, y)

    SpriteAnimation.super.init(self)

    self.imageTable = gfx.imagetable.new(imageTablePath)

    -- Divide by the target framerate to go from time -> updates
    local animationTimeInUpdates = animationTime / GLOBAL_TARGET_FPS

    -- 'updates' here is how many times the update method gets hit.  
    self.updatesPerFrame = math.floor(animationTimeInUpdates / self.imageTable:getLength())
    self.updateCounter = 0
    
    -- 'frames' here refers to the sprite sheet image
    self.frame = 0

    self.repeatCount = 0
    self.repeats = 0

    self.active = true
    self.onCompletedCallback = nil
    self.isCompleted = false

    self:moveTo(x,y)
    self:add()
end

function SpriteAnimation:physicsUpdate()
    
    SpriteAnimation.super.physicsUpdate(self)

    if (self.active) then 
        self.updateCounter = self.updateCounter +1

        -- update the sprite frame 
        if (self.updateCounter >= self.updatesPerFrame) then
            self.frame = self.frame + 1
            self.updateCounter = 0

            if (self.frame >= self.imageTable:getLength()) then
                if (self.repeats == 0) then
                    self:_complete()
                elseif (self.repeats ~= -1) then
                    self.repeatCount = self.repeatCount + 1
                    if (self.repeatCount > self.repeats) then
                        self:_complete()
                    end
                end
                
            end
        end

        local image = self.imageTable:getImage(self.frame)
        self:setImage(image)
    end
end

function SpriteAnimation:pause()
    self.active = false
end

function SpriteAnimation:play()
    self.active = true
end

function SpriteAnimation:_complete()
    self.isCompleted = false;

    if (self.onCompletedCallback) then
        self.onCompletedCallback()
    end

    self:remove()
end


-- function SpriteAnimation:reset()
-- end
