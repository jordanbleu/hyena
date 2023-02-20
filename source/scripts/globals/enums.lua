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
