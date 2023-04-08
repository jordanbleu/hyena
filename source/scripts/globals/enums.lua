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
    ENEMY_PROJECTILE = 4,
    PROJECTILE_DEFLECTOR = 5,
    POWERUP = 6
}

WEAPON = 
{
    MINE = 1,
    LASER = 2,
    MISSILE = 3,
    EMP = 4,
    SHIELD = 5
}

CUTSCENE_FRAME_EFFECT = 
{
    -- the image moves to the center of the screen and doesnt move 
    STATIC = 0,
    PAN_UP_DOWN = 1,
    -- Image will start on the left side, and scroll to the right.  
    PAN_LEFT_RIGHT = 2,
    -- Image will start on the right side then scroll to the left
    PAN_RIGHT_LEFT = 3,
    PAN_DOWN_UP = 4,
    SINGLE_SHAKE = 5
}

-- checkpoints are a lame way to track game data without relying on a scene or something.
-- each checkpoint dictates which items you unlock / player state as well as which scene should be loaded.
-- It gets saved into a save data file.
CHECKPOINT = {
    START = 0,
    TEST = 1
}
