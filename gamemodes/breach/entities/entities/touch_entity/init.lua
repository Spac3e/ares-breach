AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
    self:SetModel('models/hunter/blocks/cube025x025x025.mdl')

    self:DrawShadow(false)
    
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)

    self:SetNoDraw(false)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)

    self:SetTrigger(true)
    self:UseTriggerBounds(true)

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Think()
    self.Think()
    
	self:NextThink( CurTime() )

	return true
end

function ENT:Touch(pEntity)
    if !pEntity:IsValid() or !pEntity:IsPlayer() then return end
    return self.TouchFunc(self,self:GetOwner())
end