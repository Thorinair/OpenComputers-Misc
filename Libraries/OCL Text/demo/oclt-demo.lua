--[[
    Application: OCL Text Demo (oclt-demo)
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Demo for testing the OCL Text library.
    Usage: Download the library, connect an OCLights 2 GPU with the computer and run the demo.
    Requirements: 
    	OCLights 2 mod has to be installed, and a GPU should be connected with the OpenComputer.
    	Additionally, the OCL Text library from this same repository should be installed on the OpenComputer.
--]]

local component = require("component")
local gpu = component.ocl_gpu
local ocl = require("ocl-text")

gpu.setColor(0, 0, 0)
gpu.filledRectangle(0, 0, 448, 256)

ocl.drawText(gpu, "Demo - OCL Text", 128, 24, 1, ocl.left, 255, 255, 255, 255, 0, 0, 0, 0)

os.sleep(0.5)

ocl.drawText(gpu, "abcdefghijklmnopqrstuvwxyz", 128, 56, 1, ocl.left, 255, 255, 255, 255, 255, 0, 255, 255)
ocl.drawText(gpu, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 128, 64, 1, ocl.left, 255, 255, 255, 255, 255, 0, 255, 255)
ocl.drawText(gpu, "!\"#$%&/()=?* \'+,.-;:_<>[]{}\\", 128, 72, 1, ocl.left, 255, 255, 255, 255, 255, 0, 255, 255)

os.sleep(0.5)

ocl.drawText(gpu, "Red color", 128, 88, 1, ocl.left, 255, 0, 0, 255, 0, 0, 0, 0)
ocl.drawText(gpu, "Green color", 128, 96, 1, ocl.left, 0, 255, 0, 255, 0, 0, 0, 0)
ocl.drawText(gpu, "Blue color", 128, 104, 1, ocl.left, 0, 0, 255, 255, 0, 0, 0, 0)

os.sleep(0.5)

ocl.drawText(gpu, "Red background", 128, 120, 1, ocl.left, 0, 0, 0, 255, 255, 0, 0, 255)
ocl.drawText(gpu, "Green background", 128, 128, 1, ocl.left, 0, 0, 0, 255, 0, 255, 0, 255)
ocl.drawText(gpu, "Blue background", 128, 136, 1, ocl.left, 0, 0, 0, 255, 0, 0, 255, 255)

os.sleep(0.5)

ocl.drawText(gpu, "Left alignment", 128, 152, 1, ocl.left, 255, 255, 255, 255, 0, 0, 0, 0)
ocl.drawText(gpu, "Right alignment", 128, 160, 1, ocl.right, 255, 255, 255, 255, 0, 0, 0, 0)
ocl.drawText(gpu, "Center alignment", 128, 168, 1, ocl.center, 255, 255, 255, 255, 0, 0, 0, 0)

os.sleep(0.5)

ocl.drawText(gpu, "Larger text", 128, 184, 2, ocl.left, 255, 255, 255, 255, 255, 0, 0, 0, 0)

os.sleep(0.5)

ocl.drawText(gpu, "Formatted value: " .. ocl.formatValue(4357432309, " RF"), 128, 208, 1, ocl.left, 255, 255, 255, 255, 0, 0, 0, 0)