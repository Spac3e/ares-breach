include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
    local parent = self:GetParent()

    self:DrawModel()
end


function ENT:Think()
    local parent = self:GetParent()

    if (!IsValid(parent) and self:EntIndex() == -1) then self:Remove() return end

    local parent_valid = parent and parent:IsValid()
    if not parent_valid and self:EntIndex() == -1 then
        self:Remove()
    elseif not parent_valid then
        return
    end

    if not parent:IsPlayer() then return end
    local parent_nodraw = parent:GetNoDraw()
    local self_nodraw = self:GetNoDraw()
    if parent_valid and parent_nodraw and not self_nodraw then
        self:SetNoDraw(true)
        self.no_draw = true
    elseif parent_valid and not parent_nodraw and self_nodraw then
        self:SetNoDraw(false)
        self.no_draw = false
    end
end
