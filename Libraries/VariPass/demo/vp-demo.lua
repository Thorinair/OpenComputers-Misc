--[[
    Demo: VariPass Demo (vp-demo)
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Demo for testing the VariPass library.
    Usage:
    	Install the library, connect a Lever and a Redstone Lamp to a Redstone I/O.
    	You will need to edit the key and id values, along with sides that are used.
    	The demo will toggle the lamp when one variable is toggled on the website, and the other variable is
    	toggled by using the lever.
    Requirements: 
    	The OpenComputers computer needs to have an Internet Card installed.
    	A Redstone I/O should be attached along with a Lever and a Redstone Lamp.
    	You need to have an account on VariPass (varipass.org).
    	Additionally, the OCL Text library from this same repository should be installed on the OpenComputer.
--]]

local vp = require('vp')

local component = require('component')
local redstone = component.redstone
local sides = require('sides')

-- Adjust these as needed.
local key			= ""
local id_lamp 		= ""
local id_lever 		= ""
local side_lamp 	= sides.top
local side_lever 	= sides.south

local sleep = 1

function process()
	while true do

		local value, result = vp.read(key, id_lamp, vp.TYPE_BOOL)
		if value ~= nil then
			if value then
				redstone.setOutput(side_lamp, 255)
			else
				redstone.setOutput(side_lamp, 0)
			end
		end

		local active = false
		if redstone.getInput(side_lever) > 0 then
			active = true
		end
		local result = vp.write(key, id_lever, active)

		os.sleep(sleep)
	end
end

process()