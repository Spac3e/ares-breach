AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("AlphaWarheadTimer_CLIENTSIDE")
util.AddNetworkString("NukeStart")

function ENT:UpdateNukeTimer(time, remove)
    local time = time or 0
    local remove = remove or false

    net.Start("AlphaWarheadTimer_CLIENTSIDE")
        net.WriteString(time)
        net.WriteBool(remove)
    net.Broadcast()
end

function ENT:AddStatistics(reason, value)
    for _, v in ipairs(player.GetAll()) do
        if v:GTeam() != TEAM_GOC then
            return
        end

        if not v:GetModel():find("goc") then
            return
        end

        v:AddToStatistics(reason, value)
    end
end

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetUseType(SIMPLE_USE)
    self:SetActivated(false)
    self:SetDeactivationTime(0)

    self:SetPos(Vector( -36.187725, -7187.614746, -2239.251465 ))
    self:SetRenderMode(1)

    self.TurningOn = false
end

function ENT:Use(ply)
    if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then
        return
    end

    if (ply.nukeuse or 0) > CurTime() then
        return
    end

    ply.nukeuse = CurTime() + 1

    if GetGlobalBool("Evacuation") then return end

    if ply:GTeam() == TEAM_GOC and ply:GetModel():find("goc") and not self:GetActivated() and not self.TurningOn then
        if timer.Exists("NukeTimer") and timer.TimeLeft("NukeTimer") then
            self:ResumeNuke()
        else
            self:StartNuke()
            self:AddStatistics("l:sgoc_first_objective_completed", 700)
        end
    elseif not self.TurningOn and ply:GTeam() != TEAM_GOC and timer.Exists("NukeTimer") and GetGlobalBool("NukeTime") and timer.TimeLeft("NukeTimer") > 20 then
        self:StopNuke()
    end
end

local function NukeBool(bool)
    net.Start("NukeStart")
    net.WriteBool(bool)
    net.Broadcast()

    SetGlobalBool("NukeTime", bool)
end

function ENT:StartNukeSequence()
    local moni = ents.Create("alphawarhead_monitor")
    moni:Spawn()

    NukeBool(true)

    PlayAnnouncer("nextoren/sl/warheadcrank.ogg")
end

function ENT:RemoveMonitor()
    for _, v in ipairs(ents.FindByClass("alphawarhead_monitor")) do
        v:Remove()
    end
end

function ENT:StartNuke()
    for _, v in ipairs(player.GetAll()) do v:bSendLua('FadeMusic(1)') end

    self:StartNukeSequence()

    PlayAnnouncer("no_music/nukes/goc_nuke.ogg")

    RoundPauseTimers()

    timer.Create("StartingTime", 14, 1, function()
        if not IsValid(self) then
            return
        end

        PlayAnnouncer("nextoren/round_sounds/main_decont/final_nuke.mp3")

        for _, v in ipairs(player.GetAll()) do
            v:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "l:goc_nuke_start", Color(255, 0, 0))
        end

        SetGlobalBool("Evacuation_HUD", true)

        timer.Create("NukeTimer", self.ExplosionTime, 1, function()
            self:Detonate()
        end)

        self:UpdateNukeTimer(timer.TimeLeft("NukeTimer"))

        self:SetActivated(true)
        self.TurningOn = false
    end)

    self.TurningOn = true
end

function ENT:StopNuke()
    for _, v in ipairs(player.GetAll()) do
        v:bSendLua('RunConsoleCommand("stopsound")')
        v:BrTip(0, "[Ares Breach]", Color(255, 0, 0), "Альфа-Боеголовка была отключена, соблюдайте бдительность!", Color(0, 255, 0))
    end

    self:SetActivated(false)

    NukeBool(false)

    timer.Pause("NukeTimer")

    self:RemoveMonitor()
    self:UpdateNukeTimer(nil, true)

    SetGlobalBool("Evacuation_HUD", false)

    RoundResumeTimers()

    timer.Simple(0.1, function()
        PlayAnnouncer("nextoren/round_sounds/intercom/goc_nuke_cancel.mp3")
    end)

    self:SetDeactivationTime(CurTime() + 5)
end

function ENT:ResumeNuke()
    if (self:GetDeactivationTime() or 0) > CurTime() then
        return
    end

    local closestdecision = nil
    local closestdiff = math.huge

    for _, v in ipairs(player.GetAll()) do
        v:SendLua('FadeMusic(1)')
    end

    self:StartNukeSequence()

    local trim = string.TrimLeft(timer.TimeLeft("NukeTimer"), "-")
    local timeleft = tonumber(trim)
    
    self.TurningOn = true

    RoundPauseTimers()

    timer.Create("StartingTime", 14, 1, function()
        if not IsValid(self) then
            return
        end

        if timeleft >= 90 then
            timeleft = 90
        end
    
        local newtimeleft = math.max(timeleft, 0) + 7

        timer.UnPause("NukeTimer")

        if timer.Exists("NukeTimer") then
            timer.Adjust("NukeTimer", newtimeleft, 1, function()
                self:Detonate()
            end)
        else
            timer.Create("NukeTimer", newtimeleft, 1, function()
                self:Detonate()
            end)
        end

        self:UpdateNukeTimer(timer.TimeLeft("NukeTimer"))
        self:SetActivated(true)

        self.TurningOn = false

        for _, decision in ipairs(BREACH.TimeDecision) do
            local diff = math.abs(newtimeleft - decision.triggertime)
            if diff < closestdiff then
                closestdiff = diff
                closestdecision = decision
            end
        end

        if closestdecision then
            PlayAnnouncer(closestdecision.sound)
        end   
    end)
end

function ENT:Detonate()
    RoundEnd("l:roundend_alphawarheadgoc")
end

function ENT:Evacuate()
    self:AddStatistics("l:activated_warhead", 900)

    for _, v in ipairs(player.GetAll()) do
        if v:GTeam() != TEAM_GOC then
            return
        end

        net.Start("ThirdPersonCutscene", true)
        net.WriteUInt(2, 4)
        net.WriteBool(false)
        net.Send(v)
        
        BroadcastLua("ParticleEffectAttach(\"mr_portal_1a\", PATTACH_POINT_FOLLOW, Entity(" .. v:EntIndex() .. "), Entity(" .. v:EntIndex() .. "):LookupAttachment(\"waist\"))")
       
        v:SetMoveType(MOVETYPE_OBSERVER)
        v:EmitSound("nextoren/others/introfirstshockwave.wav", 115, 100, 1.4)
        v:GodEnable()

        timer.Create("goc_teleport" .. v:SteamID64(), 1.7, 1, function()
            local pos = v:GetPos()

            v:StopParticles()
            v:SetMoveType(MOVETYPE_WALK)
            v:GodDisable()

            v:LevelBar()
            v:SetupNormal()
            v:SetSpectator()

            v:SetPos(pos)
        end)

        v:SetForcedAnimation(v:LookupSequence("MPF_Deploy"))
    end
end

function ENT:Think()
    self:NextThink(CurTime() + 1)

    if timer.Exists("NukeTimer") then
        local timeleft = string.Left(timer.TimeLeft("NukeTimer"), 2)
        if timeleft == "30" then
            self:Evacuate()
        end
    end

    return true
end

function ENT:OnRemove()
    timer.Remove("NukeTimer")
    SetGlobalBool("Evacuation_HUD", false)
    NukeBool(false)

    self:RemoveMonitor()
    self:UpdateNukeTimer(nil, true)
end

scripted_ents.Register(ENT, "warhead")