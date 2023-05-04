local gfx <const> = playdate.graphics

--[[ 
    Extend this class if you are an enemy project sprite (bullet, etc) of some sort.
]] 
class("EnemyProjectileSprite").extends(SingleSpriteAnimation)

function EnemyProjectileSprite:getDamageAmount()
    return 10
end

function EnemyProjectileSprite:damageEnabled()
    return true
end