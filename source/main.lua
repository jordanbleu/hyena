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

-- Extensions
import "scripts/Extensions/math"

import "scripts/globals/enums"
import "scripts/globals/globals"


import "scripts/sceneManager"
import "scripts/scenes/test1Scene" -- todo :remove 


local gfx <const> = playdate.graphics

local timer

-- Runs on first on game launch
local function setup()
    math.randomseed(playdate.getSecondsSinceEpoch())

    playdate.display.setRefreshRate(GLOBAL_TARGET_FPS)

    local sceneMgr = SceneManager()
    sceneMgr:add()

    -- long in the future, this will be set to the 'title screen scene'
    local firstScene = Test1Scene()
    sceneMgr:switchScene(firstScene, SCENE_TRANSITION.FADE_IO)

end

setup()

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    --playdate.drawFPS(0,0)
end