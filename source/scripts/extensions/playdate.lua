
---Takes time in milliseconds and returns how many frames / update cycles should roughly occur in that time.
---@param millisecs integer time in ms
function playdate.convertMsToFrames(millisecs) 
    return (millisecs/1000) * GLOBAL_TARGET_FPS
end