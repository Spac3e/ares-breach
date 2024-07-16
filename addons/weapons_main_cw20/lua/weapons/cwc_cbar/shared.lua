--[[


addons/[weapons]_cw_20/lua/weapons/cwc_cbar/shared.lua

--]]

--[[
lua/weapons/cwc_cbar/shared.lua
--]]
AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

CustomizableWeaponry.firemodes:registerFiremode("melee", " ", true, 0, 0)



if CLIENT then

	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/entities/crow_bar")
	SWEP.BounceWeaponIcon = false


	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Монтировка"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.DisableSprintViewSimulation = false
	SWEP.HolsterUnderwater = false
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/weapons/cwc_crowbar/w_knife_t.mdl"
	SWEP.WMPos = Vector(1.8, 3, 10)
	SWEP.WMAng = Vector(00, -70, 190)
	
	
	--killicon.AddFont("cw_extrema_ratio_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.SprintPos = Vector(-5, -3, -0)
	SWEP.SprintAng = Vector(-30, -10, -20)
	
	SWEP.AlternativePos = Vector(0, 2, -2)
	SWEP.AlternativeAng = Vector(5, 0, 0)
	
	SWEP.MoveType = 1
	SWEP.SpeedDec = 500
	
	SWEP.AttachmentModelsVM = {
	["cwc_charger_ergo"] = {model = "models/cw2/attachments/cturiselection/uarhandle.mdl", bone = "mp7_charger", rel = "", pos = Vector(1.577, 0, 0), angle = Angle(0, 0, -90), size = Vector(0.8, 0.5, 1.299)},
	["md_ber_surefire"] = {model = "models/weapons/upgraded/a_flashlight_rail.mdl", bone = "mp7_main", pos = Vector(5.3, -0.209, 0.561), angle = Angle(0, 0, 180), size = Vector(0.885, 0.885, 0.885)},
}	
	end


SWEP.Animations = {
	slash_primary = {"midslash1", "midslash2"},
	slash_secondary = {"stab"},
	slash_secondary_alternative = {"stab2"},
	draw = {"drawspin", "drawspin"},
	idle = "idle"
}

SWEP.Attachments = {[1] = {header = "Sight", offset = {300, -300},  atts = {"md_microt1", "md_eotech"}},
[2] = {header = "Muzzle", offset = {-300, -200}, atts = {"md_lightsup"}},
[3] = {header = "Rail", offset = {700, 100},  atts = {"md_ber_surefire"}},
[4] = {header = "Stock", offset = {200, 100}, atts = {"bg_cwc_mp7stock"}},
[5] = {header = "Charger", offset = {400, 100}, atts = {"cwc_charger_latch", "cwc_charger_ergo"}},
["+reload"] = {header = "Ammo", offset = {-400, 300}, atts = {"am_magnum", "am_matchgrade", "cwc_att_ammo_blossom", "am_luckylast"}}}


SWEP.Sounds = {	midslash1 = {{time = 0.0, sound = "CWC_FOLEY_TOSS"},
                       	{time = 0.05, sound = "CWC_CBAR_SWING"},
                       	{time = 0.08, sound = "CWC_CBAR_SWISH"},},


	midslash2 = {{time = 0.0, sound = "CWC_FOLEY_TOSS"},
                       	{time = 0.05, sound = "CWC_CBAR_SWING"},
                       	{time = 0.08, sound = "CWC_CBAR_SWISH"},},
						
	stab = {{time = 0.0, sound = "CWC_FOLEY_TOSS"},
                       	{time = 0.02, sound = "CWC_CBAR_CHARGE"},
						{time = 0.1, sound = "CWC_CBAR_SWISH"},
                       	{time = 0.35, sound = "CWC_CBAR_CHARGE"},},
						
	stab2 = {{time = 0.0, sound = "CWC_FOLEY_TOSS"},
                       	{time = 0.02, sound = "CWC_CBAR_CHARGE"},
						{time = 0.14, sound = "CWC_CBAR_CHARGE_SWING"}},
	
	draw = {{time = 0.0, sound = "CWC_CBAR_DRAW"},
	        {time = 0.1, sound = "CWC_CBAR_CHARGE"}},
			
	drawspin = {{time = 0.0, sound = "CWC_CBAR_DRAW"},
            {time = 0.0, sound = "CWC_CBAR_CHARGE"},
            {time = 0.04, sound = "CWC_CBAR_SWING"},
            {time = 0.08, sound = "CWC_CBAR_SWISHDRAW"},
	        {time = 0.2, sound = "CWC_FOLEY_TOSS"}}
}

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.FireModes = {"melee"}
SWEP.Base = "cw_melee_base"
SWEP.NormalHoldType = "melee"
SWEP.RunHoldType = "normal"
--[[SWEP.Category = "CW 2.0 Cturiselection Melee"

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
]]--
SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/cwc_crowbar/v_cwc_cbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SprintingEnabled = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.PrimaryAttackDelay = 0.55
SWEP.SecondaryAttackDelay = 0.8

SWEP.PrimaryAttackDamage = 40
SWEP.SecondaryAttackDamage = 20

SWEP.HolsterTime = 0.2
SWEP.DeployTime = 0.6

SWEP.PrimaryAttackImpactTime = 0.15
SWEP.PrimaryAttackDamageWindow = 0.15

SWEP.SecondaryAttackImpactTime = 0.2
SWEP.SecondaryAttackDamageWindow = 0.25

SWEP.ImpactDecal = "explosivegunshot"
SWEP.CanBackstab = false
SWEP.ShootWhileProne = true
SWEP.PushVelocity = 150

SWEP.BackstabDamageMultiplier = 1

SWEP.PlayerHitSounds = {"CWC_CBAR_HITFLESH"}
SWEP.NPCHitSounds = {"CWC_CBAR_HITFLESH"}
SWEP.MiscHitSounds = {"CWC_CBAR_HITWORLD"}

SWEP.PrimaryHitAABB = {
	Vector(-30, -20, -20),
	Vector(30, 20, 20)
}

function SWEP:drawAnimFunc()
	clip = self:Clip1()
	cycle = 0.0
	rate = 0.7
	anim = "safe"
	prefix = ""
	suffix = ""
	
	self:sendWeaponAnim(prefix .. "draw" .. suffix, rate, cycle)
end //*/
	
function SWEP:PrimaryAttack()
	self.NormalHoldType = "melee"
	self.ImpactDecal = "manhackcut"
	if not self:canAttack() then
		return
	end
	
	if IsFirstTimePredicted() then
		self.PushVelocity = 800
		self:beginAttack(self.PrimaryAttackImpactTime, self.PrimaryAttackDamageWindow, self.PrimaryAttackDamage, 100, self.PrimaryHitAABB)
		self:sendWeaponAnim("slash_primary", 0.85)
		self.PlayerHitSounds = {"CWC_CBAR_HITFLESH"}
		self.NPCHitSounds = {"CWC_CBAR_HITFLESH"}
		self.MiscHitSounds = {"CWC_CBAR_HITWORLD"}
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	local time = CurTime() + self.PrimaryAttackDelay
	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)
	self.ReloadWait = time
end
	
function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) then	
		self.NormalHoldType = "melee2"
		self.ImpactDecal = "explosivegunshot"
		self.SecondaryAttackImpactTime = 0.27
		self.SecondaryAttackDamageWindow = 0.271
		self.CanBackstab = true
		self.PushVelocity = 80
		self.SecondaryAttackDelay = 1.1
		self.SecondaryAttackDamage = 120
	else
		self.NormalHoldType = "knife"
		self.ImpactDecal = "impact.metal"
		self.SecondaryAttackImpactTime = 0.18
		self.SecondaryAttackDamageWindow = 0.2
		self.CanBackstab = false
		self.PushVelocity = 100
		self.SecondaryAttackDelay = 0.4
		self.SecondaryAttackDamage = 30
	end
	
	if not self:canAttack(true) then
		return
	end
	
	if IsFirstTimePredicted() then
		self:beginAttack(self.SecondaryAttackImpactTime, self.SecondaryAttackDamageWindow, self.SecondaryAttackDamage, 40, self.SecondaryHitAABB)
	if self.Owner:KeyDown(IN_USE) then	
		self:sendWeaponAnim("slash_secondary_alternative", 0.8)
		self.PlayerHitSounds = {"CWC_CBAR_HITFLESH_HEAVY"}
		self.NPCHitSounds = {"CWC_CBAR_HITFLESH_HEAVY"}
		self.MiscHitSounds = {"CWC_CBAR_HITWORLD_HEAVY"}
		else
		self:sendWeaponAnim("slash_secondary", 0.7)
		self.PlayerHitSounds = {"CWC_CBAR_HITFLESH_LIGHT"}
		self.NPCHitSounds = {"CWC_CBAR_HITFLESH_LIGHT"}
		self.MiscHitSounds = {"CWC_CBAR_HITWORLD"}
		end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	local time = CurTime() + self.SecondaryAttackDelay
	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)
	self.ReloadWait = time
	

end

function SWEP:getDealtDamage(ent)
	local dmg = type(self.attackDamage) == "table" and math.random(self.attackDamage[1], self.attackDamage[2]) or self.attackDamage
	
	if ent:IsPlayer() and self:isBackstab(ent) then
		dmg = dmg * self.BackstabDamageMultiplier
	end
	
	local velocity = self.Owner:GetVelocity()
	dmg = dmg - velocity:Length() / self.VelocityToDamageDivider * 2
	
	return dmg
end

