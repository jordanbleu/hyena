--[[
    Project Hyena
    by Jordan Bleu

    Highly Important links:
    ======================
    PlayDate sdk docs: https://sdk.play.date/1.13.0/Inside%20Playdate.html
    SquidGod video that explains his file structure: https://www.youtube.com/watch?v=PZD1Ba15nnM    
]]

-- Core libraries for PLayDate
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import 'CoreLibs/animator'
import 'CoreLibs/animation'

-- Extensions
import "scripts/Extensions/math"
import "scripts/Extensions/playdate"
import "scripts/extensions/string.lua"
import "scripts/extensions/graphics.lua"

import "scripts/globals/enums"
import "scripts/globals/globals"


import "scripts/sceneManager"
import "scripts/scenes/demoScene" -- todo :remove 
import "scripts/scenes/test1Scene"

local gfx <const> = playdate.graphics

-- Runs on first on game launch
local function setup()
    math.randomseed(playdate.getSecondsSinceEpoch())

    playdate.display.setRefreshRate(GLOBAL_TARGET_FPS)

    local sceneMgr = SceneManager()
    sceneMgr:add()

    -- long in the future, this will be set to the 'title screen scene'
    --local firstScene = DemoScene()
    local firstScene = Test1Scene() 
    sceneMgr:switchScene(firstScene, SCENE_TRANSITION.FADE_IO)
end


local function drawDebugText()
    local fon = gfx.font.new("fonts/Nano Sans")
    gfx.setFont(fon)
    gfx.drawText("Deboooog text:", 10, 10)

    local enemies = 0
    local actors = 0
    local spriteanimations = 0
    local scenes = 0
    local timers = 0

    -- sprite info
    for i,spr in ipairs(gfx.sprite.getAllSprites()) do
        if (spr:isa(Enemy)) then
            enemies+=1
        end 

        if (spr:isa(Actor)) then
            actors+=1
        end

        if (spr:isa(SpriteAnimation)) then
            spriteanimations+=1
        end

        if (spr:isa(Scene)) then
            scenes += 1
        end
        
    end

    local allTimers = playdate.timer.allTimers()
    timers = #allTimers
    

    gfx.drawText("Enemies: " .. tostring(enemies), 10,20)
    gfx.drawText("Actors: " .. tostring(actors), 10, 30)
    gfx.drawText("SpriteAnimations: " .. tostring(spriteanimations), 10, 40)
    gfx.drawText("Scenes: " .. tostring(scenes), 10, 50)
    gfx.drawText("Timers: " .. tostring(timers), 10, 60)


end

setup()

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    gfx.animation.blinker.updateAll()
    playdate.drawFPS(0,0)
    --drawDebugText()
end

-- ** this should be disabled for the final build **
function playdate.keyReleased(key)
    local k = string.lower(key)

    -- press T to toggle time scale 
    if (k == "t") then
        if (GLOBAL_TIME_DELAY == 0) then
            GLOBAL_TIME_DELAY = 250
        else 
            GLOBAL_TIME_DELAY = 0
        end
    end
end



