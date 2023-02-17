--[[

    Project Hyena
    by Jordan Bleu

    Highly Important links:
    ======================
    PlayDate sdk docs: https://sdk.play.date/1.13.0/Inside%20Playdate.html
    SquidGod video that explains his file structure: https://www.youtube.com/watch?v=PZD1Ba15nnM    

]]


-- Runs on first on game launch
local function setup()
    playdate.display.setRefreshRate(50) 
end
setup()


function playdate.update()
    -- get localized text
    print(txt)
end
