SCREEN_EFFECT_CACHE = {}
globalCache = {}

---This will load the screen effect cache.  WARNING: This cache is very taxing, and should only be called once.
function globalCache.preComputeScreenEffects()
    local gfx <const> = playdate.graphics
    -- tweak this for more frames / worse performance (max is 100)

    SCREEN_EFFECT_CACHE.White = {}
    SCREEN_EFFECT_CACHE.Black = {}

    local ditherType = gfx.image.kDitherTypeBayer8x8

    -- pre-compute all white frames for the flashing effect.
    for i=0, GLOBAL_TRANSITION_QUALITY, 1 do

        local alpha = (i/GLOBAL_TRANSITION_QUALITY)

        local fadedImage = gfx.image.new(400,240)

        -- we are now drawing onto the faded image directly
        gfx.pushContext(fadedImage)
            local filledRect = gfx.image.new(400,240, gfx.kColorWhite)
            filledRect:drawFaded(0, 0, alpha, ditherType)
        gfx.popContext()

        SCREEN_EFFECT_CACHE.White[i] = fadedImage
    end

    -- pre-compute all black frames for the flashing effect.
    for i=0, GLOBAL_TRANSITION_QUALITY, 1 do

        local alpha = (i/GLOBAL_TRANSITION_QUALITY)

        local fadedImage = gfx.image.new(400,240)

        -- we are now drawing onto the faded image directly
        gfx.pushContext(fadedImage)
            local filledRect = gfx.image.new(400,240, gfx.kColorBlack)
            filledRect:drawFaded(0, 0, alpha, ditherType)
        gfx.popContext()

        SCREEN_EFFECT_CACHE.Black[i] = fadedImage
    end
end