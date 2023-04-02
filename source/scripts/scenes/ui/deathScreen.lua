local gfx <const> = playdate.graphics

import "scripts/scenes/base/scene"
import "scripts/ui/menu"
import "scripts/scenes/ui/mainMenu"

class("DeathScreen").extends(Scene)

function DeathScreen:initialize(sceneManager)
    DeathScreen.super.initialize(self, sceneManager)
    
    local black = gfx.image.new("images/black")
    local blackSprite = gfx.sprite.new(black)
    blackSprite:moveTo(200,120)
    blackSprite:add()

    local menu = Menu("Retry", "Quit")
    menu:setCallbackForItemIndex(1, function() self:_retry(sceneManager) end)
    menu:setCallbackForItemIndex(2, function() self:_quitToMenu(sceneManager) end)
    --todo: add a kickass background
    
end

function DeathScreen:_retry(sceneManager)
    -- todo: save game data 
    dataManager.restoreGameState(sceneManager)

end

function DeathScreen:_quitToMenu(sceneManager)
    -- todo: save game data
    sceneManager:switchScene(MainMenu(), SCENE_TRANSITION.FADE_IO)
end