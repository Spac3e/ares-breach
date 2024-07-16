--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_rpg_m72/shared.lua

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

	SWEP.InvIcon = Material( "nextoren/gui/icons/weapons/m72.png" )

	SWEP.RearEffectw = true
	SWEP.NoShells = true

	SWEP.AttachmentModelsVM = {
		["kk_counter_front"] = {model = "models/weapons/stattrack.mdl", bone = "AT4", rel = "", pos = Vector(-0.029, 3.767, 2.51), angle = Angle(), size = Vector(1, 1, 1), ignoreKKBGO = true},
		["kk_counter_mid"] = {model = "models/weapons/stattrack.mdl", bone = "AT4", rel = "", pos = Vector(1.218, -8.176, 1.179), angle = Angle(-47.401, 0, 0), size = Vector(0.699, 0.699, 0.699), ignoreKKBGO = true},
		["kk_counter_back"] = {model = "models/weapons/stattrack.mdl", bone = "AT4", rel = "", pos = Vector(-0.788, -10.893, 2.131), angle = Angle(0, -90, 15), size = Vector(1, 1, 1), ignoreKKBGO = true},
	}

	SWEP.IronsightPos = Vector(-1.2966, -2, 0.5867)
	SWEP.IronsightAng = Vector(1.6276, -2.1752, 7)

	SWEP.ViewModelMovementScale_sprint = 0.5
	SWEP.CustomizationMenuScale = 0.01
	SWEP.HUD_MagText = "TUBE: "
end

SWEP.MuzzleEffect = "ins_weapon_at4_frontblast"

SWEP.Attachments = {
	{header = "Nope, no attachments for this one.", offset = {-250, 0}, atts = {}},
	{header = "Just sit back and enjoy awsum rpg rockets.", offset = {-250, 75}, atts = {}}
}

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
SWEP.Category = "CW BREACH"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_cultist/m72/v_m72.mdl"
SWEP.WorldModel		= "models/weapons/cw_cultist/m72/w_m72.mdl"

SWEP.WMPos = Vector(7, 1, -2)
SWEP.WMAng = Vector(-10, 0, 180)

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip = 0 --	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AT4 Launcher"

SWEP.FireDelay = 0.5
SWEP.FireSound = "CW_KK_INS2_AT4_FIRE"

SWEP.Recoil = 0.5
SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.005
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.8
SWEP.Shots = 1
SWEP.Damage = 100

SWEP.MuzzleVelocity = 285
SWEP.projectileClass = "cw_kk_ins2_projectile_at4"
SWEP.hipBulletDelay = 0.3

SWEP.DeployTime = 1
SWEP.HolsterTime = 1

SWEP.Chamberable = false
SWEP.CanCustomize = false

SWEP.FirstDeployTime = 3.4
SWEP.WeaponLength = 40

// terrible hax FTW

SWEP.ironFireAnimStartCycle = 0.25

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
