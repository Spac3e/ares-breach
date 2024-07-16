util.AddNetworkString("BREACHObserverFlashlight")

hook.Add("CanPlayerEnterVehicle", "BREACH.Observer-CanEnterVehicle", function(ply)
	if (ply:GetMoveType() == MOVETYPE_NOCLIP) then
		return false
	end
end)

/*
hook.Add("PlayerSwitchFlashlight", "BREACH.Observer-PlayerSwitchFlashlight", function(ply, state)
    if IsValid(ply) and ply:IsAdmin() and ply:Alive() and not ply:InVehicle() and ply:GetMoveType() == MOVETYPE_NOCLIP and ply:GTeam() != TEAM_SPEC then
        if ply:GetNWBool("observerLight") then
            ply:SetNWBool("observerLight", false)

            net.Start("BREACHObserverFlashlight")
            net.Send(ply)

			return false
        else
            net.Start("BREACHObserverFlashlight")
            net.Send(ply)
        
            ply:SetNWBool("observerLight", true)    

			return false
        end
    end
end)
*/