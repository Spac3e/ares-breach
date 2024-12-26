util.AddNetworkString("PlayTaunt")
util.AddNetworkString("UpdateClientHoldType")
util.AddNetworkString("smooth_lerp_gest")
util.AddNetworkString("DropAnimation")

hook.Add("PlayerSay", "TalkingAnim", function(ply, text, teamchat)
    if teamchat == true then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:Alive() then return end
    if (string.StartWith(text, "!") or string.StartWith(text, "/")) then return end
    if utf8.len(text) < 2 then return end
    if ply:GTeam() == TEAM_SPEC or ply:GTeam() == TEAM_SCP then return end

    local GM = GAMEMODE or GM
    GM:DoChatGesture(ply, 1, text)
end)

net.Receive("PlayTaunt", function(len, ply)
    local taunt = net.ReadString()

    if not ply:Alive() or ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then
        return
    end

    if ply.ForceAnimSequence then return end

    if (ply.nexttauntcd or 0) > CurTime() then return end

    ply.nexttauntcd = CurTime() + 5

    net.Start("smooth_lerp_gest")
        net.WriteEntity(ply)
        net.WriteFloat(5)
    net.SendPVS(ply:GetPos())

    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(taunt), 0, true)

    net.Start("GestureClientNetworking")
        net.WriteEntity(ply)
        net.WriteString(taunt)
        net.WriteUInt(GESTURE_SLOT_CUSTOM, 3)
        net.WriteBool(true)
    net.SendPVS(ply:GetPos())
end)

net.Receive("DropAnimation", function(len, ply)
    if not ply or not ply:Alive() then return end

    if ply.ForceAnimSequence then return end

    --if ply.playinsupacoolanim then 
        --timer.Simple(0.4, function() ply.playinsupacoolanim = nil end) 
        --return 
    --end

    --ply.playinsupacoolanim = true

    local taunt = "2renThrow"

    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, ply:LookupSequence(taunt), 0, true)

    net.Start("GestureClientNetworking")
    net.WriteEntity(ply)
    net.WriteString(taunt)
    net.WriteUInt(GESTURE_SLOT_VCD, 3)
    net.WriteBool(true)
    net.SendPVS(ply:GetPos())
end)
