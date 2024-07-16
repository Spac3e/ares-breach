if ( SERVER ) then

  AddCSLuaFile( "shared.lua" )

end

ENT.Base = "breach_npc_base"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.MoveType = 2

ENT.UseFootSteps = 0

ENT.collisionheight = 85
ENT.collisionside = 13

ENT.Speed = 120
ENT.WalkSpeedAnimation = 1.0

ENT.health = 80000
ENT.Damage = 120

ENT.AttackRange = 40
ENT.InitialAttackRange = 70

ENT.NextAttack = 0
ENT.AttackFinishTime = 0

ENT.pitch = 70
ENT.pitchVar = 15
ENT.wanderType = 3

ENT.Model = Model( "models/cultist/npc_scp/1499-1.mdl" )

ENT.WalkAnim = "run"

ENT.IdleAnim = "idle"

ENT.AttackAnim = "attack1"

ENT.volume = 1

function ENT:Initialize()

  self:SetModel( self.Model )

  self.WalkAnim = self:LookupSequence( self.WalkAnim )
  self.Attack_Duration = self:SequenceDuration( self:LookupSequence( self.AttackAnim ) )

  if ( SERVER ) then

    self:SetHealth( self.health )

    self.IsAttacking = false

    self.loco:SetStepHeight( 35 )
    self.loco:SetAcceleration( 500 )
    self.loco:SetDeceleration( 900 )

    self:CollisionSetup( self.collisionside, self.collisionheight, COLLISION_GROUP_PLAYER )
    self:PhysicsInitShadow( true, true )

  end

end

local team_spec_index = TEAM_SPEC

function ENT:SearchForEnemy( ents )

  for _, v in ipairs( ents ) do

    if ( v:IsPlayer() && v:Team() != team_spec_index ) then

      return self:SetEnemy( v )

    end

  end

  return self:SetEnemy( nil )

end

function ENT:CustomThink()

  if ( ( self.NextMoan || 0 ) > CurTime() ) then return end

  self.NextMoan = CurTime() + 25
  self:EmitSound( "nextoren/scp/1499/idle" .. math.random( 1, 4 ) .. ".ogg", 110, math.random( 90, 100 ), 1, CHAN_VOICE )

end

ENT.TriggerSound = Sound( "nextoren/scp/1499/triggered.ogg" )

function ENT:AlertSound()

  local snd = CreateSound( self, self.TriggerSound )
  snd:SetDSP( 17 )
  snd:Play()

end
