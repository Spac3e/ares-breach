if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/adrenalin.png" )

end

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.PrintName = "Адреналин"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/cultist/items/adrenalin/w_adrenaline.mdl"
SWEP.ViewModel = "models/cultist/items/adrenalin/v_adrenaline.mdl"
SWEP.HoldType = "slam"
SWEP.UseHands = true
SWEP.IsDrinking = nil

SWEP.Pos = Vector( 1, -1, -4 )
SWEP.Ang = Angle( 80, 0, 0 )

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

function SWEP:Deploy()

  if ( !IsFirstTimePredicted() ) then

    return

  else

    self.ShouldDraw = nil
    self.HolsterDelay = nil

  end

  if ( !self.OldWeapon || self.Old_Weapon && self.OldWeapon != self.Owner.Old_Weapon:GetClass() ) then

    if ( self.Owner.Old_Weapon && self.Owner.Old_Weapon:IsValid() && self.Owner:HasWeapon( self.Owner.Old_Weapon:GetClass() ) ) then

      self.OldWeapon = self.Owner.Old_Weapon:GetClass()

    end

  end

  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "deploy" )

  self:EmitSound( "weapons/universal/uni_weapon_draw_02.wav", 75, 80, 1, CHAN_WEAPON )

  timer.Simple( 0, function()

    if ( self && self:IsValid() ) then

      self.ShouldDraw = true

    end

  end )

end

function SWEP:ShouldDrawViewModel()

  return self.ShouldDraw

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle_raw", true )

	end

end

local viewpunch_angle = Angle( -15, 0, 0 )
local adrenaline_clr = Color( 0, 255, 198 )

local team_flash = {

  [ TEAM_CLASSD ] = true,
  [ TEAM_SCI ] = true

}

function SWEP:PrimaryAttack()

  if ( self.IsDrinking ) then return end
  self.IsDrinking = true

  self.IdleDelay = CurTime() + 4

  self:PlaySequence( "use" )
  self:EmitSound( "nextoren/weapons/items/adrenaline/adrenaline_cap_off.wav" )

  if ( SERVER ) then

    net.Start( "GestureClientNetworking" )

      net.WriteEntity( self.Owner )
      net.WriteString("l4d_coach_adrenaline_use")
      net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
      net.WriteBool( true )

    net.Broadcast()

  end

	timer.Simple( self.Owner:SequenceDuration( 5201 ) - .1, function()

		if ( self && self:IsValid() ) then

			self.NoDrawModel = true

      if ( ( self.Owner && self.Owner:IsValid() ) ) then

        self.Owner:SelectWeapon( "v92_eq_unarmed" )

      end

		end

	end )

  timer.Simple( .3, function()

    if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

    if ( !team_flash[ self.Owner:GTeam() ] ) then

      self:EmitSound( "nextoren/weapons/items/adrenaline/adrenaline_needle_in.wav" )

    else

      self:EmitSound( "nextoren/weapons/items/adrenaline/adrenaline_needle_in_orig.wav" )

    end

    if ( CLIENT ) then

      surface.PlaySound( "nextoren/weapons/items/syringe/adrenaline_heartbeat.wav" )

	  end

    if ( CLIENT ) then

      self.Owner.Stamina = self.Owner.Stamina + 30

    end

		self.Owner:Boosted( 4, math.random( 10, 13 ) )
    self.Owner:ViewPunch( viewpunch_angle )
    self.Owner:ScreenFade( SCREENFADE.IN, ColorAlpha( adrenaline_clr, 60 ), 0.2, 1 )

  end )

  timer.Simple( 1, function()

    if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

      self.Owner:ScreenFade( SCREENFADE.IN, ColorAlpha( adrenaline_clr, 10 ), 10, 1 )

    end

  end )

  timer.Simple( 1.25, function()

    if ( self && self:IsValid() ) then

      if ( ( self.Owner && self.Owner:IsValid() ) && self.OldWeapon ) then

        self.Owner:SelectWeapon( self.OldWeapon )

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

    self.IdleDelay = CurTime() + 1.5
		self.HolsterDelay = CurTime() + 1
    self:PlaySequence( "holster" )

    timer.Simple( .3, function()

      if ( self && self:IsValid() ) then

        self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

      end

    end )

    return false
	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

		return true

	end

end

function SWEP:CanSecondaryAttack()

  return false

end
