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

import "scripts/globals/enums"

import "scripts/sceneManager"
import "scripts/scenes/test1Scene" -- todo :remove 
import "scripts/scenes/test2Scene"

local gfx <const> = playdate.graphics

-- Runs on first on game launch
local function setup()
    playdate.display.setRefreshRate(50)

    local sceneMgr = SceneManager()
    sceneMgr:add()
    
    -- long in the future, this will be set to the 'title screen scene'
    local firstScene = Test1Scene()
    sceneMgr:switchScene(firstScene, SCENE_TRANSITION.HARD_CUT)

end

setup()

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
