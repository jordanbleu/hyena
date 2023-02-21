--[[   
    These are global functions that extend the existing lua libraries
]]

--[[ Returns the value, limited between the min and the max values ]]
function math.clamp(value, min, max)

    if (value > max) then
        return max
    elseif (value < min) then
        return min 
    end
    return value
end

--[[ If (value) is within (threshold) of (snapvalue) then return (snapvalue), otherwise returns (value) back. ]]
function math.snap(value, threshold, snapValue) 
    if (math.isWithin(value, threshold, snapValue)) then
        return snapValue
    end
    return value
end

--[[ Returns true if (value) is +/- (threshold) of (ofValue).]]
function math.isWithin(value, threshold, ofValue)
    local min = ofValue - threshold
    local max = ofValue + threshold 
    return (value >= min and value <= max )
end