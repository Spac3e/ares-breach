ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Bonemerge entity"
ENT.Author = "BroJou"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Invisible")
    self:SetInvisible(false)
end