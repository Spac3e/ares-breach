--[[


addons/[weapons]_cw_20/lua/entities/cw_uiu_wh_grenade/cl_init.lua

--]]

include("shared.lua")

local gren_color = Color(215,0,0)

function ENT:Initialize()
	self.Entity.Emitter = ParticleEmitter(self.Entity:GetPos())
	self.Entity.ParticleDelay = 0

	local hookname = "DRAWUIUSPEC_ENT_"..self:EntIndex()

	hook.Add("PreDrawPlayerHands", hookname, function()
		if !IsValid(self) or LocalPlayer():GTeam() != TEAM_USA or !LocalPlayer():Alive() then hook.Remove("PreDrawOutlines", hookname) return end

		if !self:GetFused() then return end

		local Ents = ents.FindInSphere(self:GetPos(),500)

		outline.Add(self, gren_color, 3)

		for i = 1, #Ents do
			local ent = Ents[i]

			if IsValid(ent) and ent:IsPlayer() and ent:Alive() and ent:Health() > 0 and ent != LocalPlayer() and ent:GTeam() != TEAM_SPEC and ent:GTeam() != TEAM_USA then
				outline.Add(ent, gren_color, 3)
			end

		end
	end)
end

function ENT:Think()
end

function ENT:Draw()
	self.Entity:DrawModel()
end

