--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_content.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()

// SOUNDS
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_SHOVEL", {"weapons/entrenchingtool/ent_tool_melee_01.wav", "weapons/entrenchingtool/ent_tool_melee_02.wav", "weapons/entrenchingtool/ent_tool_melee_03.wav", "weapons/entrenchingtool/ent_tool_melee_04.wav", "weapons/entrenchingtool/ent_tool_melee_05.wav", "weapons/entrenchingtool/ent_tool_melee_06.wav"})

	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_KNIFE", {"weapons/universal/weapon_melee_01.wav", "weapons/universal/weapon_melee_02.wav", "weapons/universal/weapon_melee_03.wav", "weapons/universal/weapon_melee_04.wav", "weapons/universal/weapon_melee_05.wav", "weapons/universal/weapon_melee_06.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_KNIFE_HITPLY", {"weapons/universal/weapon_melee_hitflesh_01.wav", "weapons/universal/weapon_melee_hitflesh_02.wav", "weapons/universal/weapon_melee_hitflesh_03.wav", "weapons/universal/weapon_melee_hitflesh_04.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_KNIFE_HITWORLD", {"weapons/universal/weapon_melee_hitworld_01.wav", "weapons/universal/weapon_melee_hitworld_02.wav"})

	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_MELEE", {"weapons/meleebash/melee_bash_01.wav", "weapons/meleebash/melee_bash_02.wav", "weapons/meleebash/melee_bash_03.wav", "weapons/meleebash/melee_bash_04.wav", "weapons/meleebash/melee_bash_05.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_MELEE_FT", {"weapons/meleebash/melee_bash_flamethrower_01.wav", "weapons/meleebash/melee_bash_flamethrower_02.wav", "weapons/meleebash/melee_bash_flamethrower_03.wav", "weapons/meleebash/melee_bash_flamethrower_04.wav", "weapons/meleebash/melee_bash_flamethrower_05.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_MELEE_HITPLY", {"weapons/meleebash/melee_bash_hit_flesh_01.wav", "weapons/meleebash/melee_bash_hit_flesh_02.wav", "weapons/meleebash/melee_bash_hit_flesh_03.wav", "weapons/meleebash/melee_bash_hit_flesh_04.wav", "weapons/meleebash/melee_bash_hit_flesh_05.wav", "weapons/meleebash/melee_bash_hit_flesh_06.wav", "weapons/meleebash/melee_bash_hit_flesh_07.wav", "weapons/meleebash/melee_bash_hit_flesh_08.wav", "weapons/meleebash/melee_bash_hit_flesh_09.wav", "weapons/meleebash/melee_bash_hit_flesh_10.wav", "weapons/meleebash/melee_bash_hit_flesh_11.wav", "weapons/meleebash/melee_bash_hit_flesh_12.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_MELEE_HITWORLD", {"weapons/meleebash/melee_bash_hitworld_01.wav", "weapons/meleebash/melee_bash_hitworld_02.wav", "weapons/meleebash/melee_bash_hitworld_03.wav", "weapons/meleebash/melee_bash_hitworld_04.wav"})

	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_BAYONET_HITPLY", {"weapons/bayonet/bayonet_hitflesh_01.wav", "weapons/bayonet/bayonet_hitflesh_02.wav", "weapons/bayonet/bayonet_hitflesh_03.wav", "weapons/bayonet/bayonet_hitflesh_04.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_BAYONET_HITWORLD", {"weapons/bayonet/bayonet_hitworld_01.wav", "weapons/bayonet/bayonet_hitworld_02.wav", "weapons/bayonet/bayonet_hitworld_03.wav", "weapons/bayonet/bayonet_hitworld_04.wav"})

	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_HATCHET", {"weapons/meleebash/hatchet_melee_01.wav", "weapons/meleebash/hatchet_melee_02.wav", "weapons/meleebash/hatchet_melee_03.wav", "weapons/meleebash/hatchet_melee_04.wav", "weapons/meleebash/hatchet_melee_05.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_HATCHET_HITPLY", {"weapons/meleebash/hatchet_hitflesh_01.wav", "weapons/meleebash/hatchet_hitflesh_02.wav", "weapons/meleebash/hatchet_hitflesh_03.wav", "weapons/meleebash/hatchet_hitflesh_04.wav"})
	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_HATCHET_HITWORLD", {"weapons/meleebash/hatchet_hitworld_01.wav", "weapons/meleebash/hatchet_hitworld_02.wav", "weapons/meleebash/hatchet_hitworld_03.wav", "weapons/meleebash/hatchet_hitworld_04.wav"})

	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_BAYONET_DRAW", {"weapons/universal/bayonet_draw_01.wav", "weapons/universal/bayonet_draw_02.wav", "weapons/universal/bayonet_draw_03.wav"})
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_BAYONET_HOLSTER", {"weapons/universal/bayonet_holster_01.wav", "weapons/universal/bayonet_holster_02.wav", "weapons/universal/bayonet_holster_03.wav"})

	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_ADSIN", {"weapons/universal/uni_ads_in_01.wav", "weapons/universal/uni_ads_in_02.wav", "weapons/universal/uni_ads_in_02.wav", "weapons/universal/uni_ads_in_04.wav", "weapons/universal/uni_ads_in_05.wav", "weapons/universal/uni_ads_in_06.wav"})
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_ADSOUT", {"weapons/universal/uni_ads_out_01.wav", "weapons/universal/uni_ads_out_02.wav", "weapons/universal/uni_ads_out_02.wav", "weapons/universal/uni_ads_out_04.wav", "weapons/universal/uni_ads_out_05.wav", "weapons/universal/uni_ads_out_06.wav"})
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_LOWER", {"weapons/universal/uni_weapon_lower_01.wav", "weapons/universal/uni_weapon_lower_02.wav", "weapons/universal/uni_weapon_lower_02.wav", "weapons/universal/uni_weapon_lower_04.wav", "weapons/universal/uni_weapon_lower_05.wav", "weapons/universal/uni_weapon_lower_06.wav"})
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_RAISE", {"weapons/universal/uni_weapon_raise_01.wav", "weapons/universal/uni_weapon_raise_02.wav", "weapons/universal/uni_weapon_raise_02.wav", "weapons/universal/uni_weapon_raise_04.wav", "weapons/universal/uni_weapon_raise_05.wav", "weapons/universal/uni_weapon_raise_06.wav"})

	CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_LAUNCHER_EMPTY", "weapons/universal/uni_launcher_empty.wav")

	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A1", "weapons/universal/uni_a_01.wav")
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A2", "weapons/universal/uni_a_02.wav")
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A3", "weapons/universal/uni_a_03.wav")
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A4", "weapons/universal/uni_a_04.wav")
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A5", "weapons/universal/uni_a_05.wav")
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_UNIVERSAL_A6", "weapons/universal/uni_a_06.wav")

	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_PLAYER_DAMAGEMAJOR", {
		"player/damage/pl_damage_major_01.wav",
		"player/damage/pl_damage_major_02.wav",
		"player/damage/pl_damage_major_03.wav",
		"player/damage/pl_damage_major_04.wav",
		"player/damage/pl_damage_major_05.wav",
		"player/damage/pl_damage_major_06.wav",
		"player/damage/pl_damage_major_07.wav",
		"player/damage/pl_damage_major_08.wav",
		"player/damage/pl_damage_major_09.wav",
		"player/damage/pl_damage_major_10.wav",
		"player/damage/pl_damage_major_11.wav",
		"player/damage/pl_damage_major_12.wav",
		"player/damage/pl_damage_major_13.wav",
		"player/damage/pl_damage_major_14.wav",
	})
	CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_PLAYER_DAMAGEMINOR", {
		"player/damage/pl_damage_minor_01.wav",
		"player/damage/pl_damage_minor_02.wav",
		"player/damage/pl_damage_minor_03.wav",
		"player/damage/pl_damage_minor_04.wav",
		"player/damage/pl_damage_minor_05.wav",
		"player/damage/pl_damage_minor_06.wav",
		"player/damage/pl_damage_minor_07.wav",
		"player/damage/pl_damage_minor_08.wav",
		"player/damage/pl_damage_minor_09.wav",
		"player/damage/pl_damage_minor_10.wav",
		"player/damage/pl_damage_minor_11.wav",
		"player/damage/pl_damage_minor_12.wav",
		"player/damage/pl_damage_minor_13.wav",
		"player/damage/pl_damage_minor_14.wav",
		"player/damage/pl_damage_minor_15.wav",
		"player/damage/pl_damage_minor_16.wav",
		"player/damage/pl_damage_minor_17.wav",
		"player/damage/pl_damage_minor_18.wav",
		"player/damage/pl_damage_minor_19.wav",
		"player/damage/pl_damage_minor_20.wav",
		"player/damage/pl_damage_minor_21.wav",
	})

// SHELLS
if CLIENT then
	CustomizableWeaponry.shells:addNew_KKINS2("KK_INS2_30-06_link", "models/weapons/shells/30-06_link.mdl", "CW_KK_INS2_SHELL_LINK", Vector(-0.65, -0.5, -0.25), Vector(0.9, 0.55, 0.25))
end

// AMMO
	CustomizableWeaponry:registerAmmo(".380/200", "9x20MMR Rounds", 9, 19.7)
	CustomizableWeaponry:registerAmmo(".303 British", "7.7x56MMR Rounds", 7.7, 56)
	CustomizableWeaponry:registerAmmo("PIAT Bomb", "PIAT Bombs", 0, 0)
	CustomizableWeaponry:registerAmmo("88MM Rocket", "88MM Rockets", 0, 0)

// FIREMODES
	CustomizableWeaponry.firemodes:registerFiremode("barfast", "FAST-AUTO", true, 0, 5)
	CustomizableWeaponry.firemodes:registerFiremode("barslow", "SLOW-AUTO", true, 0, 4)

// KILLSTUFFS
if CLIENT then
	local killCol = Color(255, 80, 0, 150)
	local white = Color(255, 255, 255, 150)

	-- killicon.AddFont("cw_kk_ins2_doi_mel_brass",		"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_garand",		"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_k98k",			"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_kabar",		"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_shovel_de",	"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_shovel_gb",	"CW_KillIcons", "j", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mel_shovel_us",	"CW_KillIcons", "j", killCol)

	-- killicon.AddFont("cw_kk_ins2_doi_browninghp",		"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_c96",				"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_luger",			"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m1911",			"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m1917",			"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_p38",				"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_ppk",				"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_webley",			"CW_KillIcons", "a", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_welrod",			"CW_KillIcons", "a", killCol)

	-- killicon.AddFont("cw_kk_ins2_doi_c96_c",			"CW_KillIcons", "x", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m3",				"CW_KillIcons", "q", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m3a1",				"CW_KillIcons", "q", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mp40",				"CW_KillIcons", "x", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_sten_mk2",			"CW_KillIcons", "x", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_sten_mk5",			"CW_KillIcons", "x", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_thom_1928",		"CW_KillIcons", "q", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_thom_m1a1",		"CW_KillIcons", "q", killCol)

	-- killicon.AddFont("cw_kk_ins2_doi_bar",				"CW_KillIcons", "i", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_bren",				"CW_KillIcons", "i", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_browning",			"CW_KillIcons", "z", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_enfield",			"CW_KillIcons", "r", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_fg42",				"CW_KillIcons", "r", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_g43",				"CW_KillIcons", "i", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_garand",			"CW_KillIcons", "i", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_ithaca",			"CW_KillIcons", "k", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_k98k",				"CW_KillIcons", "r", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_lewis",			"CW_KillIcons", "z", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m1",				"CW_KillIcons", "o", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m1a1",				"CW_KillIcons", "o", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_m1912",			"CW_KillIcons", "k", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mg34",				"CW_KillIcons", "z", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_mg42",				"CW_KillIcons", "z", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_spring",			"CW_KillIcons", "r", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_stg44",			"CW_KillIcons", "w", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_wicked",			"CW_KillIcons", "z", killCol)

	-- killicon.AddFont("cw_kk_ins2_doi_flame_gb",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_flame_gb",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_flame_us",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_molotov",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_c4_de",		"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_c4_us",		"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_m24",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_mk2",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_n36",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_n39",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_n69",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_n76",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_nade_n77",			"CW_KillIcons", "e", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_piat",				"HL2MPTypeDeath", "3", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_tankfist",			"HL2MPTypeDeath", "3", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_tankshrek",		"HL2MPTypeDeath", "3", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_zooka",			"HL2MPTypeDeath", "3", killCol)

	-- killicon.AddFont("cw_kk_ins2_doi_bino_de",			"HL2MPTypeDeath", "3", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_bino_gb",			"HL2MPTypeDeath", "3", killCol)
	-- killicon.AddFont("cw_kk_ins2_doi_bino_us",			"HL2MPTypeDeath", "3", killCol)

	// doi got nice new ki.. ehm inventory icons
	// guns and launchers

	killicon.Add("cw_kk_ins2_doi_mel_brass",			"vgui/hud/weapons/weapon_brassknuckles", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_enfield",			"vgui/hud/weapons/weapon_enfield_bayonet", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_enfield2",			"vgui/hud/weapons/weapon_enfield_bayonet", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_garand",			"vgui/hud/weapons/weapon_garand_bayonet", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_k98k",				"vgui/hud/weapons/weapon_k98bayonet", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_kabar",			"vgui/hud/weapons/weapon_kabar", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_kabar2",			"vgui/hud/weapons/weapon_gravityknife", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_kabar3",			"vgui/hud/weapons/weapon_stiletto", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_kabar4",			"vgui/hud/weapons/weapon_fairbairn", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_kabar5",			"vgui/hud/weapons/weapon_hatchet", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_shovel_de",		"vgui/hud/weapons/weapon_etool", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_shovel_gb",		"vgui/hud/weapons/weapon_etool_brit", killCol)
	killicon.Add("cw_kk_ins2_doi_mel_shovel_us",		"vgui/hud/weapons/weapon_etool_us", killCol)

	killicon.Add("cw_kk_ins2_doi_browninghp",			"vgui/hud/weapons/weapon_browninghp", killCol)
	killicon.Add("cw_kk_ins2_doi_c96",					"vgui/hud/weapons/weapon_c96", killCol)
	killicon.Add("cw_kk_ins2_doi_luger",				"vgui/hud/weapons/weapon_luger", killCol)
	killicon.Add("cw_kk_ins2_doi_m1911",				"vgui/hud/weapons/weapon_m1911", killCol)
	killicon.Add("cw_kk_ins2_doi_m1917",				"vgui/hud/weapons/weapon_sw1917", killCol)
	killicon.Add("cw_kk_ins2_doi_p38",					"vgui/hud/weapons/weapon_p38", killCol)
	killicon.Add("cw_kk_ins2_doi_ppk",					"vgui/hud/weapons/weapon_ppk", killCol)
	killicon.Add("cw_kk_ins2_doi_webley",				"vgui/hud/weapons/weapon_webley", killCol)
	killicon.Add("cw_kk_ins2_doi_welrod",				"vgui/hud/weapons/weapon_welrod", killCol)

	killicon.Add("cw_kk_ins2_doi_c96_c",				"vgui/hud/weapons/weapon_c96carbine", killCol)
	killicon.Add("cw_kk_ins2_doi_m3",					"vgui/hud/weapons/weapon_m3greasegun", killCol)
	killicon.Add("cw_kk_ins2_doi_m3a1",					"vgui/hud/weapons/weapon_m3greasegun", killCol)
	killicon.Add("cw_kk_ins2_doi_mp40",					"vgui/hud/weapons/weapon_mp40", killCol)
	killicon.Add("cw_kk_ins2_doi_mp40_mx",				"vgui/hud/weapons/weapon_mp40", killCol)
	killicon.Add("cw_kk_ins2_doi_owen_mk1",				"vgui/hud/weapons/weapon_owen", killCol)
	killicon.Add("cw_kk_ins2_doi_owen_mk2",				"vgui/hud/weapons/weapon_owen", killCol)
	killicon.Add("cw_kk_ins2_doi_sten_mk2",				"vgui/hud/weapons/weapon_sten_mk2", killCol)
	killicon.Add("cw_kk_ins2_doi_sten_mk5",				"vgui/hud/weapons/weapon_sten_mk5", killCol)
	killicon.Add("cw_kk_ins2_doi_thom_1928",			"vgui/hud/weapons/weapon_thompson_m1928a1", killCol)
	killicon.Add("cw_kk_ins2_doi_thom_m1a1",			"vgui/hud/weapons/weapon_thompson_m1a1", killCol)

	killicon.Add("cw_kk_ins2_doi_bar",					"vgui/hud/weapons/weapon_bar", killCol)
	killicon.Add("cw_kk_ins2_doi_bren",					"vgui/hud/weapons/weapon_bren_mk2", killCol)
	killicon.Add("cw_kk_ins2_doi_browning",				"vgui/hud/weapons/weapon_m1919", killCol)
	killicon.Add("cw_kk_ins2_doi_enfield",				"vgui/hud/weapons/weapon_enfield", killCol)
	killicon.Add("cw_kk_ins2_doi_fg42",					"vgui/hud/weapons/weapon_fg42", killCol)
	killicon.Add("cw_kk_ins2_doi_g43",					"vgui/hud/weapons/weapon_g43", killCol)
	killicon.Add("cw_kk_ins2_doi_garand",				"vgui/hud/weapons/weapon_garand", killCol)
	killicon.Add("cw_kk_ins2_doi_ithaca",				"vgui/hud/weapons/weapon_ithaca", killCol)
	killicon.Add("cw_kk_ins2_doi_k98k",					"vgui/hud/weapons/weapon_k98", killCol)
	killicon.Add("cw_kk_ins2_doi_lewis",				"vgui/hud/weapons/weapon_lewis", killCol)
	killicon.Add("cw_kk_ins2_doi_m1",					"vgui/hud/weapons/weapon_m1carbine", killCol)
	killicon.Add("cw_kk_ins2_doi_m1a1",					"vgui/hud/weapons/weapon_m1paratrooper", killCol)
	killicon.Add("cw_kk_ins2_doi_m1912",				"vgui/hud/weapons/weapon_ithaca", killCol)
	killicon.Add("cw_kk_ins2_doi_mg34",					"vgui/hud/weapons/weapon_mg34", killCol)
	killicon.Add("cw_kk_ins2_doi_mg42",					"vgui/hud/weapons/weapon_mg42", killCol)
	killicon.Add("cw_kk_ins2_doi_spring",				"vgui/hud/weapons/weapon_springfield", killCol)
	killicon.Add("cw_kk_ins2_doi_stg44",				"vgui/hud/weapons/weapon_stg44", killCol)
	killicon.Add("cw_kk_ins2_doi_wicked",				"vgui/hud/weapons/weapon_vickers", killCol)

	killicon.Add("cw_kk_ins2_doi_flame_de",				"vgui/hud/weapons/weapon_flamethrower_german", killCol)
	killicon.Add("cw_kk_ins2_doi_flame_gb",				"vgui/hud/weapons/weapon_flamethrower_british", killCol)
	killicon.Add("cw_kk_ins2_doi_flame_us",				"vgui/hud/weapons/weapon_flamethrower_american", killCol)
	killicon.Add("cw_kk_ins2_doi_molotov",				"vgui/hud/weapons/weapon_flamethrower_eintoss46_german", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_c4_de",			"vgui/hud/weapons/weapon_sprengbuchse", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_c4_us",			"vgui/hud/weapons/weapon_tnt", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_m24",				"vgui/hud/weapons/weapon_stielhandgranate", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_mk2",				"vgui/hud/weapons/weapon_mk2", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_n36",				"vgui/hud/weapons/weapon_no36", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_n39",				"vgui/hud/weapons/weapon_nebelhandgranate", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_n69",				"vgui/hud/weapons/weapon_no69", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_n76",				"vgui/hud/weapons/weapon_no79", killCol)
	killicon.Add("cw_kk_ins2_doi_nade_n77",				"vgui/hud/weapons/weapon_no77", killCol)
	killicon.Add("cw_kk_ins2_doi_piat",					"vgui/hud/weapons/weapon_piat", killCol)
	killicon.Add("cw_kk_ins2_doi_tankfist",				"vgui/hud/weapons/weapon_panzerfaust", killCol)
	killicon.Add("cw_kk_ins2_doi_tankshrek",			"vgui/hud/weapons/weapon_panzerschreck", killCol)
	killicon.Add("cw_kk_ins2_doi_zooka",				"vgui/hud/weapons/weapon_bazooka", killCol)

	killicon.Add("cw_kk_ins2_doi_bino_de",				"vgui/hud/weapons/weapon_binoculars_german", killCol)
	killicon.Add("cw_kk_ins2_doi_bino_gb",				"vgui/hud/weapons/weapon_binoculars_british", killCol)
	killicon.Add("cw_kk_ins2_doi_bino_us",				"vgui/hud/weapons/weapon_binoculars_american", killCol)

	// projectiles

	killicon.Add("cw_kk_ins2_projectile_m6a1",			"vgui/hud/weapons/weapon_bazooka", killCol)
	killicon.Add("cw_kk_ins2_projectile_m10",			"vgui/hud/weapons/weapon_bazooka", killCol)
	killicon.Add("cw_kk_ins2_projectile_molotov_doi",	"vgui/hud/weapons/weapon_flamethrower_eintoss46_german", killCol)
	killicon.Add("cw_kk_ins2_projectile_n69",			"vgui/hud/weapons/weapon_no69", killCol)
	killicon.Add("cw_kk_ins2_projectile_n76",			"vgui/hud/weapons/weapon_no76", killCol)
	killicon.Add("cw_kk_ins2_projectile_n77",			"vgui/hud/weapons/weapon_no77", killCol)
	killicon.Add("cw_kk_ins2_projectile_pf60",			"vgui/hud/weapons/weapon_panzerfaust", killCol)
	killicon.Add("cw_kk_ins2_projectile_piat",			"vgui/hud/weapons/weapon_piat", killCol)
	killicon.Add("cw_kk_ins2_projectile_shrek",			"vgui/hud/weapons/weapon_panzerschreck", killCol)
	killicon.Add("cw_kk_ins2_projectile_ww2_c4_de",		"vgui/hud/weapons/weapon_sprengbuchse", killCol)
	killicon.Add("cw_kk_ins2_projectile_ww2_c4_us",		"vgui/hud/weapons/weapon_tnt", killCol)

	// nice class names

	language.Add("cw_kk_ins2_projectile_m10", "M10A1 WP rocket")
	language.Add("cw_kk_ins2_projectile_m6a1", "M6A1 HEAT rocket")
	language.Add("cw_kk_ins2_projectile_pf60", "Panzerfaust projectile")
	language.Add("cw_kk_ins2_projectile_shrek", "Panzerschreck projectile")
	language.Add("cw_kk_ins2_projectile_piat", "PIAT projectile")

	language.Add("cw_kk_ins2_projectile_n69", "No. 69 Frag. Grenade")
	language.Add("cw_kk_ins2_projectile_n76", "No. 76 WP Grenade")
	language.Add("cw_kk_ins2_projectile_n77", "No. 77 Smoke Grenade")

	language.Add("cw_kk_ins2_projectile_ww2_c4_de", "Thrown Satchel Charge")
	language.Add("cw_kk_ins2_projectile_ww2_c4_us", "Thrown Satchel Charge")

end
