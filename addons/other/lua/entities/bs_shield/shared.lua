--[[


addons/[weapons]_ballistic_shields/lua/entities/bs_shield/shared.lua

--]]

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Deployed shield"
ENT.Category = "Ballistic shields"

ENT.Spawnable = false
ENT.DisableDuplicator = true

function ENT:Use( activator )
	if IsValid( activator ) && activator:IsPlayer() && self.Entity.Owner == activator then
		activator:Give( "deployable_shield" )
		activator:EmitSound( "npc/combine_soldier/gear2.wav" )
		table.RemoveByValue(activator.bs_shields, self.Entity)
		self.Entity:Remove()
	end
end