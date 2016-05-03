--[[
    Application: OC Component Methods
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Lists all available methods for a certain connected OpenComputers compatible component.
    Usage: Run the application and then type the component name you wish to scan. The methods will be listed as output with detailed descriptions when available.
    Requirements: Due to OC's lack of output scrolling, a larger screen is highly recommended.
--]]

component = require("component")

io.write("\nInstalled Components:\n  ")
for address, componentType in component.list() do 
    io.write(componentType .. "  ")
end

io.write("\n\nComponent to scan: ")
id = io.read()

if next(component.list(id)) ~= nil then
	io.write("\nComponent Methods:\n")
	local found = 0
	for method, description in pairs(component.proxy(component.list(id)())) do
		if string.sub(tostring(description), 1, 8) == "function" then
			if tostring(description) == "function" then
				io.write("  " .. method .. "\n")
			else	
				io.write("  " .. method .. "\n      " .. tostring(description) .. "\n")
			end	
			found = found + 1
		end
	end
	if found == 0 then
		io.write("  None\n")
	end	
else	
	io.write("\nNo Component found.\n")
end

io.write("\n")
