--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_bino_gb/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Binoculars GB"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_binoculars_british")

	SWEP.AttachmentModelsVM = {
		-- ["ani_body"] = {model = "models/weapons/v_binoculars_british.mdl", pos = Vector(), angle = Angle(), size = Vector(1, 1, 1), merge = true, hideVM = true, active = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector()
	SWEP.IronsightAng = Vector()

	SWEP.CustomizationMenuScale = 0.01
	SWEP.ReloadViewBobEnabled = false
	SWEP.DisableSprintViewSimulation = true

	SWEP.AimOverlay = surface.GetTextureID("models/weapons/optics/binocs_overlay_british")
end

SWEP.CanRestOnObjects = false
SWEP.WeaponLength = 16

SWEP.Attachments = {
	-- {header = "Stock", offset = {1000, 0}, atts = {"kk_ins2_ww2_sling"}},
}

SWEP.Animations = {
	base_pickup = "base_draw",
	base_draw = "base_draw",
	base_idle = "base_idle",
	base_idle_aim = "iron_idle_preblend",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "base_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 10

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.NormalHoldType = "slam"
SWEP.RunHoldType = "slam"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base_bino"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_binoculars_british.mdl"
SWEP.WorldModel		= "models/weapons/w_binoculars_british.mdl"

SWEP.WMPos = Vector(3.48, 5.131, -0.802)
SWEP.WMAng = Vector(57.638, 177.912, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.ww2gb
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2gb

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.FireSound = "CW_KK_INS2_DOI_BINO_GB_ATTACK"
SWEP.ResponseSound = "CW_KK_INS2_DOI_BINO_GB_SPAWN"
