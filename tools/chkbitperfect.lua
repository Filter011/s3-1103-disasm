#!/usr/bin/env lua

local clownmd5 = require "tools.lua.clownmd5"

-- Prevent make.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Make the ROM.
local co = coroutine.create(function() dofile("make.lua") end)
local _, _, abort = assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

if not abort then
	-- Hash the ROM.
	local hash = clownmd5.HashFile("s3built.bin")

	-- Verify the hash against known builds.
	print "-------------------------------------------------------------"

	if hash == "\x05\xAE\x03\xE1\x04\x9D\xCF\xE4\x17\xD3\x8B\x03\x1D\xC6\x96\xFB" then
		print "ROM is bit-perfect with Prototype."
	else
		print "ROM is NOT bit-perfect with Prototype!"
	end
end
