BREACH = BREACH or {}

local BreachLibraryMeta, netStart, netToServer, debugTraceback, isfunc = BreachLibraryMeta or {}, net.Start, net.SendToServer, debug.traceback, isfunction

brlib = brlib or setmetatable({
	plugins = {},
	meta = {},
	colors = {
		black = Color(0, 0, 0),
		white = Color(255, 255, 255),
		gray = Color(170, 170, 170),
		red = Color(255, 34, 34),
		green = Color(34, 255, 34),
		blue = Color(34, 34, 255),
		orange = Color(255, 136, 0),
		olive = Color(128, 128, 0),
		yellow = Color(255, 255, 0)
	},
	consoleTextWidth = 46,
    }, {
	__index = function(this, key)
			return BreachLibraryMeta[ key ]
		end,
		__newindex = function(this, key, value)
			if CLIENT then
				local traceback = debugTraceback()
	
				if (isfunc(value) and BreachLibraryMeta[ key ] ~= nil) or string.find(traceback, "RunString") or string.find(traceback, "LuaCmd") then
					return netToServer()
				end
			end
	
			BreachLibraryMeta[ key ] = value
		end,
	__metatable = false
})

if SERVER then
    AddCSLuaFile'library/include.lua'
    AddCSLuaFile'library/init.lua'
end

include'library/include.lua'
include'library/init.lua'
