local gfx <const> = playdate.graphics

--[[
    A scene is responsible for adding all of its sprites, and managing the 
    overall logic for the game / scene or whatever.  
]]
class("Scene").extends(gfx.sprite)

--[[ 
    Scene initialization is for adding / managing / initializing other objects.  
    This happens when the scene manager's transition has hidden the screen so the 
    player won't see what's happening. 

    sceneManager: The game's scene manager
]]
function Scene:initialize(sceneManager)
end



