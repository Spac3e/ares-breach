--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_rpg_pro/shared.lua

--]]

--[[
lua/weapons/cw_kk_ins2_rpg_pro/shared.lua
--]]
if not CustomizableWeaponry then return end

if CustomizableWeaponry_KK.HOME then
	AddCSLuaFile("weapons/cw_kk_ins2_nade_m67/_gitign_go.lua")
	include("weapons/cw_kk_ins2_nade_m67/_gitign_go.lua")
end

AddCSLuaFile()
AddCSLuaFile("sh_soundscript.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Professional Russian"

	-- SWEP.IconLetter = "C"

	SWEP.SelectIcon = surface.GetTextureID("vgui/entities/rpg")

	SWEP.SelectFont = "CW_SelectIcons2"
	SWEP.IconLetter = "x"

	SWEP.AttachmentModelsVM = {
		["nade"] = {model = "models/weapons/w_at4_projectile.mdl", bone = "Weapon", pos = Vector(0.028, 0.087, 18.68), angle = Angle(-90, 90, 0), size = Vector(0.75, 0.75, 0.75), active = true},
		["fx_light"] = {model = "models/maxofs2d/cube_tool.mdl", pos = Vector(), angle = Angle(), size = Vector(0.01, 0.01, 0.01), attachment = "lighter", active = true, nodraw = true},
		["fx_rag"] = {model = "models/maxofs2d/cube_tool.mdl", pos = Vector(-0.6761, 0.0552, -0.6343), angle = Angle(0, 180, 0), size = Vector(0.01, 0.01, 0.01), attachment = "rag", nodraw = true, active = true},
		["kk_counter"] = {model = "models/weapons/stattrack_cut.mdl", pos = Vector(0.3411, 0.4916, 4.6496), angle = Angle(90, 180, 27.2942), size = Vector(1, 1, 1), bone = "Weapon"},
	}

	SWEP.AttachmentModelsWM = {
		["kk_ins2_rpg_pro_trail"] = {model = "models/maxofs2d/cube_tool.mdl", pos = Vector(-1, 0, 0), angle = Angle(180, 0, 0), size = Vector(0.075, 0.075, 0.075), attachment = "rear", nodraw = true, active = true},
	}

	SWEP.HUD_MagText = "0 > "
end

SWEP.Attachments = CustomizableWeaponry_KK.ins2.slowGrenadeMenu

SWEP.CanRestOnObjects = false

SWEP.Animations = {
	pullpin = "pullback_high",
	throw = "throw",

	pull_cook = "pullback_highbake",
	throw_cook = "throw_bake",

	pull_short = "pullback_low",
	throw_short = "throw_low",

	base_pickup = "base_draw",
	base_draw = "base_draw",
	base_idle = "base_idle",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 5

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.NormalHoldType = "grenade"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base_nade"
SWEP.Category = "CW 2.0 KK INS2"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_cw_kk_ins2_rpg_pro.mdl"
-- SWEP.WorldModel		= "models/weapons/w_at4_projectile.mdl"
SWEP.WorldModel		= "models/weapons/w_cw_kk_ins2_rpg7_projectile_pd2.mdl"

SWEP.WMPos = Vector(14.17, -0.193, -25.729)
SWEP.WMAng = Angle(113.916, 13.63, 0)

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.AdminOnly			= true

SWEP.Primary.Ammo			= "PG-7VM Grenade"

SWEP.MuzzleVelocity = 25
SWEP.projectileClass = "cw_kk_ins2_projectile_rpg"
SWEP.projectileOffsetPos = Vector()
SWEP.projectileOffsetAng = Angle(5, 0, 0)

SWEP.HolsterTime = 0.6
SWEP.timeToThrow = 1.5
SWEP.swapTime = 0.5

SWEP.timeToThrowShort = 1.5
SWEP.swapTimeShort = 0.5

SWEP.fuseTime = 0
SWEP.canCook = false // this swep should b cook only lol

function SWEP:createProjectile()
	CustomizableWeaponry_KK.ins2.rpgs.fireShared(self, IsFirstTimePredicted())
end

if CLIENT then
	local oldIni = SWEP.IndividualInitialize

	function SWEP:IndividualInitialize()
		if oldIni then
			oldIni(self)
		end

		local boneIds = {}
		local vm = self.CW_VM

		for _,v in pairs({"Rag_God", "Weapon", "Liq_top", "Bone01", "Bone02", "Bone03", "Bone04", "Bone06", "Bone07"}) do
			boneIds[v] = vm:LookupBone(v)
		end

		for _,v in pairs(boneIds) do
			vm:ManipulateBoneScale(v, Vector(0.01,0.01,0.01))
		end
	end

	local m
	local muz = {}

	function SWEP:getMuzzlePosition()
		if self.Owner:ShouldDrawLocalPlayer() then
			m = self.Owner:GetBoneMatrix(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			muz.Pos = m:GetTranslation()
			muz.Ang = m:GetAngles()
			return muz
		end

		m = self.CW_VM:GetAttachment(2)

		if self.CustomizeMenuAlpha > 0 then
			offset = self.HUD_3D2DOffsetMenu
		else
			offset = self.HUD_3D2DOffset
		end

		pos = m.Pos
		ang = EyeAngles()

		pos = pos + ang:Right() * offset.x
		pos = pos + ang:Up() * offset.y
		pos = pos + ang:Forward() * offset.z

		muz.Pos = pos
		muz.Ang = m.Ang
		return muz
	end
end

SWEP.projectileTrailParticles = "weapon_compB_fuse"

if CLIENT then
	CustomizableWeaponry_KK.ins2.welementThink:add("cw_kk_ins2_rpg_pro", function(wep, welement)
		welement:SetBodygroup(0, wep.dt.PinPulled and 1 or 0)
	end)

	CustomizableWeaponry_KK.ins2.welementThink:add("kk_ins2_rpg_pro_trail", "grenadewtrail")
end


