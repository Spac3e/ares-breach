AddCSLuaFile()

SWEP.HoldType = "crowbar"

if ( CLIENT ) then

  SWEP.Category = "[NextOren] Melee"
  SWEP.PrintName = "Монтировка"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 50
  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo = false

  SWEP.InvIcon = Material( "nextoren/gui/icons/crowbar.png", "noclamp smooth" )

end

SWEP.Base = "breach_melee_base"


SWEP.ViewModel = "models/weapons/breach_melee/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/breach_melee/w_crowbar.mdl"

SWEP.PrimaryDamage = 60

SWEP.Offset = {

  Pos = {

    Up = -.5,
    Right = 2,
    Forward = 5.5

  },

  Ang = {

    Up = -1,
    Right = 5,
    Forward = 178

  },


  Scale = 1.2

}

SWEP.Pos = Vector( -1, 3, -6 )
SWEP.Ang = Angle( 0, 165, 0 )
SWEP.attackRange = 4

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

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
