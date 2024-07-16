ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Helicopter"
ENT.Author = "-Spac3"
ENT.Spawnable = true
ENT.Category = "Breach"

ENT.AutomaticFrameAdvance = true

function ENT:Think()
    self:NextThink(CurTime())
    return true
end