--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_revolver/sh_sounds.lua

--]]

--[[
lua/weapons/cw_kk_ins2_revolver/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_REVOLVER_FIRE", "weapons/revolver/revolver_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_REVOLVER_FIRE_SUPPRESSED", "weapons/revolver/revolver_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_CLOSECHAMBER", "weapons/revolver/handling/revolver_close_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_COCKHAMMER", "weapons/revolver/handling/revolver_cock_hammer.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_COCKHAMMERREADY", "weapons/revolver/handling/revolver_cock_hammer_ready.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_DUMPROUNDS", {
	"weapons/revolver/handling/revolver_dump_rounds_01.wav",
	"weapons/revolver/handling/revolver_dump_rounds_02.wav",
	"weapons/revolver/handling/revolver_dump_rounds_03.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_EMPTY", "weapons/revolver/handling/revolver_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_OPENCHAMBER", "weapons/revolver/handling/revolver_open_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_INSERTSINGLE", {
	"weapons/revolver/handling/revolver_round_insert_single_01.wav",
	"weapons/revolver/handling/revolver_round_insert_single_02.wav",
	"weapons/revolver/handling/revolver_round_insert_single_03.wav",
	"weapons/revolver/handling/revolver_round_insert_single_04.wav",
	"weapons/revolver/handling/revolver_round_insert_single_05.wav",
	"weapons/revolver/handling/revolver_round_insert_single_06.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_REVOLVER_SPEEDLOADERINSERT", "weapons/revolver/handling/revolver_speed_loader_insert_01.wav")


