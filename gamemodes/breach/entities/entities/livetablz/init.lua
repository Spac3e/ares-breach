AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/next_breach/gas_monitor.mdl")
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    --self:SetAngles(Angle(0, -90, 0))
    self:SetColor(ColorAlpha(color_white, 1))
end
 
function ENT:Use( activator, caller )
	if self:GetEmergencyMode() == true then return end
	if activator:GTeam() == TEAM_GUARD then
		self:SetEmergencyMode( true )
		self:EmitSound( "nextoren/others/button_unlocked.wav") 
		timer.Simple(4, function()
			self:SetEmergencyMode( false )
		end)
	end
end
 
function ENT:Think()
end