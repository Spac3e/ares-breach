--[[


addons/[weapons]_cw_20/lua/cw/client/cw_hooks.lua

--]]

function CustomizableWeaponry.InitPostEntity()
	local ply = LocalPlayer()

	CustomizableWeaponry.initCWVariables(ply)
end

hook.Add("InitPostEntity", "CustomizableWeaponry.InitPostEntity", CustomizableWeaponry.InitPostEntity)