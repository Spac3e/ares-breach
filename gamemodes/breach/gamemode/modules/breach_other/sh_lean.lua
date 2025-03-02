local PMETA = FindMetaTable("Player")

do
    PMETA.old_getshootpos = PMETA.old_getshootpos or PMETA.GetShootPos
    PMETA.old_eyepos = PMETA.old_eyepos or PMETA.EyePos

    function PMETA:GetShootPos()
        local offset = Vector(0, self:GetNW2Int("LeanOffset"), 0)
        offset:Rotate(self:EyeAngles())
        local _, result = pcall(self.old_getshootpos, self)
        return result - offset
    end

    function PMETA:EyePos()
        local offset = Vector(0, self:GetNW2Int("LeanOffset"), 0)
        offset:Rotate(self:EyeAngles())
        local _, result = pcall(self.old_eyepos, self)
        return result - offset
    end
end

local function Angle_Offset(new, old)
    return select(2, WorldToLocal(vector_origin, new, vector_origin, old))
end

function PMETA:IsLeaning()
    return self:GetNW2Int("LeanOffset") ~= 0
end

function RollBone(player, bone, pitch)
    player:ManipulateBoneAngles(bone, angle_zero)
    local boneMat = player:GetBoneMatrix(bone)
    if not boneMat then return end
    local boneAngle = boneMat:GetAngles()
    local boneAngleOG = boneMat:GetAngles()
    boneAngle:RotateAroundAxis(player:EyeAngles():Forward(), pitch)
    player:ManipulateBoneAngles(bone, Angle_Offset(boneAngle, boneAngleOG))
end

hook.Add("PlayerSpawn", "ResetLeanStatus", function(player)
    player:SetNW2Int("LeanOffset", 0)
    player.OldStatus = nil
end)

hook.Add("PlayerSwitchWeapon", "ResetLeanStatus", function(player)
    player:SetNW2Int("LeanOffset", 0)
    player.OldStatus = nil
end)

function CanLean(target)
    if not target.leancd then target.leancd = 1 end
    if not IsValid(target:GetActiveWeapon()) or not target:GetActiveWeapon().CW20Weapon then return false end
    if target:GetVelocity():Length2DSqr() > 22500 then return false end
    return not (target:IsFrozen() or target.MovementLocked or target:GTeam() == TEAM_SCP or target.ForceAnimSequence or target.leancd >= CurTime())
end

if SERVER then
    util.AddNetworkString("Cancel_Lean")
    util.AddNetworkString("Trigger_Lean")
    net.Receive("Cancel_Lean", function(len, player)
        if not player.leancd then player.leancd = CurTime() end
        player.leancd = CurTime() + 0.5
        player:SetNW2Int("LeanOffset", 0)
        player.OldStatus = nil
    end)

    function Trigger_Lean(len, player, forcebutt)
        local key_button
        if forcebutt then
            key_button = forcebutt
        else
            key_button = net.ReadUInt(2)
        end

        if not player.leancd then player.leancd = CurTime() end
        if not CanLean(player) then return end
        if key_button == 2 then
            if player:GetNW2Int("LeanOffset") ~= 10 then
                if player:IsLeaning() then player.leancd = CurTime() + 0.5 end
                player:SetNW2Int("LeanOffset", 10)
                player.OldStatus = nil
            else
                player.leancd = CurTime() + 0.5
                player:SetNW2Int("LeanOffset", 0)
                player.OldStatus = nil
            end
        else
            if player:GetNW2Int("LeanOffset") ~= -10 then
                if player:IsLeaning() then player.leancd = CurTime() + 0.5 end
                player:SetNW2Int("LeanOffset", -10)
                player.OldStatus = nil
            else
                player.leancd = CurTime() + 0.5
                player:SetNW2Int("LeanOffset", 0)
                player.OldStatus = nil
            end
        end
    end

    net.Receive("Trigger_Lean", Trigger_Lean)
    local function Lean_Synch(player)
        if not CanLean(player) then player:SetNW2Int("LeanOffset", 0) end
        if player.OldStatus == nil then
            player.OldStatus = player:IsLeaning()
            local offset = player:GetNW2Int("LeanOffset")
            RollBone(player, 1, offset)
            RollBone(player, 2, offset)
            RollBone(player, 3, offset)
            RollBone(player, 4, offset)
        end
    end

    hook.Add("PlayerThink", "Lean_Synchronization", Lean_Synch)
end

if CLIENT then
    local function offsetfix(seq, val)
        if val < 0 then val = val * 1.3 end
        if seq == 295 then
            if val > 0 then return val * 0.7 end
        elseif seq == 3005 then
            if val < 0 then return val * 0.7 end
        else
            if val > 0 then val = val * 1.2 end
        end
        return val
    end

    local function Lean_Lerp(delta, from, to)
        return (1 - delta) * from + delta * to
    end

    local function ThirdPerson_Lean()
        local players = player.GetAll()
        for i = 1, #players do
            local player = players[i]
            if player and player:IsValid() and player:IsSolid() then
                if not player.RealLean then player.RealLean = 0 end
                if player.RealLean ~= 0 and not player:IsLeaning() or not CanLean(player) then
                    player.RealLean = math.Approach(player.RealLean, 0, FrameTime() * 40)
                    local offset = offsetfix(player.CalcSeqOverride, player.RealLean)
                    RollBone(player, 1, offset)
                    RollBone(player, 2, offset)
                    RollBone(player, 3, offset)
                    RollBone(player, 4, offset)
                    continue
                end

                if player:IsLeaning() then
                    player.RealLean = Lean_Lerp(FrameTime() * 10, player.RealLean, player:GetNW2Int("LeanOffset"))
                    local offset = offsetfix(player.CalcSeqOverride, player.RealLean)
                    RollBone(player, 1, offset)
                    RollBone(player, 2, offset)
                    RollBone(player, 3, offset)
                    RollBone(player, 4, offset)
                end
            end
        end
    end

    hook.Add("PreRender", "LeanPlayerRendering", function() ThirdPerson_Lean() end)
    local banned_Teams = {
        [TEAM_SCP] = true,
        [TEAM_SPEC] = true
    }

    hook.Add("PlayerButtonDown", "Lean_Trigger", function(client, button)
        if IsFirstTimePredicted() then
            if banned_Teams[client:GTeam()] or client.MovementLocked or client:IsFrozen() or client:GetVelocity():Length2DSqr() > 22500 then return end
            local wep = client:GetActiveWeapon()
            if wep ~= NULL and wep.CW20Weapon and wep.dt.State == CW_CUSTOMIZE then return end
            if IsValid(BREACH.QuickChatPanel) then return end
            if button == GetConVar("breach_config_leanleft"):GetInt() then
                net.Start("Trigger_Lean", true)
                net.WriteUInt(1, 2)
                net.SendToServer()
            elseif button == GetConVar("breach_config_leanright"):GetInt() then
                net.Start("Trigger_Lean", true)
                net.WriteUInt(2, 2)
                net.SendToServer()
            end
        end
    end)
end

if CLIENT then
    hook.Add("PlayerButtonDown", "DisableLean", function(ply, button)
        if ply:IsLeaning() and ply:KeyDown(IN_SPEED) and IsFirstTimePredicted() then
            net.Start("Cancel_Lean", true)
            net.SendToServer()
        end
    end)
end