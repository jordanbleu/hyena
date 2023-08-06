local gfx <const> = playdate.graphics

import "scripts/globals/gameContext"

--[[
    The scene manager manages the transition between different scenes.  
    A scene is just a collection of sprites along  with some logic.

    Sorta similar but not really to this https://www.youtube.com/watch?v=3LoMft137z8
]]
class("SceneManager").extends(gfx.sprite)

--> Fading out -> waiting -> fading in -> complete
local TRANSITION_STATE =
{
    COMPLETE = 0,
    FADING_OUT = 1,
    WAITING = 4,
    FADING_IN = 5
}

-- How long the fade duration should be 
local TRANSITION_DURATION = 1500

function SceneManager:init()

    -- Make self globally accesible.
    gameContext.setSceneManager(self)
    
    --[[
        The image cache is just a table of loaded images.  The image will be loaded
        and then stored here in memory.  Frequently used images should be stored in the cache.

        This cache is cleared on each scene transition.
    ]]
    self.imageCache = {}
    self.imageTableCache = {}

    self.transitionState = TRANSITION_STATE.COMPLETE
    self.currentTransition = SCENE_TRANSITION.HARD_CUT
    self.fadedRects = {}
    self.previousScene = nil

    self.fadedRects = SCREEN_EFFECT_CACHE.Black
end

--[[

    Upon calling this method, the specified transition animation will begin, after which
    the selected scene will be loaded.

    scene: the scene to load next
    transition: the SCENE_TRANSITION to load next

]]
function SceneManager:switchScene(scene, transition)

    if (not self:isReady()) then
        return
    end

    -- clear the image cache
    self.imageCache = {}
    self.imageTableCache = {}

    -- immediately stops all calls to `update` on the scene itself.  
    -- I'm hoping this doesn't cause any weirdness. 
    -- The reason for this is if cleanup gets called in the current drawing batch,
    -- one more `update` will be called before the end, leading to nil-references. 
    -- Calling remove here should halt updates immediately, then cleanup will happen later.
    if (self.currentScene) then self.currentScene:remove() end

    self.animator = nil
  
    if not transition then
        transition = SCENE_TRANSITION.HARD_CUT
    end

    local firstTransitionImage = gfx.image.new(400,240,gfx.kColorClear)
    self.transitionSprite = gfx.sprite.new(firstTransitionImage)
    self.transitionSprite:moveTo(200,120)
    self.transitionSprite:setZIndex(9999)
    self.transitionSprite:setIgnoresDrawOffset(true)
    self.transitionSprite:add()

    -- Set up the proper animator based on the requested transition
    if (transition == SCENE_TRANSITION.FADE_IO) then
        self.animator = gfx.animator.new(TRANSITION_DURATION, 0, 100, playdate.easingFunctions.outCubic)
    end

    self.currentTransition = transition
    self.transitionState = TRANSITION_STATE.FADING_OUT
    self.previousScene = self.currentScene
    self.currentScene = scene

end


function SceneManager:update()
    if (self.transitionState == TRANSITION_STATE.COMPLETE) then
        return

    elseif (self.transitionState == TRANSITION_STATE.FADING_OUT or self.transitionState == TRANSITION_STATE.FADING_IN) then
        self:_handleFade()

    elseif (self.transitionState == TRANSITION_STATE.WAITING) then
        self:_handleWaiting()

    end
end

--[[ Removes all the objects from the old scene and initializes the requested scene. ]]
function SceneManager:_loadRequestedScene()

    -- call cleanup on the previous scene and remove it from memory
    if (self.previousScene) then
        self.previousScene:cleanup()
        self.previousScene = nil
    end

    local sprites = gfx.sprite.getAllSprites()
    if (sprites ~= nil and #sprites > 0) then
        for i,spr in ipairs(sprites) do
            -- removeAll() doesn't call :remove()
            spr:remove()
        end
    end

    -- re-add the scene manager and the transition sprite
    self:add()
    self.transitionSprite:add()

    -- call init on the scene so it can add it's sprites and stuff
    self.currentScene:initialize(self)

    -- add the requested scene
    self.currentScene:add()
end

-- [[ Animates the current transition until the animator completes ]]
function SceneManager:_handleFade()
    if (self.currentTransition == SCENE_TRANSITION.HARD_CUT) then
        self.transitionState = TRANSITION_STATE.COMPLETE
        self:_loadRequestedScene()

    elseif (self.currentTransition == SCENE_TRANSITION.FADE_IO) then

        if (self.animator:ended()) then
            if (self.transitionState == TRANSITION_STATE.FADING_OUT) then 
                -- begin the waiting transition
                self.animator = gfx.animator.new(TRANSITION_DURATION/2, 0, 100)
                self.transitionState = TRANSITION_STATE.WAITING

            elseif (self.transitionState == TRANSITION_STATE.FADING_IN) then 
                self.animator = nil
                self.transitionState = TRANSITION_STATE.COMPLETE
            
            end
            return
        end

        local currentTimerValue = self.animator:currentValue()
        local currentTimerPercent = currentTimerValue / 100
        local frameIndex = math.ceil(GLOBAL_TRANSITION_QUALITY * currentTimerPercent)

        -- retrieve the cached faded frame based on the progress of the animator
        local currentFrame = self.fadedRects[frameIndex]
        self.transitionSprite:setImage(currentFrame)

    end
end

--[[ Simply waits for the animator to complete, then loads the scene and begins the transition back in. ]]
function SceneManager:_handleWaiting()

    if (self.animator:ended()) then
        self:_loadRequestedScene()
        self.transitionState = TRANSITION_STATE.FADING_IN

        -- same thing as fading out, except reversed :)
        self.animator = gfx.animator.new(TRANSITION_DURATION, 100, 0, playdate.easingFunctions.inCubic)

    end
end


--[[ Returns true if the scene manager is ready to transition to a new scene (the scene is fully loaded) ]]
function SceneManager:isReady()
    return self.transitionState == TRANSITION_STATE.COMPLETE
end

---Loads an image from the cache if it exists.  Otherwise loads it into the cache.
---@param imagePath any
function SceneManager:getImageFromCache(imagePath)
    local cached = self.imageCache[imagePath]
    
    if (cached == nil) then
        img = gfx.image.new(imagePath)
        self.imageCache[imagePath] = img
        return img
    end

    return cached
end

---Evicts an image from the cache.  Use if you're sure that an image won't be needed anymore.
---@param imagePath any
function SceneManager:removeImageFromCache(imagePath)
    self.imageCache[imagePath] = nil
end

function SceneManager:getImageTableFromCache(imageTablePath)
    local cached = self.imageTableCache[imageTablePath]
    
    if (cached == nil) then
        imgTable = gfx.imagetable.new(imageTablePath)
        self.imageTableCache[imageTablePath] = imgTable
        return imgTable
    end

    return cached
end

function SceneManager:removeImageTableFromCache(imageTablePath)
    self.imageTableCache[imageTablePath] = nil
end