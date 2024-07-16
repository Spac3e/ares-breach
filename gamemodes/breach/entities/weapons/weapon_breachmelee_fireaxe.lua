if ( CLIENT ) then

  SWEP.Category = "[NextOren] Melee"
  SWEP.PrintName = "Топор"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 80
  SWEP.UseHands = false

  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo = false
  SWEP.InvIcon = Material( "nextoren/gui/icons/axe.png" )
  SWEP.BlurAmount = 0

  --[[local blur_mat = Material( "pp/toytown-top" )

  blur_mat:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

  function SWEP:drawBlur()

    local x, y = ScrW(), ScrH()

    cam.Start2D()

      surface.SetMaterial( blur_mat )
      surface.SetDrawColor( 255, 255, 255, 255 )
      for i = 1, self.BlurAmount do

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( 0, 0, x, y * 2 )

      end

    cam.End2D()

  end]]




  --[[function SWEP:HitBlur()

    local FT = FrameTime()
    print( FT )
    local can = true]]

    --[[if ( !self.Idle ) then

      can = true

    end]]

  --  print( can )
  --[[  if ( can ) then

      self.BlurAmount = math.Approach( self.BlurAmount, 10, FT * 15 )
      print( self.BlurAmount )

    end



    if ( self.BlurAmount > 0 ) then

      self:drawBlur()

    end




  end

  function SWEP:PostDrawViewModel()

    render.SetBlend( 1 )

  end]]


end

SWEP.HoldType = "axe"
SWEP.ViewModelFlip = false
SWEP.ImpactDecal = "ManhackCut"
SWEP.Spawnable = true
SWEP.Base = "breach_melee_base"
SWEP.PrimaryAttackDelay = 1.8
SWEP.PrimaryAttackRange = 90
SWEP.PrimaryAttackImpactTime = 0.05
SWEP.PrimaryAttackDamageWindow = 0.06

SWEP.PrimaryDamage = 60
SWEP.PrimaryStamina = 20
SWEP.DamageForce = 4

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

--SWEP.Pos = Vector( -3, -3, -20 )
--SWEP.Ang = Angle( 180, -5, 100 )

SWEP.AttackPos = Vector( -2, 2, -12 )
SWEP.AttackAng = Angle( 8, -195, 0 )

SWEP.Pos = Vector( -1, 3, 1 )
SWEP.Ang = Angle( 5, -182.5, 3 )

SWEP.WalkAngle = Angle( 8, -165, 0 )

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

  if ( pl && pl:IsValid() ) then

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
