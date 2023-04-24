gameContext = {}
_sceneManager = nil

---Retrieves the currently active scene manager instance. 
---@return nil
function gameContext.getSceneManager()
    if (_sceneManager == nil) then
        error("Unable to retrieve scene manager")
    end
    return _sceneManager
end

---Set the pointer for the scene manager to a new isntance.  This should only be called from
---scenemanager probably.
---@param sceneManagerInst any
function gameContext.setSceneManager(sceneManagerInst)
    _sceneManager = sceneManagerInst
end