local component = require("component")
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local term = require("term")
local oclt = require("ocl-text")

local side = sides.north

local wire = {}
wire.ignition 	= colors.white
wire.lasers 		= colors.orange
wire.output 		= colors.magenta
wire.deut_prod	= colors.lightblue
wire.deut_imp 	= colors.yellow
wire.deut_exp 	= colors.lime
wire.trit_prod	= colors.pink
wire.trit_imp		= colors.gray
wire.trit_exp		= colors.silver
wire.announcer	= colors.cyan
wire.ambience		= colors.purple
wire.hohlraum		= colors.blue

local version = "v1.0.0"

local conversion = 2.5
local intervalMeasure = 1

local gpu
local redstone
local reactor
local laser
local me
local core

local loadSteps = 7
local loadProgress = 0

local value = {}
value.reactor_status = false
value.reactor_output = 0
value.reactor_plasma = 0
value.reactor_case = 0

value.laser_energy = 0

local function round(num, places)
		local shift = 10 ^ places
		local result = tostring(math.floor(num * shift + 0.5) / shift)
		
		if string.sub(result, string.len(result) - 1, string.len(result) - 1) ~= '.' then
			result = result .. ".0"
		end
			
		return result
end

--[[
    Sets the redstone output for signalling.
    	out: 	The bundled wire to use as output.
    	signal:	Boolean to output.
--]]
local function setRedstone(out, signal)
	local value
	if signal then
		value = 255
	else
		value = 0	
	end		
	redstone.setBundledOutput(side, out, value)
end	

--[[
    Reads the set redstone output.
    	out: 	The bundled wire to read from.
    	return:	Boolean being output.
--]]
local function getRedstone(out)
	if redstone.getBundledOutput(side, out) > 0 then
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
    Draws a touchable button on the monitor.
    	x:			X monitor coordinate to draw the button at
    	y:			Y monitor coordinate to draw the button at
    	width:		Width of the button.
    	height:		Height of the button.
    	show:		Boolean whether the button should be visible.
--]]
local function drawButton(x, y, width, height, show)
	if show then
		gpu.setColor(255, 255, 255)
	else
		gpu.setColor(0, 0, 0)
	end	
	gpu.filledRectangle(x, y, 1, height)
	gpu.filledRectangle(x+width-1, y, 1, height)
	gpu.filledRectangle(x+1, y, 1, 1)
	gpu.filledRectangle(x+width-2, y, 1, 1)
	gpu.filledRectangle(x+1, y+height-1, 1, 1)
	gpu.filledRectangle(x+width-2, y+height-1, 1, 1)
end

--[[
    Draws reactor info.
--]]
local function drawReactorInfo()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(58, 211, 88, 35)

	if value.reactor_status then
		oclt.drawText(gpu, "On", 58, 211, 1, oclt.left, 0, 255, 0, 255, 0, 0, 0, 0)
	else	
		oclt.drawText(gpu, "Off", 58, 211, 1, oclt.left, 255, 0, 0, 255, 0, 0, 0, 0)
	end	
	oclt.drawText(gpu, oclt.formatValue(value.reactor_output, "|RF/t"), 58, 220, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.reactor_plasma, "|MK") 
		.. "|/|"
		.. oclt.formatValue(1200, "|MK"), 58, 229, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.reactor_case, "|MK") 
		.. "|/|800|MK", 58, 238, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	oclt.drawText(gpu, oclt.formatValue(value.laser_energy, "|RF"), 58, 128, 1, oclt.left, 255, 0, 0, 255, 0, 0, 0, 255)
end	

--[[
    Draws the whole UI. Used only during startup.
--]]
local function drawUI()
	gpu.setColor(0, 0, 0)
	gpu.fill()
	
	os.sleep(0.05)

	oclt.drawText(gpu, "Reactor Info", 7, 200, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	oclt.drawText(gpu, "Status:", 10, 211, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Output:", 10, 220, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Plasma:", 10, 229, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Case:", 10, 238, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Handles touch events on the OCLights 2 Monitor.
    	address:	Address of the GPU.
    	button:		Button.
    	x:			X monitor coordinate of the touch.
    	y:			Y monitor coordinate of the touch.
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
		me = component.me_controller
		print("Success.")
		drawProgress()
	else
		print("Error: No ME Controller component found. Exiting.")
		os.exit()
	end	
end	

--[[
    Attempts to connect to Energy Core.
--]]
local function connectCore()
	print("Connecting to Energy Core...")
	if component.draconic_rf_storage ~= nil then
		core = component.draconic_rf_storage
		print("Success.")
		drawProgress()
	else
		print("Error: No Energy Core component found. Exiting.")
		os.exit()
	end	
end	

local function updateMeasure()
	value.reactor_status = reactor.isIgnited()
	value.reactor_output = round(reactor.getProducing() / conversion, 0)
	value.reactor_plasma = round(reactor.getPlasmaHeat() / 1000000, 0)
	value.reactor_case = round(reactor.getCaseHeat() / 1000000, 0)

	value.laser_energy = laser.getStored() / 2.5
end	

local function drawMeasure()
	drawReactorInfo()
end	

local function threadMeasure()

	while true do
		os.sleep(intervalMeasure)
		updateMeasure()
		drawMeasure()
	end	

end

--[[
    Performs an initial measurement from all sensors.
--]]
local function initialMeasure()
	print("Performing an initial measurement...")
	updateMeasure()
	print("Done.")
	drawProgress()
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
	connectCore()
	initialMeasure()

	os.sleep(0.4)
	print("Drawing UI...")
	drawUI()
	print("Done.")
	print("Sending data to monitor...")
	drawMeasure()
	print("Done.")
	print("Starting up threads...")	
		
	coroutine.resume(coroutine.create(threadMeasure))

	print("Done.")

	-- drawButton(8, 8, 32, 32, false)

	-- print(setRedstone(wire.ambience, false))

	event.ignore("monitor_up", touchHandler)
end	

start()