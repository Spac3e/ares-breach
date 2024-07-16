--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_scp_122/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

SWEP.magType = "arMag"

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SCP-122"
	SWEP.CSMuzzleFlashes = true
	SWEP.InvIcon = Material( "nextoren/gui/icons/scp122.png" )

	SWEP.ViewModelMovementScale = 1.15

	SWEP.Shell = "KK_INS2_545x39"
	SWEP.ShellDelay = 0.05
	SWEP.ShellViewAngleAlign = {Forward = 0, Right = 0, Up = -30}

	SWEP.BackupSights = {
		["kk_ins2_elcan"] = {
			Vector(-2.3004, -3, -1.4735),
			Vector(-0.5597, 0, 0)
		},
	}

	SWEP.AttachmentModelsVM = {}

	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-1.841, -1.407, 0.439)
	SWEP.IronsightAng = Vector(0, 0, 18.291)

	SWEP.M203Pos = Vector( -2.8, -4, 0.6 )
	SWEP.M203Ang = Vector(1.0405, -0.0059, 0)

	SWEP.KKINS2KobraPos = Vector( -2.8, -1.5, -0.45 )
	SWEP.KKINS2KobraAng = Vector()

	SWEP.KKINS2EoTechPos = Vector( -2.8, -1, -0.4 )
	SWEP.KKINS2EoTechAng = Vector()

	SWEP.KKINS2AimpointPos = Vector( -2.8, -1, -0.4 )
	SWEP.KKINS2AimpointAng = Vector()

	SWEP.KKINS2ElcanPos = Vector( -2.8, -2, -0.4 )
	SWEP.KKINS2ElcanAng = Vector()

	SWEP.KKINS2PO4Pos = Vector( -2.8, -3, -0.3 )
	SWEP.KKINS2PO4Ang = Vector()

	SWEP.KKINS2MagnifierPos = Vector( -2.8, -3, -0.4 )
	SWEP.KKINS2MagnifierAng = Vector()

	// for the keks

	SWEP.KKINS2CSTMPGO7Pos = Vector(-0.8964, -3, -0.5)
	SWEP.KKINS2CSTMPGO7Ang = Vector()

	SWEP.KKINS2CSTMACOGPos = Vector( -2.8, -3, -0.4 )
	SWEP.KKINS2CSTMACOGAng = Vector()

	SWEP.CustomizationMenuScale = 0.016
end

SWEP.MuzzleEffect = "muzzleflash_ak74_1p_core"
SWEP.MuzzleEffectWorld = "muzzleflash_ak74_3rd"

SWEP.Attachments = {}

SWEP.Animations = {
	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = {"iron_fire","iron_fire_a","iron_fire_b","iron_fire_c","iron_fire_d","iron_fire_e","iron_fire_f"},
	base_fire_empty = "base_dryfire",
	base_fire_empty_aim = "iron_dryfire",
	base_reload = "base_reload",
	base_reload_empty = "base_reloadempty",
	base_idle = "base_idle",
	base_holster = "base_holster",
	--base_firemode = "base_fireselect",
	base_firemode_aim = "iron_fireselect",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "iron_down",
	base_crawl = "base_crawl",

	foregrip_pickup = "foregrip_ready",
	foregrip_draw = "foregrip_draw",
	foregrip_fire = "foregrip_fire",
	foregrip_fire_aim = "foregrip_iron_fire",
	foregrip_fire_empty = "foregrip_dryfire",
	foregrip_fire_empty_aim = "foergrip_iron_dryfire", // like srsly?
	foregrip_reload = "foregrip_reload",
	foregrip_reload_empty = "foregrip_reloadempty",
	foregrip_idle = "foregrip_holster",
	foregrip_holster = "foregrip_holster",
	foregrip_firemode = "foregrip_fireselect",
	foregrip_firemode_aim = "foregrip_iron_fireselect",
	foregrip_sprint = "foregrip_sprint",
	foregrip_safe = "foregrip_down",
	foregrip_safe_aim = "foregrip_iron_down",
	foregrip_crawl = "foregrip_crawl",

	gl_off_pickup = "gl_ready",
	gl_off_draw = "gl_draw",
	gl_off_fire = "gl_fire",
	gl_off_fire_aim = {"gl_iron_fire","gl_iron_fire_a","gl_iron_fire_b","gl_iron_fire_c","gl_iron_fire_d","gl_iron_fire_e","gl_iron_fire_f"},
	gl_off_fire_empty = "gl_dryfire",
	gl_off_fire_empty_aim = "gl_iron_dryfire",
	gl_off_reload = "gl_reload",
	gl_off_reload_empty = "gl_reloadempty",
	gl_off_idle = "gl_holster",
	gl_off_holster = "gl_holster",
	gl_off_firemode = "gl_fireselect",
	gl_off_firemode_aim = "gl_iron_fireselect",
	gl_off_sprint = "gl_sprint",
	gl_off_safe = "gl_down",
	gl_off_safe_aim = "gl_iron_down",
	gl_off_crawl = "gl_crawl",

	gl_on_draw = "glsetup_draw",
	gl_on_fire = "glsetup_fire",
	gl_on_fire_aim = "glsetup_iron_fire",
	gl_on_fire_empty = "glsetup_dryfire",
	gl_on_fire_empty_aim = "glsetup_iron_dryfire",
	gl_on_reload = "glsetup_reload",
	gl_on_idle = "glsetup",
	gl_on_holster = "glsetup_holster",
	gl_on_sprint = "glsetup_sprint",
	gl_on_safe = "glsetup_down",
	gl_on_safe_aim = "glsetup_iron_down",
	gl_on_crawl = "glsetup_crawl",

	gl_turn_on = "glsetup_in",
	gl_turn_off = "glsetup_out",
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW BREACH"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/scp_items/scp122/v_scp122.mdl"
SWEP.WorldModel		= "models/cultist/scp_items/scp122/w_scp122.mdl"

SWEP.WMPos = Vector(5.666, 0.66, -1.055)
SWEP.WMAng = Angle(10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.f1
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.gurkha
SWEP.CW_KK_40MM_MDL = "models/weapons/upgrades/a_projectile_gp25.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip    = 99999
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 60/650
SWEP.FireSound = "SCP_122_Fire"
SWEP.FireSoundSuppressed = "SCP_122_Fire"
SWEP.Recoil = 1.2

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 50

SWEP.DeployTime = 0.7
SWEP.HolsterTime = 0.5

SWEP.FirstDeployTime = 2.1
SWEP.WeaponLength = 22

SWEP.MuzzleVelocity = 890

SWEP.ReloadTimes = {
	base_reload = {2.2, 3.15},
	base_reloadempty = {2.2, 4.35},

	foregrip_reload = {2.2, 3.15},
	foregrip_reloadempty = {2.2, 4.35},

	gl_reload = {2.2, 3.15},
	gl_reloadempty = {2.2, 4.35},

	glsetup_in = {0.6, 0.6},
	glsetup_out = {0.7, 0.7},

	glsetup_reload = {1.75, 2.67}
}

local function initialize(self)
	if self:GetClass() != "cw_scp_122" then return end
	self.NotWorthy = {}
end

local function preFire(self)
	if self:GetClass() != "cw_scp_122" then return end
	if SERVER then
		if self.NotWorthy[self.Owner:SteamID64()] then
			return true
		end
		if self.NotWorthy[self.Owner:SteamID64()] == nil then
			local rand = math.random(1,2)
			self.NotWorthy[self.Owner:SteamID64()] = rand == 1
			if self.NotWorthy[self.Owner:SteamID64()] and self.Owner:GTeam() != TEAM_DZ then
				self.Owner:setBottomMessage("Looks like you're not worthy.")
				self.Owner:SetNWBool("cw_scp_122", false)
				return true
			else
				self.Owner:setBottomMessage("You're worthy enough to use this weapon.")
				self.Owner:SetNWBool("cw_scp_122", true)
			end
		end
	else
		if !self.Owner:GetNWBool("cw_scp_122", true) then return true end
	end
end

CustomizableWeaponry.callbacks:addNew("initialize", "cw_scp_122_initialize", initialize)
CustomizableWeaponry.callbacks:addNew("preFire", "cw_scp_122_preFire", preFire)