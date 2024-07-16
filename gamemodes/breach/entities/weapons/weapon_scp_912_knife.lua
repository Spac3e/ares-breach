SWEP.PrintName = "SCP-912 Knife"
SWEP.Primary.Ammo = 0
SWEP.Secondary.Ammo = 0

SWEP.ViewModel = "models/weapons/v_csgo_tactical.mdl"
SWEP.WorldModel = "models/weapons/w_csgo_tactical.mdl"

SWEP.HoldType = "knife"
SWEP.UseHands = true

SWEP.UnDroppable = true
SWEP.droppable = false

SWEP.Pos = Vector( -1,0,-0.8)
SWEP.Ang = Angle( 145, 0, 180 )

sound.Add( {

	name = "csgo_knife.Deploy",
	channel = CHAN_WEAPON,
	volume = .8,
	level = 66,
	pitch = { 100, 105 },
	sound = {

    "weapons/fbi_knife/knife_deploy_1.wav",
    "weapons/fbi_knife/knife_deploy_2.wav",
    "weapons/fbi_knife/knife_deploy_3.wav",
    "weapons/fbi_knife/knife_deploy_4.wav",
    "weapons/fbi_knife/knife_deploy_5.wav",
    "weapons/fbi_knife/knife_deploy_6.wav"

  }

} )

sound.Add( {

	name = "fbi_knife.slash",
	channel = CHAN_WEAPON,
	volume = .8,
	level = 90,
	pitch = { 100, 105 },
	sound = {

    "weapons/fbi_knife/knife_stab_1.wav",
    "weapons/fbi_knife/knife_stab_2.wav",
    "weapons/fbi_knife/knife_stab_3.wav",
    "weapons/fbi_knife/knife_stab_4.wav"

  }

} )

sound.Add( {

	name = "fbi_knife.hit",
	channel = CHAN_WEAPON,
	volume = .9,
	level = 90,
	pitch = { 100, 105 },
	sound = {

    "weapons/fbi_knife/knife_hit_1.wav",
    "weapons/fbi_knife/knife_hit_2.wav",
    "weapons/fbi_knife/knife_hit_3.wav",
    "weapons/fbi_knife/knife_hit_4.wav",
    "weapons/fbi_knife/knife_hit_5.wav",
    "weapons/fbi_knife/knife_hit_6.wav",
    "weapons/fbi_knife/knife_hit_7.wav",
    "weapons/fbi_knife/knife_hit_8.wav",
    "weapons/fbi_knife/knife_hit_9.wav",
    "weapons/fbi_knife/knife_hit_10.wav"

  }

} )

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

  timer.Simple( .25, function()

    if ( !( self && self:IsValid() ) ) then return end

    self.DrawSequence_ID = self:LookupSequence( "draw" )
    self.DrawSequence_Length = self:SequenceDuration( self.DrawSequence_ID )

    self.Primary_AttacksSequence = {

      select( 1, self:LookupSequence( "light_miss1" ) ),
      select( 1, self:LookupSequence( "light_miss2" ) )

    }

    self.Primary_AttacksHitSequence = {

      select( 1, self:LookupSequence( "light_hit1" ) ),
      select( 1, self:LookupSequence( "light_hit2" ) )

    }

    --print( CLIENT, #self.Primary_AttacksSequence )

    self.Primary_AttacksSequence[ 3 ] = nil
    self.Primary_AttacksHitSequence[ 3 ] = nil

    self.Secondary_AttackHitSequence = self:LookupSequence( "heavy_hit1" )
    self.Secondary_AttackSequence = self:LookupSequence( "heavy_miss1" )

    --PrintTable( self.Primary_AttacksSequence )

  end )

end

function SWEP:Think()

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

    self.IdleAnimation = {

      select( 1, self:LookupSequence( "idle1" ) ),
      select( 1, self:LookupSequence( "idle2" ) )

    }

    self.IdlePlaying = true
    self:PlaySequence( self.IdleAnimation[ math.random( 1, #self.IdleAnimation ) ], true )

  end

end

function SWEP:Deploy()

  self.IdleDelay = CurTime() + ( self.DrawSequence_Length )
  self:PlaySequence( self.DrawSequence_ID )

end

local prim_mins, prim_maxs = Vector( -16, -4, -32 ), Vector( 16, 4, 32 )

function SWEP:PrimaryAttack(secondary)

  if !IsFirstTimePredicted() then return end

  if !secondary then

    self:SetNextPrimaryFire( CurTime() + .8 )

  end

  self.IdleDelay = CurTime() + .8

  self:EmitSound( "fbi_knife.slash" )
  --self.Owner:MeleeViewPunch( 5 )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

  self.Owner:LagCompensation( true )

  local tr = {

    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 130,
    filter = { self, self.Owner },
    mins = prim_mins,
    maxs = prim_maxs

  }

	local trace = util.TraceHull( tr )

  self.Owner:LagCompensation( false )

  local ent = trace.Entity

  if ( ent:IsPlayer() and ent:GTeam() != TEAM_SCP and ent:GTeam() != TEAM_DZ ) then

    self:EmitSound( "fbi_knife.hit" )
    self:PlaySequence( self.Primary_AttacksHitSequence[ math.random( 1, #self.Primary_AttacksHitSequence ) ] )

    if ( SERVER ) then

      local damage_info = DamageInfo()

			if ( ent:GTeam() != TEAM_SCP ) then

      	damage_info:SetDamage( ent:GetMaxHealth() )

        damage_info:SetDamageForce( math.min( 300, 50 ) * 80 * self.Owner:GetAimVector() )

			else

				damage_info:SetDamage( ent:GetMaxHealth() * .1 )

        damage_info:SetDamageForce( self.Owner:GetAimVector() * 4 )

			end
      damage_info:SetInflictor( self )
      damage_info:SetAttacker( self.Owner )

      ent:TakeDamageInfo( damage_info )

    end

    local effectData = EffectData()
    effectData:SetOrigin( trace.HitPos )
    effectData:SetEntity( ent )

    util.Effect( "BloodImpact", effectData )

  else

    self:PlaySequence( self.Primary_AttacksSequence[ math.random( 1, #self.Primary_AttacksSequence ) ] )

  end

end

function SWEP:SecondaryAttack()

  self:SetNextSecondaryFire( CurTime() + .8 )

  self:PrimaryAttack(true)

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self.Owner

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )

		if ( !bone ) then return end

		local pos, ang = self.Owner:GetBonePosition( bone )
		local wm = self:CreateWorldModel()

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
