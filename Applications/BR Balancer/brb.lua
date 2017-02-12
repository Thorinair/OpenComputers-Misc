--[[
    Application: BR Balancer (brb)
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Balances the power production of multiple BigReactors at once.
    Usage: 
    	Modify the parameters as explained in comments and run the application. Exit using Ctrl+Alt+C.
    Requirements: 
    	BigReactors mod has to be installed, and at least one reactor has to be connected with the OpenComputers computer.
--]]

-- Modify BEGIN --
local PERC_MIN = 20     -- Minimum percentage of stored energy when reactors will be turned on.
local PERC_MAX = 80     -- Maximum percentage of stored energy when reactors will be turned off.
local USE_COORD = "Y"   -- Coordinate to use when identifying reactors. Coordinates are defined below.
local X = { 0, 0 }      -- Minimum X coordinate of the reactor multiblock. Edit this if you set USE_COORD to X.
local Y = { 71, 83 }    -- Minimum Y coordinate of the reactor multiblock. Edit this if you set USE_COORD to Y.
local Z = { 0, 0 }      -- Minimum Z coordinate of the reactor multiblock. Edit this if you set USE_COORD to Z.
-- Modify END ---


local MAX_ENERGY = 10000000

local component = require("component")

print("\nBR Balancer started at:  " .. os.date("%H:%M:%S", os.time()))
print("-------------------------------------\n")

function processReactors()
    for address, componentType in component.list("br_reactor") do 
        local br = component.proxy(address)
        
        local active = br.getActive()
        local energy = br.getEnergyStored()
        local x, y, z = br.getMinimumCoordinate()
        
        local id = "?"
        if (USE_COORD == "X") then
            for i = 1, #X do
                if (x == X[i]) then
                    id = i
                    break
                end
            end
        elseif (USE_COORD == "Y") then
            for i = 1, #Y do
                if (y == Y[i]) then
                    id = i
                    break
                end
            end
        elseif (USE_COORD == "Z") then
            for i = 1, #Z do
                if (z == Z[i]) then
                    id = i
                    break
                end
            end
        end
            
        if not active and energy <= MAX_ENERGY * (PERC_MIN / 100) then
            br.setActive(true)
            print("Reactor " .. id .. " turned ON at:  " .. os.date("%H:%M:%S", os.time()))
        elseif active and energy >= MAX_ENERGY * (PERC_MAX / 100) then
            br.setActive(false)
            print("Reactor " .. id .. " turned OFF at: " .. os.date("%H:%M:%S", os.time()))
        end  
    end
end

while true do
    pcall(processReactors)
    os.sleep(1)
end
