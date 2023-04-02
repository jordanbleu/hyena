--[[
    This file hosts some global functions for saving and loading and managing data. 
]]

import "scripts/scenes/test1Scene"
dataManager = {}

---Saves the current data objects into the datastore.  
function dataManager.saveGameData()
    --todo: implement
end

function dataManager.saveGlobalData()
end

---Populates `DATA.GAME` for the current selected `SAVE_SLOT` from the datastore.
-- Called when the player selects 'load game' from a menu.
function dataManager.loadGameData()
    --todo: implement

end

---Populates the `DATA.GLOBAL` object from the datastore. 
-- Called upon game start.
function dataManager.loadGlobalData()
    --todo: implement
end

--[[ 

    This 'loads your game' from the loaded-in game data object.  
    Make sure the proper data is loaded before calling this.
    
    It will load the proper scene based on checkpoint, and do whatever 
    other logic is required to restore the game state.

    Does the same thing if you load a game from the main menu or if you die
    and run outta lives.

]]
function dataManager.restoreGameState(sceneManager)
    local cp = DATA.GAME.Checkpoint

    if (cp == CHECKPOINT.START) then
        local scene = Test1Scene()
        sceneManager:switchScene(scene, SCENE_TRANSITION.FADE_IO)
    end

end