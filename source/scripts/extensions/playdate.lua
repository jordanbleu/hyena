

---Takes time in milliseconds and returns how many frames / update cycles should roughly occur in that time.
---@param millisecs integer time in ms
function playdate.convertMsToFrames(millisecs) 
    return (millisecs/1000) * GLOBAL_TARGET_FPS
end

---Loads dialogue from the specified file.  Dialogue is delimited by the pipe | (despite the param being named csv)
---@param csv string the file name within `strings/en/` including the extension
function playdate.loadDialogueFromCsv(csv) 

    local chunks = {}
    local path = "strings/dialogue-" .. GLOBAL_LANGUAGE_CODE .. "/" .. csv
    local pdFile = playdate.file.open(path)

    if (pdFile == nil) then
        error("The game installation appears to be corrupt.  Please re-install.", 1)
    end

    -- load the first line and ignore it, as it is the csv header.
    local line = pdFile:readline()

    repeat
        line = pdFile:readline()

        
        if (line ~= nil) then
            -- comments can be added with #
            if (string.startsWith(line, "#") or string.isBlank(line)) then
                goto continue
            end
            
            local parts = string.split(line, "|")
            
            local chunk = {
                avatarId = parts[1],
                title = parts[2],
                text = parts[3],
                textDelay = 0,
                camShakeLevel = 0
            }

            if (#parts > 3) then
                chunk.textDelay = tonumber(parts[4])
            end

            if (#parts > 4) then
                chunk.camShakeLevel = tonumber(parts[5])
            end
            
            table.insert(chunks, chunk)
        end

        ::continue::
    until line == nil

    pdFile:close()
    return chunks

end