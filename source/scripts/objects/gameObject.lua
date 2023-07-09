local gfx <const> = playdate.graphics

-- This is the global gameObjects batch
gameObjects = {}

--[[ 
    Game objects are just objects that automatically update per frame once they are added
    to the draw batch.    
]]
class("GameObject").extends(Object)

---Override this for code that runs every frame as long as physics are enabled.
function GameObject:physicsUpdate()
end

---Override this for code that runs every frame.
function GameObject:update()
end

function GameObject:_internalUpdate()
    self:update()

    if (GLOBAL_PHYSICS_ENABLED) then
        self:physicsUpdate()
    end
end

---Adds the gameobject to the update batch, so this objects update function will be called.
function GameObject:add()
    self.objectId = math.generateUUID()

    -- do one retry in case we generate an existing id 
    -- super unlikely but the generator function isn't perfect.
    if (gameObjects[self.objectId] ~= nil) then
        self.objectId = math.generateUUID()
        if (gameObjects[self.objectId] ~= nil) then
            error "Unable to generate UUID."
        end
    end

    gameObjects[self.objectId] = self
end

---Removes the object from the update batch.
function GameObject:remove()
    table.remove(gameObjects, self.objectId)
end

---Called to remove every gameObject.
function GameObject.removeAll()
    gameObjects = {}
end

---Call from the main update function to update each game Object in the update batch.
function GameObject.updateAll()
    for id,o in pairs(gameObjects) do
        o:_internalUpdate()
    end
end



