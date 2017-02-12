--[[
    Demo: OCL Text Demo (oclt-demo)
    Programmed by: Thorinair
    Version: v1.0.1
    Description: Demo for testing the OCL Text library.
    Usage: Install the library, connect an OCLights 2 GPU with the computer and run the demo.
    Requirements: 
    	OCLights 2 mod has to be installed, and a GPU should be connected with the OpenComputer.
    	Additionally, the OCL Text library from this same repository should be installed on the OpenComputer.
--]]

local oclt = require("oclt")

local component = require("component")
local gpu = component.ocl_gpu

gpu.startFrame()

gpu.setColor(0, 0, 0)
gpu.filledRectangle(0, 0, 448, 256)

oclt.drawText(gpu, "OCL Text Demo", 128, 24, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 0, 0, 0, 0)

oclt.drawText(gpu, "abcdefghijklmnopqrstuvwxyz", 128, 56, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 255, 0, 255, 255)
oclt.drawText(gpu, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 128, 64, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 255, 0, 255, 255)
oclt.drawText(gpu, "!\"#$%&/()=?* \'+,.-;:_<>[]{}\\", 128, 72, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 255, 0, 255, 255)

oclt.drawText(gpu, "Red color", 128, 88, 1, oclt.ALIGN_LEFT, 255, 0, 0, 255, 0, 0, 0, 0)
oclt.drawText(gpu, "Green color", 128, 96, 1, oclt.ALIGN_LEFT, 0, 255, 0, 255, 0, 0, 0, 0)
oclt.drawText(gpu, "Blue color", 128, 104, 1, oclt.ALIGN_LEFT, 0, 1, 255, 255, 0, 0, 0, 0)

oclt.drawText(gpu, "Red background", 128, 120, 1, oclt.ALIGN_LEFT, 0, 0, 0, 255, 255, 0, 0, 255)
oclt.drawText(gpu, "Green background", 128, 128, 1, oclt.ALIGN_LEFT, 0, 0, 0, 255, 0, 255, 0, 255)
oclt.drawText(gpu, "Blue background", 128, 136, 1, oclt.ALIGN_LEFT, 0, 0, 0, 255, 0, 0, 255, 255)

oclt.drawText(gpu, "Left alignment", 128, 152, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 0, 0, 0, 0)
oclt.drawText(gpu, "Right alignment", 128, 160, 1, oclt.ALIGN_RIGHT, 255, 255, 255, 255, 0, 0, 0, 0)
oclt.drawText(gpu, "Center alignment", 128, 168, 1, oclt.ALIGN_CENTER, 255, 255, 255, 255, 0, 0, 0, 0)

oclt.drawText(gpu, "Larger text", 128, 184, 2, oclt.ALIGN_LEFT, 255, 255, 255, 255, 255, 0, 0, 0, 0)

oclt.drawText(gpu, "Formatted value: " .. oclt.formatValue(4357432309, " RF"), 128, 208, 1, oclt.ALIGN_LEFT, 255, 255, 255, 255, 0, 0, 0, 0)

gpu.endFrame()