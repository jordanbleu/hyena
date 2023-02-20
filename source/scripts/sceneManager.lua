
local gfx <const> = playdate.graphics

--[[
    The scene manager manages the transition between different scenes.  
    A scene is just a collection of sprites along  with some logic.
]]
class("SceneManager").extends(gfx.sprite)

local TRANSITION_STATE= 
{
    COMPLETE = 0,
    FADING_IN = 1,
    FADING_OUT = 2
}

local transitionState 
local currentTransition
local fadeInAnimator 
local fadeOutAnimator
local currentScene


function SceneManager:init()
    transitionState = TRANSITION_STATE.COMPLETE
    currentTransition = SCENE_TRANSITION.HARD_CUT
end

--[[
    Upon calling this method, the specified transition animation will begin, after which
    the selected scene will be loaded.

    scene: the scene to load next
    transition: the SCENE_TRANSITION to load next

]]
function SceneManager:switchScene(scene, transition)
    
    if not transition then
        transition = SCENE_TRANSITION.HARD_CUT
    end
    
    -- Set up the proper animator based on the requested transition
    if (transition == SCENE_TRANSITION.FADE_IO) then 
        fadeInAnimator = gfx.animator.new(3000, 0, 100)
    end

    currentTransition = transition
    transitionState = TRANSITION_STATE.FADING_IN
    currentScene = scene 

end


function SceneManager:update()

    if (transitionState == TRANSITION_STATE.COMPLETE) then
        return
    end

    if (transitionState == TRANSITION_STATE.FADING_IN) then
        self:_handleFadeIn()
    end
end

--[[ Removes all the objects from the old scene and initializes the requested scene. ]]
function SceneManager:_loadRequestedScene()
    -- remove all existing sprites
    gfx.sprite.removeAll()

    -- re-add the scene manager
    self:add()

    -- call init on the scene so it can add it's sprites and stuff
    currentScene:initialize(self)

    -- add the requested scene
    currentScene:add()
end

-- [[ Animates the current transition until the animator completes ]]
function SceneManager:_handleFadeIn()
    -- this is a special case where we bypass the transition flow.
    if (currentTransition == SCENE_TRANSITION.HARD_CUT and transitionState == TRANSITION_STATE.FADING_IN) then
        transitionState = TRANSITION_STATE.COMPLETE
        self:_loadRequestedScene()
    end
end


