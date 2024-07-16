if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/booster.png" )

end

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.PrintName = "Усилитель"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/cultist/items/booster/w_syringe.mdl"
SWEP.ViewModel = "models/cultist/items/booster/v_syringe.mdl"
SWEP.HoldType = "slam"
SWEP.UseHands = true
SWEP.IsDrinking = nil

SWEP.Pos = Vector( 4, -1, -1 )
SWEP.Ang = Angle( 90, 60, 0 )

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
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

SWEP.Deployed = false

function SWEP:Deploy()

  if ( !IsFirstTimePredicted() ) then return end

  self.OldWeapon = self.Owner.Old_Weapon

  self.IdleDelay = CurTime() + 1.75
  self.HolsterDelay = nil
  self:PlaySequence( "deploy" )

  timer.Simple( .05, function()

    if ( self && self:IsValid() ) then

      self.Deployed = true
      self:EmitSound( "nextoren/weapons/items/adrenaline/adrenaline_deploy_1.wav" )

    end

  end )

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle_raw", true )

	end

end

function SWEP:ShouldDrawViewModel()

  return self.Deployed

end

local view_punch_angle = Angle( -15, 0, 0 )
local effect_clr = Color( 0, 0, 255 )

function SWEP:PrimaryAttack()

  if ( self.IsDrinking ) then return end
  self.IsDrinking = true

  self.IdleDelay = CurTime() + 4

  self:PlaySequence( "use" )

  self:EmitSound( "nextoren/weapons/items/syringe/adrenaline_needle_open.wav" )
	timer.Simple( .3, function()

		if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end
    self:EmitSound( "nextoren/weapons/items/syringe/adrenaline_needle_in.wav" )
    if ( CLIENT ) then

      surface.PlaySound( "nextoren/weapons/items/syringe/adrenaline_heartbeat.wav" )

    end

		self.Owner:ViewPunch( view_punch_angle )
    self.Owner:ScreenFade( SCREENFADE.IN, ColorAlpha( effect_clr, 60 ), 0.2, 1 )

  end)

	timer.Simple( 1.3, function()

    if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

    	if ( CLIENT ) then

	      self.Owner.Stamina = self.Owner.Stamina + 30

	    end

      self.Owner:Boosted( 2, math.random( 17, 20 ) )
      self.Owner:ScreenFade( SCREENFADE.IN, ColorAlpha( effect_clr, 10 ), 0.2, 20 )

    end

	end)

  timer.Simple( 2, function()

    if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

      if ( self.OldWeapon && self.OldWeapon:IsValid() ) then

        self.Owner:SelectWeapon( self.OldWeapon:GetClass() )

      end

      if ( SERVER ) then

        self:Remove()

      end

    end

  end )

end

function SWEP:Holster()

  if ( self.IsDrinking ) then return false end

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1.8
    self.IdleDelay = CurTime() + 4

    timer.Simple( .75, function()

      if ( self && self:IsValid() ) then

        self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

      end

    end )

    self:PlaySequence( "holster" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

    self.Deployed = nil
		return true

	end

end

function SWEP:CanSecondaryAttack()

  return false

end
