--[[
local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player

FSpectate = {}

local isSpectating = false
local specEnt
local thirdperson = true
local isRoaming = false

local maxdistmeters_plys = 200
local maxdist_plys = maxdistmeters_plys / 0.01905
local maxdistsqr_plys = maxdist_plys * maxdist_plys

local maxdistmeters_ents = 35
local maxdist_ents = maxdistmeters_ents / 0.01905
local maxdistsqr_ents = maxdist_ents * maxdist_ents
/*---------------------------------------------------------------------------
startHooks
FAdmin tab buttons
---------------------------------------------------------------------------*/
hook.Add("Initialize", "FSpectate", function()
    surface.CreateFont("UiBold", {
        size = 16,
        weight = 800,
        antialias = true,
        shadow = false,
        font = "Verdana"})
end)

/*---------------------------------------------------------------------------
RenderScreenspaceEffects
Draws the lines from players' eyes to where they are looking
---------------------------------------------------------------------------*/
local LineMat = Material("cable/new_cable_lit")
local linesToDraw = {}

local view = {}

function specCalcView()
    view.origin = LocalPlayer():GetShootPos()
    view.angles = LocalPlayer():EyeAngles()
end

local function lookingLines()
    if not linesToDraw[0] then return end
    render.SetMaterial(LineMat)
    cam.Start3D(view.origin, view.angles)
        for i = 0, #linesToDraw, 3 do
            render.DrawLine(linesToDraw[i], linesToDraw[i + 1], linesToDraw[i + 2]) --render.DrawBeam(linesToDraw[i], linesToDraw[i + 1], 2, 0.01, 10, linesToDraw[i + 2])
        end
    cam.End3D()
end
/*---------------------------------------------------------------------------
gunpos
Gets the position of a player's gun
---------------------------------------------------------------------------*/
local function gunpos(ply)
    --local wep = ply:GetActiveWeapon()
    --if not IsValid(wep) then return ply:EyePos() end
    --local att = wep:GetAttachment(1)
    --if not att then return ply:EyePos() end
    --return att.Pos
    return ply:EyePos()
end

/*---------------------------------------------------------------------------
Spectate think
Free roaming position updates
---------------------------------------------------------------------------*/
local function specThink()
    local ply = LocalPlayer()

    -- Update linesToDraw
    local pls = player.GetAll()
    local lastPly = 0
    local skip = 0
    for i = 0, #pls - 1 do
        local p = pls[i + 1]
        if not IsValid(p) then continue end
        if p == LocalPlayer() then
            skip = skip + 3
            continue
        end
        if not isRoaming and p == specEnt and not thirdperson then skip = skip + 3 continue end

        local tr = p:GetEyeTrace()
        local sp = gunpos(p)

        local pos = i * 3 - skip

        linesToDraw[pos] = tr.HitPos
        linesToDraw[pos + 1] = sp
        linesToDraw[pos + 2] = gteams.GetColor(p:GTeam())
        lastPly = i
    end

    -- Remove entries from linesToDraw that don't match with a player anymore
    for i = #linesToDraw, lastPly * 3 + 3, -1 do linesToDraw[i] = nil end
end

/*---------------------------------------------------------------------------
Draw help on the screen
---------------------------------------------------------------------------*/
local uiForeground, uiBackground = Color(240, 240, 255, 255), Color(20, 20, 20, 120)
local red = Color(255, 0, 0, 255)
local green = Color(0, 255, 0, 255)

local ents_blacklist = {
    ["breach_bonemerge"] = true,
    ["base_gmodentity"] = true,
}

local function drawHelp()
    local scrHalfH = math.floor(ScrH() / 2)

    local pls = player.GetAll()
    for i = 1, #pls do
        local ply = pls[i]
        if not IsValid(ply) then continue end

        if LocalPlayer():GetPos():DistToSqr(ply:GetPos()) > maxdistsqr_plys then continue end

        local pos = ply:GetShootPos():ToScreen()
        if not pos.visible then continue end

        local x, y = pos.x, pos.y

        draw.RoundedBox(2, x, y - 6, 12, 12, gteams.GetColor(ply:GTeam()))
        draw.WordBox(2, x, y - 86, ply:Nick().."("..ply:GetNamesurvivor()..")", "BudgetLabel", uiBackground, uiForeground) --LVL:"..ply:GetNLevel()
        draw.WordBox(2, x, y - 66, ply:GetRoleName(), "BudgetLabel", uiBackground, gteams.GetColor(ply:GTeam())) --gteams.GetName(ply:GTeam()).." "..
        draw.WordBox(2, x, y - 46, "HP: "..ply:Health().."/"..ply:GetMaxHealth(), "BudgetLabel", uiBackground, green)
        draw.WordBox(2, x, y - 26, ply:SteamID(), "BudgetLabel", uiBackground, uiForeground)
        --if IsValid(ply:GetActiveWeapon()) then
            --draw.WordBox(2, x, y - 26, ply:GetActiveWeapon():GetClass(), "BudgetLabel", uiBackground, uiForeground)
        --end
    end

    --[[
    local entities = ents.GetAll()
    for i = 1, #entities do
        local ent = entities[i]
        if not IsValid(ent) then continue end

        if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > maxdistsqr_ents then continue end
        --if !ent:IsScripted() then continue end
        if IsValid(ent:GetOwner()) then continue end
        if ents_blacklist[ent:GetClass()] then continue end

        local pos = ent:GetPos():ToScreen()
        if not pos.visible then continue end

        local x, y = pos.x, pos.y

        draw.RoundedBox(2, x, y, 3, 3, uiForeground)
        draw.WordBox(2, x, y - 26, ent:GetClass(), "BudgetLabel", uiBackground, uiForeground, TEXT_ALIGN_CENTER)
    end
    --]]

    --[[
    for k, v in ipairs(tier1) do
        local pos = v:ToScreen()
        if not pos.visible then continue end
        --if LocalPlayer():GetPos():DistToSqr(v) > maxdistsqr_plys then continue end

        local x, y = pos.x, pos.y

        draw.WordBox(2, x, y, "tier1", "BudgetLabel", Color(255, 0, 0), uiForeground)
    end

    for k, v in ipairs(tier2) do
        local pos = v:ToScreen()
        if not pos.visible then continue end
        --if LocalPlayer():GetPos():DistToSqr(v) > maxdistsqr_plys then continue end

        local x, y = pos.x, pos.y

        draw.WordBox(2, x, y, "tier2", "BudgetLabel", Color(0, 255, 0), uiForeground)
    end

    for k, v in ipairs(tier3) do
        local pos = v:ToScreen()
        if not pos.visible then continue end
        --if LocalPlayer():GetPos():DistToSqr(v) > maxdistsqr_plys then continue end

        local x, y = pos.x, pos.y

        draw.WordBox(2, x, y, "tier3", "BudgetLabel", Color(0, 0, 255), uiForeground)
    end
    --]]
    --]]
--end

--[[
local funnywh = false

concommand.Add("funny_wallhackers", function()

    if !LocalPlayer():IsSuperAdmin() then return end

    funnywh = !funnywh

end)
--if LocalPlayer():IsAdmin() then
    hook.Add("Think", "FSpectate_AdminObserver", function()
    if !LocalPlayer():IsAdmin() then return end
    if LocalPlayer():InVehicle() then return end

        if (LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP or funnywh) and !isSpectating and LocalPlayer():GTeam() != TEAM_SPEC then
            isSpectating = true

            hook.Add("Think", "FSpectate", specThink)
            hook.Add("HUDPaint", "FSpectate", drawHelp)
            hook.Add("CalcView", "FSpectate", specCalcView)
            hook.Add("RenderScreenspaceEffects", "FSpectate", lookingLines)
        elseif ((LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP and !funnywh) or LocalPlayer():GTeam() == TEAM_SPEC) and isSpectating then
            isSpectating = false

            hook.Remove("Think", "FSpectate")
            hook.Remove("HUDPaint", "FSpectate")
            hook.Remove("CalcView", "FSpectate", specCalcView)
            hook.Remove("RenderScreenspaceEffects", "FSpectate")
        end
    end)
--end
--]]