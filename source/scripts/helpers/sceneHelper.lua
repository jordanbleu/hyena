local gfx <const> = playdate.graphics
sceneHelper = {}

---This will automatically spawn all the basic gameplay needs and return them in a table.
--- Will create camera, player, hud, and weapon selector only.
function sceneHelper.setupGameplayScene(sceneManager)

    local camera = Camera()
    local player = Player(camera, sceneManager)
    local hud = Hud(player)
    local weaponSelector = WeaponSelector(player)

    return {
        camera = camera,
        player = player,
        hud = hud,
        weaponSelector = weaponSelector
    }

end

---Adds a black sprite to the background of the scene.
---@return any sprite background sprite
function sceneHelper.addBlackBackground()
    local bgSprite = gfx.sprite.new(gfx.image.new("images/black"))
    bgSprite:moveTo(200,120)
    bgSprite:setZIndex(0)
    bgSprite:add()
    return bgSprite
end