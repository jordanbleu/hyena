local gfx <const> = playdate.graphics

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
    WAITING = 2,
    FADING_IN = 3
}

-- How long the fade duration should be 
local TRANSITION_DURATION = 1500
-- tweak this for more frames / worse performance (max is 100)
local TRANSITION_QUALITY = 25

function SceneManager:init()
    self.transitionState = TRANSITION_STATE.COMPLETE
    self.currentTransition = SCENE_TRANSITION.HARD_CUT
    self.fadedRects = {}
    local fadedImage

    -- pre-compute all frames for the fade in effect.
    for i=0, TRANSITION_QUALITY, 1 do

        local alpha = i/TRANSITION_QUALITY

        fadedImage = gfx.image.new(400,240)

        -- we are now drawing onto the faded image directly
        gfx.pushContext(fadedImage)
        local filledRect = gfx.image.new(400,240, gfx.kColorBlack)
        filledRect:drawFaded(0, 0, alpha, gfx.image.kDitherTypeBayer8x8)
        gfx.popContext()

        self.fadedRects[i] = fadedImage

    end
end

--[[
    Upon calling this method, the specified transition animation will begin, after which
    the selected scene will be loaded.

    scene: the scene to load next
    transition: the SCENE_TRANSITION to load next

]]
function SceneManager:switchScene(scene, transition)

    if not self:isReady() then
        print ("Called SwitchScene before the the scene manager was ready.  Add a call to check for this pls")
        return
    end

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
    -- remove all existing sprites
    gfx.sprite.removeAll()

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
        local frameIndex = math.ceil(TRANSITION_QUALITY * currentTimerPercent)

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




