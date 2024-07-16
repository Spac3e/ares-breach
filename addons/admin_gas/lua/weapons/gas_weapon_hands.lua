--[[


addons/[admin]_gmodadminsuite/lua/weapons/gas_weapon_hands.lua

--]]

AddCSLuaFile()

SWEP.PrintName = "Hands"
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.DrawAmmo = false

SWEP.Spawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false

SWEP.WorldModel = ""

SWEP.Instructions = "You are temporarily restricted to this weapon only."

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	if (CLIENT or not IsValid(self:GetOwner())) then return true end
	self:GetOwner():DrawWorldModel(false)
	return true
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end