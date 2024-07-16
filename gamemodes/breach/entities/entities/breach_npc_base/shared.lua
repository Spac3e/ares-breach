if ( SERVER ) then

  AddCSLuaFile( "shared.lua" )

end

ENT.Base = "base_nextbot"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.UseFootSteps = 1
ENT.Bone1 = "ValveBiped.Bip01_R_Foot"
ENT.Bone2 = "ValveBiped.Bip01_L_Foot"
ENT.FootAngles = 0
ENT.FootAngles2 = 0
ENT.FootstepTime = .5

ENT.MoveType = 2

ENT.SearchRadius = 2000
ENT.LoseTargetDist = 4000

ENT.Speed = 0
ENT.WalkSpeedAnimation = 0
ENT.FlinchSpeed = 0

ENT.health = 0
ENT.Damage = 0

ENT.AttackRange = 70
ENT.InitialAttackRange = 60

ENT.HitPerDoor = 1
ENT.DoorAttackRange = 25

ENT.AttackFinishTime = 0
ENT.AttackAnimSpeed = 1

ENT.NextAttack = 1.5

ENT.FallDamage = 0

ENT.nextWander = 0
ENT.nextIdle = 0
ENT.retargetTime = 0

ENT.OldEnemy = nil
ENT.IsAttacking = false

ENT.corpseTime = 600

ENT.pitch = 100
ENT.pitchVar = 5
ENT.Volume = 75

ENT.wanderType = 3
ENT.idleTime = 2

ENT.Ignites = true
ENT.Launches = false
ENT.Persistent = false

ENT.Model = ""

ENT.AttackAnim = (NONE)

ENT.WalkAnim = (NONE)
ENT.IdleAnim = ACT_IDLE

ENT.FlicnhAnim = (NONE)
ENT.FallAnim = (NONE)

ENT.AttackDoorAnim = (NONE)

ENT.attackSounds = {}
ENT.alertSounds = {}
ENT.deathSounds = {}
ENT.idleSounds = {}
ENT.painSounds = {}
ENT.hitSounds = {}
ENT.missSounds = {}

ENT.chance = true
ENT.team = 0

function ENT:Precache()

  util.PrecacheModel( self.Model )

end


function ENT:Initialize() end

function ENT:SelectModel()

  self:SetModel( self.models[ math.random( #self.models ) ] )

end

function ENT:CollisionSetup( collisionside, collisionheight, collisiongroup )

  self:SetCollisionGroup( collisiongroup )
  self:SetCollisionBounds( Vector( -collisionside, -collisionside, 0 ), Vector( collisionside, collisionside, collisionheight ) )
  self.NEXTBOT = true

end

function ENT:CustomThink() end

function ENT:SpawnFunction( ply, tr, ClassName )

  if ( !tr.Hit ) then return end

  local SpawnPos = tr.HitPos + tr.HitNormal * 16

  if ( util.PointContents( tr.HitPos ) == CONTENTS_EMPTY ) then

    local ent = ents.Create( Class )
    ent:SetPos( SpawnPos )
    ent:Spawn()

  end

  return ent

end

function ENT:CantBeInHere(pos)
  if pos:WithinAABox(Vector(-864.112732, -3659.350098, -1354.657593), Vector(-644.213745, -3868.016602, -1079.129883)) or pos:WithinAABox(Vector(157.534637, -5578.742676, -1067.244019), Vector(-63.770992, -5778.269043, -1292.828003)) then
    return true
  end
  return false
end

function ENT:DoorStuck( openNormal )

  if ( !self.nextSample || !self.stuckPosition ) then

    self.nextSample = 0
    self.stuckPosition = 0

  end

  if ( self.nextSample < CurTime() ) then

    self.nextSample = CurTime() + 1

  end

end

function ENT:Think()

  self:CustomThinkClient()

  if ( !SERVER ) then return end

  if self:CantBeInHere(self:GetPos()) then
    self:SetPos(self.InitialPos)
    self:SetEnemy(nil)
    self.Enemy = nil
  end

  if self:GetEnemy() then

    if self:CantBeInHere(self:GetEnemy():GetPos()) then
    
     -- self:SetPos(self.InitialPos)
      self:SetEnemy(nil)
      self.Enemy = nil
      --self:IdleFunction()

    end

  end

  if ( !self.timers ) then

    self.timers = {}

  end

  if ( !( self && self:IsValid() ) ) then return end

  if ( self.timers ) then

    for k, v in pairs( self.timers ) do

      if ( k < CurTime() ) then

        v()
        self.timers[ k ] = nil

      end

    end

  end

  self:CustomThink()

  if ( ( self.NextEnemyFind || 0 ) < CurTime() && !self.Enemy ) then

    self.NextEnemyFind = CurTime() + .25
    self:FindEnemy()

  end

  if ( self.UseFootSteps == 1 ) then

    if ( !self.nxtThink ) then

      self.nxtThink = 0

    end

    if ( CurTime() < self.nxtThink ) then return end

    self.nxtThink = CurTime() + .025

    local bone = self:LookupBone( self.Bone1 )

    if ( bone ) then

      local pos, ang = self:GetBonePosition( bone )

      local tr = {}
      tr.start = pos
      tr.endpos = tr.start - ang:Right() * self.FootAngles + ang:Forward() * self.FootAngles2
      tr.filter = self
      tr = util.TraceLine( tr )

      if ( tr.Hit && !self.FeetOnGround ) then

        self:FootSteps()

      end

      self.FeetOnGround = tr.Hit

      local bone_2 = self:LookupBone( self.Bone2 )

      local pos2, ang2 = self:GetBonePosition( bone_2 )

      local tr = {}
      tr.start = pos2
      tr.endpos = tr.start - ang2:Right() * self.FootAngles + ang2:Forward() * self.FootAngles2
      tr.filter = self
      tr = util.TraceLine( tr )

      if ( tr.Hit && !self.FeetOnGround2 ) then

        self:FootSteps()

      end

      self.FeetOnGround2 = tr.Hit

    end

  end

end

function ENT:Attack()

  if ( ( self.NextAttackTimer || 0 ) < CurTime() ) then

    if ( ( self.Enemy && self.Enemy:IsValid() ) && self.Enemy:Health() > 0 ) then

      if ( !self:CheckStatus() ) then return end
      self:CustomAttack()

      if ( self.AttackSound ) then

        self:AttackSound()

      end

      self.IsAttacking = true

      self.loco:SetDeceleration( 0 )
      self.loco:FaceTowards( self.Enemy:GetPos() )

      if ( isnumber( self.AttackAnim ) ) then

        self:StartActivity( self.AttackAnim )
        self:AttackEffect( self.AttackFinishTime, self.Enemy, self.Damage, 0, 1 )

      else

        self:AttackEffect( self.AttackFinishTime, self.Enemy, self.Damage, 0, 1 )
        self:PlaySequenceAndWait( self.AttackAnim, self.AttackAnimSpeed )

      end

      self.loco:SetDeceleration( 900 )

    end

    self.NextAttackTimer = CurTime() + self.NextAttack

  end

end

function ENT:CustomAttack() end

function ENT:AttackEffect( waitTime, ent, dmg, type, reset )

  local function temp()

    if ( !( self && self:IsValid() ) ) then return end
    if ( self:Health() < 0 ) then return end
    if ( !self:CheckValid( ent ) ) then return end
    if ( !self:CheckStatus() ) then return end

    if ( self:GetRangeTo( ent ) < self.AttackRange ) then
      ent:TakeDamage( dmg, self )

      if ( ent:IsPlayer() ) then

        if ( self.Launches ) then

          local moveAdd = Vector( 0, 0, 350 )

          if ( !ent:IsOnGround() ) then

            moveAdd = vector_origin

          end

          ent:SetVelocity( moveAdd + ( ( self.Enemy:GetPos() - self:GetPos() ):GetNormal() * 150 ) )

        end

        ent:ViewPunch( Angle( math.random( -1, 1 ) * self.Damage, math.random( -1, 1 ) * self.Damage, math.random( -1, 1 ) * self.Damage ) )

        if ( self.HitSound ) then

          self:HitSound()

        end

      end

      if ( type == 1 ) then

        local phys = ent:GetPhysicsObject()

        if ( phys != nil && phys != NULL && phys:IsValid() ) then

          phys:ApplyForceCenter( self:GetForward():GetNormalized() * ( self.PhysForce ) + Vector( 0, 0, 2 ) )
          ent:EmitSound( self.DoorBreak )

        end

      elseif ( type == 2 ) then

        if ( ent != NULL && ent.hitsLeft != nil ) then

          if ( ent.hitsLeft > 0 ) then

            ent.hitsLeft = ent.hitsLeft - self.HitPerDoor
            ent:EmitSound( self.DoorBreak )

          end

        end

      end

    else

      self:MissSound()

    end

  end

  self:delay( waitTime, temp )

  if ( reset == 1 ) then

    local function temp()

      if ( !( self && self:IsValid() ) ) then return end
      if ( self:Health() < 0 ) then return end
      if ( !self:CheckValid( ent ) ) then return end
      if ( !self:CheckStatus() ) then return end

      self.IsAttacking = false
      self:ResumeMovementFunction()

    end

    self:delay( waitTime + self.Attack_Duration, temp )

  end

end

function ENT:delay( delayTime, delayedFunc )

  self.timers[ CurTime() + delayTime ] = delayedFunc

end

function ENT:TransformRagdoll( dmginfo )

  local ragdoll = ents.Create( "prop_ragdoll" )

  if ( ragdoll:IsValid() ) then

    ragdoll:SetPos( self:GetPos() )
    ragdoll:SetModel( self:GetModel() )
    ragdoll:SetAngles( self:GetAngles() )
    ragdoll:Spawn()
    ragdoll:SetSkin( self:GetSkin() )
    ragdoll:SetColor( self:GetColor() )
    ragdoll:SetMaterial( self:GetMaterial() )
    ragdoll:SetBloodColor( self:GetBloodColor() )

    if ( self:GetModelScale() ) then

      ragdoll:SetModelScale( self:GetModelScale(), 0 )

    end

    local num = ragdoll:GetPhysicsObjectCount() - 1
    local v = self.loco:GetVelocity()

    for i = 0, num do

      local bone = ragdoll:GetPhysicsObjectNum( i )

      if ( bone && bone:IsValid() ) then

        local bp, ba = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
        if ( bp && ba ) then

          bone:SetPos( ba )
          bone:SetAngles( ba )

        end

        bone:SetVelocity( v )

      end

    end

  end

  if ( self:IsOnFire() ) then

    ragdoll:Ignite( 10, 20 )

  end

  SafeRemoveEntity( self )

  timer.Simple( self.corpseTime, function()

    SafeRemoveEntity( ragdoll )

  end )

end

function ENT:CustomDeath( dmginfo )

  self:TransformRagdoll( dmginfo )

end

function ENT:CustomInjures( dmginfo ) end

function ENT:FootSteps() end

function ENT:FootStepThink()

  if ( self.UseFootSteps == 2 ) then

    if ( !self.nextStep ) then

      self.nextStep = 0

    end

    if ( self.nextStep < CurTime() ) then

      self:FootSteps()
      self.nextStep = CurTime() + self.FootstepTime

    end

  end

end

function ENT:AlertSound()

  local sound = self.alertSounds[ math.random( #self.alertSounds ) ]

  if ( !sound ) then return end

  self:EmitSound( sound, self.volume, math.random( self.pitch - self.pitchVar, self.pitch + self.pitchVar ) )

end

function ENT:PainSound()

  local sound = self.painSounds[ math.random( #self.painSounds ) ]

  if ( !sound ) then return end

  self:EmitSound( sound, self.volume, math.random( self.pitch - self.pitchVar, self.pitch + self.pitchVar ) )

end

function ENT:DeathSound()

  local sound = self.deathSounds[ math.random( #self.deathSounds ) ]

  if ( !sound ) then return end

  self:EmitSound( sound, self.volume, math.random( self.pitch - self.pitchVar, self.pitch + self.pitchVar ) )

end

function ENT:IdleSound()

  local sound = self.idleSounds[ math.random( #self.idleSounds ) ]

  if ( !sound ) then return end

  self:EmitSound( sound, self.volume, math.random( self.pitch - self.pitchVar, self.pitch + self.pitchVar ) )

end

function ENT:MissSound()

  local sound = self.missSounds[ math.random( #self.missSounds ) ]

  if ( !sound ) then return end

  self:EmitSound( sound, self.volume, math.random( self.pitch - self.pitchVar, self.pitch + self.pitchVar ) )

end

function ENT:IdleSounds()

  if ( self:HaveEnemy() ) then

    self:IdleSounds()

  else

    if ( math.random( 1, 10 ) == 1 ) then

      self:IdleSound()

    end

  end

end

function ENT:CheckValid( ent )

  if ( !( ent && ent:IsValid() ) ) then return false end

  if ( !( self && self:IsValid() ) ) then return false end

  if ( self:Health() < 0 || ent:Health() < 0 ) then return false end

  return true

end

function ENT:CheckStatus()

  return true

end

function ENT:ResumeMovementFunction()

  self:MovementFunction( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )

end

function ENT:IdleFunction()

  if ( self.wanderType == 1 ) then

    self:Idle()

  elseif ( self.wanderType == 2 ) then

    if ( ( self.NextHide || 0 ) < CurTime() ) then

      local spot = navmesh.GetNearestNavArea( self:GetPos() + VectorRand() * 300 )

      if ( spot && spot:GetID() != ( self.OldNavID || 0 ) ) then

        local goal_pos = spot:GetCenter()

        if ( !goal_pos ) then return end

        if ( self:IsLineOfSightClear( goal_pos ) ) then

          self:MovementFunction( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
          self:GoToLocation( goal_pos )

        end

        self.OldNavID = spot:GetID()

      end

      self.NextHide = CurTime() + math.random( 3, 6 )

    else

      self:Idle()

    end

  elseif ( self.wanderType == 3 ) then

    if ( CurTime() > self.nextWander ) then

      self:MovementFunction( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
      self:Wander( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 280 )

    else

      self:Idle()

    end

  else

    self:MovementFunction( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )
    self:Wander( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )

  end

end

function ENT:Idle()

  if ( self.nextIdle < CurTime() ) then

    self.oldVol = self.volume
    self.volume = self.volume / 2
    self:IdleSound()
    self.volume = self.oldVol
    self.oldVol = nil

    self.nextIdle = CurTime() + math.random( 10, 12 )

  end

  self:MovementFunction( self.MoveType, self.IdleAnim, self.Speed, self.WalkSpeedAnimation )

end

function ENT:MovementFunction( type, act, speed, playbackrate )

  if ( type == 1 ) then

    self:StartActivity( act )
    self:SetPoseParameter( "move_x", playbackrate )

  elseif ( type == 2 ) then

    self:ResetSequence( act )
    self:SetPlaybackRate( playbackrate )
    self:SetPoseParameter( "move_x", playbackrate )

  elseif ( type == 3 ) then

    self:ResetSequence( act )
    self:SetSequence( act )
    self:SetPoseParameter( "move_x", playbackrate )

  end

  self.loco:SetDesiredSpeed( speed )

end

function ENT:SpawnIn()

  local nav = navmesh.GetNearestNavArea( self:GetPos() )

  if ( !self:IsInWorld() || !IsValid( nav ) || nav:GetClosestPointOnArea( self:GetPos() ):DistToSqr( self:GetPos() ) >= 20000 ) then

    SafeRemoveEntity( self )

  end

  self:OnSpawn()

end

function ENT:OnSpawn() end

function ENT:RunBehaviour()

  self:SpawnIn()

  while ( true ) do

    local enemy = self:GetEnemy()

    if ( enemy && enemy:IsValid() && enemy:IsSolid() && enemy:Health() > 0 ) then

      self.Hiding = false

      pos = enemy:GetPos()

      if ( self:CheckStatus() ) then

        self:MovementFunction( self.MoveType, self.WalkAnim, self.Speed, self.WalkSpeedAnimation )

      end

      local opts = {

        lookahead = 30,
        tolerance = 40,
        draw = false,
        maxage = 8,
        repath = 2

      }

      self:ChaseEnemy( pos, opts )

    else

      self.Enemy = nil

      self:IdleFunction()

    end

    coroutine.yield()

  end

end

function ENT:CheckRangeToEnemy()

  if ( ( self.CheckTimer || 0 ) < CurTime() ) then

    local enemy = self:GetEnemy()

    if ( enemy && enemy:IsValid() && enemy:Health() > 0 ) then

      if ( self:GetRangeTo( enemy ) < self.InitialAttackRange && self:IsLineOfSightClear( enemy ) ) then

        self:Attack()

      end

    else

      self.Enemy = nil

    end

    self.CheckTimer = CurTime() + 1

  end

end

function ENT:HandleStuck()

  self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000, 1000 )

end

function ENT:ChaseEnemy( pos, options )

  if self:CantBeInHere(pos) then return "failed" end

  local enemy = self:HaveEnemy()
  local options = options || {}

  local path = Path( "Follow" )
  path:SetMinLookAheadDistance( options.lookahead || 300 )
  path:SetGoalTolerance( options.tolerance || 20 )

  if ( !( enemy && enemy:IsValid() ) ) then return end

  if ( enemy:Health() <= 0 ) then return end

  local nav = navmesh.GetNearestNavArea( enemy:GetPos() )

  if ( IsValid( nav ) && nav:GetClosestPointOnArea( enemy:GetPos() ):DistToSqr( pos ) < 20000 ) then

    path:Compute( self, pos )

  else

    return
  end

  if ( !( path && path:IsValid() ) ) then return "failed" end

  while ( path && path:IsValid() ) do

    path:Update( self )

    if ( self.loco:IsStuck() ) then

      if ( self.Enemy && self.Enemy:IsValid() && !self:IsLineOfSightClear( self.Enemy ) ) then

        self.Enemy = nil

      end

      self:HandleStuck()

    end

    if ( enemy && enemy:IsValid() ) then

      if ( !self.Persistent ) then

        if ( self:CanSeePlayer( enemy ) ) then

          self.OldPos = enemy:GetPos()

        end

      else

        self.OldPos = enemy:GetPos()

      end

      if ( !self.IsAttacking ) then

        if ( self.nextIdle < CurTime() ) then

          self:IdleSound()
          self.nextIdle = CurTime() + math.random( 6, 10 )

        end

      end

      if ( enemy:GetMoveType() == MOVETYPE_NOCLIP ) then

        self.Enemy = nil

      end

    else

      self:Idle()

      break
    end

    self:CustomChaseEnemy()
    self:CheckRangeToEnemy()
    self:FootStepThink()

    if ( options.maxage ) then

      if ( path:GetAge() > options.maxage ) then return "timeout" end

    end

    if ( options.repath ) then

      if ( path:GetAge() > options.repath ) then

        if ( !self.OldPos ) then break end

        if ( self:GetPos():DistToSqr( self.OldPos ) < 2500 ) then break end

        local nav = navmesh.GetNearestNavArea( self.OldPos )
        if ( !IsValid( nav ) || nav:GetClosestPointOnArea( self.OldPos ):DistToSqr( self.OldPos ) > 96100 ) then break end

        enemy = self.Enemy
        path:Compute( self, self.OldPos )

      end

    end

    coroutine.yield()

  end

  return "ok"

end

function ENT:GoToLocation( location, options )

  if ( !util.IsInWorld( location ) ) then return end

  local options = options || {}

  local path = Path( "Follow" )
  path:SetMinLookAheadDistance( 30 )
  path:SetGoalTolerance( 20 )

  path:Compute( self, location )

  if ( !path:IsValid() ) then return "failed" end

  while ( path:IsValid() && location ) do

    if ( self:HaveEnemy() ) then break end

    if ( !( self && self:IsValid() ) ) then break end

    self:FootStepThink()

    if ( path:GetAge() > .8 ) then

      path:Compute( self, location )

    end

    if ( self.nextIdle < CurTime() ) then

      self:IdleSound()

      self.nextIdle = CurTime() + math.random( 12, 18 )

    end

    if ( self.loco:IsStuck() ) then

      self:HandleStuck()

      return "stuck"
    end

    path:Update( self )

    if ( self:GetPos():DistToSqr( location ) < 3000 ) then break end

    coroutine.yield()

  end

  return "ok"

end

function ENT:Wander( pos, options )

  local nav = navmesh.GetNearestNavArea( pos )

  if ( !IsValid( nav ) || nav:GetClosestPointOnArea( pos ):DistToSqr( pos ) > 150 * 150 ) then

    self.nextWander = CurTime() + self.idleTime

    return
  end

  local options = options || {}

  local path = Path( "Follow" )
  path:SetMinLookAheadDistance( options.lookahead || 300 )
  path:SetGoalTolerance( options.tolerance || 20 )
  path:Compute( self, pos )

  if ( !( path && path:IsValid() ) ) then return "failed" end

  while ( path:IsValid() && !self:HaveEnemy() ) do

    local npc_Pos = self:GetPos()

    if ( !self.Stuck && self.loco:IsStuck() ) then

      self.Stuck = true

      local oldLoc = location
      location = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 1000

      local nav = navmesh.GetNearestNavArea( location )

      if ( !IsValid( nav ) || nav:GetClosestPointOnArea( location ):DistToSqr( location ) > 10000 ) then

        self.nextWander = CurTime() + self.idleTime

        break
      end

      path:Compute( self, location )

      local function temp()

        self.Stuck = false

      end

      self:delay( 1, temp )

    end

    self:DoorStuck( true )
    self:FootStepThink()

    if ( path:GetAge() > 330 / self.Speed ) then

      self.nextWander = CurTime() + self.idleTime

      break
    end

    if ( self.nextIdle < CurTime() ) then

      self:IdleSound()
      self.nextIdle = CurTime() + math.random( 10, 15 )

    end

    if ( npc_Pos:DistToSqr( pos ) < 2500 || path:GetAge() > 30 ) then

      pos = npc_Pos + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 800

      local nav = navmesh.GetNearestNavArea( pos )

      if ( !IsValid( nav ) || nav:GetClosestPointOnArea( pos ):DistToSqr( pos ) > 10000 ) then break end

      path:Compute( self, pos )

    end

    path:Update( self )

    coroutine.yield()

  end

  return "ok"

end

function ENT:GetDoor( ent ) return false end

function ENT:CustomChaseEnemy() end

function ENT:CustomPropAttack()

  if ( ( self.NextPropAttackTimer || 0 ) < CurTime() ) then

    --self:AttackSound()
    self.loco:SetDeceleration( 0 )
    self.IsAttacking = true

    if ( isnumber( self.AttackAnim ) ) then

      self:StartActivity( self.AttackAnim )
      coroutine.wait( 1 )

    else

      self:PlaySequenceAndWait( self.AttackAnim, 1 )

    end

    self:AttackEffect( self.AttackFinishTime, ent, self.Damage, 1, 1 )
    self.loco:SetDeceleration( 900 )

    self.NextPropAttackTimer = CurTime() + self.NextAttack

  end

end

function ENT:GetEnemy()

  return self.Enemy

end

function ENT:SetEnemy( ent )

  if ( !( ent && ent:IsValid() ) ) then return nil end

  self.Enemy = ent

  if ( ent != self.OldEnemy ) then

    self:AlertSound()
    self:OnAlert()

  end

  return ent

end

function ENT:CanSeePos( pos1, pos2, filter )

  local trace = {}
  trace.start = pos1
  trace.endpos = pos2
  trace.filter = filter
  trace.mask = MASK_SHOT
  local tr = util.TraceLine( trace )

  if ( tr.Fraction == 1.0 ) then return true end

  return false

end

function ENT:CanSeePlayer( ply )

  if self:CantBeInHere(ply:GetPos()) then
    return false
  end

  return self:CanSeePos( self:EyePos(), ply:EyePos(), { self, ply } )

end

local team_scp_index = TEAM_SCP

function ENT:SearchForEnemy( ents )

  for _, v in ipairs( ents ) do

    if ( v:IsPlayer() && v:Health() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && !v:GetNoDraw() ) then

      if ( self:CanSeePlayer( v ) ) then

        return self:SetEnemy( v )

      end

    end

  end

  return self:SetEnemy( nil )

end

function ENT:FindEnemy()

  return self.EyeSerach && self:SearchForEnemy( ents.FindInCone( self:GetPos(), self:GetForward() * self.SearchRadius, self.SearchRadius, 155 ) ) || self:SearchForEnemy( ents.FindInSphere( self:GetPos(), 300 ) )

end

function ENT:HaveEnemy()

  local enemy = self:GetEnemy()

  if ( !( enemy && enemy:IsValid() ) ) then

    return self:FindEnemy()

  end

  if self:CantBeInHere(enemy:GetPos()) then

    return self:FindEnemy()

  end

  if ( self.retargetTime < CurTime() ) then

    self.OldEnemy = enemy

    self.retargetTime = CurTime() + 3

    return self:FindEnemy()

  end

  if ( enemy:IsPlayer() && !enemy:Alive() ) then

    return self:FindEnemy()

  end

  if ( enemy:IsNPC() && enemy:Health() < 0 ) then

    return self:FindEnemy()

  end

  return enemy
end

function ENT:Enrage() end

function ENT:Calm() end

function ENT:OnAlert() end

function ENT:CustomThinkClient() end

function ENT:Shadow()

  self.pitch = self.pitch - 40
  self:SetBloodColor( DONT_BLEED )
  self:SetRenderMode( RENDERMODE_TRANSALPHA )
  self:SetColor( color_black )
  self:SetRenderFX( kRenderFxDistort )
  self.Ignites = false

end
