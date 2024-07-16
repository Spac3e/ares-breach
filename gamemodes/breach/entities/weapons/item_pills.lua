AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/pills.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/items/painpills/v_painpills.mdl"
SWEP.WorldModel		= "models/cultist/items/painpills/w_painpills.mdl"
SWEP.PrintName		= "Болеутоляющие таблетки"
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
SWEP.Spawnable		= true

SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,10}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands = true

SWEP.Pos = Vector( -2.2, 4, -2)
SWEP.Ang = Angle( 180, 0, 188 )

function SWEP:Deploy()

	self.IdleDelay = CurTime() + .75
  self:PlaySequence( "painpills_draw" )
  self.HolsterDelay = nil
  self:EmitSound( "weapons/universal/uni_weapon_draw_02.wav", 75, 80, 1, CHAN_WEAPON )

end

function SWEP:PrimaryAttack()

	if ( self.IsDrinking ) then return end
  self.IsDrinking = true

  self.IdleDelay = CurTime() + 4

  self:PlaySequence( "eq_painpills_use" )

	if ( SERVER ) then

    net.Start( "GestureClientNetworking" )

      net.WriteEntity( self.Owner )
      net.WriteString("l4d_Pills_Swallow_layer")
      net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
      net.WriteBool( true )

    net.Broadcast()

  end

	timer.Simple( self.Owner:SequenceDuration( 5172 ) - .1, function()

		if ( self && self:IsValid() ) then

			self.NoDrawModel = true

			if ( ( self.Owner && self.Owner:IsValid() ) ) then

        self.Owner:SelectWeapon( "v92_eq_unarmed" )

      end

		end

	end )

	timer.Simple( 1, function()

		if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) && self.Owner:Health() > 0 ) then

			self.Owner:Boosted( 3 )

		end

	end )

	timer.Simple( 2.5, function()

		if ( SERVER && self && self:IsValid() ) then

			self:Remove()

		end

	end )

end

function SWEP:Holster()

	if ( self.IsDrinking ) then return false end

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )
    self:PlaySequence( "painpills_holster" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

		return true

	end

	self.IdleDelay = CurTime() + 1

end


function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "painpills_idle", true )

	end

end

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

		local pos, ang = self.Owner:GetBonePosition( bone )
		local wm = self:CreateWorldModel()

		if ( wm && wm:IsValid() && !self.NoDrawModel ) then

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

function SWEP:CanSecondaryAttack()

	return false

end
