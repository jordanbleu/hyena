---Splits a string by the separator, and returns an array of strings
---@param inputstr string delimited string
---@param sep string delimiter
---@return table
function string.split(inputstr, sep)

    inputstr = inputstr or ""
    
    if sep == nil then
        sep = "%s"
    end

    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

---Takes an input string, applies word wrap, and returns an array containing the wrapped lines.
---The returned array will never be larger than the specified `maxLines`.  If the string is too
---long to fit in the specified limits, the last line will be longer than the desired `charsPerLine`.
---@param str string The full input string
---@param charsPerLine integer How many maximum characters are allowed on a single line (if possible)
---@param maxLines integer How many maximum lines to return.
---@return table
function string.wordWrap(str, charsPerLine, maxLines)
    local words = string.split(str, " ")
    
    -- an jagged array containing stringbuffers for each line
    local lines = {}
    local lineIndex = 1

    for i,word in ipairs(words) do

        if (i == 1) then
            -- Insert the first word into the first stringbuffer.
            -- We also store the length in the table so we don't need to re-count string lengths. 
            table.insert(lines, { length = string.len(words[1]), words = {words[1]}})
            goto continue
        end

        local stringBuffer = lines[lineIndex]
        local stringBufferLength = stringBuffer.length
        -- if this is the last line, 
        -- append it to the stringbuffer, disregarding length
        if (lineIndex == maxLines) then
            stringBuffer.length += string.len(word)
            table.insert(stringBuffer.words, word)
            goto continue
        end
        
        local wordLength = string.len(word)
        
        -- In addition to characters we need to account for a space in between each word 
        local wordsOnThisLine = #stringBuffer.words + 1

        -- if the current word fits on the current line, append to the string buffer
        if ((stringBufferLength + wordLength + wordsOnThisLine) <= charsPerLine) then
            stringBuffer.length += string.len(word)
            table.insert(stringBuffer.words, word)
        
        -- if not, go to the next line and insert this word
        else
            lineIndex += 1
            table.insert(lines, { length = string.len(word), words = { word }})
        end
        
        ::continue::
    end

    local stringArray = {}

    -- for each line, join the words array on space. 
    for i,line in ipairs(lines) do
        table.insert(stringArray, table.concat(line.words, " "))
    end

    return stringArray
end

---Returns true if the `str` starts with the string `startsWith`.
---@param str any
---@param startsWith any
---@return boolean
function string.startsWith(str, startsWith) 
    return string.sub(str, 1, string.len(startsWith)) == startsWith
end

---Returns true if the specified string is empty, either `nil` or `""`
---@param str any
---@return boolean
function string.isEmpty(str) 
    if (str == nil) then return true end
    if (string.len(str) == 0) then return true end
    return false
end

function string.isBlank(str)
    if (string.isEmpty(str)) then return true end
    local splitOnSpace = string.split(str, " ")
    return #splitOnSpace == 0
end