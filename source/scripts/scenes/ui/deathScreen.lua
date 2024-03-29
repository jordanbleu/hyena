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

    
    local plax = ParallaxLayer(gfx.image.new("images/ui/death-screen/death-screen-bg-far"),0,-4)
    plax:setZIndex(100)

    local plax2 = ParallaxLayer(gfx.image.new("images/ui/death-screen/death-screen-bg-close"),0,-8)
    plax2:setZIndex(101)


    local retryText = gfx.getString("deathscreen.menuitems.retry")
    local quitText = gfx.getString("deathscreen.menuitems.quit")

    local menu = Menu(retryText, quitText)
    menu:setCallbackForItemIndex(1, function() self:_retry(sceneManager) end)
    menu:setCallbackForItemIndex(2, function() self:_quitToMenu(sceneManager) end)
    
    
end

function DeathScreen:_retry(sceneManager)
    -- todo: save game data 
    dataManager.restoreGameState(sceneManager)

end

function DeathScreen:_quitToMenu(sceneManager)
    -- todo: save game data
    sceneManager:switchScene(MainMenu(), SCENE_TRANSITION.FADE_IO)
end