--[[


addons/[weapons]_cw_20/lua/weapons/cw_grenade_base/cl_umsgs.lua

--]]

local function CW_Flashbanged(data)
	local intensity = data:ReadFloat()
	local duration = data:ReadFloat()
	
	LocalPlayer():cwFlashbang(intensity, duration)
end

usermessage.Hook("CW_FLASHBANGED", CW_Flashbanged)