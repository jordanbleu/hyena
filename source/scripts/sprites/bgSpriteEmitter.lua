local gfx <const> = playdate.graphics

import "scripts/sprites/bgSprite"
--[[ 
    Object that will automatically spawn objects in the background.
]] 
class("BgSpriteEmitter").extends(Actor)

function BgSpriteEmitter:init(moveSpeed)
    BgSpriteEmitter.super.init(self)
    self.frequency = 300
    self.moveSpeed = moveSpeed
    self.images = {}
    self.spawnCycles = math.random(math.floor(self.frequency/2), self.frequency)
    self.spawnCycleCounter = 0
    -- prevent duplicates
    self.lastIndex = -1
    self:add()
end


function BgSpriteEmitter:physicsUpdate()
    BgSpriteEmitter.super.physicsUpdate(self)

    self.spawnCycleCounter += 1

    if (self.spawnCycleCounter >= self.spawnCycles) then
        -- pick what image to spawn 
        local index = math.random(1, #self.images)
    
        -- try to avoid duplicates
        if (index == self.lastIndex) then
            index +=1 
        end
    
        if (index > #self.images) then
            index = 1
        end
    
        self.lastIndex = index
        local x = math.random(0,400)
        local selectedImage = self.images[index]
        local w,h = selectedImage:getSize()
        BgSprite(selectedImage, x, -(h/2), self.moveSpeed)
    
        self.spawnCycleCounter = 0
        self.spawnCycles = math.random(math.floor(self.frequency/2), self.frequency)
    end




end

---Add a new image to the batch of possible images to spawn
---@param image any loaded image
function BgSpriteEmitter:addImage(image)
    table.insert(self.images, image)
end