--[[


addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_particles/cl_init.lua

--]]

include("shared.lua")

function ENT:Initialize()
	local i = self:GetProjectileClass()
	local class = self._dbInt2str[i]

	if class then
		ed = EffectData()
		ed:SetEntity(self)
		util.Effect(self.db[class].effectClass, ed)
	end
end

function ENT:Draw()
end
