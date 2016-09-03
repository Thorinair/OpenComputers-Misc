--[[
    Application: MFC (Mekanism Fusion Control)
    Programmed by: Thorinair
    Version: v1.0.0
    Description: The ultimate Mekanism fusion control software, which uses OCLights 2 screens.
    Usage: Download the library, connect all the necessary components listed in requirements and run the software.
    	   The software works in two modes: Automatic and Manual. Automatic mode will automatically toggle parts of your facility to start a reaction,
    	   while the Manual mode lets you manually toggle them. The screen can be toggled using a redstone signal connected to Brown wire.
    Requirements: OCLights 2 mod has to be installed, and a GPU should be connected with the OpenComputer.
    			  Additionally, the OCL Text library from this same repository should be installed on the OpenComputer.
			  	  A Redstone Controller should be attached to the computer. The wires are as follow:
					- White			Sends a signal to the Laser Amplifier to start the Reactor.
					- Orange		Toggles lasers for precharging of energy.
					- Magenta		Toggles energy output from the Reactor.
					- Light blue	Toggles Deuterium production.
					- Yellow		Toggles Deuterium importing to the ME Network.
					- Lime			Toggles Deuterium exporting from the ME Network into the Reactor.
					- Pink			Toggles Tritium production.
					- Gray			Toggles Tritium importing to the ME Network.
					- Silver		Toggles Tritium exporting from the ME Network into the Reactor.
					- Cyan			Plays the announcer sound file of your choice. Use a Howler Alarm for this.
					- Purple		Plays the ambient sound when the Reactor is running. Use a Howler Alarm for this.
					- Blue			Injects a Hohlraum into the Reactor.
					- Brown			Input wire for toggling the screen on and off.	
    			  The following components are required to be attached to adapters:
    			  	- Reactor Logic Adapter (from Mekanism)
					- Laser Amplifier (from Mekanism)
					- ME Controller (from Applied Energistics 2)
					- Energy Core (from Draconic Evolution)
--]]

local component = require("component")
local event = require("event")
local fs = require("filesystem")
local sides = require("sides")
local colors = require("colors")
local term = require("term")
local oclt = require("ocl-text")

local side = sides.north

local wire = {}
wire.ignition 	= colors.white
wire.lasers 	= colors.orange
wire.output 	= colors.magenta
wire.deut_prod	= colors.lightblue
wire.deut_imp 	= colors.yellow
wire.deut_exp 	= colors.lime
wire.trit_prod	= colors.pink
wire.trit_imp	= colors.gray
wire.trit_exp	= colors.silver
wire.announcer	= colors.cyan
wire.ambience	= colors.purple
wire.hohlraum	= colors.blue
wire.monitor	= colors.brown

local version = "v1.0.0"

local conversion = 2.5
local intervalMeasure = 1
local intervalGraph = 225
local requirementEnergy = 1000000000
local requirementPrecharge = 400000000
local requirementFuel = 720000
local requirementHohlraum = 1

local gpu
local redstone
local reactor
local laser
local me
local core

local loadSteps = 10
local loadProgress = 0
local graphCount = 0
local monitorToggle = true
local automatic = true
local countdown = 6
local stopInitiated = false

local value = {}
value.reactor_status = false
value.reactor_output = 0
value.reactor_plasma = 0
value.reactor_case = 0

value.laser_energy = 0
value.core_energy = 0
value.core_max = 0
value.core_graph = {}

value.me_trit = 0
value.me_deut = 0
value.me_hohl = 0
value.me_hohl_old = 0

value.moment = 0
value.status = 0

local function round(num, places)
		local shift = 10 ^ places
		local result = tostring(math.floor(num * shift + 0.5) / shift)
		
		if string.sub(result, string.len(result) - 1, string.len(result) - 1) ~= '.' then
			result = result .. ".0"
		end
			
		return result
end

--[[
    Reads the set redstone output and input.
    	out: 	The bundled wire to read from.
    	return:	Boolean being output.
--]]
local function getRedstone(out)
	if redstone.getBundledOutput(side, out) > 0 or redstone.getBundledInput(side, out) > 0 then
		return true
	else
		return false
	end		
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
	if getRedstone(out) ~= signal then
		redstone.setBundledOutput(side, out, value)
	end	
end	

--[[
    Toggles a redstone output.
    	out: 	The bundled wire to toggle.
]]
local function toggleRedstone(out)
	setRedstone(out, not getRedstone(out))
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
    Reads the graph file from disk for the first time.
--]]
local function graphReadInitial()
	local f = io.open("graph", "r")
	print("Attempting to read from graph file...")

	if f == nil then
		print("No graph file found. Creating a new one.")

		local fNew = io.open("graph", "w")
		io.output(fNew)

		io.write("# Energy Core History #")

		for i = 0, 95, 1 do
			value.core_graph[i] = 0
			io.write("\n" .. tostring(value.core_graph[i]))
		end	

		io.close(fNew)
		print("Done.")		
	else
		print("Found graph file. Loading history.")	

		io.input(f)	

		local e = io.read()
		for i = 0, 95, 1 do
			value.core_graph[i] = tonumber(io.read())
		end	

		io.close(f)
		print("Done.")		
	end	
	drawProgress()
end

--[[
    Writes the graph file to disk.
--]]
local function graphWrite()
	local f = io.open("graph", "w")
	io.output(f)

	io.write("# Energy Core History #")

	for i = 0, 95, 1 do
		io.write("\n" .. tostring(value.core_graph[i]))
	end	

	io.close(f)
end

--[[
    Updates the graph values.
--]]
function graphUpdate()
	for i = 94, 0, -1 do
		value.core_graph[i+1] = value.core_graph[i]
	end	
	value.core_graph[0] = value.core_energy
	
	graphWrite()
end

--[[
    Adds a break point to the graph.
--]]
function graphUpdateBreak()
	print ("Adding breakpoint to graph...")

	for i = 94, 0, -1 do
		value.core_graph[i+1] = value.core_graph[i]
	end	
	value.core_graph[0] = -1
	
	graphWrite()

	print("Done.")	
	drawProgress()
end

--[[
    Processes a string input to return boolean.
    	input: 	String to read from.
    	return:	Boolean result.
--]]
local function toboolean(input)
	return input == "true"
end	

--[[
    Reads the options file from disk for the first time.
--]]
local function optionsReadInitial()
	local f = io.open("options", "r")
	print("Attempting to read from options file...")

	if f == nil then
		print("No options file found. Creating a new one.")

		local fNew = io.open("options", "w")
		io.output(fNew)

		io.write("# Mekanism Fusion Control Options #")

		io.write("\n" .. tostring(automatic))
		io.write("\n" .. tostring(value.status))

		io.write("\n" .. tostring(getRedstone(wire.ignition)))
		io.write("\n" .. tostring(getRedstone(wire.lasers)))
		io.write("\n" .. tostring(getRedstone(wire.output)))
		io.write("\n" .. tostring(getRedstone(wire.deut_prod)))
		io.write("\n" .. tostring(getRedstone(wire.deut_imp)))
		io.write("\n" .. tostring(getRedstone(wire.deut_exp)))
		io.write("\n" .. tostring(getRedstone(wire.trit_prod)))
		io.write("\n" .. tostring(getRedstone(wire.trit_imp)))
		io.write("\n" .. tostring(getRedstone(wire.trit_exp)))
		io.write("\n" .. tostring(getRedstone(wire.announcer)))
		io.write("\n" .. tostring(getRedstone(wire.hohlraum)))

		io.close(fNew)
		print("Done.")		
	else
		print("Found options file. Loading options.")	

		io.input(f)	

		local e = io.read()

		automatic = toboolean(io.read())
		value.status = tonumber(io.read())

		setRedstone(wire.ignition, toboolean(io.read()))
		setRedstone(wire.lasers, toboolean(io.read()))
		setRedstone(wire.output, toboolean(io.read()))
		setRedstone(wire.deut_prod, toboolean(io.read()))
		setRedstone(wire.deut_imp, toboolean(io.read()))
		setRedstone(wire.deut_exp, toboolean(io.read()))
		setRedstone(wire.trit_prod, toboolean(io.read()))
		setRedstone(wire.trit_imp, toboolean(io.read()))
		setRedstone(wire.trit_exp, toboolean(io.read()))
		setRedstone(wire.announcer, toboolean(io.read()))
		setRedstone(wire.hohlraum, toboolean(io.read()))

		io.close(f)
		print("Done.")		
	end	
	drawProgress()
end

--[[
    Writes the options file to disk.
--]]
local function optionsWrite()
	local f = io.open("options", "w")
	io.output(f)

	io.write("# Mekanism Fusion Control Options #")

	io.write("\n" .. tostring(automatic))
	io.write("\n" .. tostring(value.status))

	io.write("\n" .. tostring(getRedstone(wire.ignition)))
	io.write("\n" .. tostring(getRedstone(wire.lasers)))
	io.write("\n" .. tostring(getRedstone(wire.output)))
	io.write("\n" .. tostring(getRedstone(wire.deut_prod)))
	io.write("\n" .. tostring(getRedstone(wire.deut_imp)))
	io.write("\n" .. tostring(getRedstone(wire.deut_exp)))
	io.write("\n" .. tostring(getRedstone(wire.trit_prod)))
	io.write("\n" .. tostring(getRedstone(wire.trit_imp)))
	io.write("\n" .. tostring(getRedstone(wire.trit_exp)))
	io.write("\n" .. tostring(getRedstone(wire.announcer)))
	io.write("\n" .. tostring(getRedstone(wire.hohlraum)))

	io.close(f)
end

--[[
    Clears all contents of the monitor.
--]]
local function clearMonitor()
	gpu.setColor(0, 0, 0)
	gpu.fill()
end	

--[[
    Draws the loading screen with an empty progress bar.
--]]
local function drawLoading()
	gpu.startFrame()

	clearMonitor()
	
	oclt.drawText(gpu, "Starting up Mekanism Fusion Control by Thorinair.", 224, 108, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 0)	
	oclt.drawText(gpu, "Please wait...", 224, 120, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 0)	
	oclt.drawText(gpu, version, 439, 240, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)	
	
	gpu.setColor(255, 255, 255)
	gpu.filledRectangle(147, 140, 154, 1)
	gpu.filledRectangle(147, 141, 1, 4)
	gpu.filledRectangle(300, 141, 1, 4)
	gpu.filledRectangle(147, 145, 154, 1)

	gpu.endFrame()
	
	os.sleep(0.5)
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
    Draws all buttons.
--]]
local function drawButtons() 
	drawButton(218, 134, 12, 12, not automatic)
	drawButton(218, 26, 12, 12, not automatic)
	drawButton(218, 230, 12, 12, not automatic)
	drawButton(410, 98, 12, 12, not automatic)
	drawButton(410, 134, 12, 12, not automatic)
	drawButton(266, 182, 12, 12, not automatic)
	drawButton(278, 86, 12, 12, not automatic)
	drawButton(386, 134, 12, 12, not automatic)
	drawButton(170, 182, 12, 12, not automatic)
	drawButton(266, 206, 12, 12, not automatic)
end

--[[
    Draws the startup button.
--]]
local function drawStartup() 
	if automatic then
		drawButton(207, 171, 34, 34, true)
		if value.status == 0 then
			gpu.setColor(255, 0, 0)
		elseif value.status == 1 then
			gpu.setColor(255, 255, 0)
		elseif value.status == 2 then
			gpu.setColor(0, 255, 0)
		elseif value.status == 3 then
			gpu.setColor(255, 0, 255)
		end	
		gpu.filledRectangle(223, 175, 2, 13)
		gpu.filledRectangle(222, 176, 4, 11)
		gpu.filledRectangle(217, 178, 2, 3)
		gpu.filledRectangle(229, 178, 2, 3)
		gpu.filledRectangle(216, 179, 2, 3)
		gpu.filledRectangle(230, 179, 2, 3)
		gpu.filledRectangle(215, 180, 2, 3)
		gpu.filledRectangle(231, 180, 2, 3)
		gpu.filledRectangle(214, 181, 2, 4)
		gpu.filledRectangle(232, 181, 2, 4)
		gpu.filledRectangle(213, 183, 2, 10)
		gpu.filledRectangle(233, 183, 2, 10)
		gpu.filledRectangle(212, 185, 1, 6)
		gpu.filledRectangle(235, 185, 1, 6)
		gpu.filledRectangle(214, 191, 2, 4)
		gpu.filledRectangle(232, 191, 2, 4)
		gpu.filledRectangle(215, 193, 2, 3)
		gpu.filledRectangle(231, 193, 2, 3)
		gpu.filledRectangle(216, 194, 2, 3)
		gpu.filledRectangle(230, 194, 2, 3)
		gpu.filledRectangle(217, 195, 2, 3)
		gpu.filledRectangle(229, 195, 2, 3)
		gpu.filledRectangle(219, 196, 2, 3)
		gpu.filledRectangle(227, 196, 2, 3)
		gpu.filledRectangle(221, 197, 6, 3)
	else
		gpu.setColor(0, 0, 0)
		gpu.filledRectangle(207, 171, 34, 34)
	end	
end

--[[
    Draws reactor info.
--]]
local function drawReactorInfo()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(54, 211, 90, 35)

	if value.reactor_status then
		oclt.drawText(gpu, "On", 54, 211, 1, oclt.left, 0, 255, 0, 255, 0, 0, 0, 0)
	else	
		oclt.drawText(gpu, "Off", 54, 211, 1, oclt.left, 255, 0, 0, 255, 0, 0, 0, 0)
	end	
	oclt.drawText(gpu, oclt.formatValue(value.reactor_output, "|RF/t"), 54, 220, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.reactor_plasma, "|MK") 
		.. "|/|"
		.. oclt.formatValue(1200, "|MK"), 54, 229, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.reactor_case, "|MK") 
		.. "|/|800|MK", 54, 238, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the Laser Amplifier value bar.
--]]
local function drawValueAmplifier()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(306, 126, 42, 8)
	gpu.filledRectangle(284, 147, 64, 8)
	local perc
	local total
	if value.laser_energy > requirementPrecharge then
		perc = ">100.0%"
		total = ">".. oclt.formatValue(requirementPrecharge/1000, "|KRF")
		gpu.setColor(0, 255, 255)
		gpu.filledRectangle(245, 137, 102, 6)
	else	
		perc = round(value.laser_energy/requirementPrecharge*100, 1) .. "%"
		total = oclt.formatValue(round(value.laser_energy/1000, 0), "|KRF")
		local bar = value.laser_energy/requirementPrecharge*102
		gpu.setColor(0, 255, 255)
		gpu.filledRectangle(245, 137, bar, 6)
		gpu.setColor(0, 0, 0)
		gpu.filledRectangle(245+bar, 137, 103-bar, 6)
	end	
	oclt.drawText(gpu, perc, 346, 126, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, total, 346, 147, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the Tritium value bar.
--]]
local function drawValueTritium()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(384, 163, 36, 8)
	gpu.filledRectangle(304, 184, 116, 8)
	local bar = value.me_trit/1024000*102
	gpu.setColor(50, 185, 255)
	gpu.filledRectangle(317, 174, bar, 6)
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(317+bar, 174, 103-bar, 6)
	oclt.drawText(gpu, round(value.me_trit/1024000*100, 1) .. "%", 418, 163, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.me_trit, "|/|" .. oclt.formatValue(1024000, "|mB")), 418, 184, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the Deuterium value bar.
--]]
local function drawValueDeuterium()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(384, 197, 36, 8)
	gpu.filledRectangle(304, 218, 116, 8)
	local bar = value.me_deut/1024000*102
	gpu.setColor(255, 50, 50)
	gpu.filledRectangle(317, 208, bar, 6)
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(317+bar, 208, 103-bar, 6)
	oclt.drawText(gpu, round(value.me_deut/1024000*100, 1) .. "%", 418, 197, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(value.me_deut, "|/|" .. oclt.formatValue(1024000, "|mB")), 418, 218, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the Energy Core value bar.
--]]
local function drawValueCore()
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(146, 41, 36, 8)
	gpu.filledRectangle(44, 32, 66, 8)
	local bar = (1-value.core_energy/value.core_max)*128
	gpu.setColor(0, 255, 255)
	if bar == 0 then
		gpu.filledRectangle(148, 52+bar, 8, 128)
	elseif bar == 128 then
		gpu.filledRectangle(148, 52+bar, 8, 0)
	else
		gpu.filledRectangle(148, 52+bar, 8, 129-bar)
	end	
	gpu.setColor(0, 0, 0)
	gpu.filledRectangle(148, 52, 8, bar)
	oclt.drawText(gpu, round(value.core_energy/value.core_max*100, 1) .. "%", 146, 41, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(round(value.core_energy/1000, 0), "|KRF|/|"), 138, 32, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the graph on the monitor.
--]]
local function drawGraph()
	gpu.startFrame()

	for i = 0, 95, 1 do
		if value.core_graph[i] == -1 then
			gpu.setColor(255, 0, 0)
			gpu.filledRectangle(139-i, 52, 1, 128)
		else
			local bar = (1-value.core_graph[i]/value.core_max)*128
			gpu.setColor(0, 255, 255)
			if bar == 0 then
				gpu.filledRectangle(139-i, 52+bar, 1, 128)
			elseif bar == 128 then
				gpu.filledRectangle(139-i, 52+bar, 1, 0)
			else
				gpu.filledRectangle(139-i, 52+bar, 1, 129-bar)
			end	
			gpu.setColor(0, 0, 0)
			gpu.filledRectangle(139-i, 52, 1, bar)
		end
	end

	gpu.endFrame()
end

--[[
    Draws the startup status.
    	text:	Text to draw.
    	color:	Color ID to use (0 - red, 1 - yellow, 2 - green).
--]]
local function drawStatus(text, color)
	if monitorToggle then
		gpu.startFrame()

		gpu.setColor(0, 0, 0)
		gpu.filledRectangle(243, 234, 200, 8)

		if color == 0 then
			oclt.drawText(gpu, text, 243, 234, 1, oclt.left, 255, 0, 0, 255, 0, 0, 0, 0)
		elseif color == 1 then
			oclt.drawText(gpu, text, 243, 234, 1, oclt.left, 255, 255, 0, 255, 0, 0, 0, 0)
		elseif color == 2 then
			oclt.drawText(gpu, text, 243, 234, 1, oclt.left, 0, 255, 0, 255, 0, 0, 0, 0)
		elseif color == 3 then
			oclt.drawText(gpu, text, 243, 234, 1, oclt.left, 255, 0, 255, 255, 0, 0, 0, 0)
		end	

		gpu.endFrame()
	end
end

--[[
    Draws a block for the schematic.
    	x:		X monitor coordinate to draw the block at.
    	y:		Y monitor coordinate to draw the block at.
    	type:	Type of the block to draw.
    	status:	Boolean whether the block is turned on.
--]]
local function drawSchematicBlock(x, y, type, status)
	local m = 1
	if not status then
		m = 4
	end
	if type == "reactor_frame" then
		gpu.setColor(0, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)
	elseif type == "reactor_laser" then
		gpu.setColor(0, 255/m, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 0, 255/m)	
		gpu.filledRectangle(x+3, y+3, 6, 6)
	elseif type == "reactor_fuel" then
		gpu.setColor(0, 0, 128/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 255/m, 255/m)	
		gpu.filledRectangle(x+3, y+3, 6, 6)
	elseif type == "reactor_output" then
		gpu.setColor(0, 255/m, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)
	elseif type == "laser" then
		gpu.setColor(0, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 255/m, 255/m)	
		gpu.filledRectangle(x+5, y+3, 2, 2)
		gpu.filledRectangle(x+3, y+5, 2, 2)
		gpu.filledRectangle(x+7, y+5, 2, 2)
		gpu.filledRectangle(x+5, y+7, 2, 2)
	elseif type == "amplifier" then
		gpu.setColor(255/m, 0, 0)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(128/m, 0, 0)
		gpu.filledRectangle(x+3, y+3, 2, 2)
		gpu.filledRectangle(x+7, y+3, 2, 2)
		gpu.filledRectangle(x+5, y+5, 2, 2)
		gpu.filledRectangle(x+3, y+7, 2, 2)
		gpu.filledRectangle(x+7, y+7, 2, 2)
	elseif type == "gas_import" then
		gpu.setColor(128/m, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)
		gpu.setColor(64/m, 0, 128/m)
		gpu.filledRectangle(x+3, y+3, 6, 6)
	elseif type == "gas_export" then
		gpu.setColor(64/m, 0, 128/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)
		gpu.setColor(128/m, 0, 255/m)
		gpu.filledRectangle(x+3, y+3, 6, 6)
	elseif type == "item_export" then
		gpu.setColor(64/m, 0, 128/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)
		gpu.setColor(128/m, 0, 255/m)
		gpu.filledRectangle(x+3, y+3, 2, 2)
		gpu.filledRectangle(x+7, y+3, 2, 2)
		gpu.filledRectangle(x+5, y+5, 2, 2)
		gpu.filledRectangle(x+3, y+7, 2, 2)
		gpu.filledRectangle(x+7, y+7, 2, 2)
	elseif type == "condensentrator" then
		gpu.setColor(0, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 255/m, 255/m)	
		gpu.filledRectangle(x+3, y+3, 2, 2)
		gpu.filledRectangle(x+7, y+3, 2, 2)
		gpu.filledRectangle(x+5, y+5, 2, 2)
		gpu.filledRectangle(x+3, y+7, 2, 2)
		gpu.filledRectangle(x+7, y+7, 2, 2)
	elseif type == "neutron" then
		gpu.setColor(0, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 255/m, 255/m)	
		gpu.filledRectangle(x+3, y+3, 6, 2)
		gpu.filledRectangle(x+3, y+7, 6, 2)
	elseif type == "electrolyzer" then
		gpu.setColor(0, 0, 255/m)
		gpu.filledRectangle(x+1, y+1, 10, 10)	
		gpu.setColor(0, 255/m, 255/m)	
		gpu.filledRectangle(x+3, y+3, 2, 6)
		gpu.filledRectangle(x+7, y+3, 2, 6)
	elseif type == "tesseract" then
		gpu.setColor(0, 255/m, 0)
		gpu.filledRectangle(x+1, y+1, 10, 10)
		gpu.setColor(0, 128/m, 0)
		gpu.filledRectangle(x+3, y+3, 6, 6)
	elseif type == "sunlight" then
		if status then
			gpu.setColor(255, 255, 0)
		else 
			gpu.setColor(0, 24, 64)
		end	
		for i = 0, 3, 1 do
			gpu.filledRectangle(x+1+i, y+4+i, 1, 3)
		end	
		for i = 0, 3, 1 do
			gpu.filledRectangle(x+7+i, y+7-i, 1, 3)
		end	
		gpu.filledRectangle(x+5, y+1, 2, 10)
	end
end

--[[
    Draws a value bar.
--]]
local function drawStaticBar(x, y, text) 
	gpu.setColor(255, 255, 255)
	gpu.filledRectangle(x, y+4, 12, 2)
	gpu.filledRectangle(x+12, y, 106, 1)
	gpu.filledRectangle(x+12, y+9, 106, 1)
	gpu.filledRectangle(x+12, y+1, 1, 8)
	gpu.filledRectangle(x+117, y+1, 1, 8)
	oclt.drawText(gpu, text, x+14, y-9, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the static parts of the graph.
--]]
local function drawStaticGraph() 
	gpu.setColor(255, 255, 255)
	gpu.filledRectangle(42, 50, 1, 132)
	gpu.filledRectangle(146, 50, 1, 132)
	gpu.filledRectangle(157, 50, 1, 132)
	gpu.filledRectangle(147, 50, 10, 1)
	gpu.filledRectangle(147, 181, 10, 1)
	gpu.filledRectangle(43, 181, 99, 1)
	gpu.filledRectangle(43, 50, 1, 1)
	gpu.filledRectangle(41, 52, 1, 1)
	gpu.filledRectangle(41, 179, 1, 1)
	gpu.filledRectangle(43, 182, 1, 1)
	gpu.filledRectangle(75, 182, 1, 1)
	gpu.filledRectangle(107, 182, 1, 1)
	gpu.filledRectangle(139, 182, 1, 1)
	gpu.filledRectangle(141, 180, 1, 1)
	oclt.drawText(gpu, "Energy Core", 44, 21, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, oclt.formatValue(round(value.core_max/1000, 0), "|KRF"), 128, 41, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "100%", 38, 49, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "0%", 38, 176, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "-96", 48, 185, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "-64", 80, 185, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "-32", 112, 185, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "0", 141, 185, 1, oclt.right, 255, 255, 255, 255, 0, 0, 0, 0)
end	

--[[
    Draws the static parts of the schematic.
--]]
local function drawStatic() 
	gpu.setColor(0, 0, 0)
	drawSchematicBlock(146, 14, "tesseract", true)
	drawSchematicBlock(146, 230, "tesseract", true)
	drawSchematicBlock(278, 62, "tesseract", true)
	
	drawStaticBar(231, 135, "Precharge")
	drawStaticBar(303, 172, "Tritium")
	drawStaticBar(303, 206, "Deuterium")

	gpu.setColor(128, 255, 0)
	gpu.filledRectangle(283, 51, 2, 10)
	gpu.filledRectangle(281, 41, 2, 2)
	for i = 0, 2, 1 do
		gpu.filledRectangle(279+i*4, 43, 2, 2)
	end
	gpu.filledRectangle(285, 45, 2, 2)
	gpu.setColor(0, 255, 255)
	gpu.filledRectangle(151, 27, 2, 12)
	gpu.filledRectangle(151, 184, 2, 45)

	gpu.setColor(128, 0, 255)
	gpu.filledRectangle(175, 151, 44, 2)
	gpu.filledRectangle(229, 151, 44, 2)
	gpu.filledRectangle(287, 159, 138, 2)
	gpu.filledRectangle(271, 175, 16, 2)
	gpu.filledRectangle(279, 187, 8, 2)
	gpu.filledRectangle(279, 211, 8, 2)
	gpu.filledRectangle(287, 227, 138, 2)
	gpu.filledRectangle(391, 147, 2, 12)
	gpu.filledRectangle(415, 147, 2, 12)
	gpu.filledRectangle(175, 153, 2, 28)
	gpu.filledRectangle(271, 153, 2, 22)
	gpu.filledRectangle(287, 161, 2, 66)
	gpu.filledRectangle(423, 161, 2, 66)

	gpu.setColor(50, 186, 255)
	gpu.filledRectangle(291, 172, 10, 10)
	gpu.setColor(255, 50, 50)
	gpu.filledRectangle(291, 206, 10, 10)

	oclt.drawText(gpu, "Status:", 243, 225, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	oclt.drawText(gpu, "Reactor Info", 7, 200, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	oclt.drawText(gpu, "Status:", 10, 211, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Output:", 10, 220, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Plasma:", 10, 229, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Case:", 10, 238, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
end	

local function drawAutomatic()
	if automatic then
		oclt.drawText(gpu, "Automatic", 8, 6, 1, oclt.left, 0, 255, 0, 255, 0, 0, 0, 0)
	else
		oclt.drawText(gpu, "Automatic", 8, 6, 1, oclt.left, 255, 0, 0, 255, 0, 0, 0, 0)	
	end	
	drawButton(4, 4, 61, 12, true)
end	

--[[
    Draws the reactor schematic.
--]]
local function drawSchematicReactor() 
	drawSchematicBlock(206, 158, "reactor_frame", true)
	drawSchematicBlock(218, 158, "reactor_laser", true)
	drawSchematicBlock(230, 158, "reactor_frame", true)
	drawSchematicBlock(194, 170, "reactor_frame", true)
	drawSchematicBlock(242, 170, "reactor_frame", true)
	drawSchematicBlock(194, 182, "reactor_fuel", true)
	drawSchematicBlock(242, 182, "reactor_fuel", true)
	drawSchematicBlock(194, 194, "reactor_frame", true)
	drawSchematicBlock(242, 194, "reactor_frame", true)
	drawSchematicBlock(206, 206, "reactor_frame", true)
	drawSchematicBlock(218, 206, "reactor_output", true)
	drawSchematicBlock(230, 206, "reactor_frame", true)
end	

--[[
    Draws the laser schematic.
--]]
local function drawSchematicLaser() 
	gpu.setColor(0, 0, 0)
	local s = getRedstone(wire.lasers)
	local m = 1
	if not s then
		m = 4
	end
	for i = 0, 3, 1 do
		drawSchematicBlock(194, 38+i*24, "laser", s)
		gpu.setColor(0, 255/m, 255/m)
		gpu.filledRectangle(189, 43+i*24, 4, 2)
		gpu.setColor(255/m, 0, 0)
		gpu.filledRectangle(207, 43+i*24, 10, 2)
	end	
	for i = 0, 3, 1 do
		drawSchematicBlock(242, 38+i*24, "laser", s)
		gpu.setColor(0, 255/m, 255/m)
		gpu.filledRectangle(255, 43+i*24, 4, 2)
		gpu.setColor(255/m, 0, 0)
		gpu.filledRectangle(231, 43+i*24, 10, 2)
	end	
	for i = 0, 3, 1 do
		drawSchematicBlock(218, 38+i*24, "amplifier", s)
		gpu.setColor(255/m, 0, 0)
		gpu.filledRectangle(221, 51+i*24, 6, 10)
	end	
	drawSchematicBlock(218, 26, "tesseract", s)
	gpu.setColor(0, 255/m, 0)
	for i = 0, 16, 1 do
		gpu.filledRectangle(159+i*4, 19, 2, 2)
	end	
	gpu.filledRectangle(223, 23, 2, 2)
	gpu.setColor(0, 255/m, 255/m)
	gpu.filledRectangle(187, 31, 2, 86)
	gpu.filledRectangle(259, 31, 2, 86)
	gpu.filledRectangle(189, 31, 28, 2)
	gpu.filledRectangle(231, 31, 28, 2)
end	

--[[
    Draws the Laser Amplifier schematic.
--]]
local function drawSchematicAmplifier() 
	local s = getRedstone(wire.ignition)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(218, 134, "amplifier", s)
	gpu.setColor(255/m, 0, 0)
	gpu.filledRectangle(221, 147, 6, 10)
end	

--[[
    Draws the Tritium production schematic.
--]]
local function drawSchematicTritiumProduction() 
	local s = getRedstone(wire.trit_prod)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(278, 86, "tesseract", s)
	drawSchematicBlock(278, 110, "condensentrator", s)
	for i = 0, 5, 1 do
		for j = 0, 7, 1 do
			drawSchematicBlock(302+j*12, 38+i*12, "neutron", s)
		end
	end
	gpu.setColor(0/m, 255/m, 0/m)
	for i = 0, 2, 1 do
		gpu.filledRectangle(283, 75+i*4, 2, 2)
	end
	gpu.setColor(128/m, 255/m, 0/m)
	gpu.filledRectangle(283, 99, 2, 10)
	gpu.setColor(192/m, 255/m, 0/m)
	gpu.filledRectangle(307, 111, 2, 4)
	gpu.filledRectangle(291, 115, 18, 2)
end	

--[[
    Draws the Deuterium production schematic.
--]]
local function drawSchematicDeuteriumProduction() 
	local s = getRedstone(wire.deut_prod)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(410, 98, "electrolyzer", s)
	gpu.setColor(48/m, 128/m, 255/m)
	gpu.filledRectangle(415, 87, 2, 10)
	gpu.filledRectangle(413, 77, 2, 2)
	gpu.filledRectangle(411, 79, 2, 2)
	gpu.filledRectangle(415, 79, 2, 2)
	gpu.filledRectangle(419, 79, 2, 2)
	gpu.filledRectangle(417, 81, 2, 2)
end	

--[[
    Draws the Tritium import schematic.
--]]
local function drawSchematicTritiumImport() 
	local s = getRedstone(wire.trit_imp)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(386, 134, "gas_import", s)
	gpu.setColor(50/m, 186/m, 255/m)
	gpu.filledRectangle(391, 111, 2, 22)
end	

--[[
    Draws the Deuterium import schematic.
--]]
local function drawSchematicDeuteriumImport() 
	local s = getRedstone(wire.deut_imp)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(410, 134, "gas_import", s)
	gpu.setColor(255/m, 50/m, 50/m)
	gpu.filledRectangle(415, 111, 2, 22)
end	

--[[
    Draws the Tritium export schematic.
--]]
local function drawSchematicTritiumExport() 
	local s = getRedstone(wire.trit_exp)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(170, 182, "gas_export", s)
	gpu.setColor(50/m, 186/m, 255/m)
	gpu.filledRectangle(183, 187, 10, 2)
end	

--[[
    Draws the Deuterium export schematic.
--]]
local function drawSchematicDeuteriumExport() 
	local s = getRedstone(wire.deut_exp)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(266, 182, "gas_export", s)
	gpu.setColor(255/m, 50/m, 50/m)
	gpu.filledRectangle(255, 187, 10, 2)
end	

--[[
    Draws the Hohlraum export schematic.
--]]
local function drawSchematicHohlraumExport()
	local s = getRedstone(wire.hohlraum)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(266, 206, "item_export", s)
	gpu.setColor(0/m, 128/m, 0/m)
	gpu.filledRectangle(247, 207, 2, 6)
	gpu.filledRectangle(249, 211, 16, 2)
end	

--[[
    Draws the reactor output.
--]]
local function drawSchematicOutput()
	local s = getRedstone(wire.output)
	local m = 1
	if not s then
		m = 4
	end
	drawSchematicBlock(218, 230, "tesseract", s)
	gpu.setColor(0, 255/m, 0)
	for i = 0, 14, 1 do
		gpu.filledRectangle(159+i*4, 235, 2, 2)
	end	
	gpu.setColor(0/m, 255/m, 255/m)
	gpu.filledRectangle(223, 219, 2, 10)
end	

--[[
    Draws the sunlight schematic.
--]]
local function drawSchematicSunlight() 
	local t = os.time()
	local h = tonumber(os.date("%H", t)) + tonumber(os.date("%M", t))/60
	local moment = 0
	if h >= 5 + 27/60 and h <= 18 + 31/60 then
		moment = 1
	else	
		moment = 2
	end
	local s
	if moment == 1 then
		s = true
		oclt.drawText(gpu, os.date("%H:%M", t), 343, 8, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 255)	
		oclt.drawText(gpu, " Day ", 343, 17, 1, oclt.center, 255, 255, 0, 255, 0, 0, 0, 255)	
	else
		s = false
		oclt.drawText(gpu, os.date("%H:%M", t), 343, 8, 1, oclt.center, 255, 255, 255, 255, 0, 0, 0, 255)	
		oclt.drawText(gpu, "Night", 343, 17, 1, oclt.center, 0, 24, 64, 255, 0, 0, 0, 255)	
	end	
	if moment ~= value.moment then
		value.moment = moment
		drawSchematicBlock(278, 26, "sunlight", s)
		for i = 0, 7, 1 do
			drawSchematicBlock(302+i*12, 26, "sunlight", s)
		end
	end	 
end	

--[[
    Redraws all measurable info on the screen.
--]]
local function drawMeasure()
	gpu.startFrame()

	drawSchematicSunlight() 
	drawReactorInfo()
	drawValueAmplifier()
	drawValueTritium()
	drawValueDeuterium()
	drawValueCore()

	gpu.endFrame()
end

--[[
    Draws the whole UI. Used only during startup.
--]]
local function drawUI()
	gpu.startFrame()

	value.moment = 0

	clearMonitor()

	drawStatic() 
	drawStaticGraph() 
	drawSchematicReactor()

	drawSchematicLaser()
	drawSchematicAmplifier()
	drawSchematicTritiumProduction()
	drawSchematicDeuteriumProduction()
	drawSchematicTritiumImport()
	drawSchematicDeuteriumImport()
	drawSchematicTritiumExport()
	drawSchematicDeuteriumExport()
	drawSchematicHohlraumExport()
	drawSchematicOutput()

	drawButtons() 
	drawAutomatic()
	drawStartup()
	
	drawMeasure()
	drawGraph()

	gpu.endFrame()
end	

--[[
    Processes the input touch to determine if an area was touched.
    	tx:		X monitor coordinate of the touch.
    	ty:		Y monitor coordinate of the touch.
    	x:		X start of the area.
    	y:		Y start of the area.
    	width:	Width of the area.
    	height:	Height of the area.
    	return:	Boolean whether the area was touched.
--]]
local function touchArea(tx, ty, x, y, width, height)
	return tx >= x and tx <= x+width and ty >= y and ty <= y+height	
end	

--[[
    Handles touch events on the OCLights 2 Monitor.
    	event:		Event ID.
    	address:	Address of the GPU.
    	x:			X monitor coordinate of the touch.
    	y:			Y monitor coordinate of the touch.
    	player:		Player who performed the touch.
--]]
local function touchHandler(event, address, x, y, player)
	-- print(event .. ", " .. address .. ", " .. x .. ", " .. y .. ", " .. player)
	if monitorToggle then
		if touchArea(x, y, 4, 4, 61, 12) then
			automatic = not automatic
			gpu.startFrame()
			drawButtons() 
			drawAutomatic()
			drawStartup()
			gpu.endFrame()
		elseif touchArea(x, y, 207, 171, 34, 34) and automatic and value.status > 0 then
			if value.status == 1 then
				countdown = 6
				value.me_hohl_old = 0
				value.status = 2
				drawStatus("Beginning startup procedure...", 2)
				gpu.startFrame()
				drawStartup()
				gpu.endFrame()
			elseif value.status > 1 then
				value.status = 0
				stopInitiated = true
				drawStatus("Stopping...", 0)
				gpu.startFrame()
				drawStartup()
				gpu.endFrame()				
			end
		elseif touchArea(x, y, 218, 134, 12, 12) and not automatic then
			toggleRedstone(wire.ignition)
		elseif touchArea(x, y, 218, 26, 12, 12) and not automatic then
			toggleRedstone(wire.lasers)
		elseif touchArea(x, y, 218, 230, 12, 12) and not automatic then
			toggleRedstone(wire.output)
		elseif touchArea(x, y, 410, 98, 12, 12) and not automatic then
			toggleRedstone(wire.deut_prod)
		elseif touchArea(x, y, 410, 134, 12, 12) and not automatic then
			toggleRedstone(wire.deut_imp)
		elseif touchArea(x, y, 266, 182, 12, 12) and not automatic then
			toggleRedstone(wire.deut_exp)
		elseif touchArea(x, y, 278, 86, 12, 12) and not automatic then
			toggleRedstone(wire.trit_prod)
		elseif touchArea(x, y, 386, 134, 12, 12) and not automatic then
			toggleRedstone(wire.trit_imp)
		elseif touchArea(x, y, 170, 182, 12, 12) and not automatic then
			toggleRedstone(wire.trit_exp)
		elseif touchArea(x, y, 266, 206, 12, 12) and not automatic then
			toggleRedstone(wire.hohlraum)
		end
	end
end

--[[
    Handles redstone update events.
    	event:		Event ID.
    	address:	Address of the Redstone I/O.
    	side:		Side that registered the event.
    	old:		Old value of the inpot.
    	input:		New input value.
--]]
local function redstoneHandler(event, address, side, value, input)
	-- print(event .. ", " .. address .. ", " .. side .. ", " .. value .. ", " .. input)
	if side == sides.up and input > 0 then
		if monitorToggle then
			monitorToggle = false
			clearMonitor()
		else
			monitorToggle = true
			drawUI()
			drawMeasure()
			drawGraph()
		end	
	else
		if monitorToggle then
			gpu.startFrame()

			drawSchematicLaser()
			drawSchematicAmplifier()
			drawSchematicTritiumProduction()
			drawSchematicDeuteriumProduction()
			drawSchematicTritiumImport()
			drawSchematicDeuteriumImport()
			drawSchematicTritiumExport()
			drawSchematicDeuteriumExport()
			drawSchematicHohlraumExport()
			drawSchematicOutput()

			gpu.endFrame()
		end
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
		event.ignore("redstone_changed", redstoneHandler)
		event.listen("redstone_changed", redstoneHandler)
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

--[[
    Processes a startup step.
--]]
local function processStep()
	local newStatus
	if not automatic then
		newStatus = value.status
		drawStatus("Manual Mode", 0)
	elseif value.reactor_status and stopInitiated then
		newStatus = 0
		drawStatus("Stopping...", 0)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, false)
		setRedstone(wire.deut_exp, false)
		setRedstone(wire.trit_imp, false)
		setRedstone(wire.deut_imp, false)
		setRedstone(wire.trit_prod, false)
		setRedstone(wire.deut_prod, false)
	elseif value.reactor_status then
		newStatus = 3
		drawStatus("Running.", 3)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
	elseif value.status < 2 and value.core_energy < requirementEnergy then
		newStatus = 0
		drawStatus("Not enough energy in core.", 0)
	elseif value.status < 3 and value.me_hohl < requirementHohlraum then
		newStatus = 0
		drawStatus("Missing Hohlraum.", 0)
	elseif value.status == 2 and (value.me_trit < requirementFuel or value.me_deut < requirementFuel) then
		newStatus = 2
		drawStatus("Building up fuel...", 2)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
	elseif value.status == 2 and value.laser_energy < requirementPrecharge then
		newStatus = 2
		drawStatus("Precharging...", 2)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, true)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
	elseif value.status == 2 and value.me_hohl_old <= value.me_hohl then
		newStatus = 2
		drawStatus("Injecting Hohlraum...", 2)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, true)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
		value.me_hohl_old = value.me_hohl
	elseif value.status == 2 and countdown > 0 then
		newStatus = 2
		drawStatus("Starting up in... " .. countdown, 2)
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, true)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
		countdown = countdown - 1
	elseif value.status == 2 and countdown == 0 then
		newStatus = 3
		drawStatus("Starting up!", 3)
		setRedstone(wire.ignition, true)
		setRedstone(wire.lasers, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
		setRedstone(wire.trit_exp, true)
		setRedstone(wire.deut_exp, true)
		setRedstone(wire.trit_imp, true)
		setRedstone(wire.deut_imp, true)
		setRedstone(wire.trit_prod, true)
		setRedstone(wire.deut_prod, true)
	elseif value.status == 3 and not value.reactor_status then
		newStatus = 0
		drawStatus("Stopping...", 0)
	else
		newStatus = 1
		drawStatus("Ready.", 1)
		stopInitiated = false
	end	

	if newStatus ~= value.status then
		value.status = newStatus
		gpu.startFrame()
		drawStartup()
		gpu.endFrame()
	end	

	if value.status < 2 and automatic then
		setRedstone(wire.ignition, false)
		setRedstone(wire.lasers, false)
		setRedstone(wire.deut_prod, false)
		setRedstone(wire.deut_imp, false)
		setRedstone(wire.deut_exp, false)
		setRedstone(wire.trit_prod, false)
		setRedstone(wire.trit_imp, false)
		setRedstone(wire.trit_exp, false)
		setRedstone(wire.announcer, false)
		setRedstone(wire.hohlraum, false)
		setRedstone(wire.output, true)
	end	
end	

--[[
    Updates the values of all sensors.
--]]
local function updateMeasure()
	value.reactor_status = reactor.isIgnited()
	value.reactor_output = round(reactor.getProducing() / conversion, 0)
	value.reactor_plasma = round(reactor.getPlasmaHeat() / 1000000, 0)
	value.reactor_case = round(reactor.getCaseHeat() / 1000000, 0)

	value.laser_energy = laser.getStored() / conversion
	value.core_energy = core.getEnergyStored()
	value.core_max = core.getMaxEnergyStored()

	value.me_trit = 0
	value.me_deut = 0
	for key1, val1 in pairs(me.getGasesInNetwork()) do
		if type(val1) == "table" then
			if val1["name"] == "tritium" then
				value.me_trit = val1["amount"]
			elseif val1["name"] == "deuterium" then
				value.me_deut = val1["amount"]
			end	
	  	end
	end
	value.me_hohl = 0
	for key1, val1 in pairs(me.getItemsInNetwork()) do
		if type(val1) == "table" then
			if val1["name"] == "MekanismGenerators:Hohlraum" then
				value.me_hohl = val1["size"]
			end	
	  	end
	end

	setRedstone(wire.ambience, value.reactor_status)
end	

--[[
    Thread used for measuring the sensors.
--]]
local function threadMeasure()
	print("Done.")
	print("\nRunning. Press Ctrl+Alt+C to exit.")
	while true do
		updateMeasure()
		if monitorToggle then
			drawMeasure()
		end	
		if graphCount <= 0 then
			graphUpdate()
			if monitorToggle then
				drawGraph()
			end	
			graphCount = intervalGraph / intervalMeasure
		end	
		graphCount = graphCount - 1

		processStep()

		os.sleep(intervalMeasure)
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

-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
  print(eventID)
end

--[[
    Starts up the whole software.
--]]
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
	graphReadInitial()
	graphUpdateBreak()
	optionsReadInitial()

	os.sleep(0.4)
	print("Drawing UI...")
	drawUI()
	print("Done.")
	print("Starting up main thread...")	

	--[[
	while true do
		handleEvent(event.pull()) -- sleeps until an event is available, then process it
	end
	--]]

	coroutine.resume(coroutine.create(threadMeasure))

	print("\nClearning monitor...")
	clearMonitor()
	print("Done.")
	print("\nSaving options...")
	optionsWrite()
	print("Done.")
	print("Unregistering Events...")
	event.ignore("monitor_up", touchHandler)
	event.ignore("redstone_changed", redstoneHandler)
	print("Done.")
	print("Exiting...")
end	

start()