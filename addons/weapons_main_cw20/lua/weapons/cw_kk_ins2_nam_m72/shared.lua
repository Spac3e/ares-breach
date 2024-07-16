--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m72/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M72"

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_law")

	SWEP.RearEffectw = true
	SWEP.NoShells = true

	SWEP.AttachmentModelsVM = {}
	SWEP.AttachmentModelsWM = {}

	SWEP.IronsightPos = Vector(-3.7099, -2, -2.0889)
	SWEP.IronsightAng = Vector(0.8465, -1.9697, 0)

	SWEP.ForegripOverridePos = {
		none = {
			["sight_rear_u"] = {pos = Vector(), angle = Angle()},
			["sight_rear_r"] = {pos = Vector(), angle = Angle()},
			["sight_rear_l"] = {pos = Vector(), angle = Angle()},
			["sight_rear_d"] = {pos = Vector(), angle = Angle()}
		},

		iron = {
			["sight_rear_u"] = {pos = Vector(0, 0.3, 0), angle = Angle()},
			["sight_rear_r"] = {pos = Vector(-0.3, 0, 0), angle = Angle()},
			["sight_rear_l"] = {pos = Vector(0.3, 0, 0), angle = Angle()},
			["sight_rear_d"] = {pos = Vector(0, -0.3, 0), angle = Angle()}
		}
	}

	SWEP.ForegripParent = "none"
	SWEP.ForegripOverride = true

	SWEP.ViewModelMovementScale_sprint = 0.5
	SWEP.CustomizationMenuScale = 0.01
	SWEP.HUD_MagText = "TUBE: "
end

SWEP.MuzzleEffect = "ins_weapon_at4_frontblast"

SWEP.Attachments = {}

SWEP.Animations = {
	at4_reload_start = "base_toss",
	at4_reload_end = "base_ready",

	base_pickup = "base_ready",
	base_draw = "base_draw",
	base_fire = "base_fire",
	base_fire_aim = "base_iron_fire",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_safe_aim = "base_iron_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 15

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "rpg"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"single"}
SWEP.Base = "cw_kk_ins2_base"
SWEP.Category = "CW 2.0 KK INS2 B2K"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_nam_law.mdl"
SWEP.WorldModel		= "models/weapons/w_nam_law.mdl"

SWEP.WMPos = Vector(7, 1, -2)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.CW_GREN_TWEAK = CustomizableWeaponry_KK.ins2.quickGrenade.models.m26
SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.b2kus
SWEP.CW_KK_40MM_MDL = "models/weapons/w_grenade_kar98k.mdl"

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AT4 Launcher"

SWEP.FireDelay = 0.5
SWEP.FireSound = "CW_KK_INS2_NAM_M72_FIRE"

SWEP.Recoil = 0.5
SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 100

SWEP.MuzzleVelocity = 145
SWEP.projectileClass = "cw_kk_ins2_projectile_at4"
SWEP.hipBulletDelay = 0.3

SWEP.DeployTime = 1
SWEP.HolsterTime = 1

SWEP.Chamberable = false
SWEP.CanCustomize = false

SWEP.FirstDeployTime = 3.4
SWEP.WeaponLength = 40

// terrible hax FTW

SWEP.ironFireAnimStartCycle = 0.35

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 3.5
SWEP.ReloadHalt = 5.1

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "State")
	self:NetworkVar("Int", 1, "Shots")
	self:NetworkVar("Float", 0, "HolsterDelay")
	self:NetworkVar("Float", 1, "AT4ReloadEnd")
	self:NetworkVar("Bool", 0, "Suppressed")
	self:NetworkVar("Bool", 1, "Safe")
	self:NetworkVar("Bool", 2, "BipodDeployed")
	self:NetworkVar("Angle", 0, "ViewOffset")
end

function SWEP:getAnimTimes()
	return self.ReloadTime, self.ReloadHalt
end

function SWEP:reloadAnimFunc(lm)
	self.dt.AT4ReloadEnd = CurTime() + self.ReloadHalt / self.ReloadSpeed

	self:sendWeaponAnim("at4_reload_start", self.ReloadSpeed, 0)

	CustomizableWeaponry.actionSequence.new(self, 1.8 / self.ReloadSpeed, nil, function()
		if not self.ReloadDelay then return end

		self:sendWeaponAnim("at4_reload_end", self.ReloadSpeed, 0)
	end)

	return self:getAnimTimes()
end //*/

function SWEP:getReloadProgress()
	local CT = CurTime()

	if self.dt.AT4ReloadEnd < CT then return end

	if CLIENT then
		self.reticleInactivity = self.dt.AT4ReloadEnd
	end

	return math.Round((CT - self.dt.AT4ReloadEnd + self.ReloadHalt / self.ReloadSpeed) * 100 / self.ReloadHalt)
end

SWEP.reticleInactivityCallbacksRaw = {
	at4_reload_start = 0.1
}

if CLIENT then
	function SWEP:updateOtherParts()
		self.ForegripParent = self:isAiming() and "iron" or "none"
	end
end
