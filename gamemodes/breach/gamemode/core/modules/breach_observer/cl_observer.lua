local IsValid = IsValid
local LocalPlayer = LocalPlayer
local DynamicLight = DynamicLight
local math = math
local CurTime = CurTime
local hook = hook
local ScrW = ScrW
local ScrH = ScrH
local pairs = pairs
local ents = ents
local string = string
local ipairs = ipairs
local surface = surface
local ColorAlpha = ColorAlpha
local table = table
local Color = Color
local CreateMaterial = CreateMaterial
local net = net
local os = os
local cam = cam
local player = player
local team = team
local Vector = Vector
local render = render
local util = util
local math = math

surface.CreateFont("UiBold", {
    size = 16,
    weight = 800,
    antialias = true,
    shadow = false,
    font = "Verdana"
})

BREACH.observer.dimDistance = 1024
BREACH.observer.fullbright = true
BREACH.observer.enabled = true
BREACH.observer.player = true
BREACH.observer.blur = true
BREACH.observer.steam = true
BREACH.observer.font = "UiBold"

net.Receive("BREACHObserverFlashlight", function(len, ply)
	LocalPlayer():EmitSound("buttons/lightswitch2.wav")
end)

hook.Add("DrawPhysgunBeam", "BREACH.Observer-DrawPhysgunBeam", function(client, physgun, enabled, target, bone, hitPos)
    if (client != LocalPlayer() and client:GetMoveType() == MOVETYPE_NOCLIP) then
		return false
	end
end)

hook.Add("PrePlayerDraw", "BREACH.Observer-DrawPhysgunBeam", function(client)
    if (client:GetMoveType() == MOVETYPE_NOCLIP and !client:InVehicle()) then
		return true
	end
end)

/*
hook.Add("Think", "BREACH.Observer-Think", function()
    if (!LocalPlayer():GetNWBool("observerLight")) then return end

	local dlight = DynamicLight(LocalPlayer():EntIndex())
	if (dlight) then
		local trace = LocalPlayer():GetEyeTraceNoCursor()
		dlight.pos = LocalPlayer():GetShootPos() + LocalPlayer():EyeAngles():Forward() * -100
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = math.Remap(math.Clamp(trace.HitPos:DistToSqr(LocalPlayer():EyePos()), 100, 10000), 100, 10000, 0.01, 1)
		dlight.Decay = 20000
		dlight.Size = 2000
		dlight.DieTime = CurTime() + 0.1
	end
end)
*/

hook.Add("DrawPointESP", "BREACH.Observer-DrawPointESP", function()

end)

hook.Add("HUDPaint", "BREACH.Observer-HUDPaint", function()
    local client = LocalPlayer()

	local drawESP = hook.Run("ShouldDrawAdminESP")

    if client:GTeam() == TEAM_SPEC then
        return
    end
    
	if (drawESP == nil) then
		drawESP = BREACH.observer.enabled and client:GetMoveType() == MOVETYPE_NOCLIP and
		!client:InVehicle() and client:IsAdmin()
	end

	if (drawESP) then
		local scrW, scrH = ScrW(), ScrH()
		local marginX, marginY = scrH * .1, scrH * .1

        hook.Run("DrawPlayerESP", client, scrW, scrH, BREACH.observer.player)

		if (BREACH.observer:ShouldRenderAnyTypes()) then
			for _, ent in pairs(ents.GetAll()) do
				if (!IsValid(ent)) then continue end

				local class = string.lower(ent:GetClass())
				if (BREACH.observer.types[class] and BREACH.observer.types[class][1]) then
					local screenPosition = ent:GetPos():ToScreen()
					local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
					if ((x != screenPosition.x or screenPosition.y != y) and !BREACH.observer.types[class][3]) then
						continue
					end

					local distance = client:GetPos():Distance(ent:GetPos())
					local factor = 1 - math.Clamp(distance / BREACH.observer.dimDistance, 0, 1)
					BREACH.observer.types[class][2](client, ent, x, y, factor, distance)
				end
			end
		end

		local points = {}

		hook.Run("DrawPointESP", points)

		for _, v in ipairs(points) do            
			local screenPosition = v[1]:ToScreen()
			local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)

			local distance = client:GetPos():Distance(v[1])
			local alpha = math.Remap(math.Clamp(distance, v[4] or 1500, v[5] or 2000), v[4] or 1500, v[4] or 2000, 255, v[6] or 0)
			local size = math.Remap(math.Clamp(distance, 0, v[5] or 2000), v[4] or 1500, v[4] or 2000, 10, 2)
			local drawColor = v[3] or color_white

			surface.SetDrawColor(drawColor.r, drawColor.g, drawColor.b, alpha)
			surface.SetFont(BREACH.observer.font)
			surface.DrawRect(x - size / 2, y - size / 2, size, size)
			draw.SimpleText(v[2], BREACH.observer.font, x, y - (size + 5), ColorAlpha(drawColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
		end
	end
end)

local blacklist = {
	["gmod_tool"] = true,
	["weapon_physgun"] = true,
}

hook.Add("GetPlayerESPText", "BREACH.Observer-GetPlayerESPText", function(client, toDraw, distance, alphaFar, alphaMid, alphaClose)
    toDraw[#toDraw + 1] = {alpha = alphaMid, priority = 11, text = client:SteamName()}

    local role = client:GetRoleName()
	if (role and role != "Spectator") then
		toDraw[#toDraw + 1] = {alpha = alphaMid, priority = 15, text = "Role: ".. role}
	end

	local weapon = client:GetActiveWeapon()
	if (IsValid(weapon) and !blacklist[weapon:GetClass()]) then
		toDraw[#toDraw + 1] = {alpha = alphaMid, priority = 16, text = "Weapon: ".. weapon:GetClass()}
	end
end)

/*
hook.Add("PreRender", "BREACH.Observer-PreRender", function()
    if (LocalPlayer():GetNWBool("observerLight") and BREACH.observer.fullbright) then
		render.SetLightingMode(1)
	end
end)

hook.Add("PreDrawHUD", "BREACH.Observer-PreDrawHUD", function()
    if (LocalPlayer():GetNWBool("observerLight") and BREACH.observer.fullbright) then
		render.SetLightingMode(0)
	end
end)
*/

BREACH.observer.traceFilter = {nil, nil}

local color_white = Color(255, 255, 255)
local extraColor = Color(200, 200, 200, 255)
local mat1 = CreateMaterial("GA0249aSFJ3","VertexLitGeneric",{
    ["$basetexture"] = "models/debug/debugwhite",
    ["$model"] = 1,
    ["$translucent"] = 1,
    ["$alpha"] = 1,
    ["$nocull"] = 1,
    ["$ignorez"] = 1
})

do
    local npccol = Color(255, 0, 128)
    local espcol = Color(255,255,255,255)
    local espcols = {}

    local function staticESP(client, entity, x, y, factor, distance)
        if (distance > 2500) then return end

        local alpha = math.Remap(math.Clamp(distance, 500, 2500), 500, 2500, 255, 45)
        if (IsValid(entity) and entity:GetNWBool("Persistent", false)) then
            draw.SimpleText(entity:GetModel(), BREACH.observer.font, x, y - math.max(10, 32 * factor), espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
        end
    end
    BREACH.observer:RegisterESPType("prop_physics", staticESP, "static", "Show Static Prop ESP")
end

local function sortFunc(a, b)
    if (a.alpha != b.alpha) then
        return a.alpha > b.alpha
    elseif (a.priority != b.priority) then
        return a.priority < b.priority
    else
        return a.text < b.text
    end
end

hook.Add("DrawPlayerESP", "BREACH.Observer-DrawPlayerESP", function(client, scrW, scrH, drawMdl)
    local pos = client:EyePos()
    local marginX, marginY = scrW * .1, scrH * .1
    BREACH.observer.traceFilter[1] = client

    local names = {}
    cam.Start3D()
        local targets = hook.Run("GetAdminESPTargets") or player.GetAll()
        for _, v in ipairs(targets) do
            if (v == client or !v:Alive() or v:GTeam() == TEAM_SPEC or client:GetAimVector():Dot((v:GetPos() - pos):GetNormal()) < 0.65) then
                continue
            end

            local bObserver = v:GetMoveType() == MOVETYPE_NOCLIP and !v:InVehicle()
            local teamColor = bObserver and Color(255, 85, 20, 255) or gteams.GetColor(v:GTeam())
            local vEyePos = v:EyePos()
            local distance = pos:Distance(vEyePos)

            if drawMdl then hook.Run("RenderAdminESP", client, v, teamColor, pos, vEyePos, distance) end

            names[#names + 1] = {v, teamColor, distance}
        end
    cam.End3D()

    local right = client:GetRight() * 25
    for _, info in ipairs(names) do
        local ply, teamColor, distance = info[1], info[2], info[3]
        local plyPos = ply:GetPos()

        local min, max = ply:GetModelRenderBounds()
        min = min + plyPos + right
        max = max + plyPos + right

        local barMin = Vector((min.x + max.x) / 2, (min.y + max.y) / 2, min.z):ToScreen()
        local barMax = Vector((min.x + max.x) / 2, (min.y + max.y) / 2, max.z):ToScreen()
        local eyePos = ply:EyePos():ToScreen()
        local rightS = math.min(math.max(barMin.x, barMax.x), eyePos.x + 150)

        local barWidth = math.Remap(math.Clamp(distance, 200, 2000), 500, 2000, 120, 75)
        local barHeight = math.abs(barMax.y - barMin.y)
        local barX, barY = math.Clamp(rightS, marginX, scrW - marginX - barWidth),  math.Clamp(barMin.y - barHeight + 18, marginY, scrH - marginY)

        local alphaFar = math.Remap(math.Clamp(distance, 1500, 2000), 1500, 2000, 255, 0)
        local alphaMid = math.Remap(math.Clamp(distance, 400, 700), 400, 700, 255, 0)
        local alphaClose = math.Remap(math.Clamp(distance, 200, 500), 200, 500, 255, 0)

        local bArmor = ply:Armor() > 0
        surface.SetDrawColor(40, 40, 40, 200 * alphaFar / 255)
        surface.DrawRect(barX - 1, barY - 1, barWidth + 2, 5)
        if (bArmor) then surface.DrawRect(barX - 1, barY + 9, barWidth + 2, 5)  end

        surface.SetDrawColor(teamColor.r * 1.6, teamColor.g * 1.6, teamColor.b * 1.6, alphaFar)
        surface.DrawRect(barX, barY, barWidth * math.Clamp(ply:Health() / ply:GetMaxHealth(), 0, 1), 3)

        local extraHeight = 0
        if (bArmor) then
            extraHeight = 10
            surface.SetDrawColor(255, 255, 255, alphaFar)
            surface.DrawRect(barX, barY + 10, barWidth * math.Clamp(ply:Armor() / 50, 0, 1), 3)
        end

        surface.SetFont(BREACH.observer.font)
        draw.SimpleText(ply:Name(), BREACH.observer.font, barX, barY - 13, teamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, nil, 255)

        if (BREACH.observer.steam) then
            surface.SetFont(BREACH.observer.font)
            local y = barY + extraHeight + 13
            local toDraw = {}
            hook.Run("GetPlayerESPText", ply, toDraw, distance, alphaFar, alphaMid, alphaClose)
            table.sort(toDraw, sortFunc)

            for _, v in ipairs(toDraw) do
                if (v.alpha <= 0) then continue end

                extraColor.a = v.alpha
                draw.SimpleText(v.text, BREACH.observer.font, barX, y, v.color or extraColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, nil, v.alpha)

                local _, txtHeight = surface.GetTextSize(v.text)
                y = y + txtHeight
            end
        end
    end
end)

hook.Add("RenderAdminESP", "BREACH.Observer-RenderAdminESP", function(client, target, color, clientPos, targetEyePos, distance)
    render.SuppressEngineLighting(true)
    render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)

    BREACH.observer.traceFilter[2] = target

    if (BREACH.observer.blur or util.QuickTrace(clientPos, targetEyePos - clientPos, BREACH.observer.traceFilter).Fraction < 0.95) then
        render.SetBlend(1)
    else
        render.SetBlend(math.Remap(math.Clamp(distance, 200, 4000), 200, 8000, 0.05, 1))
    end
    
    render.MaterialOverride(mat1)
    
    target:DrawModel()
    
    for _, ent in ipairs(ents.GetAll()) do
        if ent:GetClass() == "breach_bonemerge" and ent:GetOwner() == target then
            ent:DrawModel()
        end
    end

    render.MaterialOverride()
    render.SuppressEngineLighting(false)
end)
