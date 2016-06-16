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

local version = "v1.0.0"

local conversion = 2.5
local intervalMeasure = 0.1
local intervalGraph = 1

local gpu
local redstone
local reactor
local laser
local me
local core

local loadSteps = 9
local loadProgress = 0
local graphCount = 0

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

value.moment = 0

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

		value.core_graph[0] = -1
		io.write("\n" .. tostring(value.core_graph[0]))

		for i = 1, 95, 1 do
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
    Reads the graph file from disk.
--]]
local function graphRead()
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
	if value.laser_energy > 400000000 then
		perc = ">100.0%"
		total = ">".. oclt.formatValue(400000, "|KRF")
		gpu.setColor(0, 255, 255)
		gpu.filledRectangle(245, 137, 102, 6)
	else	
		perc = round(value.laser_energy/400000000*100, 1) .. "%"
		total = oclt.formatValue(round(value.laser_energy/1000, 0), "|KRF")
		local bar = value.laser_energy/400000000*102
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
		oclt.drawText(gpu, os.date("%H:%M", t), 343, 8, 1, oclt.center, 255, 255, 0, 255, 0, 0, 0, 255)	
		oclt.drawText(gpu, " Day ", 343, 17, 1, oclt.center, 255, 255, 0, 255, 0, 0, 0, 255)	
	else
		s = false
		oclt.drawText(gpu, os.date("%H:%M", t), 343, 8, 1, oclt.center, 0, 24, 64, 255, 0, 0, 0, 255)	
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
    Draws the whole UI. Used only during startup.
--]]
local function drawUI()
	gpu.startFrame()

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

	oclt.drawText(gpu, "Reactor Info", 7, 200, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	oclt.drawText(gpu, "Status:", 10, 211, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Output:", 10, 220, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Plasma:", 10, 229, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)
	oclt.drawText(gpu, "Case:", 10, 238, 1, oclt.left, 255, 255, 255, 255, 0, 0, 0, 0)

	gpu.endFrame()
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
	print(event .. ", " .. address .. ", " .. x .. ", " .. y .. ", " .. player)
	if x >= 20 and x <= 120 and y >= 20 and y <= 120 then
		print("Boop!")
	end
end

--[[
    Handles redstone update events.
    	event:		Event ID.
    	address:	Address of the Redstone I/O.
    	input:		Input wire number.
--]]
local function redstoneHandler(event, address, side, value, input)
	--print(event .. ", " .. address .. ", " .. side .. ", " .. value .. ", " .. input)
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

	for key1, val1 in pairs(me.getGasesInNetwork()) do
		if type(val1) == "table" then
			if val1["name"] == "tritium" then
				value.me_trit = val1["amount"]
			elseif val1["name"] == "deuterium" then
				value.me_deut = val1["amount"]
			end	
	  	end
	end
	for key1, val1 in pairs(me.getItemsInNetwork()) do
		if type(val1) == "table" then
			if val1["name"] == "MekanismGenerators:HohlRaum" then
				value.me_hohl = val1["amount"]
			end	
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
    Thread used for measuring the sensors.
--]]
local function threadMeasure()
	print("Done.")
	print("\nRunning. Press Ctrl+Alt+C to exit.")
	while true do
		os.sleep(intervalMeasure)
		updateMeasure()
		drawMeasure()
		if graphCount <= 0 then
			graphUpdate()
			graphCount = intervalGraph / intervalMeasure
		end	
		graphCount = graphCount - 1
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

	os.sleep(0.4)
	print("Drawing UI...")
	drawUI()
	print("Done.")
	print("Sending data to monitor...")
	drawMeasure()
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
	print("Unregistering Events...")
	event.ignore("monitor_up", touchHandler)
	event.ignore("redstone_changed", redstoneHandler)
	print("Done.")
	print("Exiting...")

	-- drawButton(8, 8, 32, 32, false)
end	

start()