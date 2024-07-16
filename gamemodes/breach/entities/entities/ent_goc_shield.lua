AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/props_breach/goc_shield.mdl" )

sound.Add( {

  name = "goc_shield.on",
  channel = CHAN_STATIC,
  volume = .95,
  pitch = { 90, 100 },
  sound = "nextoren/entities/goc_shield/on.wav"

} )

sound.Add( {

  name = "goc_shield.idle",
  channel = CHAN_STATIC,
  volume = .6,
  pitch = 100,
  sound = "ambient/machines/combine_shield_loop3.wav"

} )

sound.Add( {

  name = "goc_shield.off",
  channel = CHAN_STATIC,
  volume = .8,
  pitch = { 90, 100 },
  sound = "nextoren/entities/goc_shield/off.wav"

} )

sound.Add( {

  name = "goc_shield.block",
  channel = CHAN_STATIC,
  volume = 1,
  channel = 110,
  pitch = { 100, 110 },
  sound = "nextoren/entities/goc_shield/block.wav"

} )

--local min, max = Vector( -10, 50, 0 ), Vector( -12, -50, 90 )

function ENT:Initialize()

  self:SetModel( self.Model )

  --[[self:PhysicsInitMultiConvex( {

    {

      Vector( min.x, min.y, min.z ),
    	Vector( min.x, min.y, max.z ),
    	Vector( min.x, max.y, min.z ),
    	Vector( min.x, max.y, max.z ),
    	Vector( max.x, min.y, min.z ),
    	Vector( max.x, min.y, max.z ),
    	Vector( max.x, max.y, min.z ),
    	Vector( max.x, max.y, max.z )

    }

  } )]]

  self:SetSolid( SOLID_VPHYSICS )
  self:AddEffects( EF_NOSHADOW )

  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
  self:SetMoveType( MOVETYPE_NONE )

  --self:EnableCustomCollisions( true )

  self:SetModelScale( .45, 0 )
  self:Activate()

  self:EmitSound( "goc_shield.on" )

  if ( SERVER ) then

    --self:SetTrigger( true )

    timer.Simple( .65, function()

      if ( self && self:IsValid() ) then

        self:EmitSound( "goc_shield.idle" )

      end

    end )

  end

  self.DeathTime = CurTime() + 20

  if ( CLIENT ) then

    self:SetNextClientThink( -1293 )

  end

  self:PhysWake()

end

function ENT:UpdatePosition()

  local player = self:GetOwner()
  local eye_ang = player:EyeAngles()
  local forward_vec = eye_ang:Forward()
  forward_vec.z = 0

  local end_position = player:GetPos() + forward_vec * 100
  local end_trace_pos = end_position + forward_vec * 16

  local trace = {}
  trace.start = player:GetShootPos()
  trace.endpos = end_trace_pos
  trace.mask = MASK_SHOT
  trace.filter = { player, self }

  trace = util.TraceLine( trace )

  local dist = trace.HitPos:DistToSqr( end_trace_pos )

  if ( dist != 0 ) then

    end_position = end_position - forward_vec * math.sqrt( dist ) * 1.2

  end

  self:SetPos( end_position )
  self:SetAngles( Angle( 0, eye_ang.y, 0 ) )

end

function ENT:OnRemove()

  self:StopSound( "goc_shield.idle" )

end

if ( SERVER ) then

  function ENT:Think()

    if ( !( self.Owner && self.Owner:IsValid() ) || self.Owner:Health() <= 0 ) then

      self:Remove()

      return
    end

    if ( !( self.Owner && self.Owner:IsValid() ) ) then

      self:Remove()

      return
    end

    if ( !self.StartDisable && ( self.DeathTime - .75 ) <= CurTime() ) then

      self.StartDisable = true
      self:EmitSound( "goc_shield.off" )

    end

    if ( self.DeathTime <= CurTime() ) then

      self:Remove()

      return
    end

    self:UpdatePosition()

  end

else

  function ENT:Think()

    self:UpdatePosition()

  end

  function ENT:Draw()

    --[[render.SetMaterial( SHIELD_MATERIAL )
    render.DrawBox( self:GetPos(), self:GetAngles(), min, max )]]

    if ( !self.StartDisable && ( self.DeathTime - .75 ) <= CurTime() ) then

      self.StartDisable = true

    end

    if ( !self.StartDisable || math.sin( CurTime() * ( 10 * ( 1 * ( ( CurTime() - self.DeathTime - .75 ) / 20 ) ) ) ) > .75 ) then

      self:DrawModel()

    end

    --render.DrawWireframeBox( self:GetPos(), self:GetAngles(), min, max, col )

  end

end
