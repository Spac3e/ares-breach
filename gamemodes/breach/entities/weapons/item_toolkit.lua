AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/tool_kit.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/items/toolbox/tool_box.mdl"
SWEP.PrintName		= "Набор инструментов"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
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

SWEP.Pos = Vector( 1, 3, -2 )
SWEP.Ang = Angle( 240, -90, 240 )

function SWEP:Deploy()

  self.Owner:DrawViewModel( false )

end

function SWEP:CanPrimaryAttack()

  return false

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:DrawWorldModel()

	--if ( !( self.Owner && self.Owner:IsValid() ) ) then

		self:DrawModel()

	--end

end
