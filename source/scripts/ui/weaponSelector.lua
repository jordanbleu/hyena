local gfx <const> = playdate.graphics


--[[ The HUD displays health, energy, and the selected weapon ]]
class("WeaponSelector").extends(gfx.sprite)


local STATE <const> = 
{
    HIDDEN = 1,
    ANIMATING_IN = 2,
    SHOWN =3,
    ANIMATING_OUT =4
}

-- how many update cycles the user has to be holding B for the selector to show
local HOLD_B_CYCLES_TO_WAIT<const> = 10
local ANIMATION_DURATION<const> = 500

function WeaponSelector:init(playerInst)
    self.player = playerInst

    self.state = STATE.HIDDEN
    self.holdBCycleCount = 0

    self.blurSprite = gfx.sprite.new(gfx.image.new("images/ui/blur-overlay"))
    self.blurSprite:moveTo(200,120)
    self.blurSprite:setZIndex(101)
    self.blurSprite:setZIndex(102)
    self.blurSprite:setIgnoresDrawOffset(true)

    -- Load all the center sprite images into memory
    self.centerSpriteImages = {}
    self.centerSpriteImages[WEAPON.MINE] = gfx.image.new("images/ui/hud/center-sprite-mine")
    self.centerSpriteImages[WEAPON.SHIELD] = gfx.image.new("images/ui/hud/center-sprite-deflector")
    self.centerSpriteImages[WEAPON.EMP] = gfx.image.new("images/ui/hud/center-sprite-emp")
    self.centerSpriteImages[WEAPON.LASER] = gfx.image.new("images/ui/hud/center-sprite-laser")
    self.centerSpriteImages[WEAPON.DASH] = gfx.image.new("images/ui/hud/center-sprite-dash")
    self.centerSpriteImages[WEAPON.MISSILE] = gfx.image.new("images/ui/hud/center-sprite-missile")

    self.centerSprite = gfx.sprite.new(self.centerSpriteImages[self.player:getSelectedWeaponId()])
    self.centerSprite:moveTo(200,120)
    self.centerSprite:setZIndex(105)
    self.centerSprite:setIgnoresDrawOffset(true)

    self.arrowSprite = gfx.sprite.new(gfx.image.new("images/ui/hud/center-sprite-arrows"))
    self.arrowSprite:moveTo(200,120)
    self.arrowSprite:setZIndex(105)
    self.arrowSprite:setIgnoresDrawOffset(true)

    -- Now, we just load a shit ton of images :)
    self.dashSelectorSelectedImage = gfx.image.new("images/ui/hud/dash-selector-selected")
    self.dashSelectorImage = gfx.image.new("images/ui/hud/dash-selector")
    self.dashSelectorSprite = gfx.sprite.new(self.dashSelectorImage)
    self.dashSelectorSprite:moveTo(200,120)
    self.dashSelectorSprite:setZIndex(103)
    self.dashSelectorSprite:setIgnoresDrawOffset(true)

    self.empSelectorSelectedImage = gfx.image.new("images/ui/hud/emp-selector-selected")
    self.empSelectorImage = gfx.image.new("images/ui/hud/emp-selector")
    self.empSelectorSprite = gfx.sprite.new(self.empSelectorImage)
    self.empSelectorSprite:moveTo(200,120)
    self.empSelectorSprite:setZIndex(103)
    self.empSelectorSprite:setIgnoresDrawOffset(true)

    self.laserSelectorSelectedImage = gfx.image.new("images/ui/hud/laser-selector-selected")
    self.laserSelectorImage = gfx.image.new("images/ui/hud/laser-selector")
    self.laserSelectorSprite = gfx.sprite.new(self.laserSelectorImage)
    self.laserSelectorSprite:moveTo(200,120)
    self.laserSelectorSprite:setZIndex(103)
    self.laserSelectorSprite:setIgnoresDrawOffset(true)

    self.mineSelectorSelectedImage = gfx.image.new("images/ui/hud/mine-selector-selected")
    self.mineSelectorImage = gfx.image.new("images/ui/hud/mine-selector")
    self.mineSelectorSprite = gfx.sprite.new(self.mineSelectorImage)
    self.mineSelectorSprite:moveTo(200,120)
    self.mineSelectorSprite:setZIndex(103)
    self.mineSelectorSprite:setIgnoresDrawOffset(true)

    self.missileSelectorSelectedImage = gfx.image.new("images/ui/hud/missile-selector-selected")
    self.missileSelectorImage = gfx.image.new("images/ui/hud/missile-selector")
    self.missileSelectorSprite = gfx.sprite.new(self.missileSelectorImage)
    self.missileSelectorSprite:moveTo(200,120)
    self.missileSelectorSprite:setZIndex(103)
    self.missileSelectorSprite:setIgnoresDrawOffset(true)

    self.shieldSelectorSelectedImage = gfx.image.new("images/ui/hud/shield-selector-selected")
    self.shieldSelectorImage = gfx.image.new("images/ui/hud/shield-selector")
    self.shieldSelectorSprite = gfx.sprite.new(self.shieldSelectorImage)
    self.shieldSelectorSprite:moveTo(200,120)
    self.shieldSelectorSprite:setZIndex(103)
    self.shieldSelectorSprite:setIgnoresDrawOffset(true)

    self.animator = nil
    self:add()
end

function WeaponSelector:update()

    -- normal update flows
    if (self.state == STATE.HIDDEN) then
        self:_waitForHoldButton()
    elseif (self.state == STATE.ANIMATING_IN) then
        self:_waitForAnimateIn()
    elseif (self.state == STATE.ANIMATING_OUT) then
        self:_waitForAnimateOut()
    end

    -- You can start selecting a weapon even while the screen is animating in
    if (self.state ~= STATE.HIDDEN and self.state ~= STATE.ANIMATING_OUT) then
        self:_updateUI()
    end


    -- if the user releases the B button at any time, reset everything.
    if (playdate.buttonJustReleased(playdate.kButtonB)) then
        self.holdBCycleCount = 0
        if (self.state ~= STATE.HIDDEN and self.state ~= STATE.ANIMATING_OUT) then
            print "ENTER: ANIMATING OUT"
            self.arrowSprite:remove()
            self.animator = gfx.animator.new(ANIMATION_DURATION, 1, 0, playdate.easingFunctions.outCubic)
            self.state = STATE.ANIMATING_OUT
        end   
    end

end

function WeaponSelector:_waitForHoldButton()
    if (playdate.buttonIsPressed(playdate.kButtonB)) then
        self.holdBCycleCount = self.holdBCycleCount + 1

        print ("held b for cycles->" .. self.holdBCycleCount)

        if (self.holdBCycleCount > HOLD_B_CYCLES_TO_WAIT) then
            print "ENTER: ANIMATING IN"

            -- disallow attacks while the menu is open.
            self.player:setAllowAttacks(false)

            -- Set's the game time to slow motion.
            GLOBAL_TIME_DELAY = 300

            self.animator = gfx.animator.new(ANIMATION_DURATION, 0, 1,  playdate.easingFunctions.outCubic)
            self.state = STATE.ANIMATING_IN

            -- add all the sprites to the batch
            self.blurSprite:add()
            self.centerSprite:add()
            self.dashSelectorSprite:add()
            self.empSelectorSprite:add()
            self.laserSelectorSprite:add()
            self.missileSelectorSprite:add()
            self.mineSelectorSprite:add()
            self.shieldSelectorSprite:add()
            self.holdBCycleCount = 0
        end
    end
end

function WeaponSelector:_waitForAnimateIn()

    local animValue = self.animator:currentValue()

    print ("Animating in, Current anim value => " .. animValue)
    self:_updateSelectorPositions(animValue)

    if (self.animator:ended()) then
        print "ENTER: SHOWN"
        self.arrowSprite:add()
        self.state = STATE.SHOWN
    end
    
end

function WeaponSelector:_updateUI()

    -- Set the center sprite
    local weaponId = self.player:getSelectedWeaponId()
    self.centerSprite:setImage(self.centerSpriteImages[weaponId])

    -- just set all the images to the normal ones because i am lazy
    self.dashSelectorSprite:setImage(self.dashSelectorImage)
    self.empSelectorSprite:setImage(self.empSelectorImage)
    self.laserSelectorSprite:setImage(self.laserSelectorImage)
    self.missileSelectorSprite:setImage(self.missileSelectorImage)
    self.mineSelectorSprite:setImage(self.mineSelectorImage)
    self.shieldSelectorSprite:setImage(self.shieldSelectorImage)

    -- and now update the actually selected one 
    if (weaponId == WEAPON.DASH) then
        self.dashSelectorSprite:setImage(self.dashSelectorSelectedImage)
    elseif (weaponId == WEAPON.EMP) then
        self.empSelectorSprite:setImage(self.empSelectorSelectedImage)
    elseif (weaponId == WEAPON.LASER) then
        self.laserSelectorSprite:setImage(self.laserSelectorSelectedImage)
    elseif (weaponId == WEAPON.MINE) then
        self.mineSelectorSprite:setImage(self.mineSelectorSelectedImage)
    elseif (weaponId == WEAPON.MISSILE) then
        self.missileSelectorSprite:setImage(self.missileSelectorSelectedImage)
    elseif (weaponId == WEAPON.SHIELD) then
        self.shieldSelectorSprite:setImage(self.shieldSelectorSelectedImage)
    end

    -- now we check for arrows
    -- todo: click noises should be played here 
    -- todo: Prevent selecting weapons you don't have access to yet 
    if (playdate.buttonJustPressed(playdate.kButtonLeft)) then
        self.player:setSelectedWeaponId(WEAPON.MISSILE)
    elseif (playdate.buttonJustPressed(playdate.kButtonRight)) then
        self.player:setSelectedWeaponId(WEAPON.EMP)
    elseif (playdate.buttonJustPressed(playdate.kButtonUp)) then
        if (weaponId == WEAPON.LASER) then
            self.player:setSelectedWeaponId(WEAPON.MINE)
        else
            self.player:setSelectedWeaponId(WEAPON.LASER)
        end
    elseif (playdate.buttonJustPressed(playdate.kButtonDown)) then
        if (weaponId == WEAPON.DASH) then
            self.player:setSelectedWeaponId(WEAPON.SHIELD)
        else 
            self.player:setSelectedWeaponId(WEAPON.DASH)
        end
    end

    -- todo: blink arrows maybe ?

    -- Make sure nobody else modifies the time delay but us 
    GLOBAL_TIME_DELAY = 300

end

function WeaponSelector:_waitForAnimateOut()
    local animValue = self.animator:currentValue()
    print ("Animating out, Current anim value => " .. animValue)
    self:_updateSelectorPositions(animValue)

    if (self.animator:ended()) then
        print "ENTER: HIDDEN"

        -- re-allow attacks.
        self.player:setAllowAttacks(true)

        -- Restore the game time back to zero.
        GLOBAL_TIME_DELAY = 0

        -- arrows sprite is removed prior to this 
        self.blurSprite:remove()
        self.centerSprite:remove()
        self.dashSelectorSprite:remove()
        self.empSelectorSprite:remove()
        self.laserSelectorSprite:remove()
        self.missileSelectorSprite:remove()
        self.mineSelectorSprite:remove()
        self.shieldSelectorSprite:remove()
        self.state = STATE.HIDDEN
    end
end

function WeaponSelector:_updateSelectorPositions(percent)

    local startX = 200
    local startY = 120

    ----
    -- the magic numbers below are the deviation the selector should be from the center of the screen.
    -- upon completion of the animation.
    ----

    -- missile 
    local missileSelectorX = startX + (-40 * percent)
    self.missileSelectorSprite:moveTo(missileSelectorX, self.missileSelectorSprite.y)

    -- EMP
    local empSelectorX = startX + (40 * percent)
    self.empSelectorSprite:moveTo(empSelectorX, self.empSelectorSprite.y)

    -- dash
    local dashSelectorY = startY + (40 * percent)
    self.dashSelectorSprite:moveTo(self.dashSelectorSprite.x, dashSelectorY)

    -- deflector AKA shield
    local shieldSelectorY = startY + (70 * percent)
    self.shieldSelectorSprite:moveTo(self.shieldSelectorSprite.x, shieldSelectorY)

    -- laser
    local laserSelectorY = startY + (-40 * percent)
    self.laserSelectorSprite:moveTo(self.laserSelectorSprite.x, laserSelectorY)

    -- mine
    local mineSelectorY = startY + (-70 * percent)
    self.mineSelectorSprite:moveTo(self.mineSelectorSprite.x, mineSelectorY)

end
