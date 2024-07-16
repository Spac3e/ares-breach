AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetPos(Vector(-3643, 5276, 1690))

	//self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	//self:PhysicsInit( SOLID_VPHYSICS )
	//self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetModel("models/props_junk/watermelon01.mdl")

    //local phys = self:GetPhysicsObject()
	//if (phys:IsValid()) then
		//phys:Wake()
	//end

	timer.Simple(100, function()
		if not IsValid(self) then
			return
		end

		self:Remove()
	end)
end
 
function ENT:Use( activator, caller )
	return
end

local canescape = {
	[TEAM_DZ] = true,
	[TEAM_SCP] = true
}
 
function ENT:Think()
	for k,v in pairs(ents.FindInSphere(Vector(-3643, 5276, 1690), 50)) do
		if v:IsPlayer() and v:Alive() and canescape[v:GTeam()] then
			v:AddToStatistics("l:ending_tp_to_unknown_loc", 900)
			v:Evacuate()
		end
	end
end