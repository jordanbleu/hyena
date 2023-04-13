local gfx <const> = playdate.graphics


--[[ 
    Three ships fly past and shake camera 
]]
class("FriendsFlyBy").extends(gfx.sprite)

function FriendsFlyBy:init(cameraInst)
    self.camera = cameraInst

    self.image = gfx.image.new("images/player")
    self.bigImage = gfx.image.new("images/player-2x")

    self.sprite1 = gfx.sprite.new(self.image)
    self.sprite1:moveTo(50, 300)
    self.sprite1:add()

    self.sprite2 = gfx.sprite.new(self.bigImage)
    self.sprite2:moveTo(300, 300)
    self.sprite2:add()

    self.sprite3 = gfx.sprite.new(self.image)
    self.sprite3:moveTo(250, 300)
    self.sprite3:add()

    self.animator1 = gfx.animator.new(2000, 300,-50, playdate.easingFunctions.inOutExpo)
    self.animator2 = gfx.animator.new(2100, 300,-50, playdate.easingFunctions.inOutExpo, 2000)
    self.animator3 = gfx.animator.new(1700, 300,-50, playdate.easingFunctions.inOutExpo, 3000)


    self.shake1 = false
    self.shake2 = false
    self.shake3 = false

    self:add()
end 

function FriendsFlyBy:update()

    self.sprite1:moveTo(self.sprite1.x, self.animator1:currentValue())
    self.sprite2:moveTo(self.sprite2.x, self.animator2:currentValue())
    self.sprite3:moveTo(self.sprite3.x, self.animator3:currentValue())

    if (not self.shake1 and self.sprite1.y < 120) then
        self.camera:wideSway()
        self.shake1 = true  
    end

    if (not self.shake2 and self.sprite2.y < 120) then
        self.camera:massiveSway()
        self.shake2 = true
    end

    if (not self.shake3 and self.sprite3.y < 120) then
        self.camera:wideSway()
        self.shake3 = true
    end

    if (self.animator3:ended()) then
        self:remove()
    end

end

function FriendsFlyBy:remove()
    self.sprite1:remove()
    self.sprite2:remove()
    self.sprite3:remove()
end