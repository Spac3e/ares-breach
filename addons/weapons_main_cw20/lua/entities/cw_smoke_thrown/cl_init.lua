--[[


addons/[weapons]_cw_20/lua/entities/cw_smoke_thrown/cl_init.lua

--]]

include("shared.lua")

function ENT:Initialize()
	self.Entity.Emitter = ParticleEmitter(self.Entity:GetPos())
	self.Entity.ParticleDelay = 0
end

function ENT:Draw()
	self.Entity:DrawModel()
end