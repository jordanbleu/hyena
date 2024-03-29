local gfx <const> = playdate.graphics


--[[ The HUD displays health, energy, and the selected weapon ]]
class("Hud").extends(gfx.sprite)

function Hud:init(playerInst)

    local hudHeight = 12
    local healthBarGap = 100
    local badgeGap = 160
    self.player = playerInst

    -- since redrawing is taxing, defer it.
    self.redrawCycles = 10
    self.redrawCycleCounter = 0
    self.lastSelectedWeapon = self.player:getSelectedWeaponId()

    -- load images for each weapon type into memory for big speed.
    self.weaponImages = {}
    self.weaponImages[WEAPON.MINE] = gfx.image.new("images/ui/hud/mine-main")
    self.weaponImages[WEAPON.LASER] = gfx.image.new("images/ui/hud/laser-main")
    self.weaponImages[WEAPON.MISSILE] = gfx.image.new("images/ui/hud/missile-main")
    self.weaponImages[WEAPON.EMP] = gfx.image.new("images/ui/hud/emp-main")
    self.weaponImages[WEAPON.SHIELD] = gfx.image.new("images/ui/hud/shield-main")

    -- draw the selected weapon sprite
    self.weaponSprite = gfx.sprite.new(self.weaponImages[1])
    self.weaponSprite:setZIndex(100)
    self:_updateWeaponSprite()
    self.weaponSprite:moveTo(200,hudHeight)
    self.weaponSprite:setIgnoresDrawOffset(true)
    self.weaponSprite:add()

    -- draw the frame for the health bar 
    self.healthBarFrame = gfx.sprite.new(gfx.image.new("images/ui/hud/health-bar-frame"))
    self.healthBarFrame:moveTo(200-healthBarGap,hudHeight)
    self.healthBarFrame:setIgnoresDrawOffset(true)
    self.healthBarFrame:setZIndex(100)
    self.healthBarFrame:add()

    -- draw the icon for the health bar 
    self.healthBarBadge = gfx.sprite.new(gfx.image.new("images/ui/hud/health-bar-badge"))
    self.healthBarBadge:moveTo(200-badgeGap,hudHeight+1)
    self.healthBarBadge:setIgnoresDrawOffset(true)
    self.healthBarBadge:setZIndex(100)
    self.healthBarBadge:add()

    -- draw the rect for the health bar
    self.healthBarRect = gfx.image.new(92, 6)
    self.healthBarSprite = gfx.sprite.new(self.healthBarRect)
    self.healthBarSprite:moveTo(200-healthBarGap, hudHeight-1)
    self.healthBarSprite:setZIndex(100)
    self.healthBarSprite:setIgnoresDrawOffset(true)
    self.healthBarSprite:add()

    -- draw the frame for the energy bar
    self.energyBarFrame = gfx.sprite.new(gfx.image.new("images/ui/hud/energy-bar-frame"))
    self.energyBarFrame:moveTo(200 + healthBarGap,hudHeight)
    self.energyBarFrame:setIgnoresDrawOffset(true)
    self.energyBarFrame:setZIndex(100)
    self.energyBarFrame:add()

    -- draw the icon for the energy bar 
    self.energyBarBadge = gfx.sprite.new(gfx.image.new("images/ui/hud/energy-bar-badge"))
    self.energyBarBadge:moveTo(200+badgeGap,hudHeight+1)
    self.energyBarBadge:setIgnoresDrawOffset(true)
    self.energyBarBadge:setZIndex(100)
    self.energyBarBadge:add()
    
    -- draw the rect for the energy bar
    self.energyBarRect = gfx.image.new(92, 6)
    self.energyBarSprite = gfx.sprite.new(self.energyBarRect)
    self.energyBarSprite:moveTo(200+healthBarGap, hudHeight-1)
    self.energyBarSprite:setZIndex(100)
    self.energyBarSprite:setIgnoresDrawOffset(true)
    self.energyBarSprite:add()

    self.energyBarBadgeAnimation = SpriteAnimation("images/ui/hud/energyBarBadgeAnim/badge", 500, 200+badgeGap,hudHeight+1)
    self.energyBarBadgeAnimation:setZIndex(101)
    self.energyBarBadgeAnimation:setIgnoresDrawOffset(true)
    self.energyBarBadgeAnimation:setRepeats(-1)
    self.energyBarBadgeAnimation:hide()

    -- these are the values that are currently displayed 
    -- they are not necessarily up to date
    self.presentedHealth = 0
    self.presentedEnergy = 0

    self:add()

end

function Hud:update()
    Hud.super.update(self)
    
    local currentWeaponId = self.player:getSelectedWeaponId()
    if (self.lastSelectedWeapon ~= currentWeaponId) then
        self:_updateWeaponSprite()
        self.lastSelectedWeapon = currentWeaponId
    end
    
    self.redrawCycleCounter += 1
    if (self.redrawCycleCounter > self.redrawCycles) then
        self:_updateHealthBar()
        self:_updateEnergyBar()
        self.redrawCycleCounter = 0
    end
    self:_setFlashingEnergyIcon(self.player:isBigMode())

end

function Hud:_updateWeaponSprite()
    local selectedWeapon = self.player:getSelectedWeaponId()

    if (selectedWeapon == WEAPON.NONE) then
        -- before the player unlocks the first weapon, they won't have a selected weapon
        self.weaponSprite:setVisible(false)
    else 
        self.weaponSprite:setVisible(true)
        self.weaponSprite:setImage(self.weaponImages[selectedWeapon])
    end
end

function Hud:_updateHealthBar()
    local percent = self.player:getHealth()/ 100
    gfx.pushContext(self.healthBarRect)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(0, 0, percent * 92, 4)
    gfx.popContext()
end

function Hud:_updateEnergyBar()
    -- annoyingly for this to look cool we have to reverse it.
    local percent = self.player:getEnergy() / 100
    gfx.pushContext(self.energyBarRect)
        gfx.clear(gfx.kColorClear)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(92-(92*percent), 0, 92, 4)
    gfx.popContext()
end

function Hud:_setFlashingEnergyIcon(isEnabled)
    if (isEnabled) then
        self.energyBarBadgeAnimation:show()
    else
        self.energyBarBadgeAnimation:hide()
    end
end