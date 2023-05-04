local gfx <const> = playdate.graphics

import "scripts/sprites/spriteAnimation"
import "scripts/actors/cursedNeuron/neuronNode"
import "scripts/actors/diveBomb"
import "scripts/actors/grunt"
import "scripts/effects/screenFlash"

--[[ 
    The cursed neuron is the first boss of the game (as of this writing).

    it is an neuron-like thing that is surrounded by 5 different pods.  The pods can shoot at you.
    In between the pods is a shield.  If you destroy a pod it will eventually repair itself.

    If you destroy three pods, the shield will be disabled temporarily, leaving the main enemy vulnerable.
]] 
class("CursedNeuron").extends(Enemy)

function CursedNeuron:init(playerInst, cameraInst, bossBarInst)
    
    CursedNeuron.super.init(self,80)

    self.bossBar = bossBarInst
    self.camera = cameraInst
    self.player = playerInst 

    self:moveTo(200, 50)
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
    self.fleshSprites[1][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-left", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[1][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/top-right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[2][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y, false, false)

    self.fleshSprites[2][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][2]:add()

    self.fleshSprites[2][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[2][3]:add()

    self.fleshSprites[2][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[3][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/left", fleshAnimSpeed, self.x, self.y, false, false)

    self.fleshSprites[3][2] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][2]:add()

    self.fleshSprites[3][3] = gfx.sprite.new(centerImg)
    self.fleshSprites[3][3]:add()
    
    self.fleshSprites[3][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/right", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][1] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-left", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][2] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][3] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom", fleshAnimSpeed, self.x, self.y, false, false)
    self.fleshSprites[4][4] = SpriteAnimation("images/bosses/cursedNeuron/fleshAnim/bottom-right", fleshAnimSpeed, self.x, self.y, false, false)

    self.armTopRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topright", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armTopRightSprite:setZIndex(22)
    self.armTopRightSprite:setRepeats(-1)

    self.armTopLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/topleft", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armTopLeftSprite:setZIndex(22)
    self.armTopLeftSprite:setRepeats(-1)

    self.armBottomLeftSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomleft", fleshAnimSpeed*2, self.x, self.y, false, false)
    self.armBottomLeftSprite:setZIndex(22)
    self.armBottomLeftSprite:setRepeats(-1)

    self.armBottomRightSprite = SpriteAnimation("images/bosses/cursedNeuron/armAnim/bottomright", fleshAnimSpeed*2, self.x, self.y, false, false)
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

    self.leftNode = NeuronNode(playerInst, cameraInst)
    self.bottomNode = NeuronNode(playerInst, cameraInst)
    self.rightNode = NeuronNode(playerInst, cameraInst)

    self.shieldSprite = gfx.sprite.new(gfx.image.new("images/bosses/cursedNeuron/shield"))
    self.shieldSprite:setZIndex(23)
    self.shieldSprite:add()

    self.leftConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/horizontal", 200, self.x, self.y, false, false)
    self.leftConnector:setRepeats(-1)
    self.rightConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/horizontal", 200, self.x, self.y, false, false)
    self.rightConnector:setRepeats(-1)
    self.bottomConnector = SpriteAnimation("images/bosses/cursedNeuron/connectorAnim/vertical", 200, self.x, self.y, false, false)
    self.bottomConnector:setRepeats(-1)

    --
    -- Movement Patterns
    -- Moves to a location, waits a random amount of time, and moves to a new location 
    --
    self.xMin = 100
    self.xMax = 300
    self.yMin = 25
    self.yMax = 75
    self.moveSpeed = 1
    self.xDestination = self.x
    self.yDestination = self.y

    self.moveWaitCycleCounterEnabled = false 

    self.moveWaitCycleCounter = 0
    -- how long to wait before picking a new location to move to 
    self.moveWaitCycles = 200

    -- how far up / down to bob
    self.yOffsetSize = 5
    -- current amount the boss has bobbed
    self.yOffset = 0
    -- how fast the boss bobs
    self.yOffsetVelocity = 0.35

    -- collision 
    self:setCollideRect(-32,-32,64,64)
    self:setGroups({COLLISION_LAYER.ENEMY})
    self:setCollidesWithGroups({COLLISION_LAYER.PLAYER, COLLISION_LAYER.PLAYER_PROJECTILE})
    
    self.shieldActive = true
    
    --[[

        0 - dude just sits there
        1 - moves around
        2 - spawn enemies
        3 - moves more and spawn enemies
        4 - spawn a few more enemies
    ]]
    self.phase = 0

    self:add()
end

function CursedNeuron:update()

    
    self:_moveAllSprites()
    self:_checkCollisions()
    self:_updatePosition()
    self:_updateShieldState()
    self:_updatePhase()

    CursedNeuron.super.update(self)
end

function CursedNeuron:_updateShieldState()
    local leftNodeAlive = self.leftNode:isAlive()
    local rightNodeAlive = self.rightNode:isAlive()
    local bottomNodeAlive = self.bottomNode:isAlive()

    local allDead = not leftNodeAlive and not rightNodeAlive and not bottomNodeAlive

    if (allDead) then
        self.shieldActive = false
        self.shieldSprite:setVisible(false)
    else
        self.shieldActive = true
        self.shieldSprite:setVisible(true)
    end
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

    self.leftNode:moveTo(self.x - 100, self.y)
    self.rightNode:moveTo(self.x + 100, self.y)
    self.bottomNode:moveTo(self.x, self.y + 100)
    self.shieldSprite:moveTo(self.x, self.y)

    self.leftConnector:moveTo(self.x-80, self.y)
    self.leftConnector:setVisible(self.leftNode:isAlive())

    self.rightConnector:moveTo(self.x+80, self.y)
    self.rightConnector:setVisible(self.rightNode:isAlive())
    
    self.bottomConnector:moveTo(self.x, self.y+80)
    self.bottomConnector:setVisible(self.bottomNode:isAlive())
end

function CursedNeuron:_updatePosition()
    
    local newX = self.x 
    local newY = self.y - self.yOffset
    
    -- offset 
    local currentOffset = math.abs(self.yOffset)
    if (currentOffset > self.yOffsetSize) then
        self.yOffsetVelocity = -self.yOffsetVelocity
    end

    self.yOffset += self.yOffsetVelocity

    -- move towards the destination 
    if (self.moveWaitCycleCounterEnabled) then
        self.moveWaitCycleCounter += 1
    end

    if (self.moveWaitCycleCounter > self.moveWaitCycles) then
        self.xDestination = math.random(self.xMin, self.xMax)
        self.yDestination = math.random(self.yMin, self.yMax)
        
        self.moveWaitCycleCounter = 0
    end

    if (math.isWithin(newX, self.moveSpeed, self.xDestination)) then
        newX = self.xDestination
    else 
        newX = math.moveTowards(newX, self.xDestination, self.moveSpeed)
    end

    if (math.isWithin(newY, self.moveSpeed, self.yDestination)) then
        newY = self.yDestination
    else 
        newY = math.moveTowards(newY, self.yDestination, self.moveSpeed)
    end


    self:moveTo(newX, newY + self.yOffset)
end

function CursedNeuron:_checkCollisions()
    local collisions = self:overlappingSprites()
    
    for i,col in ipairs(collisions) do
         
        if (col:isa(PlayerBullet)) then

            if (self.shieldActive) then
                col:ricochet()
                local spr = SingleSpriteAnimation("images/effects/shieldAbsorbAnim/absorb", 250,col.x, col.y)
                spr:setZIndex(50)

            else

                local spr = SingleSpriteAnimation("images/effects/explosionAnim/explosion-inverted", 250,self.x, self.y)
                spr:setZIndex(50)
                col:destroy()
                self:damage(1)
                self.bossBar:setPercent(self:getHealthPercent())
                self.camera:mediumShake()             

            end
        end
    end
end

function CursedNeuron:_updatePhase()
    local hp = self:getHealthPercent() 

    -- phase 1
    if (hp < 0.8 and self.phase == 0) then
        -- move right when the phase is hit so the player knows what's up 
        self.moveWaitCycleCounter = self.moveWaitCycles
        self.moveWaitCycleCounterEnabled = true
        ScreenFlash(250, gfx.kColorWhite)
        self.phase = 1
    
    -- phase 2
    elseif (hp < 0.65 and self.phase == 1) then
        DiveBomb(50, -30, self.camera, self.player)
        DiveBomb(300, -35, self.camera, self.player)
        Grunt(100, -30, self.camera, self.player)
        Grunt(120, -45, self.camera, self.player)
        ScreenFlash(500, gfx.kColorWhite)
        self.phase = 2
        
        -- phase 3 
    elseif (hp < 0.3 and self.phase == 2) then
        -- set movement wait time 
        DiveBomb(50, -30, self.camera, self.player)
        DiveBomb(100, -40, self.camera, self.player)
        DiveBomb(300, -60, self.camera, self.player)
        DiveBomb(300, -35, self.camera, self.player)
        DiveBomb(200, -45, self.camera, self.player)
        Grunt(100, -30, self.camera, self.player)
        ScreenFlash(300, gfx.kColorWhite)
        -- he moves slightly more often
        self.moveWaitCycles = 150
        self.phase = 3

    end
end