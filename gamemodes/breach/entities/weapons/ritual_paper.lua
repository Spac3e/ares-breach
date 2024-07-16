AddCSLuaFile()

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

SWEP.PrintName = "Ритуал" -- (String) Printed name on menu

SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/cult_paper.png" )

end

SWEP.UnDroppable = true
SWEP.UseHands = false

SWEP.ViewModel = Model( "models/jessev92/weapons/unarmed_c.mdl" )
SWEP.WorldModel = ""
SWEP.HoldType = "normal"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:CanPrimaryAttack()

	return true

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack( )

	return false

end

function SWEP:Reload() end

function SWEP:Deploy( )

end

function SWEP:OnDrop( )

end
