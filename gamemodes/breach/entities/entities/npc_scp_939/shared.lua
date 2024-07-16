if ( SERVER ) then

  AddCSLuaFile( "shared.lua" )

end

ENT.Base = "breach_npc_base"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.MoveType = 3

ENT.UseFootSteps = 0

ENT.collisionheight = 80
ENT.collisionside = 10

ENT.FootAngles = 8
ENT.FootAngles2 = 8

ENT.Speed = 135
ENT.WalkSpeedAnimation = 1.0

ENT.AttackRange = 90
ENT.InitialAttackRange = 90

ENT.Bone1 = "foot_control_R"
ENT.Bone2 = "foot_control_L"

ENT.health = 1400
ENT.Damage = 35

ENT.NextAttack = 0
ENT.AttackFinishTime = .1

ENT.pitch = 70
ENT.pitchVar = 15
ENT.wanderType = 2

ENT.UseFootSteps = 1

ENT.Footsteps = {

  "nextoren/scp/939/939-run-rr1.wav",
  "nextoren/scp/939/939-run-rr2.wav",
  "nextoren/scp/939/939-run-rr3.wav",
  "nextoren/scp/939/939-run-rr4.wav",
  "nextoren/scp/939/939-run-rr5.wav",
  "nextoren/scp/939/939-run-rr6.wav",
  "nextoren/scp/939/939-run-rr7.wav",
  "nextoren/scp/939/939-run-rr8.wav"

}

ENT.AttackSounds = {

  "nextoren/scp/939/sl_attack1.mp3",
  "nextoren/scp/939/sl_attack2.mp3",
  "nextoren/scp/939/sl_attack3.mp3"

}

ENT.hitSounds = {

  "nextoren/scp/939/0attac1.mp3",
  "nextoren/scp/939/0attac2.mp3",
  "nextoren/scp/939/0attac3.mp3",
  "nextoren/scp/939/1attack1.mp3",
  "nextoren/scp/939/1attack2.mp3",
  "nextoren/scp/939/1attack3.mp3",
  "nextoren/scp/939/2attack1.mp3",
  "nextoren/scp/939/2attack2.mp3",
  "nextoren/scp/939/2attack3.mp3"

}

ENT.alertSounds = {

  "nextoren/scp/939/0alert1.mp3",
  "nextoren/scp/939/0alert2.mp3",
  "nextoren/scp/939/0alert3.mp3",
  "nextoren/scp/939/1alert1.mp3",
  "nextoren/scp/939/1alert2.mp3",
  "nextoren/scp/939/1alert3.mp3",
  "nextoren/scp/939/2alert1.mp3",
  "nextoren/scp/939/2alert2.mp3",
  "nextoren/scp/939/2alert3.mp3"

}

ENT.Model = Model( "models/cultist/npc_scp/939.mdl" )

ENT.WalkAnim = "run"

ENT.IdleAnim = "idle"

ENT.AttackAnim = "attack"

ENT.SearchRadius = 800

ENT.volume = 1

ENT.NextAttack = .8

function ENT:Initialize()

  self:SetModel( self.Model )

  self.InitialPos = self:GetPos()

  self.WalkAnim = self:LookupSequence( self.WalkAnim )
  self.Attack_Duration = self:SequenceDuration( self:LookupSequence( self.AttackAnim ) )

  if ( SERVER ) then

    self:SetHealth( self.health )

    self:CollisionSetup( self.collisionside, self.collisionheight, COLLISION_GROUP_PLAYER )

    self.IsAttacking = false

    self.loco:SetStepHeight( 35 )
    self.loco:SetAcceleration( 500 )
    self.loco:SetDeceleration( 900 )

    self:SetModelScale( .8, 0 )

    self:PhysicsInitShadow( true, true )

  end

end

local team_spec_index, team_scp_index = TEAM_SPEC, TEAM_SCP

function ENT:SearchForEnemy( ents )

  for _, v in ipairs( ents ) do

    if ( !( v:IsPlayer() && v:GetMoveType() != MOVETYPE_NOCLIP && v:GTeam() != team_scp_index && v:GTeam() != TEAM_DZ && v:IsSolid() ) ) then continue end

    if ( !v:Crouching() && v:GetVelocity():Length2D() > .25 && self:CanSeePlayer( v ) || v:GetPos():DistToSqr( self:GetPos() ) < 19600 ) then

      if !self:CantBeInHere(v:GetPos()) then

        return self:SetEnemy( v )

      end

    end

  end

  return self:SetEnemy( nil )

end

function ENT:FootSteps()

  local snd = CreateSound( self, self.Footsteps[ math.random( 1, #self.Footsteps ) ])
  snd:Play()

end

function ENT:AttackSound()

  local snd = CreateSound( self, self.AttackSounds[ math.random( 1, #self.AttackSounds ) ])
  snd:Play()

end

function ENT:HitSound()

  local snd = CreateSound( self, self.alertSounds[ math.random( 1, #self.hitSounds ) ] )
  snd:Play()

end

function ENT:AlertSound()

  local snd = CreateSound( self, self.alertSounds[ math.random( 1, #self.alertSounds ) ] )
  snd:Play()

end
