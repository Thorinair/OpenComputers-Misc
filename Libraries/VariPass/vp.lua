--[[
    Library: VariPass (vp)
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Provides an API for easily exchanging data with the VariPass (varipass.org) website.
    Usage: 	
    	First add this library to the OpenComputers computer by placing it into the lib folder.
        Then, include the library in your program using the require function, and then access the functions by their name. 
        The methods and values that should be used are in the "LIBRARY PUBLIC VALUES AND METHODS" section, along with documentation.
    Requirements: 
    	The OpenComputers computer needs to have an Internet Card installed.
    	You need to have an account on VariPass (varipass.org).
--]]

local vp = {}

local internet = require('internet')

--[[ 
	=====================================
	  LIBRARY PUBLIC VALUES AND METHODS
	=====================================
--]]

--[[
    Different results returned by the API methods.
--]]
vp.RESULT_SUCCESS               = 0
vp.RESULT_ERROR_INVALID_KEY     = 1
vp.RESULT_ERROR_INVALID_ID      = 2
vp.RESULT_ERROR_INVALID_TYPE    = 3
vp.RESULT_ERROR_COOLDOWN        = 4
vp.RESULT_ERROR_UNCONFIRMED     = 5
vp.RESULT_ERROR_BANNED          = 6
vp.RESULT_ERROR_EMPTY_VARIABLE  = 7
vp.RESULT_ERROR_DB              = 8

--[[
    Variable types, used when reading.
--]]
vp.TYPE_INT     = 0
vp.TYPE_FLOAT   = 1
vp.TYPE_BOOL    = 2
vp.TYPE_STRING  = 3

--[[
    Writes data to a variable.
    params:
    	key: 	User's API key.
    	id: 	ID of the variable.
    	value: 	Value to be written.
    return: 
    	result: The RESULT value, for instance RESULT_SUCCESS.
--]]
function vp.write(key, id, value)
    local req = internet.request("http://api.varipass.org", { key = key, action = "swrite", id = id, value = tostring(value) })

    local data = ""
    for line in req do
        data = data .. line
    end

    if data == "success" then
        return vp.RESULT_SUCCESS;
    elseif data == "error_invalid_key" then
        return vp.RESULT_ERROR_INVALID_KEY;
    elseif data == "error_invalid_id" then
        return vp.RESULT_ERROR_INVALID_ID;
    elseif data == "error_cooldown" then
        return vp.RESULT_ERROR_COOLDOWN;
    elseif data == "error_unconfirmed" then
        return vp.RESULT_ERROR_UNCONFIRMED;
    elseif data == "error_banned" then
        return vp.RESULT_ERROR_BANNED;
    elseif data == "error_empty_variable" then
        return vp.RESULT_ERROR_EMPTY_VARIABLE;
    elseif data == "error_db" then
        return vp.RESULT_ERROR_DB;
    end    

end

--[[
    Reads data from a variable.
    params:
    	key: 	User's API key.
    	id: 	ID of the variable.
    	type: 	Type of the variable, should be one of the TYPE values from above, for instance TYPE_INT.
    return: 
    	value: 	The value that was read.
    	result: The RESULT value, for instance RESULT_SUCCESS.
--]]
function vp.read(key, id, type)
    local req = internet.request("http://api.varipass.org", { key = key, action = "sread", id = id })

    local data = ""
    for line in req do
        data = data .. line
    end

    if data == "error_invalid_key" then
        return nil, vp.RESULT_ERROR_INVALID_KEY
    elseif data == "error_invalid_id" then
        return nil, vp.RESULT_ERROR_INVALID_ID
    elseif data == "error_cooldown" then
        return nil, vp.RESULT_ERROR_COOLDOWN
    elseif data == "error_unconfirmed" then
        return nil, vp.RESULT_ERROR_UNCONFIRMED
    elseif data == "error_banned" then
        return nil, vp.RESULT_ERROR_BANNED
    elseif data == "error_empty_variable" then
        return nil, vp.RESULT_ERROR_EMPTY_VARIABLE
    elseif data == "error_db" then
        return nil, vp.RESULT_ERROR_DB
    else 
        data = string.gsub(data, "success|", "")
        if type == vp.TYPE_INT or type == vp.TYPE_FLOAT then
            return tonumber(data), vp.RESULT_SUCCESS
        elseif type == vp.TYPE_BOOL then
            if data == "true" then
                return true, vp.RESULT_SUCCESS
            else
                return false, vp.RESULT_SUCCESS
            end    
        elseif type == vp.TYPE_STRING then
            return data, vp.RESULT_SUCCESS
        else
            return nil, vp.RESULT_ERROR_INVALID_TYPE
        end             
    end  
end

return vp