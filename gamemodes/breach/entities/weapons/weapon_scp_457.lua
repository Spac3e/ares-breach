if ( CLIENT ) then

  net.Receive( "create_fake_wall", function()

    local pos = net.ReadVector()
    local ang = net.ReadAngle()
    local end_move = net.ReadVector()

    local fake_wall = ents.CreateClientside( "scp_457_entity" )
    fake_wall:SetPos( pos )
    fake_wall:SetAngles( ang )
    fake_wall.EndMove = end_move
    fake_wall:Spawn()

    ParticleEffectAttach( "gas_explosion_ground_fire", PATTACH_ABSORIGIN_FOLLOW, fake_wall, 0 )

  end )

end

if ( SERVER ) then

  util.AddNetworkString( "create_fake_wall" )

end

SWEP.AbilityIcons = {

  {

    Name = "Inferno Wall",
    Description = "Sets fire on people on contact",
    Cooldown = 45,
    KEY = "RMB",
    Icon = "nextoren/gui/special_abilities/scp_457_wall.png"

  }

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-457"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"
SWEP.ViewModel = ""
SWEP.HoldType = "scp457"
SWEP.Base = "breach_scp_base"
SWEP.IgniteRadius = 220
SWEP.IgniteTime = 2

SWEP.droppable = false

function SWEP:CanPrimaryAttack()

  return false

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:SecondaryAttack()

  if ( ( self.SecondaryAttackCD || 0 ) > CurTime() ) then return end

  self.SecondaryAttackCD = CurTime() + 45
  if ( CLIENT ) then

    self.AbilityIcons[ 1 ].Using = false
    self.AbilityIcons[ 1 ].CooldownTime = CurTime() + tonumber( self.AbilityIcons [ 1 ].Cooldown )

    return
  end

  local inferno_wall = ents.Create( "scp_457_entity" )
  inferno_wall:SetAngles( self.Owner:GetAngles() - Angle( 0, 90, 90 ) )
  inferno_wall:SetPos( self.Owner:GetPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * 60 )
  inferno_wall:Spawn()

  net.Start( "create_fake_wall" )

    net.WriteVector( inferno_wall:GetPos() )
    net.WriteAngle( inferno_wall:GetAngles() )
    net.WriteVector( inferno_wall:GetPos() + inferno_wall:GetAngles():Up() * 1024 )

  net.Broadcast()

end

--[[
if ( SERVER ) then

  hook.Add( "DoPlayerDeath", "Explosion", function( ply )

    if ( ply:GetRoleName() != "SCP457" ) then return end

    ply:StopParticles()

    local current_pos = ply:GetPos()

    local emitter = ents.Create( "base_gmodentity" )
    emitter:SetPos( current_pos )
    emitter:SetNoDraw( true )
    emitter:DrawShadow( false )
    emitter:Spawn()

    net.Start( "CreateParticleAtPos" )

      net.WriteString( "aircraft_destroy_fireballR1" )
      net.WriteVector( current_pos )
      net.WriteEntity( emitter )

    net.Broadcast()

    timer.Simple( .8, function()

      for i = 1, 30 do

        sound.Play( "bullet/explode/large_4.wav", current_pos )

      end

      net.Start( "CreateParticleAtPos" )

        net.WriteString( "gas_explosion_ground_wave" )
        net.WriteVector( current_pos )
        net.WriteEntity( emitter )

      net.Broadcast()

    end )

    timer.Simple( 1.25, function()

      if ( !( ply && ply:IsValid() ) || ply:Health() > 0 ) then return end

      local cdmginfo = DamageInfo()
      cdmginfo:SetDamage( 1800 )
      cdmginfo:SetDamageForce( 1800 * 70 * vector_up )

      cdmginfo:SetDamageType( DMG_BLAST )

      util.BlastDamageInfo( cdmginfo, ply:GetPos(), 1240 )

    end )

    timer.Simple( 15, function()

      if ( emitter && emitter:IsValid() ) then

        emitter:Remove()

      end

    end )

  end )

end]]

function SWEP:CalcViewModelView()

  if ( !self.SmoothSize ) then

    self.SmoothSize = math.random( 200, 300 )

  end

  self.SmoothSize = math.Approach( self.SmoothSize, math.random( 128, 384 ), 2.5 )

  local dynamic_light = DynamicLight( self:EntIndex() )

  if ( dynamic_light ) then

    dynamic_light.Pos = self:GetPos() + self:GetUp() * 2
    dynamic_light.r = 255
    dynamic_light.g = 80
    dynamic_light.b = 0
    dynamic_light.Brightness = 1
    dynamic_light.Size = self.SmoothSize
    dynamic_light.Decay = 2500
    dynamic_light.DieTime = CurTime() + .1

  end

end

function SWEP:DrawWorldModel()

  if ( ( self.NextParticleUpdate || 0 ) < CurTime() && self.Owner != LocalPlayer() ) then

    self.NextParticleUpdate = CurTime() + 2

    self.Owner:StopParticles()
    ParticleEffectAttach( "fire_small_03", PATTACH_POINT_FOLLOW, self.Owner, 5 )

  end

  if ( !self.SmoothSize ) then

    self.SmoothSize = math.random( 200, 300 )

  end

  self.SmoothSize = math.Approach( self.SmoothSize, math.random( 128, 384 ), 2.5 )

  local dynamic_light = DynamicLight( self:EntIndex() )

  if ( dynamic_light ) then

    dynamic_light.Pos = self:GetPos() + self:GetUp() * 2
    dynamic_light.r = 255
    dynamic_light.g = 80
    dynamic_light.b = 0
    dynamic_light.Brightness = 1
    dynamic_light.Size = self.SmoothSize
    dynamic_light.Decay = 2500
    dynamic_light.DieTime = CurTime() + .1

  end

end

function SWEP:Think()

  if ( ( self.int_NextThink || 0 ) > CurTime() ) then return end

  self.int_NextThink = CurTime() + .25

  if ( SERVER ) then

    for _, v in ipairs( ents.FindInSphere( self.Owner:GetPos(), self.IgniteRadius ) ) do

      if ( v && v:IsValid() && v != self.Owner && v:IsPlayer() && v:Health() > 0 && !v.IgniteParticle && !( v:GTeam() == TEAM_SPEC || v:GTeam() == TEAM_SCP || v:GTeam() == TEAM_DZ ) ) then

        self.Owner:SetHealth( math.Clamp( self.Owner:Health() + math.random( 5, 10 ), 0, self.Owner:GetMaxHealth() ) )
        v:IgniteSequence( self.IgniteTime )

      end

    end

  end

end
