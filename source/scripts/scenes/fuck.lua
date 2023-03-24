import "scripts/scenes/base/scene"
import "scripts/actors/player"
import "scripts/camera/camera"
import "scripts/sprites/parallaxLayer"

import "scripts/actors/grunt"
import "scripts/actors/rangedGrunt"
import "scripts/actors/tinyGuy"

import "scripts/actors/deathStar"
import "scripts/actors/diveBomb"
import "scripts/actors/shieldRangedGrunt"

import "scripts/ui/hud"
import "scripts/ui/weaponSelector"
import "scripts/ui/gameplayDialogue"

import "scripts/ui/typer"

local gfx <const> = playdate.graphics

class("Fuck").extends(Scene)

function Fuck:initialize(sceneManager)
    Fuck.super.initialize(self, sceneManager)
    Typer(10,180,"I'm mad because this stupid code isn't working.",3, 32)
end

function Fuck:update()

end
