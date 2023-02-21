local gfx <const> = playdate.graphics

--[[
    The camera basically just set the global draw offset to it's x / y position.
]]
class("Camera").extends(gfx.sprite)

function Camera:init()

    -- how shakey the camera currently is
    -- todo: implement
    self.shake = 0.5

    self:setIgnoresDrawOffset(true)
    self:moveTo(0,0)
end


function Camera:update()

    gfx.setDrawOffset(-self.x, -self.y)

    -- todo: these are just testing the panning ability of the camera.  Delete them because they dumb.
    if (playdate.buttonIsPressed(playdate.kButtonUp)) then
        self.y = self.y - 1
    elseif (playdate.buttonIsPressed(playdate.kButtonDown)) then 
        self.y = self.y + 1
    end

    if (playdate.buttonIsPressed(playdate.kButtonLeft)) then
        self.x = self.x -1 
    elseif (playdate.buttonIsPressed(playdate.kButtonRight)) then
        self.x = self.x + 1
    end

end

