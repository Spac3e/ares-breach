local BREACH_GM = GM or GAMEMODE
local FindMetaTable = FindMetaTable
local CurTime = CurTime
local pairs = pairs
local string = string
local table = table
local timer = timer
local hook = hook
local math = math
local mathNormalizeAngle = math.NormalizeAngle
local mathClamp = math.Clamp

BREACH.Animations = BREACH.Animations or {}
BREACH.Animations.MainSequenceTable = BREACH.Animations.MainSequenceTable or {}

local function FindSequenceIDFromTable(str)
    return BREACH.Animations.MainSequenceTable[str] or -1
end

local function custom_FindSequenceIDFromTable(str, tbl)
    return tbl[str] or -1
end

function GenerateSCPTable(holdtype, player) --[[
if SERVER then
  util.AddNetworkString("WeaponChangeGesture")

  --ggitler
  net.Receive("WeaponChangeGesture", function(len, ply)
    ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence("ahl_holster_ar"), 0, true)
  end)
end
--]]
    local scp_animations_table = BREACH.AnimationTable.SCPS
    local current_holdtype_animations = {}
    local search_method
    local current_list = player:GetSequenceList()
    if #current_list > 200 then
        search_method = FindSequenceIDFromTable
        current_list = nil
    else
        search_method = custom_FindSequenceIDFromTable
        new_tbl = {}
        for i = 0, #current_list do
            local sequence_name = current_list[i]
            new_tbl[sequence_name:lower()] = i
        end

        current_list = new_tbl
    end

    for name, animations in pairs(scp_animations_table) do
        if name:find(holdtype .. "_") or name:find("_" .. holdtype) then
            if istable(animations) then
                current_holdtype_animations[holdtype] = current_holdtype_animations[holdtype] or {}
                local current_table
                if name:find(holdtype .. "_") then
                    local name_walktype = string.Replace(name, holdtype .. "_", "")
                    current_holdtype_animations[holdtype][name_walktype] = {}
                    current_table = current_holdtype_animations[holdtype][name_walktype]
                else
                    local name_walktype = string.Replace(name, "_" .. holdtype, "")
                    current_holdtype_animations[holdtype][name_walktype] = {}
                    current_table = current_holdtype_animations[holdtype][name_walktype]
                end

                for _, sequence_name in ipairs(animations) do
                    if current_list then
                        current_table[#current_table + 1] = search_method(sequence_name:lower(), current_list)
                    else
                        current_table[#current_table + 1] = search_method(sequence_name)
                    end
                end
            else
                current_holdtype_animations[holdtype] = current_holdtype_animations[holdtype] or {}
                local seq_name = scp_animations_table[name]
                if name:find(holdtype .. "_") then
                    if current_list then
                        current_holdtype_animations[holdtype][string.Replace(name, holdtype .. "_", "")] = search_method(seq_name:lower(), current_list)
                    else
                        current_holdtype_animations[holdtype][string.Replace(name, holdtype .. "_", "")] = search_method(seq_name)
                    end
                else
                    if current_list then
                        current_holdtype_animations[holdtype][string.Replace(name, holdtype .. "_", "")] = search_method(seq_name:lower(), current_list)
                    else
                        current_holdtype_animations[holdtype][string.Replace(name, "_" .. holdtype, "")] = search_method(seq_name, current_list)
                    end
                end
            end
        end
    end
    return current_holdtype_animations or false
end

function GetMainSequenceTable()
    local createmethod
    if CLIENT then
        createmethod = ents.CreateClientside
    else
        createmethod = ents.Create
    end

    local test_entity = createmethod("base_gmodentity")
    test_entity:SetModel("models/cultist/humans/sci/scientist.mdl")
    test_entity:Spawn()
    local sequence_list = test_entity:GetSequenceList()
    for i = 1, #sequence_list do
        local animation = sequence_list[i]
        BREACH.Animations.MainSequenceTable[animation] = i
    end

    test_entity:Remove()
end

function CreateTestHoldTypeTables()
    local human_holdtypes = {"ar2", "smg", "rpg", "knife", "shield", "shotgun", "zombie", "gauss", "melee2", "crowbar", "items", "heal", "revolver", "keycard", "pass", "slam", "normal", "physgun", "gren", "shotgun", "ww2tdm", "camera", "axe"}
    BREACH.Animations.HumansAnimations = {}
    BREACH.Animations.GuardAnimations = {}
    BREACH.Animations.SoldiersAnimations = {}
    local tables_to_generate = {
        {
            original_tbl = BREACH.AnimationTable.Soldiers,
            tbl_to_use = BREACH.Animations.SoldiersAnimations
        },
        {
            original_tbl = BREACH.AnimationTable.Guards,
            tbl_to_use = BREACH.Animations.GuardAnimations
        },
        {
            original_tbl = BREACH.AnimationTable.maleHuman,
            tbl_to_use = BREACH.Animations.HumansAnimations
        }
    }

    for _, tables in ipairs(tables_to_generate) do
        for animation in pairs(tables.original_tbl) do
            for _, holdtype_name in ipairs(human_holdtypes) do
                if animation:find(holdtype_name) then
                    if istable(tables.original_tbl[animation]) then
                        tables.tbl_to_use[holdtype_name] = tables.tbl_to_use[holdtype_name] or {}
                        local current_table
                        if animation:find(holdtype_name .. "_") then
                            local name_walktype = string.Replace(animation, holdtype_name .. "_", "")
                            tables.tbl_to_use[holdtype_name][name_walktype] = {}
                            current_table = tables.tbl_to_use[holdtype_name][name_walktype]
                        else
                            local name_walktype = string.Replace(animation, "_" .. holdtype_name, "")
                            tables.tbl_to_use[holdtype_name][name_walktype] = {}
                            current_table = tables.tbl_to_use[holdtype_name][name_walktype]
                        end

                        for _, v in ipairs(tables.original_tbl[animation]) do
                            if not istable(v) then
                                current_table[#current_table + 1] = FindSequenceIDFromTable(v)
                            else
                                current_table.animation = FindSequenceIDFromTable(v.animation)
                                current_table.gesture = FindSequenceIDFromTable(v.gesture)
                            end
                        end
                    else
                        tables.tbl_to_use[holdtype_name] = tables.tbl_to_use[holdtype_name] or {}
                        local seq_name = tables.original_tbl[animation]
                        if animation:find(holdtype_name .. "_") then
                            tables.tbl_to_use[holdtype_name][string.Replace(animation, holdtype_name .. "_", "")] = FindSequenceIDFromTable(seq_name)
                        else
                            tables.tbl_to_use[holdtype_name][string.Replace(animation, "_" .. holdtype_name, "")] = FindSequenceIDFromTable(seq_name)
                        end
                    end
                end
            end
        end
    end
end

function ANIMATIONBASEFIX()
    GetMainSequenceTable()
    CreateTestHoldTypeTables()
    BroadcastLua("GetMainSequenceTable() CreateTestHoldTypeTables()")
end

hook.Add("Initialize", "CreateAnimationsTable", function()
    timer.Simple(1, function()
        GetMainSequenceTable()
        CreateTestHoldTypeTables()
    end)
end)

function BREACH_GM:HandlePlayerJumping(player)
    if player:GetJumpPower() <= 0 then return end
    if player:GetMoveType() == MOVETYPE_NOCLIP or (player:GTeam() == TEAM_SPEC or player:Health() <= 0) then return end
    local plytable = player:GetTable()
    if not player:OnGround() and not plytable.m_bJumping then
        plytable.m_bJumping = true
        plytable.m_flJumpStartTime = CurTime()
    end

    if plytable.m_bJumping then
        local holdtype = plytable.AnimationHoldType
        if holdtype and plytable.JumpAnimation then
            plytable.CalcIdeal = plytable.JumpAnimation
            plytable.CalcSeqOverride = plytable.JumpAnimation
        else
            plytable.CalcIdeal = 108
            plytable.CalcSeqOverride = 108
        end

        if CurTime() - plytable.m_flJumpStartTime > 0.2 then
            if player:OnGround() then
                plytable.m_bJumping = false
                player:AnimRestartMainSequence()
            end
        end
        return true
    end
end

function BREACH_GM:HandlePlayerDucking(player, velocity)
    if player:Crouching() then
        local weapon = player:GetActiveWeapon()
        local velLength = velocity:Length2D()
        local weptable = weapon:GetTable() or weapon
        local IswepCW = weptable.CW20Weapon
        local plytable = player:GetTable()
        if IswepCW then
            local firemode = weptable.FireMode
            if weptable.KKINS2Nade then
                if velLength > 0.5 then
                    if not weptable.dt.ReadToThrow then
                        animation = plytable.CrouchWalkAim
                    else
                        animation = plytable.CrouchWalkIdle
                    end
                else
                    if not weptable.dt.ReadToThrow then
                        animation = plytable.CrouchIdleAim
                    else
                        animation = plytable.CrouchIdleSafemode
                    end
                end
            else
                if velLength > 0.5 then
                    if firemode ~= "safe" then
                        animation = plytable.CrouchWalkAim
                    else
                        animation = plytable.CrouchWalkIdle
                    end
                else
                    if firemode ~= "safe" then
                        animation = plytable.CrouchIdleAim
                    else
                        animation = plytable.CrouchIdleSafemode
                    end
                end
            end
        else
            if velLength > .5 then
                animation = plytable.CrouchWalkAim
            else
                animation = plytable.CrouchWalkIdle
            end
        end

        plytable.CalcSeqOverride = animation
        return true
    end
    return false
end

function BREACH_GM:HandlePlayerDriving(player)
    if player:InVehicle() then
        local plytable = player:GetTable()
        local is_driver = player:GetVehicle():GetClass() ~= "prop_vehicle_prisoner_pod"
        plytable.CalcIdeal = is_driver and 2538 or 292
        plytable.CalcSeqOverride = is_driver and 2538 or 292
        return true
    end
    return false
end

local vector_zero = Vector(0, 0, 0)
local rememberang = angle_zero
local machine = "models/scp_chaos_jeep/chaos_jeep.mdl"
function BREACH_GM:UpdateAnimation(player, velocity, maxSeqGroundSpeed)
    local velLength = velocity:Length2D()
    local rate = 1.0
    local plytable = player:GetTable()
    if player:GetModel() == machine then
        local newang = player:GetVelocity():Angle().yaw
        if newang ~= 0 then rememberang = Angle(0, newang, 0) end
        player:SetRenderAngles(rememberang)
    end

    if player:GetNWAngle("ViewAngles") ~= angle_zero then player:SetRenderAngles(player:GetNWAngle("ViewAngles")) end
    if velLength > 0.5 then rate = (velLength * 0.8) / maxSeqGroundSpeed end
    local forcedAnimation = plytable.ForceAnimSequence
    if forcedAnimation and forcedAnimation ~= 0 then
        player:SetPlaybackRate(1.0)
    else
        rate = math.min(rate, 2)
        player:SetPlaybackRate(rate)
    end

    if CLIENT then
        if player:InVehicle() then
            local vehicle = player:GetVehicle()
            if vehicle and vehicle:IsValid() then
                local velocity = vehicle:GetVelocity()
                local steer = (vehicle:GetPoseParameter("vehicle_steer") * 2) - 1
                player:SetPoseParameter("vertical_velocity", velocity.z * .01)
                player:SetPoseParameter("vehicle_steer", steer)
            end
        end

        if player == LocalPlayer() then
            if BREACHLEGS.legEnt and BREACHLEGS.legEnt:IsValid() then
                BREACHLEGS:LegsWork(player, maxSeqGroundSpeed)
            else
                BREACHLEGS:CreateLegs()
            end
        end

        self:GrabEarAnimation(player)
        self:MouthMoveAnimation(player)
    end
end

local blink_value = 1
local multiplier = 1
local mouth_banned = {
    [TEAM_SPEC] = true,
    [TEAM_SCP] = true
}

mouth_allowed_models = {
    ["models/cultist/heads/female/shaky/head_1.mdl"] = true,
    ["models/cultist/humans/balaclavas_new/head_balaclava_month.mdl"] = true,
    ["models/cultist/humans/balaclavas_new/balaclava_full.mdl"] = true,
    ["models/cultist/humans/balaclavas_new/balaclava_half.mdl"] = true,
    ["models/shaky/heads/head_gp.mdl"] = true,
    ["models/cultist/heads/male/bor_heads/bor_head.mdl"] = true,
    ["models/shaky/funnyheads/head_gremlin.mdl"] = true,
}

mouth_allowed_playermodels = {
    ["models/cultist/humans/mog/dispatch_male.mdl"] = true, --["models/cultist/humans/sci/dispatch.mdl"] = true,
}

function BREACH_GM:MouthMoveAnimation(ply)
    if SERVER then return end
    if mouth_banned[ply:GTeam()] then return end
    local plytable = ply:GetTable()
    if not plytable.talkmult then plytable.talkmult = 0 end
    if plytable.talkedrecently and plytable.talkedrecently >= CurTime() then
        plytable.talkmult = math.Approach(plytable.talkmult, 1, FrameTime() * 10)
    else
        plytable.talkmult = math.Approach(plytable.talkmult, 0, FrameTime() * 5)
    end

    local talk_value = 0.5 + math.sin(CurTime() * 15) * 0.5
    if not (plytable.HeadEnt and plytable.HeadEnt:IsValid()) then
        if ply:GTeam() == TEAM_SPECIAL or mouth_allowed_playermodels[ply:GetModel()] then
            plytable.HeadEnt = ply
        else
            for i, v in pairs(ply:LookupBonemerges()) do
                local mdl = v:GetModel()
                if mdl:find("male_head") or mdl:find("fat") or mouth_allowed_models[mdl] then plytable.HeadEnt = v end
            end
        end
        return
    end

    local flex = {plytable.HeadEnt:GetFlexIDByName("Eyes"), plytable.HeadEnt:GetFlexIDByName("Mounth")}
    local multiplier = 1 / GetConVar("voice_scale"):GetFloat()
    local weight = ply:IsSpeaking() and not plytable.DisableMouthAnimation and math.min(ply:VoiceVolume() * multiplier * 6, 1) or 0
    if flex[1] then
        if (plytable.NextBlink or 0) < CurTime() then
            plytable.NextBlink = CurTime() + math.random(2, 8)
            blink_value = 1
            plytable.HeadEnt:SetFlexWeight(flex[1], blink_value)
        elseif blink_value > 0 then
            multiplier = 1.25
            if RealFrameTime() > 0.01 then multiplier = 2.5 end
            blink_value = math.Approach(blink_value, 0, RealFrameTime() * multiplier)
            plytable.HeadEnt:SetFlexWeight(flex[1], blink_value)
        end
    end

    if flex[2] then plytable.HeadEnt:SetFlexWeight(flex[2], Lerp(plytable.talkmult, weight * 1.5, talk_value)) end
end

function BREACH_GM:TranslateActivity(player, act)
    local plytable = player:GetTable()
    local animations = plytable.BrAnimTable
    if not animations then return self.BaseClass:TranslateActivity(player, act) end
    if player:OnGround() then
        local weapon = player:GetActiveWeapon()
        local weptable = weapon:GetTable() or weapon
        local IswepCW = weptable.CW20Weapon
        local IsRaised
        if IswepCW then IsRaised = weptable.dt.State == CW_AIMING end
        if animations[holdtype] and animations[holdtype][act] then
            local animation = animations[holdtype][act]
            if istable(animation) then
                if IsRaised then
                    animation = animation[2]
                else
                    animation = animation[1]
                end
            elseif isstring(animation) then
                plytable.CalcSeqOverride = player:LookupSequence(animation)
            end
            return animation
        end
    end
end

function GM:PlayerWeaponChanged(client, weapon, force)
    local plytable = client:GetTable()
    local wep = client:GetActiveWeapon()
    local weptable = wep:GetTable() or wep
    if plytable.UsingInvisible then wep:SetNoDraw(true) end
    if wep ~= weapon and not force then return end
    local wep_table = istable(weapon)
    if not wep_table and not (weapon and weapon:IsValid()) then return end
    local holdType
    local IswepCW
    if wep_table then
        IswepCW = weptable.Base == "cw_kk_ins2_base"
        if IswepCW then
            holdType = weptable.NormalHoldType
        else
            holdType = weptable.HoldType
        end
    else
        local stored_wep = weapons.GetStored(weapon:GetClass())
        IswepCW = weptable.CW20Weapon or stored_wep and stored_wep.Base == "cw_kk_ins2_base"
        holdType = BREACH.AnimationTable:GetWeaponHoldType(client, weapon, IswepCW)
    end

    if weptable.CW20Weapon and not weptable.CW20Weapon and not force then return end
    local stored_wep = weapons.GetStored(weapon:GetClass())
    local is_scp = client:GetModel():find("/scp/") and client:GTeam() == TEAM_SCP
    if not plytable.DrawAnimation and not is_scp and stored_wep then
        plytable.DrawAnimation = true
        client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, 3289, 0, true)
        timer.Simple(client:SequenceDuration(3289) + .5, function() if client and client:IsValid() then plytable.DrawAnimation = nil end end)
    end

    if not holdType then return end
    if plytable.AnimationHoldType and plytable.AnimationHoldType == holdType and plytable.Old_Model == client:GetModel() then return end
    plytable.AnimationHoldType = holdType
    
    plytable.AnimationRole = client:GetRoleName()
    plytable.GestureAnimationIdle = nil
    plytable.GestureAnimationWalk = nil
    plytable.GestureAnimationRun = nil
    local animations_table
    if not is_scp then
        animations_table = AnimationTableGetTable(client, client:GetModel())[plytable.AnimationHoldType]
    else
        animations_table = GenerateSCPTable(plytable.AnimationHoldType, client)
        if animations_table then animations_table = animations_table[plytable.AnimationHoldType] end
    end

    if not animations_table then return end
    for k, v in pairs(animations_table) do
        if k:find("walk") then
            if not v.animation then
                plytable.SafeModeWalk = v[1]
                plytable.Walk = v[2] or 0
                plytable.AimWalk = v[3] or 0
                if BREACH.AnimationTable.AltWalk[holdType .. "_altwalk"] then
                    plytable.AltWalk = client:LookupSequence(BREACH.AnimationTable.AltWalk[holdType .. "_altwalk"])
                else
                    plytable.AltWalk = 0
                end
            else
                plytable.SafeModeWalk = v.animation
                plytable.GestureAnimationWalk = v.gesture
            end
        elseif k:find("run") then
            if not v.animation then
                plytable.SafeRun = v[1]
                plytable.Run = v[2] or 0
            else
                plytable.SafeRun = v.animation
                plytable.GestureAnimationRun = v.gesture
            end
        elseif k:find("crouch") then
            if not k:find("reload") then
                plytable.CrouchWalkAim = v[1]
                plytable.CrouchWalkIdle = v[2] or 0
                plytable.CrouchIdleAim = v[3] or 0
                plytable.CrouchIdleSafemode = v[4] or 0
            else
                if not plytable.ReloadAnimations then plytable.ReloadAnimations = {} end
                plytable.ReloadAnimations[2] = v
            end
        elseif k:find("idle") then
            if not v.animation then
                plytable.IdleSafemode = v[1]
                plytable.Idle = v[2] or 0
                plytable.IdleAim = v[3] or 0
            else
                plytable.IdleSafemode = v.animation
                plytable.GestureAnimationIdle = v.gesture
            end
        elseif k:find("attack") then
            plytable.AttackAnimations = v
        elseif k:find("reload") then
            if not plytable.ReloadAnimations then plytable.ReloadAnimations = {} end
            plytable.ReloadAnimations[1] = v
        elseif k:find("jump") then
            plytable.JumpAnimation = v
        end
    end

    plytable.Old_Weapon = weapon
    plytable.Old_Model = client:GetModel()
end

function GM:PlayerSwitchWeapon(ply, old, new)
    
end

do
    local vectorAngle = FindMetaTable("Vector").Angle
    local spec_index = TEAM_SPEC
    function BREACH_GM:CalcMainActivity(player, velocity)
        local pl = player:GetTable()
        if player:GTeam() == spec_index then return end
        local forcedAnimation = pl.ForceAnimSequence
        if forcedAnimation and forcedAnimation ~= 0 then
            if player:GetSequence() ~= forcedAnimation then player:SetCycle(0) end
            return -1, forcedAnimation
        end

        if CLIENT then player:SetIK(false) end
        player:SetPoseParameter("move_yaw", mathNormalizeAngle(vectorAngle(velocity)[2] - player:EyeAngles()[2]))
        local wep = player:GetActiveWeapon()
        local weptable = wep
        if wep ~= NULL then weptable = wep:GetTable() end
        local wepIsCW = weptable.CW20Weapon
        if pl.nextfootstep == nil then pl.nextfootstep = 0 end
        if wep ~= NULL then if not pl.IdleSafemode or pl.IdleSafemode == -1 or (not wepIsCW and weptable.HoldType or weptable.NormalHoldType) ~= pl.AnimationHoldType then hook.Run("PlayerWeaponChanged", player, wep, true) end end
        if wepIsCW then
            if weptable.KKINS2Nade then
                if not weptable.dt.ReadyToThrow then
                    pl.CalcSeqOverride = pl.Idle
                    pl.CalcIdeal = pl.Idle
                else
                    pl.CalcSeqOverride = pl.IdleSafemode
                    pl.CalcIdeal = pl.IdleSafemode
                end
            else
                if weptable.FireMode ~= "safe" then
                    if weptable.dt.State == CW_AIMING then
                        pl.CalcSeqOverride = pl.IdleAim
                        pl.CalcIdeal = pl.IdleAim
                    else
                        pl.CalcSeqOverride = pl.Idle
                        pl.CalcIdeal = pl.Idle
                    end
                else
                    pl.CalcSeqOverride = pl.IdleSafemode
                    pl.CalcIdeal = pl.IdleSafemode
                end
            end
        else
            if pl.GestureAnimationIdle and velocity:Length2DSqr() < 500 and (pl.GesturePlaying or 0) ~= pl.GestureAnimationIdle then
                player:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, pl.GestureAnimationIdle, 0, false)
                pl.GesturePlaying = pl.GestureAnimationIdle
            end

            pl.CalcSeqOverride = pl.IdleSafemode
            pl.CalcIdeal = pl.IdleSafemode
        end

        local baseClass = self.BaseClass
        if not (baseClass:HandlePlayerNoClipping(player, velocity) or self:HandlePlayerDriving(player) or baseClass:HandlePlayerVaulting(player, velocity) or self:HandlePlayerJumping(player, velocity) or baseClass:HandlePlayerSwimming(player, velocity) or self:HandlePlayerDucking(player, velocity)) then
            local velLength = velocity:Length2DSqr()
            local run_length = 22500
            if pl:GetRoleName() == SCP062DE then run_length = 15000 end
            if velLength > run_length then
                if wepIsCW then
                    if weptable.KKINS2Nade then
                        if not weptable.dt.ReadyToThrow then
                            pl.CalcSeqOverride = pl.Run
                            pl.CalcIdeal = pl.Run
                        else
                            pl.CalcSeqOverride = pl.SafeRun
                            pl.CalcIdeal = pl.SafeRun
                        end
                    else
                        if weptable.FireMode ~= "safe" then
                            pl.CalcSeqOverride = pl.Run
                            pl.CalcIdeal = pl.Run
                        else
                            pl.CalcSeqOverride = pl.SafeRun
                            pl.CalcIdeal = pl.SafeRun
                        end
                    end
                else
                    if pl.GestureAnimationRun and (pl.GesturePlaying or 0) ~= pl.GestureAnimationRun then
                        player:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
                        player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, pl.GestureAnimationRun, 0, false)
                        pl.GesturePlaying = pl.GestureAnimationRun
                    end

                    pl.CalcSeqOverride = pl.SafeRun
                    pl.CalcIdeal = pl.SafeRun
                end
            elseif velLength > 500 then
                if wepIsCW then
                    if weptable.KKINS2Nade then
                        if not weptable.dt.ReadyToThrow then
                            pl.CalcSeqOverride = pl.Walk
                            pl.CalcIdeal = pl.Walk
                        else
                            pl.CalcSeqOverride = pl.SafeModeWalk
                            pl.CalcIdeal = pl.SafeModeWalk
                        end
                    else
                        if weptable.FireMode ~= "safe" then
                            if weptable.dt.State == CW_AIMING then
                                pl.CalcSeqOverride = pl.AimWalk
                                pl.CalcIdeal = pl.AimWalk
                            else
                                if velLength > 6000 or pl.AltWalk == 0 then
                                    pl.CalcSeqOverride = pl.Walk
                                    pl.CalcIdeal = pl.Walk
                                else
                                    pl.CalcSeqOverride = pl.AltWalk
                                    pl.CalcIdeal = pl.AltWalk
                                end
                            end
                        else
                            pl.CalcSeqOverride = pl.SafeModeWalk
                            pl.CalcIdeal = pl.SafeModeWalk
                        end
                    end
                else
                    if pl.GestureAnimationWalk and (pl.GesturePlaying or 0) ~= pl.GestureAnimationWalk then
                        player:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
                        player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, pl.GestureAnimationWalk, 0, false)
                        pl.GesturePlaying = pl.GestureAnimationWalk
                    end

                    pl.CalcSeqOverride = pl.SafeModeWalk
                    pl.CalcIdeal = pl.SafeModeWalk
                    if not (velLength > 3000 or pl.AltWalk == 0) then
                        pl.CalcSeqOverride = pl.AltWalk
                        pl.CalcIdeal = pl.AltWalk
                    end
                end
            end
        end

        if isstring(pl.CalcSeqOverride) then pl.CalcSeqOverride = player:LookupSequence(pl.CalcSeqOverride) end
        if isstring(pl.CalcIdeal) then pl.CalcSeqOverride = player:LookupSequence(pl.CalcIdeal) end
        return pl.CalcIdeal, pl.CalcSeqOverride
    end
end

function BREACH_GM:DoAnimationEvent(player, event, data)
    local plytable = player:GetTable()
    if event == 20 then event = 19 end
    local weapon = player:GetActiveWeapon()
    local IswepCW = weapon.CW20Weapon
    local holdtype = plytable.AnimationHoldType
    if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
        if not holdtype then
            hook.Run("PlayerWeaponChanged", player, player:GetActiveWeapon(), true)
            return
        end

        if CLIENT then player:SetIK(false) end
        local gestureSequence = plytable.AttackAnimations
        if istable(gestureSequence) then gestureSequence = table.Random(gestureSequence) end
        if not gestureSequence then return end
        if gestureSequence and plytable.GestureAnimationIdle then
            if player:Crouching() then
                player:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, 1)
                player:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, 0)
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
            else
                player:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, .1)
                player:AnimSetGestureWeight(GESTURE_SLOT_VCD, .9)
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, gestureSequence, 0, true)
                timer.Create("ReturnWeight", player:SequenceDuration(gestureSequence) - .1, 1, function()
                    player:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, 1)
                    player:AnimSetGestureWeight(GESTURE_SLOT_VCD, 0)
                end)
            end
        elseif gestureSequence then
            player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
        end

        if CLIENT then player:SetIK(false) end
        return ACT_VM_PRIMARYATTACK
    elseif event == PLAYERANIMEVENT_RELOAD then
        local gestureSequence
        if not holdtype then
            hook.Run("PlayerWeaponChanged", player, player:GetActiveWeapon(), true)
            return
        end

        if not plytable.ReloadAnimations then return end
        if not player:Crouching() then
            gestureSequence = plytable.ReloadAnimations[1]
        else
            gestureSequence = plytable.ReloadAnimations[2]
        end

        if not gestureSequence then return end
        if gestureSequence then
            if player:Crouching() then
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
            else
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
            end
        end
        return ACT_INVALID
    elseif event == PLAYERANIMEVENT_JUMP then
        plytable.m_bJumping = true
        plytable.m_bFirstJumpFrame = true
        plytable.m_flJumpStartTime = CurTime()
        player:AnimRestartMainSequence()
        return ACT_INVALID
    elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
        player:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
        return ACT_INVALID
    elseif event == PLAYERANIMEVENT_HEALTHATTACK then
        local gestureSequence = player:LookupSequence("Attack_BANDAGES")
        if gestureSequence then
            if player:Crouching() then
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, gestureSequence, 0, true)
            else
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, gestureSequence, 0, true)
            end
        end
        return ACT_INVALID
    elseif event == PLAYERANIMEVENT_MELEEATTACK then
        if CLIENT then player:SetIK(false) end
        local gestureSequence = player:LookupSequence("wos_judge_r_s2_t2")
        if gestureSequence then
            if player:Crouching() then
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
            else
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence, 0, true)
            end
        end
        return ACT_INVALID
    end
    return nil
end