--[[
    Project Hyena
    by Jordan Bleu

    Highly Important links:
    ======================
    PlayDate sdk docs: https://sdk.play.date/1.13.0/Inside%20Playdate.html
    SquidGod video that explains his file structure: https://www.youtube.com/watch?v=PZD1Ba15nnM    
]]

import 'CoreLibs/animation' 
import 'CoreLibs/animator'
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "scripts/data/dataManager"
import "scripts/extensions/graphics.lua"
import "scripts/extensions/math"
import "scripts/extensions/playdate"
import "scripts/extensions/string.lua"
import "scripts/globals/enums"
import "scripts/globals/gameContext"
import "scripts/globals/gameData"
import "scripts/globals/globalCache"
import "scripts/globals/globals"
import "scripts/sceneManager"
import "scripts/scenes/cutsceneDemo"
import "scripts/scenes/demoScene"
import "scripts/scenes/scene0020"
import "scripts/scenes/scene0030"
import "scripts/scenes/scene0050"
import "scripts/scenes/scene0080"
import "scripts/scenes/testScenes/testingScene"
import "scripts/scenes/test1Scene"
import "scripts/scenes/testScenes/benchmarkScene"
import "scripts/scenes/ui/deathScreen"
import "scripts/scenes/ui/mainMenu"
import "scripts/sprites/fastSprite"
import "scripts/objects/gameObject"


local gfx <const> = playdate.graphics

-- Runs on first on game launch
local function setup()
    --gfx.sprite.setAlwaysRedraw(true)

    math.randomseed(playdate.getSecondsSinceEpoch())

    playdate.display.setRefreshRate(GLOBAL_TARGET_FPS)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    globalCache.preComputeScreenEffects()

    local sceneMgr = SceneManager()
    sceneMgr:add()

    -- long in the future, this will be set to the 'title screen scene'
    --local firstScene = DeathScreen()
    --local firstScene = Test1Scene()
    --local firstScene = CutsceneDemo()
    --local firstScene = DemoScene()
    --local firstScene = Scene0080() -- Uncomment to start at main menu
    --local firstScene = BenchmarkScene() -- Uncomment to start at main menu

    --local firstScene = Scene0060() -- Uncomment to start from the opening credits
    --local firstScene = Scene0020() -- Start from first gameplay section
    local firstScene = TestingScene()
    --local firstScene = MainMenu() 
    sceneMgr:switchScene(firstScene, SCENE_TRANSITION.HARD_CUT)
end


local function drawDebugText()
    local fon = gfx.font.new("fonts/Nano Sans")
    gfx.setFont(fon)

    local enemies = 0
    local actors = 0
    local spriteanimations = 0
    local scenes = 0
    local timers = 0
    local sprites = gfx.sprite.getAllSprites()
    -- sprite info
    for i,spr in ipairs(sprites) do
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
    
    gfx.drawTextWhite("Enemies: " .. tostring(enemies), 10,20)
    gfx.drawTextWhite("Actors: " .. tostring(actors), 10, 30)
    gfx.drawTextWhite("SpriteAnimations: " .. tostring(spriteanimations), 10, 40)
    gfx.drawTextWhite("Scenes: " .. tostring(scenes), 10, 50)
    gfx.drawTextWhite("Timers: " .. tostring(timers), 10, 60)
    gfx.drawTextWhite("Sprites: " .. tostring(#sprites), 10, 70)
end

setup()

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    --FastSprite.updateAll()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    gfx.animation.blinker.updateAll()
    GameObject.updateAll()
    --drawDebugText()
    playdate.drawFPS(0,0)
end




