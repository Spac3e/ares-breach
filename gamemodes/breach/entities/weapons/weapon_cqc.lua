AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/disarm.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.PrintName		= "Действие: Обезоруживание"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.UnDroppable				= true

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

  if ( SERVER ) then

    self.Owner:DrawWorldModel( false )

  end

  self.Owner:DrawViewModel( false )

end

function SWEP:PrimaryAttack()

  if ( CLIENT ) then return end

  local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

  if ( !ent:IsPlayer() ) then return end

  if !self.Owner:IsSuperAdmin() then
    if ( ent:GTeam() == TEAM_SCP || !( ent:GTeam() == TEAM_CLASSD && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" || ent:GTeam() == TEAM_SCI && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" || ent:GTeam() == TEAM_GOC && ent:GetRoleName() == "ClassD_GOCSpy" && ent:GetModel() != "models/cultist/humans/mog/mog.mdl"
    || ent:GTeam() == TEAM_DZ && ent:GetRoleName() == "SCI_SpyDZ" && ent:GetModel() != "models/cultist/humans/mog/mog.mdl" ) ) then return end
  end

	local wep = ent:GetActiveWeapon()

  if ( wep && wep != NULL && !wep.UnDroppable ) then

    self.Owner:BrProgressBar( "l:disarming", 2, "nextoren/gui/icons/disarm.png", ent, true, function()

      if ( ent && ent:IsValid() ) then

        ent:DropWeapon( wep )

      end

    end )

  end

end

function SWEP:CanPrimaryAttack()

  return true

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
