local gfx <const> = playdate.graphics

--[[
    A scene is responsible for adding all of its sprites, and managing the 
    overall logic for the game / scene or whatever.  
]]
class("Scene").extends(gfx.sprite)

local sceneMgr

--[[ 
    Scene initialization is for adding / managing / initializing other objects.  
    This happens when the scene manager's transition has hidden the screen so the 
    player won't see what's happening. 

    sceneManager: The game's scene manager
]]
function Scene:initialize(sceneManager)
    sceneMgr = sceneManager
end

function Scene:getSceneManager() 
    if not sceneMgr then 
        print ("Scene Manager was not available.  Did you forget to call super.initialize in a scene?")
        error ("Unable to retrieve scene manager")
    end

    return sceneMgr

end



