AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/shield.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel = "models/weapons/shield/w_shield.mdl"
SWEP.PrintName = "Баллистический щит"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "shield"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Pos = Vector( 0, -2, 4 )
SWEP.Ang = Angle( 60, -180, 240 )

function SWEP:Deploy()

  self.Owner:DrawViewModel( false )

  if SERVER then
	  local shield = ents.Create("entity_item_shield")
	  self.Shield = shield
	  shield:SetOwner(self.Owner)
	  shield.ActiveWeapon = self
	  shield:Spawn()
	end

end

function SWEP:PrimaryAttack()

end

function SWEP:DrawWorldModel()

	if !IsValid(self.Owner) then
		self:DrawModel()
	end

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
