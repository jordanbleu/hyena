local gfx <const> = playdate.graphics

import "scripts/extensions/playdate"

--[[ Takes whatever text you tell it to write and types it out letter by letter.  
    Also listens for key presses so user can acknowledge text. 

    Note that this object doesn't have any of the image frame type stuff or other UI 
    so it shouldn't be used on its own.
]]
class("GameplayDialogue").extends(gfx.sprite)

function GameplayDialogue:init(csvFile)

    self.dialogues = {}

    -- read the csv file and load into memory
    local asdfasdf = playdate.loadDialogueFromCsv(csvFile)

end 