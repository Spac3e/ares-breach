--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_ww2_c4_de/cl_init.lua

--]]

include("shared.lua")

function ENT:Initialize()
	ParticleEffectAttach(self.fuseParticles, PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:Draw()
	self.Entity:DrawModel()
end
