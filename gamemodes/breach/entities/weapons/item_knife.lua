if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/srank.png" )

end

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false

SWEP.PrintName		= "Заточка"
SWEP.WorldModel = "models/weapons/horizon/w_csgo_stiletto.mdl"
SWEP.ViewModel = "models/weapons/horizon/v_csgo_stiletto.mdl"
SWEP.HoldType		= "knife"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= false
SWEP.UnDroppable 			= true

SWEP.UseHands				= true
SWEP.Pos = Vector( -3, 2, 1 )
SWEP.Ang = Angle( 60, 240, 20 )

SWEP.HitSound = Sound( "weapons/imbrokeru_knife/knife_hit3.wav" )
SWEP.LightattackAnimations = { 7, 8 }
SWEP.LightattackAnimations_miss = { 3, 4 }

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

	self.HolsterDelay = nil
	self.IdleDelay = CurTime() + 1
	self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )
	self:PlaySequence( "draw" )

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle1" )

	end

end

function SWEP:Holster() return true end

local punch_angle = Angle( 2, 2, 2 )

local trigger_box = Vector( 20, 4, 32 )

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + .75 )

	self.IdleDelay = CurTime() + 1

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

  local trace = {

    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 130,
    filter = { self.Owner },
    mins = -trigger_box,
    maxs = trigger_box

  }

  self.Owner:LagCompensation( true )

  local tr = util.TraceHull( trace )

  self.Owner:LagCompensation( false )

  local ent = tr.Entity

  if ( ent && ent:IsValid() && ent:IsPlayer() ) then

    self:PlaySequence( self.LightattackAnimations[ math.random( 1, #self.LightattackAnimations ) ] )

		local fx = EffectData()

    fx:SetOrigin( tr.HitPos )
    fx:SetNormal( tr.HitNormal )
    fx:SetColor( BLOOD_COLOR_RED )
    util.Effect( "BloodImpact", fx )

		if ( SERVER ) then

			local recipients = RecipientFilter()
			recipients:AddAllPlayers()

			local hit_snd = CreateSound( self, self.HitSound, recipients )
			hit_snd:SetDSP( 17 )
			hit_snd:Play()

			local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )

			if ( ent:GTeam() != TEAM_SCP ) then

				dmginfo:SetDamage( ent:GetMaxHealth() * 2 )

			else

				dmginfo:SetDamage( 50 )

			end

			dmginfo:SetDamageForce( self.Owner:GetAimVector() * 3 )
			dmginfo:SetAttacker( self.Owner )
			dmginfo:SetInflictor( self )

			ent:TakeDamageInfo( dmginfo )

			self:Remove()

		end

  else

		self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )
    self:PlaySequence( self.LightattackAnimations_miss[ math.random( 1, #self.LightattackAnimations_miss ) ] )

  end

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + .75 )

  self:PrimaryAttack()

end
