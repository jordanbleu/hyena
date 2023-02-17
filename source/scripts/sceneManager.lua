
local gfx <const> = playdate.graphics

--[[
    The scene manager manages the transition between different scenes.  

    A scene is just a collection of sprites along  with some logic.
]]
class("SceneManager").extends(gfx.sprite)

function SceneManager:init()
    print "hello scene manager"
end

-- Todo: Delete this
function SceneManager:methodExample(arg)
    print (arg)
end

--[[
    Upon calling this method, the specified transition animation will begin, after which
    the selected scene will be loaded.
]]
function SceneManager:switchScene(scene)
    
    -- todo: do this part when the screen is obscured by the transition 
    -- this logic will probably be managed by an internal state machine 
    
    -- todo: it'd be cool if this was a factory pattern instead so we can prevent the caller from 
    -- doing weird stuff to the passed in scene.

    -- remove all existing sprites
    gfx.sprite.removeAll()

    -- re-add the scene manager
    self:add()

    -- call init on the scene so it can add it's sprites and stuff
    scene:initialize(self)

    -- add the requested scene
    scene:add()

end