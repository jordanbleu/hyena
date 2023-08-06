-- local gfx <const> = playdate.graphics

-- import "scripts/effects/playerSplotcher"
-- import "scripts/scenes/scene0080"


-- --[[
--     First hallucination scene.  
-- ]]
-- class("Scene0070").extends(SegmentedScene)

-- function Scene0070:initialize(sceneManager)
--     self.sceneManager = sceneManager

--     local segments = {}
--     local blackBg = sceneHelper.addBlackBackground()

--     local camera = Camera()
--     local player = Player(camera, sceneManager)
--     player:moveTo(200,200)
    
--     local segments = {}
    
--     local plax1 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-farther"),0,1)
--     plax1:setZIndex(1)
--     local plax2 = ParallaxLayer(gfx.image.new("images/backgrounds/stars-far"),0,3)
--     plax2:setZIndex(2)


--     table.insert(segments, function()
--         return WaitSegment(3000)
--     end)
    
--     table.insert(segments, function()
--         return DialogueSegment("scene0070/voice.txt", player, camera)
--     end)

--     table.insert(segments, function()
--         return WaitSegment(1000)
--     end)

--     local plax3 = nil
--     local splotcher = nil
--     table.insert(segments, function()
--         plax1:remove()
--         plax2:remove()
    
--         blackBg:remove()
--         ScreenFlash(250, gfx.kColorWhite)
--         splotcher = PlayerSplotcher(player)
--         plax3 = ParallaxLayer(gfx.image.new("images/backgrounds/patterns/abstract"),0,-2)
--         camera:setNormalSway(6, 0.20)
--         return WaitSegment(1000)
--     end)


--     table.insert(segments, function()
--         return DialogueSegment("scene0070/voice2.txt", player, camera)
--     end)

--     table.insert(segments, function()
--         ScreenFlash(1000, gfx.kColorWhite)
--         plax3:remove()
--         camera:removeNormalSway()
--         splotcher:remove()

--         return WaitSegment(3000)
--     end)

--     table.insert(segments, function()
--         return DialogueSegment("scene0070/voice3.txt", player, camera)
--     end)
    
--     Scene0070.super.initialize(self, segments, sceneManager)
-- end

-- function Scene0070:completeScene()
--     self.sceneManager:switchScene(Scene0080(), SCENE_TRANSITION.FADE_IO)
-- end