local gfx <const> = playdate.graphics

import "scripts/ui/menu"
import "scripts/ui/pressButtonToBegin"
import "scripts/scenes/scene0010"
import "scripts/ui/tutorial"
import "scripts/effects/screenFlash"


class("MainMenu").extends(Scene)

function MainMenu:initialize(sceneManager)
    MainMenu.super.initialize(self, sceneManager)

    self.sceneManager = sceneManager

    local blackGround = gfx.sprite.new(gfx.image.new("images/black"))
    blackGround:moveTo(200,120)
    blackGround:setZIndex(0)
    blackGround:add()

    self.camera = Camera()
    self.camera:removeNormalSway()

    self.plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-dense-farther"),-4,0)
    self.plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-dense-far"),-6,0)

    self.planet = gfx.sprite.new(gfx.image.new("images/ui/main-menu/menu-planet2"))

    self.planetAnimator = gfx.animator.new(500, 220, 190, playdate.easingFunctions.outCubic)
    self.planet:moveTo(200,180)
    self.planet:setZIndex(1)
    self.planet:add()

    self.logoAnimator = gfx.animator.new(1000, -100, 50, playdate.easingFunctions.outBack, 1500)
    self.logo = gfx.sprite.new(gfx.image.new("images/ui/main-menu/logo-title"))
    self.logo:moveTo(200, -100)
    self.logo:setZIndex(110)
    self.logo:add()

    PressButtonToBegin(function() self:_createMenu() end)

end

function MainMenu:update()
    MainMenu.super.update(self)
    self:_updatePlanet()
    self:_updateLogo()
    
end

function MainMenu:_updatePlanet()
    local newY = self.planetAnimator:currentValue()
    self.planet:moveTo(self.planet.x, newY)
end

function MainMenu:_updateLogo()
    local newY = self.logoAnimator:currentValue()
    self.logo:moveTo(self.logo.x, newY)
end

function MainMenu:_createMenu()

    ScreenFlash(500, gfx.kColorWhite)
    
    self.planetAnimator = gfx.animator.new(4000, self.planet.y, 165, playdate.easingFunctions.outCubic)
    self.logoAnimator = gfx.animator.new(1000, self.logo.y, -100, playdate.easingFunctions.inBack)

    self:_openMenu()
    
end

function MainMenu:_openMenu()

    local playText = gfx.getString("mainmenu.menuitems.play")
    local endlessText = gfx.getString("mainmenu.menuitems.endless")
    local optionsText = gfx.getString("mainmenu.menuitems.settings")
    local extrasText = gfx.getString("mainmenu.menuitems.extras")
    
    local menu = Menu(playText, endlessText, optionsText, extrasText)
    menu:setCallbackForItemIndex(1, function() self:_play() end)
    menu:setCallbackForItemIndex(2, function() self:_notAvailableForDemo() end)
    menu:setCallbackForItemIndex(3, function() self:_notAvailableForDemo() end)
    menu:setCallbackForItemIndex(4, function() self:_notAvailableForDemo() end)
    menu:setCallbackForGoBack(function() self:_goBack() end)
end


function MainMenu:_play()
    -- eventually this will open the save selector but not today
    self.sceneManager:switchScene(Scene0010(), SCENE_TRANSITION.FADE_IO)
end

function MainMenu:_notAvailableForDemo()
    self.camera:smallShake()
    Tutorial(gfx.getString("mainmenu.notfordemo"), 30)
    self:_openMenu()
end

function MainMenu:_goBack()
    PressButtonToBegin(function() self:_createMenu() end)
    self.planetAnimator = gfx.animator.new(1000, self.planet.y, 190, playdate.easingFunctions.outCubic, 500)
    self.logoAnimator = gfx.animator.new(1000, self.logo.y, 50, playdate.easingFunctions.outBack)
end

function MainMenu:cleanup()
    self.planet:remove()
    self.planetAnimator = nil
    self.plax1:remove()
    self.plax2:remove()
    self.logo:remove()
    self.logoAnimator = nil
end