--[[
    Library: OCLights Text
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Provides an API for drawing text on OCLights 2 monitors.
    Usage: Include the library in your program using the require function, and then access the functions by their name. 
           The functions that should be used are on the bottom of this file, along with documentation.
    Requirements: OCLights 2 mod has to be installed, and a GPU should be connected with the OpenComputer.
--]]


function drawChar(gpu, c, r, g, b, a, rb, gb, bb, ab, x, y)

	local n = x + 6

	gpu.setColor(rb, gb, bb, ab)	
	if c == '|' then
		gpu.filledRectangle(x, y, 2, 8)
	else 
		gpu.filledRectangle(x, y, 6, 8)	
	end

	gpu.setColor(r, g, b, a)

	--0
	if c == '0' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+3, y+2, 0, 0)
		gpu.filledRectangle(x+2, y+3, 0, 0)
		gpu.filledRectangle(x+1, y+4, 0, 0)
		gpu.filledRectangle(x+0, y+1, 0, 4)
		gpu.filledRectangle(x+4, y+1, 0, 4)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+2, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+2, y+4, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+5, 2, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 5, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 6)
	--1
	elseif c == '1' then
		gpu.filledRectangle(x+0, y+6, 4, 0)
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+2, y+0, 0, 5)

		--gpu.filledRectangle(0, 0, 0, x+3, y+0, 2, 5)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 1, 3)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 5, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+1, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+6, 0, 0)
	--2
	elseif c == '2' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+2, y+3, 1, 0)
		gpu.filledRectangle(x+0, y+6, 4, 0)
		gpu.filledRectangle(x+0, y+1, 0, 0)
		gpu.filledRectangle(x+1, y+4, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+1, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+2, y+4, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+4, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+5, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--3
	elseif c == '3' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+2, y+3, 1, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+1, 0, 1)
		gpu.filledRectangle(x+4, y+4, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 1, 2)
		--gpu.filledRectangle(0, 0, 0, x+1, y+4, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--4
	elseif c == '4' then
		gpu.filledRectangle(x+0, y+4, 3, 0)
		gpu.filledRectangle(x+3, y+0, 0, 0)
		gpu.filledRectangle(x+2, y+1, 0, 0)
		gpu.filledRectangle(x+1, y+2, 0, 0)
		gpu.filledRectangle(x+0, y+3, 0, 0)
		gpu.filledRectangle(x+4, y+0, 0, 6)

		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+2, y+2, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+5, 3, 2)
		--gpu.filledRectangle(0, 0, 0, x+2, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+1, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+7, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--5
	elseif c == '5' then
		gpu.filledRectangle(x+0, y+0, 4, 0)
		gpu.filledRectangle(x+0, y+2, 3, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+3, 0, 2)

		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 2, 2)
		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 3, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+2, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
		--gpu.filledRectangle(0, 0, 0, x+0, y+3, 0, 1)
	--6
	elseif c == '6' then
		gpu.filledRectangle(x+2, y+0, 1, 0)
		gpu.filledRectangle(x+1, y+3, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+2, 0, 3)
		gpu.filledRectangle(x+4, y+4, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 1, 3)
		--gpu.filledRectangle(0, 0, 0, x+2, y+1, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+1, y+4, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 5, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+1, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+2, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+4, 0, 2)
	--7
	elseif c == '7' then
		gpu.filledRectangle(x+0, y+0, 4, 0)
		gpu.filledRectangle(x+0, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+4, y+1, 0, 1)
		gpu.filledRectangle(x+2, y+4, 0, 2)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 1, 5)
		--gpu.filledRectangle(0, 0, 0, x+3, y+4, 2, 3)
		--gpu.filledRectangle(0, 0, 0, x+2, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+2, y+7, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 3)
	--8
	elseif c == '8' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+3, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 1)
		gpu.filledRectangle(x+4, y+1, 0, 1)
		gpu.filledRectangle(x+0, y+4, 0, 1)
		gpu.filledRectangle(x+4, y+4, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+1, y+4, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--9
	elseif c == '9' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+3, 2, 0)
		gpu.filledRectangle(x+1, y+6, 1, 0)
		gpu.filledRectangle(x+3, y+5, 0, 0)
		gpu.filledRectangle(x+0, y+1, 0, 1)
		gpu.filledRectangle(x+4, y+1, 0, 3)

		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+1, y+4, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+3, y+6, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+4, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+5, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
		--gpu.filledRectangle(0, 0, 0, x+0, y+3, 0, 3)
		
	-- 
	elseif c == ' ' then	
		gpu.filledRectangle(0, 0, 0, x+0, y+0, 5, 7)
		
	--|
	elseif c == '|' then	
		gpu.filledRectangle(0, 0, 0, x+0, y+0, 1, 7)
		n = x + 2
		
	--%
	elseif c == '%' then
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+2, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+6, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 1)
		gpu.filledRectangle(x+3, y+1, 0, 1)
		gpu.filledRectangle(x+1, y+4, 0, 1)
		gpu.filledRectangle(x+4, y+5, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+1, y+0, 1, 2)
		--gpu.filledRectangle(0, 0, 0, x+2, y+4, 1, 2)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
		--gpu.filledRectangle(0, 0, 0, x+4, y+1, 0, 3)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 0, 3)
	--/
	elseif c == '/' then
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+2, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+6, 0, 0)
		gpu.filledRectangle(x+3, y+1, 0, 1)
		gpu.filledRectangle(x+1, y+4, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 2, 2)
		--gpu.filledRectangle(0, 0, 0, x+4, y+1, 1, 2)
		--gpu.filledRectangle(0, 0, 0, x+2, y+4, 3, 3)
		--gpu.filledRectangle(0, 0, 0, x+0, y+3, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+3, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+1, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+4, 0, 1)
	---
	elseif c == '-' then
		gpu.filledRectangle(x+0, y+4, 4, 0)

		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 5, 3)
		--gpu.filledRectangle(0, 0, 0, x+0, y+5, 5, 2)
		--gpu.filledRectangle(0, 0, 0, x+5, y+4, 0, 0)
	--.
	elseif c == '.' then
		gpu.filledRectangle(x+2, y+5, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 5, 4)
		--gpu.filledRectangle(0, 0, 0, x+0, y+5, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+3, y+5, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 5, 0)
	--:
	elseif c == ':' then
		gpu.filledRectangle(x+2, y+1, 0, 1)
		gpu.filledRectangle(x+2, y+5, 0, 1)

		--gpu.filledRectangle(0, 0, 0, x+0, y+1, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+3, y+1, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+3, 5, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+5, 1, 1)
		--gpu.filledRectangle(0, 0, 0, x+3, y+5, 2, 1)
		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 5, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 5, 0)
		
	--A
	elseif c == 'A' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 5)
		gpu.filledRectangle(x+4, y+1, 0, 5)
	--B
	elseif c == 'B' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+4, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+3, 0, 2)
	--C
	elseif c == 'C' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+4, y+1, 0, 0)
		gpu.filledRectangle(x+4, y+5, 0, 0)
		gpu.filledRectangle(x+0, y+1, 0, 4)
	--D
	elseif c == 'D' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+1, 0, 4)
	--E
	elseif c == 'E' then
		gpu.filledRectangle(x+1, y+0, 3, 0)
		gpu.filledRectangle(x+1, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+6, 3, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)

		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 3, 2)
		--gpu.filledRectangle(0, 0, 0, x+1, y+1, 3, 0)
		--gpu.filledRectangle(0, 0, 0, x+3, y+2, 1, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--F
	elseif c == 'F' then
		gpu.filledRectangle(x+1, y+0, 3, 0)
		gpu.filledRectangle(x+1, y+2, 1, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
	--G
	elseif c == 'G' then
		gpu.filledRectangle(x+1, y+0, 3, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+3, y+2, 0, 0)
		gpu.filledRectangle(x+0, y+1, 0, 4)
		gpu.filledRectangle(x+4, y+2, 0, 3)
	--H
	elseif c == 'H' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+0, 0, 6)
	--I
	elseif c == 'I' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+2, y+1, 0, 4)
	--J
	elseif c == 'J' then
		n = 6
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+0, 0, 5)
	--K
	elseif c == 'K' then
		gpu.filledRectangle(x+1, y+2, 1, 0)
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+3, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+4, 0, 2)
	--L
	elseif c == 'L' then
		gpu.filledRectangle(x+1, y+6, 3, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
	--M
	elseif c == 'M' then
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+1, 0, 0)
		gpu.filledRectangle(x+2, y+2, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+0, 0, 6)
	--N
	elseif c == 'N' then
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+2, y+2, 0, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+0, 0, 6)
	--O
	elseif c == 'O' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 4)
		gpu.filledRectangle(x+4, y+1, 0, 4)
	--P
	elseif c == 'P' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+4, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
	--Q
	elseif c == 'Q' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 1, 0)
		gpu.filledRectangle(x+3, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+6, 0, 0)
		gpu.filledRectangle(x+0, y+1, 0, 4)
		gpu.filledRectangle(x+4, y+1, 0, 3)
	--R
	elseif c == 'R' then
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+4, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+3, 0, 3)
	--S
	elseif c == 'S' then
		gpu.filledRectangle(x+1, y+0, 3, 0)
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+1, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+3, 0, 2)
	--T
	elseif c == 'T' then
		gpu.filledRectangle(x+0, y+0, 4, 0)
		gpu.filledRectangle(x+2, y+1, 0, 5)
	--U
	elseif c == 'U' then
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+0, 0, 5)
		gpu.filledRectangle(x+4, y+0, 0, 5)

		--gpu.filledRectangle(0, 0, 0, x+1, y+0, 2, 5)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+0, 0, 7)
	--V
	elseif c == 'V' then
		gpu.filledRectangle(x+2, y+6, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 3)
		gpu.filledRectangle(x+4, y+0, 0, 3)
		gpu.filledRectangle(x+1, y+4, 0, 1)
		gpu.filledRectangle(x+3, y+4, 0, 1)
	--W
	elseif c == 'W' then
		gpu.filledRectangle(x+2, y+4, 0, 0)
		gpu.filledRectangle(x+1, y+5, 0, 0)
		gpu.filledRectangle(x+3, y+5, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+0, 0, 6)
	--X
	elseif c == 'X' then
		gpu.filledRectangle(x+0, y+0, 0, 0)
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+1, 0, 0)
		gpu.filledRectangle(x+2, y+2, 0, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+4, 0, 2)
		gpu.filledRectangle(x+4, y+4, 0, 2)
	--Y
	elseif c == 'Y' then
		gpu.filledRectangle(x+0, y+0, 0, 0)
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+1, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+1, 0, 0)
		gpu.filledRectangle(x+2, y+2, 0, 4)
	--Z
	elseif c == 'Z' then
		gpu.filledRectangle(x+0, y+0, 4, 0)
		gpu.filledRectangle(x+0, y+6, 4, 0)
		gpu.filledRectangle(x+4, y+1, 0, 0)
		gpu.filledRectangle(x+3, y+2, 0, 0)
		gpu.filledRectangle(x+2, y+3, 0, 0)
		gpu.filledRectangle(x+1, y+4, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		
	--a
	elseif c == 'a' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+4, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+5, 0, 0)
		gpu.filledRectangle(x+4, y+3, 0, 3)		
	--b
	elseif c == 'b' then
		gpu.filledRectangle(x+2, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+3, 0, 2)
	--c
	elseif c == 'c' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+4, y+3, 0, 0)
		gpu.filledRectangle(x+4, y+5, 0, 0)
		gpu.filledRectangle(x+0, y+3, 0, 2)
	--d
	elseif c == 'd' then
		gpu.filledRectangle(x+1, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+3, 0, 2)
		gpu.filledRectangle(x+4, y+0, 0, 6)
	--e
	elseif c == 'e' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+4, 2, 0)
		gpu.filledRectangle(x+1, y+6, 3, 0)
		gpu.filledRectangle(x+0, y+3, 0, 2)
		gpu.filledRectangle(x+4, y+3, 0, 1)
	--f
	elseif c == 'f' then
		gpu.filledRectangle(x+2, y+0, 1, 0)
		gpu.filledRectangle(x+0, y+2, 3, 0)
		gpu.filledRectangle(x+1, y+1, 0, 5)
	--g
	elseif c == 'g' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+5, 2, 0)
		gpu.filledRectangle(x+0, y+7, 3, 0)
		gpu.filledRectangle(x+0, y+3, 0, 1)
		gpu.filledRectangle(x+4, y+2, 0, 4)
	--h
	elseif c == 'h' then
		gpu.filledRectangle(x+2, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+3, 0, 3)
	--i
	elseif c == 'i' then
		gpu.filledRectangle(x+2, y+0, 0, 0)
		gpu.filledRectangle(x+2, y+2, 0, 4)
	--j
	elseif c == 'j' then
		gpu.filledRectangle(x+1, y+7, 2, 0)
		gpu.filledRectangle(x+4, y+0, 0, 0)
		gpu.filledRectangle(x+0, y+5, 0, 1)
		gpu.filledRectangle(x+4, y+2, 0, 4)
	--k
	elseif c == 'k' then
		gpu.filledRectangle(x+3, y+2, 0, 0)
		gpu.filledRectangle(x+2, y+3, 0, 0)
		gpu.filledRectangle(x+1, y+4, 0, 0)
		gpu.filledRectangle(x+2, y+5, 0, 0)
		gpu.filledRectangle(x+3, y+6, 0, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
	--l
	elseif c == 'l' then
		gpu.filledRectangle(x+2, y+6, 0, 0)
		gpu.filledRectangle(x+1, y+0, 0, 5)
	--m
	elseif c == 'm' then
		gpu.filledRectangle(x+1, y+2, 0, 0)
		gpu.filledRectangle(x+3, y+2, 0, 0)
		gpu.filledRectangle(x+0, y+2, 0, 4)
		gpu.filledRectangle(x+2, y+3, 0, 1)
		gpu.filledRectangle(x+4, y+3, 0, 3)
	--n
	elseif c == 'n' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+0, y+2, 0, 4)
		gpu.filledRectangle(x+4, y+3, 0, 3)
	--o
	elseif c == 'o' then
		gpu.filledRectangle(x+1, y+2, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+3, 0, 2)
		gpu.filledRectangle(x+4, y+3, 0, 2)
	--p
	elseif c == 'p' then
		gpu.filledRectangle(x+2, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+5, 2, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+2, 0, 5)
		gpu.filledRectangle(x+4, y+3, 0, 1)
	--q
	elseif c == 'q' then
		gpu.filledRectangle(x+1, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+5, 2, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+3, 0, 1)
		gpu.filledRectangle(x+4, y+2, 0, 5)
	--r
	elseif c == 'r' then
		gpu.filledRectangle(x+2, y+2, 1, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+4, y+3, 0, 0)
		gpu.filledRectangle(x+0, y+2, 0, 4)
	--s
	elseif c == 's' then
		gpu.filledRectangle(x+1, y+2, 3, 0)
		gpu.filledRectangle(x+1, y+4, 2, 0)
		gpu.filledRectangle(x+0, y+6, 3, 0)
		gpu.filledRectangle(x+0, y+3, 0, 0)
		gpu.filledRectangle(x+4, y+5, 0, 0)

		--gpu.filledRectangle(0, 0, 0, x+0, y+0, 5, 1)
		--gpu.filledRectangle(0, 0, 0, x+1, y+3, 3, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+5, 3, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+7, 4, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+2, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+0, y+4, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+4, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+4, y+6, 0, 0)
		--gpu.filledRectangle(0, 0, 0, x+5, y+2, 0, 5)
	--t
	elseif c == 't' then
		gpu.filledRectangle(x+1, y+1, 2, 0)
		gpu.filledRectangle(x+3, y+6, 0, 0)
		gpu.filledRectangle(x+2, y+0, 0, 5)
	--u
	elseif c == 'u' then
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+2, 0, 3)
		gpu.filledRectangle(x+4, y+2, 0, 4)
	--v
	elseif c == 'v' then
		gpu.filledRectangle(x+1, y+5, 0, 0)
		gpu.filledRectangle(x+3, y+5, 0, 0)
		gpu.filledRectangle(x+2, y+6, 0, 0)
		gpu.filledRectangle(x+0, y+2, 0, 2)
		gpu.filledRectangle(x+4, y+2, 0, 2)
	--w
	elseif c == 'w' then
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+2, 0, 3)
		gpu.filledRectangle(x+2, y+4, 0, 1)
		gpu.filledRectangle(x+4, y+2, 0, 4)
	--x
	elseif c == 'x' then
		gpu.filledRectangle(x+0, y+2, 0, 0)
		gpu.filledRectangle(x+4, y+2, 0, 0)
		gpu.filledRectangle(x+1, y+3, 0, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+2, y+4, 0, 0)
		gpu.filledRectangle(x+1, y+5, 0, 0)
		gpu.filledRectangle(x+3, y+5, 0, 0)
		gpu.filledRectangle(x+0, y+6, 0, 0)
		gpu.filledRectangle(x+4, y+6, 0, 0)
	--y
	elseif c == 'y' then
		gpu.filledRectangle(x+1, y+5, 2, 0)
		gpu.filledRectangle(x+0, y+7, 3, 0)
		gpu.filledRectangle(x+0, y+2, 0, 2)
		gpu.filledRectangle(x+4, y+2, 0, 4)
	--z
	elseif c == 'z' then
		gpu.filledRectangle(x+0, y+2, 4, 0)
		gpu.filledRectangle(x+0, y+6, 4, 0)
		gpu.filledRectangle(x+3, y+3, 0, 0)
		gpu.filledRectangle(x+2, y+4, 0, 0)
		gpu.filledRectangle(x+1, y+5, 0, 0)
		
	--ELSE	
	else
		gpu.filledRectangle(x+1, y+0, 2, 0)
		gpu.filledRectangle(x+1, y+6, 2, 0)
		gpu.filledRectangle(x+0, y+0, 0, 6)
		gpu.filledRectangle(x+4, y+0, 0, 6)		
	end	

	return n
end