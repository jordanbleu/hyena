--[[ 
    Welcome to the enums file 
    
    Lua doesn't have enums so these are just globally accesible tables.
    
    Since this file is imported in main.lua there's no need to call import again.
]]

SCENE_TRANSITION = 
{
    -- Hard cut will immediately transition to the next scene, no delay or animation.
    HARD_CUT = 0,
    -- linear fade in / out
    FADE_IO  = 1
}

--[[ Layers used for sprite collision.  These are just consts for numbers 1-32.  
    See https://sdk.play.date/1.13.1/Inside%20Playdate.html#M-sprite-collisions for more info.  
]]
COLLISION_LAYER = 
{
    PLAYER = 1,
    ENEMY = 2,
    PLAYER_PROJECTILE = 3,
    ENEMY_PROJECTILE = 4
}
