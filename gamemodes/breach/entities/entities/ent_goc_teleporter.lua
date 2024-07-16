AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "GOC Teleporter"
ENT.Model = "models/shaky/goc_teleporter.mdl"

function ENT:Initialize()

  self:SetModel( self.Model )

  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_VPHYSICS )

  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

  if ( CLIENT ) then
    return
  end

  self:EmitSound( "goc_specialist/goc_teleporter_deploy.wav" )

  --sound.Play( "goc_specialist/goc_teleporter_deploy.wav", self:GetPos() )

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end

if ( SERVER ) then

  function ENT:OnTakeDamage()

    --if ( self:GetTriggered() ) then return end

    --self:SetTriggered( true )

    --self:Explode( self:GetPos() )

    if IsValid(self:GetOwner()) then
      if self:GetOwner():GTeam() != TEAM_SPEC then
        self:GetOwner():AresNotify("Ваш телепорт был уничтожен!")
      end
    end

    self:Remove()

  end

  function ENT:Use( activator )

    if ( activator != self:GetOwner() ) then return end

    activator.TempValues.UsedTeleporter = false

    self:Remove()

  end

end
