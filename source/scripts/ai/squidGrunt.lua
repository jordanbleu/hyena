
import "scripts/ai/behaviors/squidBehavior"

--[[
    The grunt enemy moves vaguely downwards and towards the player
]]
class("SquidGrunt").extends(SquidBehavior)

function SquidGrunt:init(x,y, playerInst, cameraInst)

    local idleImagePath = "images/enemies/grimideanGruntAnim/idle"
    local deathImagePath = "images/enemies/grimideanGruntAnim/death"
    local maxHealth = 3

    SquidGrunt.super.init(self, idleImagePath, 500, x, y, maxHealth, playerInst, cameraInst)

    self.deathAnimationImagePath = deathImagePath

end
