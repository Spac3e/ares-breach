AddCSLuaFile()

ENT.Type = "anim"

ENT.Name = "SCP-2012 Shield"
ENT.Category = "[BREACH] Others"

ENT.RenderGroups = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/scp/scp2012/scp_shield.mdl" )

local min, max = Vector( 14, 34, 0 ), Vector( -14, -22, 8 )

if ( SERVER ) then

  function ENT:Initialize()

    self:SetModel( self.Model )

    self:PhysicsInitConvex( {

      Vector( min.x, min.y, min.z ),
    	Vector( min.x, min.y, max.z ),
    	Vector( min.x, max.y, min.z ),
    	Vector( min.x, max.y, max.z ),
    	Vector( max.x, min.y, min.z ),
    	Vector( max.x, min.y, max.z ),
    	Vector( max.x, max.y, min.z ),
    	Vector( max.x, max.y, max.z )

    } )

    self:SetMoveType( MOVETYPE_VPHYSICS )
	  self:SetSolid( SOLID_VPHYSICS )

    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    self:EnableCustomCollisions( true )

    --self:PhysWake()

  	local phys = self:GetPhysicsObject()

  	if ( phys && phys:IsValid() ) then

    	phys:EnableMotion( false )

    end

  end

else

  function ENT:Initialize()

    local min, max = self:GetCollisionBounds()

    self:PhysicsInitConvex( {

      Vector( min.x, min.y, min.z ),
    	Vector( min.x, min.y, max.z ),
    	Vector( min.x, max.y, min.z ),
    	Vector( min.x, max.y, max.z ),
    	Vector( max.x, min.y, min.z ),
    	Vector( max.x, min.y, max.z ),
    	Vector( max.x, max.y, min.z ),
      Vector( max.x, max.y, max.z )

    } )

    self:SetMoveType( MOVETYPE_VPHYSICS )
	  self:SetSolid( SOLID_VPHYSICS )

	  self:EnableCustomCollisions( true )

  end

  function ENT:Draw()

    if ( LocalPlayer() != self.Owner ) then

      self:DrawModel()

    end

    --render.DrawWireframeBox( self:GetPos(), self:GetAngles(), min, max, color_white )

  end

end
