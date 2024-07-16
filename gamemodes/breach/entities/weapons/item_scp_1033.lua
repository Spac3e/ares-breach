AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/1033.png" )

end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/scp_items/1033/scp_1033_ru.mdl"
SWEP.PrintName		= "SCP-1033-RU"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.UnDroppable = true

SWEP.AttackDelay			= 0.15
SWEP.droppable				= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Percent = 100
SWEP.IsUsing = false
SWEP.Healthd = 1


local NextPercent = 0
local NextRandom = 0

function SWEP:Equip()

  self.Owner:SetArmor( 200 )
  self.Owner:setBottomMessage( "l:scp1033_protect" )

end

function SWEP:PrimaryAttack()

end

function SWEP:Think()

  if ( SERVER && self.Owner && self.Owner:IsValid() && self.Owner:Armor() <= 0 ) then

    self.Owner:setBottomMessage( "l:scp1033_depleted" )
    self:Remove()

  end

end
