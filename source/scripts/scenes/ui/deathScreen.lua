local gfx <const> = playdate.graphics

import "scripts/scenes/base/scene"
import "scripts/ui/menu"

class("DeathScreen").extends(Scene)

function DeathScreen:initialize(sceneManager)
    DeathScreen.super.initialize(self, sceneManager)
    
    local black = gfx.image.new("images/black")
    local blackSprite = gfx.sprite.new(black)
    blackSprite:moveTo(200,120)
    blackSprite:add()

    local menu = Menu("Retry", "Quit", nil, nil)
    -- and a kickass background


end