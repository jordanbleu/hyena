

---Takes time in milliseconds and returns how many frames / update cycles should roughly occur in that time.
---@param millisecs integer time in ms
function playdate.convertMsToFrames(millisecs) 
    return (millisecs/1000) * GLOBAL_TARGET_FPS
end

---Loads data from a csv file into a table and returns the data as tables
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
            
            local parts = string.split(line, "|")
            
            local chunk = {
                avatarId = parts[1],
                title = parts[2],
                text = parts[3]
            }
            
            table.insert(chunks, chunk)
        end

    until line == nil

    pdFile:close()
    return chunks

end