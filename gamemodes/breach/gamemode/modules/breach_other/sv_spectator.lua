local PLAYER = FindMetaTable("Player")

spectators = spectators or {}

function spectators.Set(ply, spawn)
    ply:SetRoleName(role.Spectator)
    ply:SetGTeam(TEAM_SPEC)

    ply:SetModel("models/props_junk/watermelon01.mdl")
    ply:SetNoDraw(true)
    ply:SetNoTarget(true)
    ply:SetMoveType(MOVETYPE_NOCLIP)

    ply:Flashlight(false)
    ply:AllowFlashlight(false)

    ply:StripWeapons()
    ply:RemoveAllAmmo()

    ply:SetCanZoom(false)

    if spawn then
        local spawnpos = table.Random(BREACH.MainMenu_Spawns)
        ply:SetPos(spawnpos[1])
        ply:SetEyeAngles(spawnpos[2])
    end

    ply:Spectate(OBS_MODE_ROAMING)
    ply:SetObserverMode(OBS_MODE_ROAMING)

    spectators.InvalidateTargets(ply)

    ply.Active = true
    ply.BaseStats = nil
    ply.UsingArmor = nil
    ply.canblink = false
    ply.handsmodel = nil
    ply.alreadyselectedscp = false
end

PLAYER.SetSpectator = spectators.Set

function spectators.OnDeath(victim)
    if not IsValid(victim) then return end
    local deathPos = victim:GetPos()

    for _, spec in pairs(player.GetAll()) do
        if spec:GTeam() == TEAM_SPEC and spec:GetObserverTarget() == victim then
            spec:UnSpectate()
            spec:Spectate(OBS_MODE_ROAMING)
            spec:SetObserverMode(OBS_MODE_ROAMING)
            spec:SetMoveType(MOVETYPE_NOCLIP)
            spec:SetPos(deathPos)
        end
    end
end

function spectators.Detach(ply)
    if ply:GTeam() != TEAM_SPEC then return end
    local target = ply:GetObserverTarget()

    if IsValid(target) then
        local targetPos = target:GetPos()
        ply:UnSpectate()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SetObserverMode(OBS_MODE_ROAMING)
        ply:SetMoveType(MOVETYPE_NOCLIP)
        ply:SpectateEntity(nil)
        ply:SetPos(targetPos)
    end
end

function spectators.InvalidateTargets(ply)
    local roam = #spectators.GetValidTargets(ply) < 1
    for _, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC and v != ply then
            if v:GetObserverTarget() == ply then
                if roam then
                    v:UnSpectate()
                    v:Spectate(OBS_MODE_ROAMING)
                    v:SetObserverMode(OBS_MODE_ROAMING)
                else
                    spectators.Spectate(v, 1)
                end
            end
        end
    end
end

function spectators.GetValidTargets(ply, all)
    local plys = {}
    for _, v in pairs(player.GetAll()) do
        if all or (v:GTeam() != TEAM_SPEC and not v.supported) then
            table.insert(plys, v)
        end
    end
    return plys
end

function spectators.Spectate(ply, offset)
    if ply:GTeam() != TEAM_SPEC then return end
    ply:SetMoveType(MOVETYPE_NOCLIP)
    local plys = spectators.GetValidTargets(ply)
    if ply:GetObserverMode() == OBS_MODE_ROAMING and #plys > 0 then
        ply:Spectate(OBS_MODE_CHASE)
        ply:SetObserverMode(OBS_MODE_CHASE)
    elseif #plys < 1 then
        ply:UnSpectate()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SetObserverMode(OBS_MODE_ROAMING)
        return
    end

    local cur_target = ply:GetObserverTarget()
    local index = 1
    if IsValid(cur_target) then
        for i, v in ipairs(plys) do
            if v == cur_target then
                index = i + offset
                break
            end
        end
    end

    if index < 1 then
        index = #plys
    elseif index > #plys then
        index = 1
    end

    local target = plys[index]
    if target != cur_target then
        ply:SpectateEntity(target)
    else
        ply:SpectateEntity(nil)
    end

    if IsValid(target) then
        ply:SetPos(target:GetPos()) -- а нужно ли?
    end
end

function spectators.ChangeMode(ply)
    if ply:GTeam() != TEAM_SPEC then return end
    local cur_mode = ply:GetObserverMode()
    local valid_targets = spectators.GetValidTargets(ply)

    if #valid_targets < 1 then
        if cur_mode != OBS_MODE_ROAMING then
            ply:UnSpectate()
            ply:Spectate(OBS_MODE_ROAMING)
            ply:SetObserverMode(OBS_MODE_ROAMING)
            ply:SetMoveType(MOVETYPE_NOCLIP)
        end
        return
    end

    if cur_mode == OBS_MODE_ROAMING then
        ply:Spectate(OBS_MODE_CHASE)
        ply:SetObserverMode(OBS_MODE_CHASE)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    elseif cur_mode == OBS_MODE_CHASE then
        ply:Spectate(OBS_MODE_IN_EYE)
        ply:SetObserverMode(OBS_MODE_IN_EYE)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    elseif cur_mode == OBS_MODE_IN_EYE then
        ply:Spectate(OBS_MODE_CHASE)
        ply:SetObserverMode(OBS_MODE_CHASE)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    end
end

function spectators.RandomSpectate(ply)
    if ply:GTeam() != TEAM_SPEC then return end
    local valid_targets = spectators.GetValidTargets(ply)

    if #valid_targets > 0 then
        local random_target = valid_targets[math.random(1, #valid_targets)]
        ply:Spectate(OBS_MODE_CHASE)
        ply:SetObserverMode(OBS_MODE_CHASE)
        ply:SpectateEntity(random_target)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    else
        ply:UnSpectate()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SetObserverMode(OBS_MODE_ROAMING)
        ply:SetMoveType(MOVETYPE_NOCLIP)
    end
end

hook.Add("KeyPress", "SpectatorKeyPress", function(ply, button)
    if ply:GTeam() != TEAM_SPEC or ply:IsBot() then return end
    local movetype = ply:GetMoveType()
    if movetype != MOVETYPE_NOCLIP then ply:SetMoveType(MOVETYPE_NOCLIP) end

    if ply:KeyDown(IN_USE) and button == IN_ATTACK then
        if IsValid(ply:GetObserverTarget()) then
            spectators.ChangeMode(ply)
        end
    elseif button == IN_ATTACK then
        spectators.Spectate(ply, 1)
    elseif button == IN_ATTACK2 then
        spectators.Spectate(ply, -1)
    elseif button == IN_RELOAD then
        if not IsValid(ply:GetObserverTarget()) then
            spectators.RandomSpectate(ply)
        else
            spectators.Detach(ply)
        end
    end
end)

hook.Add("PlayerDeath", "SpectatorOnDeath", function(victim, inflictor, attacker)
    spectators.OnDeath(victim)
end)