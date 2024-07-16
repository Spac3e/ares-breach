if ( CLIENT ) then

  SWEP.InvIcon = Material( "chemer_icon/chemer.png" )

end

SWEP.ViewModelFOV = 72
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.PrintName = "Cheemer"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/chemers/cheemer.mdl"
SWEP.ViewModel = "models/chemers/v_cheemer.mdl"
SWEP.HoldType = "items"

SWEP.Pos = Vector( -3,5,0)
SWEP.Ang = Angle( -90, 0,-45 )

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )
    self.WModel:SetModelScale(0.8)

	end

	return self.WModel

end

function SWEP:Initialize()
  self:SetModelScale(0.8)
end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_Spine2" )
		if ( !bone ) then return end

		local wm = self:CreateWorldModel()
		local pos, ang = self.Owner:GetBonePosition( bone )

		if ( wm && wm:IsValid() ) then

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

function SWEP:Deploy()

  if ( !IsFirstTimePredicted() ) then

    return

  else

    self.ShouldDraw = nil
    self.HolsterDelay = nil

  end

  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "deploy" )

end

function SWEP:Think()

end

function SWEP:CanPrimaryAttack()

  return false

end

function SWEP:Holster()

  return true

end

function SWEP:CanSecondaryAttack()

  return false

end
