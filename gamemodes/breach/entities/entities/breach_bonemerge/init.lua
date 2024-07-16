
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:ReturnToPlayer()
    local owner = self:GetOwner()
    if not IsValid(owner) then
        self:Remove()
        return
    end

    self:SetParent(owner)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetLocalPos(vector_origin)
    self:SetLocalAngles(angle_zero)
    self:AddEffects(EF_BONEMERGE)
    self:AddEffects(EF_BONEMERGE_FASTCULL)
    self:AddEffects(EF_PARENT_ANIMATES)
end

function ENT:Think()
    local parent = self:GetParent()
    if not IsValid(parent) then
        self:ReturnToPlayer()
        return
    end

    if parent:IsPlayer() then
        if not parent:Alive() then
            local rag = parent:getRagdoll()
            if IsValid(rag) then
                self:SetParent(rag)
                self:SetMoveType(MOVETYPE_NONE)
                self:SetLocalPos(vector_origin)
                self:SetLocalAngles(angle_zero)
                self:AddEffects(EF_BONEMERGE)
                self:AddEffects(EF_BONEMERGE_FASTCULL)
                self:AddEffects(EF_PARENT_ANIMATES)
            else
                self:ReturnToPlayer()
            end
        end
    elseif parent:IsRagdoll() then
        local owner = self:GetOwner()
        if IsValid(owner) and owner:IsPlayer() and owner:Alive() then
            self:ReturnToPlayer()
            parent:Remove()
        end
    end
end