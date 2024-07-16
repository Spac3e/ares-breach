--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_n76/cl_init.lua

--]]

include("shared.lua")

function ENT:Initialize()
	self.Entity.Emitter = ParticleEmitter(self.Entity:GetPos())
	self.Entity.ParticleDelay = 0
end

function ENT:Draw()
	self.Entity:DrawModel()
end
