--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_nade_c4_de/shared.lua

--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
AddCSLuaFile("sh_soundscript.lua")
include("sh_sounds.lua")
include("sh_soundscript.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "HE Charge DE"
	SWEP.CSMuzzleFlashes = true

	SWEP.SelectIcon = surface.GetTextureID("vgui/inventory/weapon_sprengbuchse")

	SWEP.AttachmentModelsVM = {
		["fx_rag"] = {model = "models/maxofs2d/cube_tool.mdl", pos = Vector(), angle = Angle(0, 90, 0), size = Vector(0.01, 0.01, 0.01), attachment = "tail", bodygroups = {1}, active = true, nodraw = true},
	}

	SWEP.AttachmentModelsWM = {}

	SWEP.MoveType = 2
	SWEP.ViewModelMovementScale = 0.8
	SWEP.DisableSprintViewSimulation = true

	SWEP.HUD_3D2DOffset = Vector(0, 0, 0)
	SWEP.HUD_3D2DOffsetMenu = Vector(2.5, 2.5, 0)
	SWEP.CustomizationMenuScale = 0.0055
end

SWEP.Attachments = CustomizableWeaponry_KK.ins2.slowGrenadeMenu

SWEP.CanRestOnObjects = false
SWEP.projectileClass = "cw_kk_ins2_projectile_ww2_c4_de"

SWEP.Animations = {
	plant = "base_plant",

	pullpin = "base_pullback",
	throw = "base_throw",

	pull_cook = "secondary_pullback",
	throw_cook = "secondary_throw",

	pull_short = "low_pullback",
	throw_short = "low_throw",

	base_pickup = "base_draw",
	base_idle = "base_idle",
	base_draw = "base_draw",
	base_holster = "base_holster",
	base_sprint = "base_sprint",
	base_safe = "base_down",
	base_crawl = "base_crawl",
}

SWEP.SpeedDec = 5

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "grenade"
SWEP.RunHoldType = "slam"
SWEP.FireModes = {"semi"}
SWEP.Base = "cw_kk_ins2_base_nade"
SWEP.Category = "CW 2.0 KK INS2 DOI"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cw_kk_doi/v_compb_axis.mdl"
SWEP.WorldModel		= "models/weapons/w_compb_axis.mdl"

SWEP.WMPos = Vector(5.5, 3.295, -1.765)
SWEP.WMAng = Angle(-28.962, 165.365, 70)

SWEP.CW_KK_KNIFE_TWEAK = CustomizableWeaponry_KK.ins2.quickKnife.models.ww2de

SWEP.Spawnable			= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)
SWEP.AdminSpawnable		= CustomizableWeaponry_KK.ins2.isContentMounted4(SWEP)

SWEP.Primary.Ammo			= "Frag Grenades"

SWEP.fuseTime = 10

SWEP.spoonTime = 29/30
SWEP.timeToThrowCook = 0.8
SWEP.swapTimeCook = 0.9
SWEP.maxVelDelayCook = 1.5

SWEP.spoonTimeShort = 29/30
SWEP.timeToThrowShort = 0.8
SWEP.swapTimeShort = 0.9
SWEP.maxVelDelayShort = 1.5

SWEP.mustCook = true
SWEP.canPlant = true

SWEP.PlantPos = Vector(1.5, 0, 0)
SWEP.PlantAng = Angle()

SWEP.projectileTrailParticles = "weapon_compB_fuse"

if CLIENT then
	function SWEP:updateOtherParts()
		local outtaAmmo = self.Owner:GetAmmoCount(self.Primary.Ammo) < 1
		if (self._pcfStop and self.Sequence != self._pcfStop) or outtaAmmo then
			self.AttachmentModelsVM.fx_rag.ent:StopParticles()
			-- self.AttachmentModelsVM.fx_rag.ent:StopLoopingSound(self._soundStop)
			-- self.CW_VM:StopParticles()

			self._pcfStop = nil

			local sound = self.soundLoop

			if sound then
				timer.Simple(self.spawnTime, function()
					if sound then
						sound:Stop()
					end
				end)
			end
		else
			-- local pos = self.AttachmentModelsVM.fx_rag.ent:GetPos()
			-- local ed = EffectData()
			-- ed:SetOrigin(pos)
			-- ed:SetScale(0.01)
			-- util.Effect("Sparks", ed)
		end
	end

	function SWEP:OnRemove()
		self.AttachmentModelsVM.fx_rag.ent:StopParticles()

		local sound = self.soundLoop

		if sound then
			sound:Stop()
		end
	end
end
