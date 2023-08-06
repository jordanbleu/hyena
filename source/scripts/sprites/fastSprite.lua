local gfx <const> = playdate.graphics

fastSprites = {}

--[[ 
    Object that will automatically spawn objects in the background.
]] 
class("FastSprite").extends(Object)

function FastSprite:init(image)
    self.x = 0
    self.y = 0

    self:setImage(image)
    self.image = image
    self.index = -1

    self.ignoreDisabledPhysics = false
end

-- calls update but only if physics are enabled
function FastSprite:_internalUpdate()
    if (self.ignoreDisabledPhysics or GLOBAL_PHYSICS_ENABLED) then        
        self:_redraw()
        self:update()
    end
end

function FastSprite:update()
    -- child classes can override this.  Runs every frame regardless of physics.
end

function FastSprite:_redraw()
    self.image:drawAnchored(self.x, self.y, self.anchorX, self.anchorY)
end

function FastSprite:moveTo(x,y)

    self.x = x
    self.y = y
end

function FastSprite:setCenter(ax, ay)
    self.anchorX = ax
    self.anchorY = ay    
end

---adds the fast sprite to the list of sprites to be updated / drawn
function FastSprite:add()
    table.insert(fastSprites, self)
    self.index = #fastSprites
end

function FastSprite:remove()
    table.remove(fastSprites, self.index)
end

function FastSprite:getImage()
    return self.image
end

function FastSprite:setImage(image)
    self.image = image
    local w,h = image:getSize()
    self.w = w
    self.h = h
    
    -- default the anchor to the center like normal sprites do
    self.anchorX = w/2
    self.anchorY = h/2
end

-- function FastSprites:setIgnoreDisabledPhysics(shouldIgnore)
--     self.ignoreDisabledPhysics = shouldIgnore
-- end

----------------------------------------------------------------------------------------------------------------
-- // Global functions \\ --
----------------------------------------------------------------------------------------------------------------

--- Iteratively calls 'update' on each sprite in the list
function FastSprite.updateAll()
    for i,spr in ipairs(fastSprites) do
        spr:_internalUpdate()
    end
end

