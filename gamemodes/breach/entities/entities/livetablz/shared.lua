ENT.Type = "anim"
ENT.PrintName = "LZ Status Monitor"
ENT.Spawnable = true

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "EmergencyMode" )
  self:NetworkVar( "Float", 0, "DecontTimer" )

  self:SetEmergencyMode( false )
  self:SetDecontTimer(100)

end