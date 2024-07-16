SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-049-2"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.ViewModel = "models/cultist/scp/scp_049_2_hands.mdl"
SWEP.HoldType = "zombie"
--SWEP.Base = "breach_scp_base"
SWEP.AlertWindow = false
SWEP.AbillityID = 0
SWEP.mins = Vector( -8, -10, -5 )
SWEP.maxs = Vector( 8, 10, 5 )

SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeForceScale = 1
SWEP.MeleeDamage = 35
SWEP.MeleeSize = 4.5
SWEP.MeleeReach = 48
SWEP.MeleeDelay = .61
SWEP.MeleeSpeedMul = 1.2
SWEP.MeleeAnimationDelay = 2

SWEP.UnDroppable = true

SWEP.droppable = false
SWEP.Primary.Delay = 1.2

SWEP.Secondary.Delay = 6

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

	self.Deployed = true

	self.Owner:DrawViewModel( true )

	self:SendWeaponAnim( ACT_VM_IDLE )

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

	end

end

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

  self.Voice_Line = CreateSound( self.Owner, s_sound )
  self.Voice_Line:SetDSP( 17 )
  self.Voice_Line:Play()

end

SWEP.AlertSounds = {

	"alert1.wav",
	"alert2.wav",
	"alert05.wav",
	"alert06.wav",
	"alert07.wav",
	"alert08.wav"

}

SWEP.AttackSounds = {

	"attack1.wav",
	"attack02.wav",
	"attack03.wav",
	"attack04.wav",
	"attack05.wav",
	"attack06.wav"

}


function SWEP:Alert()

	self:VoiceLine( "nextoren/charactersounds/zombie/" .. self.AlertSounds[ math.random( 1, #self.AlertSounds ) ] )

end

function SWEP:StartMoaning()

	self:VoiceLine( "nextoren/charactersounds/zombie/idle"..math.random( 1, 6 )..".wav" )

end

function SWEP:PlayHitSound()

	self:VoiceLine( "nextoren/charactersounds/zombie/claw_strike"..math.random( 1, 3 )..".wav", nil, nil, nil, CHAN_AUTO )

end

function SWEP:PlayMissSound()

	self:VoiceLine( "nextoren/charactersounds/zombie/claw_miss"..math.random( 1, 2 )..".wav", nil, nil, nil, CHAN_AUTO )

end

function SWEP:PlayAttackSound()

	self:VoiceLine( "nextoren/charactersounds/zombie/" .. self.AttackSounds[ math.random( 1, #self.AttackSounds ) ] )

end

function SWEP:CheckMoaning()

	--[[if ( self:IsMoaning() && self.Owner:Health() < self:GetMoanHealth() ) then

		self:StopMoaning()

	end]]

end

function SWEP:CheckIdleAnimation()

	if ( self.IdleAnimation && self.IdleAnimation < CurTime() ) then

		self.IdleAnimation = nil
		self:SendWeaponAnim( ACT_VM_IDLE )

	end

end

function SWEP:CheckAttackAnimation()

	if ( self.NextAttackAnim && self.NextAttackAnim <= CurTime() ) then

		self.NextAttackAnim = nil;
		self:SendAttackAnim()

	end

end

if ( CLIENT ) then

	function SWEP:DrawHUD()

		if ( !self.Deployed ) then

			self:Deploy()

		end

	end

end

function SWEP:CheckMeleeAttack()

	local swingend = self:GetSwingEndTime()

	if ( swingend == 0 || CurTime() < swingend ) then return end

	self:StopSwinging( 0 )

	self:Swung()
	self:SendWeaponAnim( ACT_VM_IDLE )

end

function SWEP:GetTracesNumPlayers( traces )

	local numplayers = 0

	local ent;

	if ( !traces || !istable( traces ) ) then return end

	for _, trace in pairs( traces ) do

		ent = trace.Entity
		if ( ent && ent:IsValid() && ent:IsPlayer() ) then

			numplayers = numplayers + 1

		end

	end

	return numplayers

end

function SWEP:GetDamage( numplayers, basedamage )

	basedamage = basedamage || self.MeleeDamage

	if ( numplayers ) then

		return basedamage * math.Clamp( 1.1 - numplayers * 0.1, 0.666, 1 )

	end

	return basedamage

end

function SWEP:Swung()

	if ( !IsFirstTimePredicted() ) then return end

	--print( "true" )
	local owner = self.Owner

	local hit = false
	local traces = owner:CompensatedZombieMeleeTrace( self.MeleeReach, self.MeleeSize )
	local prehit = self.Prehit

	if ( prehit ) then

		local ins = true
		for _, tr in pairs( traces ) do

			if ( tr.HitNonWorld ) then

				ins = false
				break
			end

		end

		if ( ins ) then

			local eyepos = owner:EyePos()

			if ( prehit.Entity:IsValid() && prehit.Entity:NearestPoint( eyepos ):DistToSqr( eyepos ) <= self.MeleeReach * self.MeleeReach ) then

				table.insert( traces, prehit )

			end

		end

		self.Prehit = nil;
	end

	local damage = self:GetDamage( self:GetTracesNumPlayers( traces ) )
	local effectdata = EffectData()
	local ent;

	if ( !istable( traces ) ) then return end

	for _, trace in ipairs( traces ) do

		if ( !trace.Hit ) then continue end

		ent = trace.Entity

		hit = true

		if ( trace.HitWorld ) then

			self:MeleeHitWorld( trace )
			break

		elseif ( ent && ent:IsValid() && ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) then

			self:MeleeHit( ent, trace, damage )
			break

		end

		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( trace.StartPos )
		effectdata:SetNormal( trace.HitNormal )
		util.Effect( "RagdollImpact", effectdata )

		--if ( !trace.HitSky ) then

		effectdata:SetSurfaceProp( trace.SurfaceProps )
		effectdata:SetDamageType( self.MeleeDamageType )
		effectdata:SetHitBox( trace.HitBox )
		effectdata:SetEntity( ent )
		util.Effect( "Impact", effectdata )

		--end

	end

	if ( hit && ent:IsPlayer() ) then

		self:PlayHitSound()

	else

		self:PlayMissSound()

	end

end

local bannedTeams = {

	[ TEAM_SCP ] = true,
	[ TEAM_DZ ] = true,
	[ TEAM_SPEC ] = true

}

function SWEP:Think()

	self:CheckIdleAnimation()
	self:CheckAttackAnimation()
	self:CheckMeleeAttack()

	if ( SERVER && ( self.NextMoaning || 0 ) < CurTime() ) then

		self.NextMoaning = CurTime() + math.random( 20, 30 )
		self:StartMoaning()

	end

	if ( ( self.t_NextThink || 0 ) > CurTime() ) then return end
	self.t_NextThink = CurTime() + 1.5

	if self.Owner:GetMoveType() == MOVETYPE_WALK then
		self.Owner:SetNWEntity("NTF1Entity", NULL)
	end

	if ( SERVER && ( self.NextVoiceLine || 0 ) < CurTime() ) then

		local entities = ents.FindInSphere( self.Owner:GetPos(), 400 )

		for _, v in ipairs( entities ) do

			if ( v:IsPlayer() && !bannedTeams[ v:GTeam() ] && self.Owner:CanSee( v ) && self.Owner:CanSee( v ) ) then

				self.NextVoiceLine = CurTime() + 55
				self:Alert()

				break
			end

		end

	end

end

function SWEP:MeleeHit( ent, trace, damage, forcescale )

	--if ( !IsFirstTimePredicted() ) then return end

	if ( ent:IsPlayer() ) then

		self:MeleeHitPlayer( ent, trace, damage, forcescale )

	else

		self:MeleeHitEntity( ent, trace, damage, forcescale )

	end

	self:ApplyMeleeDamage( ent, trace, damage )

end

function SWEP:MeleeHitEntity( ent, trace, damage, forcescale )

	local phys = ent:GetPhysicsObject()

	if ( phys:IsValid() && phys:IsMoveable() ) then

		if ( trace.IsPreHit ) then

			phys:ApplyForceOffset( damage * 750 * ( forcescale || self.MeleeForceScale ) * self:GetOwner():GetAimVector(), ( ent:NearestPoint( self:GetOwner():EyePos() ) + ent:GetPos() * 5 ) / 6 )

		else

			phys:ApplyForceOffset( damage * 750 * ( forcescale || self.MeleeForceScale ) * trace.Normal, ( ent:NearestPoint( trace.StartPos ) + ent:GetPos() * 2 ) / 3 )

		end

		ent:SetPhysicsAttacker( self:GetOwner() )

	end

end

function SWEP:MeleeHitWorld( trace )

end

function SWEP:MeleeHitPlayer( ent, trace, damage, forcescale )

	ent:ThrowFromPositionSetZ( self.Owner:GetPos(), damage * 2.5 * ( forcescale || self.MeleeForceScale ) )
	ent:MeleeViewPunch( damage )
	local nearest = ent:NearestPoint( trace.StartPos )
	--util.Blood( nearest, math.Rand( damage * 0.5, damage * .75 ), ( nearest - trace.StartPos ):GetNormalized(), math.Rand( damage * 5, damage * 10 ), true )

end

function SWEP:ApplyMeleeDamage( hitent, tr, damage )

	if ( !IsFirstTimePredicted() ) then return end

	local owner = self.Owner

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition( tr.HitPos )
	dmginfo:SetAttacker( owner )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamageType( self.MeleeDamageType )
	dmginfo:SetDamage( damage )
	dmginfo:SetDamageForce( math.min( damage, 50 ) * 50 * owner:GetAimVector() )

	local vel;

	if ( hitent:IsPlayer() ) then

		if ( SERVER ) then

			hitent:SetLastHitGroup( tr.HitGroup )

			if ( hitent:WouldDieFrom( damage, tr.HitPos ) ) then

				dmginfo:SetDamageForce( math.min( damage, 50 ) * 400 * owner:GetAimVector() )

			end

		end

		vel = hitent:GetVelocity()

	end

	hitent:DispatchTraceAttack( dmginfo, tr, owner:GetAimVector() )

	if ( vel ) then

		hitent:SetLocalVelocity( vel )

	end

end

function SWEP:PrimaryAttack()

	if ( self.Owner.AttackedByBor ) then return end

	local owner = self:GetOwner()
	local armdelay = self.MeleeSpeedMul

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay * armdelay )

	self:StartSwinging()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	--local tr = self:HitDetect()


end

function SWEP:SendAttackAnim()

	local owner = self.Owner
	local armdelay = self.MeleeSpeedMul

	if ( self.SwapAnims ) then

		self:SendWeaponAnim( ACT_VM_HITCENTER )

	else

		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

	end

	self.SwapAnims = !self.SwapAnims

	if ( self.SwingAnimSpeed ) then

		owner:GetViewModel():SetPlaybackRate( self.SwingAnimSpeed * armdelay )

	else

		owner:GetViewModel():SetPlaybackRate( 1 * armdelay )

	end

end

function SWEP:StartSwinging()

	if ( !IsFirstTimePredicted() ) then return end

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	local owner = self.Owner
	local armdelay = self.MeleeSpeedMul

	self.MeleeAnimationMul = 1 / armdelay
	if ( self.MeleeAnimationMul ) then

		self.NextAttackAnim = CurTime() + self.MeleeAnimationDelay * armdelay

	else

		self:SendAttackAnim()

	end


	self:PlayAttackSound()

	if ( self.MeleeDelay > 0 ) then

		self:SetSwingEndTime( CurTime() + self.MeleeDelay * armdelay )

		local trace = owner:CompensatedMeleeTrace( self.MeleeReach, self.MeleeSize )

		if ( trace.HitNonWorld && !trace.Entity:IsPlayer() ) then


			trace.IsPreHit = true
			self.PreHit = trace

		end

		self.IdleAnimation = CurTime() + ( self:SequenceDuration() + ( self.MeleeAnimationDelay || 0 ) ) * armdelay

	else

		self:Swung()

	end

end

function SWEP:StopSwinging()

	self:SetSwingEndTime( 0 )

end


function SWEP:SetSwingEndTime( time )

	self:SetDTFloat( 0, time )

end

function SWEP:GetSwingEndTime()

	return self:GetDTFloat( 0 )

end

function SWEP:IsSwinging()

	return self:GetSwingEndTime() > 0

end

function SWEP:CanSecondaryAttack()

	return false

end
