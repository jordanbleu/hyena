local gfx <const> = playdate.graphics

--[[
    An animation director object pretty much just reports if it is done or not lol
]]
class("AnimationDirector").extends(gfx.sprite)


function AnimationDirector:isCompleted() 
    return false
end

function AnimationDirector:cleanup() end