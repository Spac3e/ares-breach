if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/energy.png" )

end

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.PrintName = "Энергетический напиток"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/cultist/items/drinks/w_energy_drink.mdl"
SWEP.ViewModel = "models/cultist/items/drinks/v_energy_drink.mdl"
SWEP.HoldType = "items"
SWEP.UseHands = true
SWEP.IsDrinking = nil

SWEP.Skin = 2

SWEP.Pos = Vector( -4, -3, -2 )
SWEP.Ang = Angle( -180, 0, 90 )

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:DrawWorldModel()

	local pl = self.Owner

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

      if ( wm:GetSkin() != self.Skin ) then

        wm:SetSkin( self.Skin )

      end

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

    if ( self:GetSkin() != self.Skin ) then

      self:SetSkin( self.Skin )

    end

	end

end

function SWEP:Deploy()

  if ( !IsFirstTimePredicted() ) then return end

  self.IdleDelay = CurTime() + .5
  self.HolsterDelay = nil
  self:PlaySequence( "deploy" )
  timer.Simple( .25, function()

    if ( self && self:IsValid() ) then

      self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )

    end

  end )

  if ( self.Skin ) then

    local vm = self.Owner:GetViewModel()

    if ( vm && vm:IsValid() ) then

      self.Owner:GetViewModel():SetSkin( self.Skin )

    end
    
  end

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

local view_punch_angle = Angle( -15, 0, 0 )

function SWEP:PrimaryAttack()

  if ( self.IsDrinking ) then return end
  self.IsDrinking = true

  self.IdleDelay = CurTime() + 4

  self:PlaySequence( "use" )

  timer.Simple( .5, function()

    if ( !( self && self:IsValid() ) ) then return end

    if ( self.Owner && self.Owner:IsValid() ) then

      self.Owner:ViewPunch( view_punch_angle )

    end

  end )

  if ( CLIENT ) then return end

  timer.Simple( 1, function()

    if ( !( self && self:IsValid() ) ) then return end
    if ( !( self.Owner && self.Owner:IsValid() ) ) then return end

    self.Owner:Boosted( 1, math.random( 15, 20 ) )

    timer.Simple( .25, function()

      if ( self && self:IsValid() ) then

        self:Remove()

      end

    end )

  end )

end

function SWEP:Holster()

  if ( self.IsDrinking ) then return false end

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
    self.IdleDelay = CurTime() + 1.5
  	self:PlaySequence( "holster" )
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then return true end

end

function SWEP:SecondaryAttack()

  return false

end
