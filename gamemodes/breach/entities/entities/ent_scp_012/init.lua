AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/scp012comp/scp012comp.mdl")
	self:SetSkin(1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    self:SetPos(Vector(8182, -4640, -223))
    self:SetAngles(Angle(0, 0, 0))

	local phys = self:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then

		phys:Wake()

	end

end

local textureindex = 1
local used = false

local mins, maxs = Vector( -350, -250, -150 ), Vector( -300, -200, -100 )

function ENT:Think()

	if self:GetPos():WithinAABox( mins, maxs ) then return end

	for _, ply in pairs (ents.FindInSphere(self:GetPos(), 123)) do
		if (( ply:IsPlayer() ) and not (ply:GTeam() == TEAM_SCP) and not (ply:GTeam() == TEAM_SPEC) and not ply:HasGodMode()) then

			ply:SetEyeAngles((self:GetPos() - ply:GetShootPos()):Angle())
			ply:SetHealth(ply:Health() - 3)
			ply:EmitSound("ambient/creatures/town_scared_breathing1.wav" ,30 , 100, 1, CHAN_VOICE)
			if ((ply:Health() <= 0) && (SERVER) && ply:Alive()) then

				ply:Kill()

			end

			if (used == false) then

				textureindex = textureindex + 1
				used = true
				timer.Simple(1, function()
					used = false
				end)

			end

			if (textureindex == 5) then

				textureindex = 1

			end

			self:SetSkin(textureindex)

			if ( CLIENT ) then

				self:DrawModel()

			end

		end

	end
end
