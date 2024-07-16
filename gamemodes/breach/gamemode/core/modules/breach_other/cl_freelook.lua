local freelooking = false
local LookX, LookY = 0, 0
local InitialAng, CoolAng = Angle(), Angle()
local ZeroAngle = Angle()
local blockads = true
local blockshoot = true
local enabled = false 

-- Works pretty fucking ugly with CW 2.0, im too lazy to fix it 4now, fuck it.

if not enabled then return end

concommand.Add("+freelook", function(ply, cmd, args) freelooking = true end)
concommand.Add("-freelook", function(ply, cmd, args) freelooking = false end)

local function isinsights(ply)
    local weapon = ply:GetActiveWeapon()
    return blockads and (ply:KeyDown(IN_ATTACK2) or (weapon.GetInSights and weapon:GetInSights()) or (weapon.ArcCW and weapon:GetState() == ArcCW.STATE_SIGHTS) or (weapon.GetIronSights and weapon:GetIronSights()))
end

local function holdingbind(ply)
    if not input.LookupBinding("freelook") then
        return ply:KeyDown(IN_WALK)
    else
        return freelooking
    end
end

hook.Add("CalcView", "AltlookView", function(ply, origin, angles, fov)
    if not ply:Alive() or ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end

    local smoothness = math.Clamp(1, 0.1, 2)
    CoolAng = LerpAngle(0.15 * smoothness, CoolAng, Angle(LookY, -LookX, 0))
    if not holdingbind(ply) and CoolAng.p < 0.05 and CoolAng.p > -0.05 or isinsights(ply) and CoolAng.p < 0.05 and CoolAng.p > -0.05 or not system.HasFocus() or ply:ShouldDrawLocalPlayer() then
        InitialAng = angles + CoolAng
        LookX, LookY = 0, 0
        CoolAng = ZeroAngle
        return
    end

    angles.p = angles.p + CoolAng.p
    angles.y = angles.y + CoolAng.y
end)

hook.Add("CalcViewModelView", "AltlookVM", function(wep, vm, oPos, oAng, pos, ang)

    
    local MWBased = wep.m_AimModeDeltaVelocity and -1.5 or 1
    ang.p = ang.p + CoolAng.p / 2.5 * MWBased
    ang.y = ang.y + CoolAng.y / 2.5 * MWBased
end)

hook.Add("InputMouseApply", "AltlookMouse", function(cmd, x, y, ang)
    local ply = LocalPlayer()

    if not ply:Alive() or ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end

    if not holdingbind(ply) or isinsights(ply) or ply:ShouldDrawLocalPlayer() then
        LookX, LookY = 0, 0
        return
    end

    InitialAng.z = 0
    cmd:SetViewAngles(InitialAng)
    LookX = math.Clamp(LookX + x * 0.02, -140, 140)
    LookY = math.Clamp(LookY + y * 0.02, -65, 65)
    return true
end)

hook.Add("StartCommand", "AltlookBlockShoot", function(ply, cmd)
    if not ply:Alive() or ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then return end

    if not ply:IsPlayer() or not ply:Alive() then return end
    if not blockshoot then return end
    if not holdingbind(ply) or isinsights(ply) or ply:ShouldDrawLocalPlayer() then return end
    cmd:RemoveKey(IN_ATTACK)
end)