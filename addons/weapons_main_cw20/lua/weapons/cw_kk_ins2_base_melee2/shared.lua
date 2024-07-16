--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_base_melee2/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()

--AddCSLuaFile("weapons/cw_extrema_ratio_official/shared.lua")
--AddCSLuaFile("weapons/cw_melee_base/shared.lua")

--include("weapons/cw_extrema_ratio_official/shared.lua")
--include("weapons/cw_melee_base/shared.lua")

SWEP.KKINS2Melee = true

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.SpeedDec = 0
SWEP.WeaponLength = 0

function SWEP:IndividualThink()
	-- weapons.GetStored("cw_kk_ins2_base").IndividualThink(self)
	weapons.GetStored("cw_kk_ins2_base_main").IndividualThink(self)

	weapons.GetStored("cw_melee_base").IndividualThink(self)
end

SWEP.SprintingEnabled = true
SWEP.InactiveWeaponStates = {
	[CW_RUNNING] = false,
	[CW_ACTION] = true,
	[CW_CUSTOMIZE] = true,
	[CW_HOLSTER_START] = true,
	[CW_HOLSTER_END] = true,
	[CW_PRONE_BUSY] = true,
	[CW_PRONE_MOVING] = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["slash_primary"] = -0.4,
	["slash_secondary"] = -0.4,
}
