ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Spawnable = true

function ENT:SetupDataTables()
  self:NetworkVar( "Bool", 0, "BroadcastStatus" );
  self:NetworkVar( "Float", 0, "SupportChannel" )
end