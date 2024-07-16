include('shared.lua')

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

/*---------------------------------------------------------
   Overridden because I want to show the name of the 
   player that spawned it..
---------------------------------------------------------*/
function ENT:GetOverlayText()

	return self:GetPlayerName()	
	
end
