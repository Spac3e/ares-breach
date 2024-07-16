AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:Initialize()
	self.Entity:SetModel("models/bshields/dshield_open.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetRenderMode( RENDERMODE_TRANSCOLOR )	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1500)
	end
end
