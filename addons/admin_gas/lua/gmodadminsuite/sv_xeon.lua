GAS.XEON = {}

local XEONReady = XEON ~= nil
local HTTPReady = false

local postload = {}
function GAS.XEON:PostLoad(callback)
	if (XEONReady and PlayerJoined) then
		callback()
	else
		table.insert(postload, callback)
	end
end
local function PostLoad()
	if (XEONReady and HTTPReady) then
		for _,v in ipairs(postload) do v() end
		postload = {}
	end
end

timer.Simple(0, function()
	HTTPReady = true
	PostLoad()
end)
GAS:hook("XEON.Ready", "XEON.Ready", function()
	GAS:unhook("XEON.Ready", "XEON.Ready")
	XEONReady = true
	PostLoad()
end)