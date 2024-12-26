util.AddNetworkString("BREACH.Observer.Flashlight")

hook.Add("CanPlayerEnterVehicle", "BREACH.Observer-CanEnterVehicle", function(ply)
	if (ply:GetMoveType() == MOVETYPE_NOCLIP) then
		return false
	end
end)

hook.Add("PlayerNoClip", "BREACH.Observer", function(ply, state)
    if state then
        ply:SetNWBool("observerLight", false)
    end
end)

hook.Add("KeyPress", "BREACH.Observer-ZoomToggle", function(ply, key)
    if key ~= IN_ZOOM then return end

    if ply:GTeam() ~= TEAM_SPEC and not ply:IsAdmin() or ply:GetMoveType() ~= MOVETYPE_NOCLIP and ply:GetNWBool("observerLight") then
        return false
    end
    
    ply:SetNWBool("observerLight", !ply:GetNWBool("observerLight"))
    net.Start("BREACH.Observer.Flashlight")
    net.Send(ply)
end)