local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"


--[[ 
    The cursed neuron is the first boss of the game (as of this writing).

    it is an neuron-like thing that is surrounded by 5 different pods.  The pods can shoot at you.
    In between the pods is a shield.  If you destroy a pod it will eventually repair itself.

    If you destroy three pods, the shield will be disabled temporarily, leaving the main enemy vulnerable.
]] 
class("CursedNeuron").extends(Enemy)

function CursedNeuron:init(playerInst, cameraInst)
    CursedNeuron.super.init(self,500)

    self:moveTo(200, 100)
    -- parts

    -- the 'eye' / nucleus thing
    self.eyeSprite = SpriteAnimation("images/bosses/cursedNeuron/eyeAnim/idle", 1000, self.x, self.y)
    self.eyeSprite:setZIndex(23)
    self.eyeSprite:setRepeats(-1)
    
    -- outer bits, or 'flesh' or whatever you call it is really just separate independent animations

    local centerImg = gfx.image.new("images/bosses/cursedNeuron/flesh-middle")
    local fleshAnimSpeed = 750

    -- 2d array of the flesh sprites, first index being the row and second being the column
    self.fleshSprites = {}

    for i=1, 4 do
        self.fleshSprites[i] = {}
    end

    -- top left corner
    self.fleshSprites[1][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-left", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[1][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[1][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[1][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-right", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[2][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y)

    self.fleshSprites[2][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][2]:add()

    self.fleshSprites[2][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][3]:add()

    self.fleshSprites[2][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[3][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y)

    self.fleshSprites[3][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][2]:add()

    self.fleshSprites[3][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][3]:add()
    
    self.fleshSprites[3][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[4][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-left", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[4][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[4][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y)
    self.fleshSprites[4][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-right", fleshAnimSpeed, self.x, self.y)

    self.armTopRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topright", fleshAnimSpeed*2, self.x, self.y)
    self.armTopRightSprite:setZIndex(22)
    self.armTopRightSprite:setRepeats(-1)

    self.armTopLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topleft", fleshAnimSpeed*2, self.x, self.y)
    self.armTopLeftSprite:setZIndex(22)
    self.armTopLeftSprite:setRepeats(-1)

    self.armBottomLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomleft", fleshAnimSpeed*2, self.x, self.y)
    self.armBottomLeftSprite:setZIndex(22)
    self.armBottomLeftSprite:setRepeats(-1)

    self.armBottomRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomright", fleshAnimSpeed*2, self.x, self.y)
    self.armBottomRightSprite:setZIndex(22)
    self.armBottomRightSprite:setRepeats(-1)

    -- kinda lazy code below
    for r,row in ipairs(self.fleshSprites) do
        for c,col in ipairs(row) do
            local o = self.fleshSprites[r][c]
            o:setZIndex(21)
            o:setCenter(0,0)
            if (o:isa(SpriteAnimation)) then
                o:setRepeats(-1)
            end
        end   
    end

    self:add()
end

function CursedNeuron:update()
    self:_moveAllSprites()
    CursedNeuron.super.update(self)
end

function CursedNeuron:_moveAllSprites()
    -- this assumes that each section of the flesh portion is 16x16
    local startX = -32
    local startY = -32
    local size = 16

    for r,row in ipairs(self.fleshSprites) do
        for c,col in ipairs(row) do
           
            -- -- unadjusted locations
            local xx = self.x + ((c-1) * size)
            local yy = self.y + ((r-1) * size)

            local newX = xx + startX
            local newY = yy + startY
            self.fleshSprites[r][c]:moveTo(newX,newY)
        end   
    end

    self.eyeSprite:moveTo(self.x, self.y) -- this will eventaully be different
    self.armTopRightSprite:moveTo(self.x+36,self.y-36)
    self.armTopLeftSprite:moveTo(self.x-36,self.y-36)
    self.armBottomLeftSprite:moveTo(self.x-36,self.y+36)
    self.armBottomRightSprite:moveTo(self.x+36,self.y+36)


end