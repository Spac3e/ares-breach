AddCSLuaFile()

ENT.Type = "anim"

ENT.Name = "SCP-2012 Shield"
ENT.Category = "[BREACH] Others"

ENT.RenderGroups = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/weapons/shield/w_shield.mdl" )

local min, max = Vector( 10, 22, -28 ), Vector( -0, -11, 29.5 )

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

    local owner = self:GetOwner()

    local bonepos, boneang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
    local owner = owner
    local ang = owner:GetAngles()
    ang.r = ang.r - 90
    ang.y = ang.y - 170

    boneang = ang
    bonepos = bonepos + boneang:Right()*4 + boneang:Up()*-4 + boneang:Forward()*17
    self:SetPos(bonepos)
    self:SetAngles(boneang)
    self:SetParent(owner, 32)
    self:SetLocalPos(Vector(20,11.5,13))
    self:SetLocalAngles(Angle(185,15,90))

  end

  function ENT:Think()
    local owner = self:GetOwner()

    self:SetLocalPos(Vector(20,11.5,13))
    self:SetLocalAngles(Angle(185,15,90))

    if self.ActiveWeapon != owner:GetActiveWeapon() then
      self:Remove()
    end
  end

  function ENT:OnTakeDamage(dmg)
    print(dmginfo:GetAttacker())
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

    --if ( LocalPlayer() != self.Owner ) then

      self:DrawModel()

    --end

    --render.DrawWireframeBox( self:GetPos(), self:GetAngles(), min, max, color_white )

  end

end
