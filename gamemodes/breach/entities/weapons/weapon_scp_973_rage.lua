AddCSLuaFile()


if ( CLIENT ) then

  SWEP.Category = "[NextOren] Melee"
  SWEP.PrintName = "SCP-973-Rage"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 70
  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo = false

end

SWEP.ViewModel = "models/cultist/scp/scp_973/weapons/v_night_stick.mdl"
SWEP.WorldModel = "models/cultist/scp/scp_973/weapons/w_night_stick.mdl"
SWEP.HoldType = "tonfarage"

SWEP.Pos = Vector( -1, 4, 8 )
SWEP.Ang = Angle( 175, 0, 200 )

SWEP.UseHands = true

SWEP.Target_Rage = 0

SWEP.NextVoiceLine = 0

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

  self.Voice_Line = CreateSound( self.Owner, s_sound )
  self.Voice_Line:SetDSP( 17 )
  self.Voice_Line:SetSoundLevel( 80 )
  self.Voice_Line:Play()

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "deploy" )

  if ( SERVER ) then

    self:EmitSound( "nextoren/scp/973/weapon/drawn.wav", 110, 70, 1, CHAN_WEAPON )

  end

end

SWEP.NextPrimaryAttack = 0

function SWEP:PrimaryAttack()

  if ( self.NextPrimaryAttack > CurTime() ) then return end
  self.NextPrimaryAttack = CurTime() + .65

  self.Owner:LagCompensation( true )

  self.Owner:MeleeViewPunch( 5 )

  self.Owner:SetAnimation( PLAYER_ATTACK1 )

  self.IdleDelay = CurTime() + .65
  self:PlaySequence( "attack_0" .. math.random( 1, 2 ) )

  self:EmitSound( "nextoren/scp/973/weapon/swingn" .. math.random( 1, 4 ) .. ".wav", 85, math.random( 79, 89 ), 1, CHAN_WEAPON )
  self:EmitSound( "nextoren/scp/973/weapon/chargeswing" .. math.random( 1, 2 ) .. ".wav", 85, math.random( 79, 89 ), 1, CHAN_WEAPON )

  local tr = {

    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 135,
    filter = { self, self.Owner },
    mins = Vector( -32, -8, -32 ),
    maxs = Vector( 32, 8, 32 )

  }

  local trace = util.TraceHull( tr )

  local ent = trace.Entity

  if ( ent && ent:IsValid() && ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) then

    if ( SERVER ) then

      local damage_info = DamageInfo()
      damage_info:SetDamage( ent:GetMaxHealth() * .65 )
      damage_info:SetDamageForce( ent:GetAimVector() * 58 )
      damage_info:SetDamageType( DMG_SLASH )
      damage_info:SetInflictor( self )
      damage_info:SetAttacker( self.Owner )

      if ( ent:Health() - damage_info:GetDamage() <= 0 ) then

        self:VoiceLine( "nextoren/scp/973/kill_" .. math.random( 1, 4 ) .. ".ogg" )

      else

        if ( math.random( 1, 4 ) > 2 ) then

          self:VoiceLine( "nextoren/scp/973/lauth_" .. math.random( 1, 2 ) .. ".ogg" )

        end

      end

      sound.Play( "nextoren/scp/973/weapon/hitheavy" .. math.random( 1, 3 ) .. ".wav", trace.HitPos, 85, math.random( 80, 100 ), 1 )

      ent:TakeDamageInfo( damage_info )

    end

    local effectData = EffectData()
    effectData:SetOrigin( trace.HitPos )
    effectData:SetEntity( ent )

    util.Effect( "BloodImpact", effectData )

    ent:MeleeViewPunch( 60 )

  end

  self.Owner:LagCompensation( false )

end

function SWEP:CanSecondaryAttack()

  return false

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
