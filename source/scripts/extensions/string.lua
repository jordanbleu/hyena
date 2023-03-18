
---Splits a string by the separator, and returns an array of strings
---@param inputstr string delimited string
---@param sep string delimiter 
---@return table
function string.split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
