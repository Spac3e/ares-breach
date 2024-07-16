--[[


addons/[weapons]_cw_20/lua/weapons/cw_base/sh_ammotypes.lua

--]]

function CW_AddAmmoType(name)
	game.AddAmmoType({name = name,
	dmgtype = DMG_BULLET})
	
	if CLIENT then
		language.Add(name .. "_ammo", name .. " Ammo")
	end
end