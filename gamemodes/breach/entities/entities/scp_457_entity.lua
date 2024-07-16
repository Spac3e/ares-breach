AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.WallModel = Model( "models/hunter/plates/plate5x5.mdl" )

function ENT:Initialize()

  self:SetModel( self.WallModel )
  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )

  if ( SERVER ) then

    self:SetTrigger( true )

  end

  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

  self.TimeCreation = CurTime()

  if ( self:EntIndex() != -1 ) then

    self.EndMove = self:GetPos() + self:GetAngles():Up() * 1024

  end

  self:SetRenderMode( 1 )

end

function ENT:Think()

  self:NextThink( CurTime() )

  if ( self.TimeCreation < CurTime() - 5 ) then

    if ( SERVER ) then

      self:Remove()

    elseif ( self:EntIndex() == -1 ) then

      self:StopParticles()
      SafeRemoveEntity( self )

    end

  else

    self:SetPos( Vector( math.Approach( self:GetPos().x, self.EndMove.x, FrameTime() * 512 ), math.Approach( self:GetPos().y, self.EndMove.y, FrameTime() * 512 ), self:GetPos().z ) )

  end

  return true
end

function ENT:ShouldCollide( ply )

  return false

end

function ENT:StartTouch( ply )

  if ( ply && ply:IsValid() && ply:IsPlayer() && !( ply:Team() == TEAM_SPEC || ply:Team() == TEAM_SCP ) ) then

    ply:IgniteSequence( 7 )

  end

end

function ENT:Draw()

  --self:DrawModel()
  self:DestroyShadow()

end
