AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/cultist/scp_items/409/scp_409_big.mdl" )

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )
  self.Can_Obtain = true
  ParticleEffectAttach( "steam_manhole", PATTACH_ABSORIGIN_FOLLOW, self, 1 )

  local physobject = self:GetPhysicsObject()

  if ( physobject:IsValid() ) then

    physobject:EnableMotion( false )

  end

end

function ENT:Use( activator, caller )

  if ( self.Can_Obtain ) then

    if ( SERVER && caller:IsPlayer() ) then

      caller:BreachGive( "weapon_scp_409" )

    end

    if ( caller:HasWeapon( "weapon_scp_409" ) ) then

      caller:SelectWeapon( "weapon_scp_409" )

    end

    self.Can_Obtain = false

  end

end

if ( SERVER ) then

  function ENT:Think()

    for _, v in ipairs( ents.FindInSphere( self:GetPos(), 240 ) ) do

      if ( v:IsPlayer() && v:Health() > 0 && !( v:GTeam() == TEAM_SPEC || v:GetRoleName() == role.ClassD_FartInhaler || v:GTeam() == TEAM_SCP || v:GetRoleName() == role.DZ_Gas ) && !v:HasHazmat() && ( v:GTeam() != TEAM_GOC or v:GetRoleName() == role.ClassD_GOCSpy ) && !v.GASMASK_Equiped ) then

        if ( !v.Infected409 ) then

          v:Start409Infected()

        end

      end

    end

  end

else

  function ENT:Draw()

    self:DrawModel()

  end

end
