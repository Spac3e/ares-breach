AddCSLuaFile()

if ( CLIENT ) then

  SWEP.Category = "[NextOren] Melee"
  SWEP.PrintName = "Молоток"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 70
  SWEP.DrawSecondaryAmmo = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/hammer.png" )
  SWEP.DrawAmmo = false

end

SWEP.Base = "breach_melee_base"
SWEP.HoldType = "crowbar"

SWEP.ViewModel = "models/weapons/breach_melee/v_hammer.mdl"
SWEP.WorldModel = "models/weapons/breach_melee/w_hammer.mdl"

SWEP.Pos = Vector( -1, 4, -12 )
SWEP.Ang = Angle( 185, -28, 200 )

SWEP.PrimaryDamage = 20
SWEP.PrimaryStamina = 10
SWEP.DamageForce = 8

function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
    self.WModel:SetNoDraw( true )

  end

  return self.WModel

end

function SWEP:DrawWorldModel()

  local wm = self:CreateWorldModel()

  local pl = self:GetOwner()

  if ( IsValid( pl ) ) then

    local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
    if ( !bone ) then return end
    local pos, ang = self.Owner:GetBonePosition( bone )

    if ( bone ) then

      ang:RotateAroundAxis( ang:Right(), self.Ang.p )
      ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
      ang:RotateAroundAxis( ang:Up(), self.Ang.r )
      wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
      wm:SetRenderAngles( ang )
      wm:DrawModel()

    end

  else

    self:SetRenderOrigin( nil )
    self:SetRenderAngles( nil )
    self:DrawModel()

  end

end
