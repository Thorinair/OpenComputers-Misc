local component = require("component")
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local term = require("term")
local oclt = require("ocl-text")

local redstone_side 		= sides.north

local redstone_ignition 	= colors.white
local redstone_lasers 		= colors.orange
local redstone_output 		= colors.magenta
local redstone_deut_prod 	= colors.lightblue
local redstone_deut_imp 	= colors.yellow
local redstone_deut_exp 	= colors.lime
local redstone_trit_prod	= colors.pink
local redstone_trit_imp		= colors.gray
local redstone_trit_exp		= colors.silver
local redstone_announcer	= colors.cyan
local redstone_ambience		= colors.purple
local redstone_hohlraum		= colors.blue

local version = "v1.0.0"

local gpu
local redstone
local reactor
local laser
local me

local loadSteps = 5
local loadProgress = 0

--[[
    Sets the redstone output for signalling.
    	wire: 	The bundled wire to use as output.
    	signal:	Boolean to output.
--]]
local function setRedstone(wire, signal)
	local value
	if signal then
		value = 255
	else
		value = 0	
	end		
	redstone.setBundledOutput(redstone_side, wire, value)
end	

--[[
    Reads the set redstone output.
    	wire: 	The bundled wire to read from.
    	return:	Boolean being output.
--]]
local function getRedstone(wire)
	if redstone.getBundledOutput(redstone_side, wire) > 0 then
		return true
	else
		return false
	end		
end

--[[
    Draws the loading screen with an empty progress bar.
--]]
local function drawLoading()

	gpu.setColor(0, 0, 0)
	gpu.fill()
	
	os.sleep(0.05)
	
	oclt.drawText(gpu, "Starting up Mekanism Fusion Control by Thorinair.", 224, 108, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 0)	
	oclt.drawText(gpu, "Please wait...", 224, 120, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 0)	
	oclt.drawText(gpu, version, 439, 240, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)	
	
	gpu.setColor(255, 255, 255)
	gpu.filledRectangle(147, 140, 154, 1)
	gpu.filledRectangle(147, 141, 1, 4)
	gpu.filledRectangle(300, 141, 1, 4)
	gpu.filledRectangle(147, 145, 154, 1)
	
	os.sleep(0.5)
end

--[[
    Draws the loading screen progress bar.
--]]
local function drawProgress()
	loadProgress = loadProgress + (100/loadSteps)
	if loadProgress > 0 then
		local barWidth = 152 * (loadProgress/100)
		gpu.filledRectangle(148, 141, barWidth, 4)
	end
	os.sleep(0.05)
end

--[[
    Handles touch events on the OCLights 2 Monitor.
    	address:	Address of the GPU.
    	button:		Button.
    	x:			X screen coordinate of the touch.
    	y:			Y screen coordinate of the touch.
    	player:		Player who performed the touch.
--]]
local function touchHandler(event, address, x, y, player)
	print(event .. ", " .. address .. ", " .. x .. ", " .. y .. ", " .. player)
	if x >= 20 and x <= 120 and y >= 20 and y <= 120 then
		print("Boop!")
	end
end

--[[
    Attempts to connect to OCLights 2 GPU and sets up the touch event.
--]]
local function connectGpu()
	print("Connecting to OCLights 2 GPU...")
	if component.ocl_gpu ~= nil then
		gpu = component.ocl_gpu
		event.ignore("monitor_up", touchHandler)
		event.listen("monitor_up", touchHandler)
		drawLoading()
		print("Success.")
		drawProgress()
	else
		print("Error: No OCLights 2 GPU component found. Exiting.")
		os.exit()
	end	
end		

--[[
    Attempts to connect to Redstone I/O.
--]]
local function connectRedstone()
	print("Connecting to Redstone I/O...")
	if component.redstone ~= nil then
		redstone = component.redstone
		print("Success.")
		drawProgress()
	else
		print("Error: No Redstone I/O component found. Exiting.")
		os.exit()
	end	
end		

--[[
    Attempts to connect to Reactor Logic Adapter.
--]]
local function connectReactor()
	print("Connecting to Reactor Logic Adapter...")
	if component.reactor_logic_adapter ~= nil then
		reactor = component.reactor_logic_adapter
		print("Success.")
		drawProgress()
	else
		print("Error: No Reactor Logic Adapter component found. Exiting.")
		os.exit()
	end	
end		

--[[
    Attempts to connect to Laser Amplifier.
--]]
local function connectLaser()
	print("Connecting to Laser Amplifier...")
	if component.laser_amplifier ~= nil then
		laser = component.laser_amplifier
		print("Success.")
		drawProgress()
	else
		print("Error: No Laser Amplifier component found. Exiting.")
		os.exit()
	end	
end		

--[[
    Attempts to connect to ME Controller.
--]]
local function connectMe()
	print("Connecting to ME Controller...")
	if component.me_controller ~= nil then
		laser = component.me_controller
		print("Success.")
		drawProgress()
	else
		print("Error: No ME Controller component found. Exiting.")
		os.exit()
	end	
end		

local function start()
	
	term.clear()
	print("Mekanism Fusion Control by Thorinair")
	print("------------------------------------\n")
	print("Starting up...")

	connectGpu()
	connectRedstone()
	connectReactor()
	connectLaser()
	connectMe()

	-- print(setRedstone(redstone_ambience, false))

	event.ignore("monitor_up", touchHandler)
end	

start()