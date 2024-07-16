--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_assrifle_msr/sh_sounds.lua

--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_M40A1_FIRE", "weapons/m40a1/m40a1_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_M40A1_FIRE_SUPPRESSED", "weapons/m40a1/m40a1_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_BOLTBACK", "weapons/m40a1/handling/m40a1_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_BOLTFORWARD", "weapons/m40a1/handling/m40a1_boltforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_BOLTLATCH", "weapons/m40a1/handling/m40a1_boltlatch.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_BOLTRELEASE", "weapons/m40a1/handling/m40a1_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_BULLETIN", {
	"weapons/m40a1/handling/m40a1_bulletin_1.wav",
	"weapons/m40a1/handling/m40a1_bulletin_2.wav",
	"weapons/m40a1/handling/m40a1_bulletin_3.wav",
	"weapons/m40a1/handling/m40a1_bulletin_4.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_M40A1_EMPTY", "weapons/m40a1/handling/m40a1_empty.wav")
