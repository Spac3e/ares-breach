AddCSLuaFile()

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

SWEP.WeaponName = "v92_eq_unarmed" -- (String) Name of the weapon script
SWEP.PrintName = "Руки Вортигонта" -- (String) Printed name on menu

SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

SWEP.droppable				= false

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/hand.png" )

end

SWEP.UnDroppable = true
SWEP.UseHands = true
SWEP.WorldModel = ""
SWEP.CustomHoldtype = "vort"

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack( )

	return false

end

function SWEP:Reload() end
