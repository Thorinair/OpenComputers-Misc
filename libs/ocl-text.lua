--[[
    Library: OCL Text
    Programmed by: Thorinair
    Version: v1.0.0
    Description: Provides an API for drawing text on OCLights 2 monitors.
    Usage: First add this library to the OpenComputers computer by placing it into the lib folder.
    	   Then, include the library in your program using the require function, and then access the functions by their name. 
           The functions that should be used are on the bottom of this file, along with documentation.
           When displaying text, keep in mind that the pipe character "|" is used for a smaller space between characters.
    Supported dymbols:
    	   123456789
    	   abcdefghijklmnopqrstuvwxyz
    	   ABCDEFGHIJKLMNOPQRSTUVWXYZ
    	   !"#$%&/()=?*'+,.-;:_<>[]{}\
		   |
    Requirements: OCLights 2 mod has to be installed, and a GPU should be connected with the OpenComputer.
--]]

local ocltext = {}

local function drawBackground(gpu, c, x, y, s)
	local n

	if c == '|' then
		gpu.filledRectangle(x, y, 2*s, 8*s)
		n = x + 2*s
	else 
		gpu.filledRectangle(x, y, 6*s, 8*s)	
		n = x + 6*s
	end

	return n
end	

local function drawChar(gpu, c, x, y, s)
	local n

	if c == '|' then
		n = x + 2*s
	else 
		n = x + 6*s
	end

	--0
	if c == '0' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 5*s)
	--1
	elseif c == '1' then
		gpu.filledRectangle(x+0*s, y+6*s, 5*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 6*s)
	--2
	elseif c == '2' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 2*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 2*s)
	--3
	elseif c == '3' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 2*s)
	--4
	elseif c == '4' then
		gpu.filledRectangle(x+0*s, y+4*s, 4*s, 1*s)
		gpu.filledRectangle(x+3*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--5
	elseif c == '5' then
		gpu.filledRectangle(x+0*s, y+0*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 3*s)
	--6
	elseif c == '6' then
		gpu.filledRectangle(x+2*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 4*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 2*s)
	--7
	elseif c == '7' then
		gpu.filledRectangle(x+0*s, y+0*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 3*s)
	--8
	elseif c == '8' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+0*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 2*s)
	--9
	elseif c == '9' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 2*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 4*s)	
	--a
	elseif c == 'a' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 4*s)		
	--b
	elseif c == 'b' then
		gpu.filledRectangle(x+2*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 3*s)
	--c
	elseif c == 'c' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 3*s)
	--d
	elseif c == 'd' then
		gpu.filledRectangle(x+1*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--e
	elseif c == 'e' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 2*s)
	--f
	elseif c == 'f' then
		gpu.filledRectangle(x+2*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 6*s)
	--g
	elseif c == 'g' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+7*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 5*s)
	--h
	elseif c == 'h' then
		gpu.filledRectangle(x+2*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 4*s)
	--i
	elseif c == 'i' then
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 5*s)
	--j
	elseif c == 'j' then
		gpu.filledRectangle(x+1*s, y+7*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 5*s)
	--k
	elseif c == 'k' then
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
	--l
	elseif c == 'l' then
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+0*s, 1*s, 6*s)
	--m
	elseif c == 'm' then
		gpu.filledRectangle(x+1*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 5*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 4*s)
	--n
	elseif c == 'n' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 5*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 4*s)
	--o
	elseif c == 'o' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 3*s)
	--p
	elseif c == 'p' then
		gpu.filledRectangle(x+2*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 6*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 2*s)
	--q
	elseif c == 'q' then
		gpu.filledRectangle(x+1*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 6*s)
	--r
	elseif c == 'r' then
		gpu.filledRectangle(x+2*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 5*s)
	--s
	elseif c == 's' then
		gpu.filledRectangle(x+1*s, y+2*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+5*s, 1*s, 1*s)
	--t
	elseif c == 't' then
		gpu.filledRectangle(x+1*s, y+1*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 6*s)
	--u
	elseif c == 'u' then
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 4*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 5*s)
	--v
	elseif c == 'v' then
		gpu.filledRectangle(x+1*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 3*s)
	--w
	elseif c == 'w' then
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 4*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 5*s)
	--x
	elseif c == 'x' then
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+6*s, 1*s, 1*s)
	--y
	elseif c == 'y' then
		gpu.filledRectangle(x+1*s, y+5*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+7*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 5*s)
	--z
	elseif c == 'z' then
		gpu.filledRectangle(x+0*s, y+2*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 5*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 1*s, 1*s)
	--A
	elseif c == 'A' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 6*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 6*s)
	--B
	elseif c == 'B' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 3*s)
	--C
	elseif c == 'C' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 5*s)
	--D
	elseif c == 'D' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 5*s)
	--E
	elseif c == 'E' then
		gpu.filledRectangle(x+1*s, y+0*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
	--F
	elseif c == 'F' then
		gpu.filledRectangle(x+1*s, y+0*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
	--G
	elseif c == 'G' then
		gpu.filledRectangle(x+1*s, y+0*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 4*s)
	--H
	elseif c == 'H' then
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--I
	elseif c == 'I' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 5*s)
	--J
	elseif c == 'J' then
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 6*s)
	--K
	elseif c == 'K' then
		gpu.filledRectangle(x+1*s, y+2*s, 2*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 3*s)
	--L
	elseif c == 'L' then
		gpu.filledRectangle(x+1*s, y+6*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
	--M
	elseif c == 'M' then
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--N
	elseif c == 'N' then
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--O
	elseif c == 'O' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 5*s)
	--P
	elseif c == 'P' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
	--Q
	elseif c == 'Q' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 2*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 4*s)
	--R
	elseif c == 'R' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 4*s)
	--S
	elseif c == 'S' then
		gpu.filledRectangle(x+1*s, y+0*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 3*s)
	--T
	elseif c == 'T' then
		gpu.filledRectangle(x+0*s, y+0*s, 5*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 6*s)
	--U
	elseif c == 'U' then
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 6*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 6*s)
	--V
	elseif c == 'V' then
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 4*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 4*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+4*s, 1*s, 2*s)
	--W
	elseif c == 'W' then
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)
	--X
	elseif c == 'X' then
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+4*s, 1*s, 3*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 3*s)
	--Y
	elseif c == 'Y' then
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 5*s)
	--Z
	elseif c == 'Z' then
		gpu.filledRectangle(x+0*s, y+0*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 5*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 1*s, 1*s)
	--!
	elseif c == '!' then
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 5*s)
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
	--"
	elseif c == '\"' then
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
	--#
	elseif c == '#' then
		gpu.filledRectangle(x+1*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+3*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 1*s)
	--$
	elseif c == '$' then
		gpu.filledRectangle(x+1*s, y+1*s, 4*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 4*s, 1*s)
		gpu.filledRectangle(x+0*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
	--%
	elseif c == '%' then
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+5*s, 1*s, 2*s)
	--&
	elseif c == '&' then
		gpu.filledRectangle(x+2*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 3*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+6*s, 2*s, 1*s)
		gpu.filledRectangle(x+4*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+5*s, 0*s, 1*s)
	--/
	elseif c == '/' then
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+0*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 2*s)
	--(
	elseif c == '(' then
		gpu.filledRectangle(x+3*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+2*s, 1*s, 3*s)
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+6*s, 2*s, 1*s)
	--)
	elseif c == ')' then
		gpu.filledRectangle(x+1*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 3*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 2*s, 1*s)
	--=
	elseif c == '=' then
		gpu.filledRectangle(x+0*s, y+2*s, 5*s, 1*s)
		gpu.filledRectangle(x+0*s, y+5*s, 5*s, 1*s)
	--?
	elseif c == '?' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+6*s, 1*s, 1*s)
	--*
	elseif c == '*' then
		gpu.filledRectangle(x+1*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 2*s, 1*s)
		gpu.filledRectangle(x+1*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+4*s, 1*s, 1*s)
	--'
	elseif c == '\'' then
		gpu.filledRectangle(x+3*s, y+0*s, 1*s, 2*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
	--+
	elseif c == '+' then
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+0*s, y+3*s, 2*s, 1*s)
		gpu.filledRectangle(x+3*s, y+3*s, 2*s, 1*s)
	--,
	elseif c == ',' then
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 3*s)
	--.
	elseif c == '.' then
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 2*s)
	---
	elseif c == '-' then
		gpu.filledRectangle(x+0*s, y+4*s, 5*s, 1*s)
	--;
	elseif c == ';' then
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 3*s)
	--:
	elseif c == ':' then
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 2*s)	
	--_
	elseif c == '_' then
		gpu.filledRectangle(x+0*s, y+7*s, 5*s, 1*s)
	--<
	elseif c == '<' then
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+6*s, 1*s, 1*s)
	-->
	elseif c == '>' then
		gpu.filledRectangle(x+1*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+2*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+4*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+5*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 1*s, 1*s)
	--[
	elseif c == '[' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
	--]
	elseif c == ']' then
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 5*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
	--{
	elseif c == '{' then
		gpu.filledRectangle(x+3*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+2*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+6*s, 2*s, 1*s)
	--}
	elseif c == '}' then
		gpu.filledRectangle(x+1*s, y+0*s, 2*s, 1*s)
		gpu.filledRectangle(x+3*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+4*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+3*s, y+4*s, 1*s, 2*s)
		gpu.filledRectangle(x+1*s, y+6*s, 2*s, 1*s)
	--\
	elseif c == '\\' then
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 1*s)
		gpu.filledRectangle(x+2*s, y+3*s, 1*s, 1*s)
		gpu.filledRectangle(x+4*s, y+6*s, 1*s, 1*s)
		gpu.filledRectangle(x+1*s, y+1*s, 1*s, 2*s)
		gpu.filledRectangle(x+3*s, y+4*s, 1*s, 2*s)
	-- 
	elseif c == ' ' then
	--|
	elseif c == '|' then
	--ELSE	
	else
		gpu.filledRectangle(x+1*s, y+0*s, 3*s, 1*s)
		gpu.filledRectangle(x+1*s, y+6*s, 3*s, 1*s)
		gpu.filledRectangle(x+0*s, y+0*s, 1*s, 7*s)
		gpu.filledRectangle(x+4*s, y+0*s, 1*s, 7*s)		
	end	

	return n
end

--[[
    Formats a number (separated by thousands) and appends a unit.
    This new string is easier to display on the monitor.
    	number: The input number.
    	unit: 	The unit to append at the end.
--]]
function ocltext.formatValue(number, unit)

	local text = tostring(number)
	local length = string.len(text)
	local j = 0
	local result = ""
	
	if string.sub(text, length-1, length-1) == '.' then
		length = length - 2
	end	
	
	for i = length, 1, -1 do
		if j < 3 then
			result = string.sub(text, i, i) .. result
			j = j + 1
		else
			result = string.sub(text, i, i) .. "|" .. result
			j = 1
		end		
	end
		
	return result .. unit
end	

--[[
    Draws text on the OC Lights 2 monitor.
    	gpu: 	GPU component to draw to.
    	text: 	The string of text that will be drawn.
    	x: 		X position of text on the monitor.
    	y: 		Y position of text on the monitor.
    	size:	Size multiplier for the text.
    	align:	Alignment of the text, can be left, right or center.
    	r:		Red color component of the text, 0-255.
    	g:		Green color component of the text, 0-255.
    	b:		Blue color component of the text, 0-255.
    	a:		Alpha (transparency) of the text, 0-255.
    	rB:		Red color component of the background, 0-255.
    	gB:		Green color component of the background, 0-255.
    	bB:		Blue color component of the background, 0-255.
    	aB:		Alpha (transparency) of the background, 0-255.
--]]
function ocltext.drawText(gpu, text, x, y, size, align, r, g, b, a, rB, gB, bB, aB)
	gpu.startFrame()
	local length = string.len(text)
	local n = 0
	local offs
	
	-- Count Microspaces	
	for i = length, 1, -1 do
		if string.sub(text, i, i) == '|' then
			n = n + 1
		end	
	end
	
	-- Setup Alignment
	if align == 0 then
		offs = x
	elseif align == 1 then
		offs = x - length*6*size+2 + n*4*size
	elseif align == 2 then
		offs = x - math.floor(length*6/2*size + n*4*size)
	end
	local bgOffs = offs

	if aB > 0 then
		-- Draw Background
		gpu.setColor(rB, gB, bB, aB)
		for i = 1, length do
			bgOffs = drawBackground(gpu, string.sub(text, i, i), bgOffs, y, size)
		end
	end

	-- Draw Characters
	gpu.setColor(r, g, b, a)
	for i = 1, length do
		offs = drawChar(gpu, string.sub(text, i, i), offs, y, size)
	end
	gpu.endFrame()
end	

--[[
    Text alignment constants.
--]]
ocltext.left = 0
ocltext.right = 1
ocltext.center = 2

return ocltext