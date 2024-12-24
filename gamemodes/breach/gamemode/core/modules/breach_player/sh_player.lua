local RunConsoleCommand = RunConsoleCommand
local FindMetaTable = FindMetaTable
local CurTime = CurTime
local pairs = pairs
local string = string
local table = table
local timer = timer
local hook = hook
local math = math
local pcall = pcall
local unpack = unpack
local tonumber = tonumber
local tostring = tostring
local ents = ents
local ErrorNoHalt = ErrorNoHalt
local DeriveGamemode = DeriveGamemode
local util = util
local net = net
local player = player
local mply = FindMetaTable("Player")
local ment = FindMetaTable("Entity")

function mply:IsPremium()
    if self:IsSuperAdmin() then return true end
    if self:IsAdmin() then return true end
    if self:GetUserGroup() == "premium" then return true end
    if self:GetNWBool("Breach_IsPremium") then return true end
    return false
end

function mply:CanEscapeHand()
    return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_GUARD or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL or self:GTeam() == TEAM_OSN
end

function mply:CanEscapeChaosRadio()
    return self:GTeam() == TEAM_CLASSD
end

function mply:CanEscapeCar()
    return self:GTeam() != TEAM_SCP
end

function mply:CanEscapeFBI()
    return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_GUARD or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL or self:GTeam() == TEAM_OSN
end

function mply:CanEscapeO5()
    return self:GTeam() == TEAM_SECURITY or self:GetRoleName() == SCP999 or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL or self:GTeam() == TEAM_OSN
end

function mply:SetEscapeEXP(name, n)
    self:AddToStatistics(name, n * tonumber("1." .. tostring(self:GetNLevel() * 2)))
end

local util_TraceLine = util.TraceLine
local util_TraceHull = util.TraceHull
local temp_attacker = NULL
local temp_attacker_team = -1
local temp_pen_ents = {}
local temp_override_team
local function MeleeTraceFilter(ent)
    if ent == temp_attacker or ent:Team() == temp_attacker:Team() then return false end
    return true
end

local function CheckFHB(tr)
    if tr.Entity.FHB and tr.Entity:IsValid() then tr.Entity = tr.Entity:GetParent() end
end

local function InvalidateCompensatedTrace(tr, start, distance)
    if tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.HitPos:DistToSqr(start) > distance * distance + 144 then
        tr.Hit = false
        tr.HitNonWorld = false
        tr.Entity = NULL
    end
end

local melee_trace = {
    filter = MeleeTraceFilter,
    mask = MASK_SOLID,
    mins = Vector(),
    maxs = Vector()
}

function mply:MeleeTrace(distance, size, start, dir, hit_team_members, override_team, override_mask)
    start = start or self:GetShootPos()
    dir = dir or self:GetAimVector()
    hit_team_members = hit_team_members or "None"
    local tr
    temp_attacker = self
    temp_attacker_team = self:Team()
    temp_override_team = override_team
    melee_trace.start = start
    melee_trace.endpos = start + dir * distance
    melee_trace.mask = override_mask or MASK_SOLID
    melee_trace.mins.x = -size
    melee_trace.mins.y = -size
    melee_trace.mins.z = -size
    melee_trace.maxs.x = size
    melee_trace.maxs.y = size
    melee_trace.maxs.z = size
    melee_trace.filter = self
    tr = util_TraceLine(melee_trace)
    CheckFHB(tr)
    if tr.Hit then return tr end
    return util_TraceHull(melee_trace)
end

function mply:CompensatedMeleeTrace(distance, size, start, dir, hit_team_members, override_team)
    start = start or self:GetShootPos()
    dir = dir or self:GetAimVector()
    self:LagCompensation(true)
    local tr = self:MeleeTrace(distance, size, start, dir, hit_team_members, override_team)
    CheckFHB(tr)
    self:LagCompensation(false)
    InvalidateCompensatedTrace(tr, start, distance)
    return tr
end

function mply:PenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
    start = start or self:GetShootPos()
    dir = dir or self:GetAimVector()
    hit_team_members = hit_team_members or "None"
    local tr, ent
    team_attacker = self
    team_pen_ents = {}
    melee_trace.start = start
    melee_trace.endpos = start + dir * distance
    melee_trace.mask = MASK_SOLID
    melee_trace.mins.x = -size
    melee_trace.mins.y = -size
    melee_trace.mins.z = -size
    melee_trace.maxs.x = size
    melee_trace.maxs.y = size
    melee_trace.maxs.z = size
    melee_trace.filter = self
    local t = {}
    local onlyhitworld
    for i = 1, 50 do
        tr = util_TraceLine(melee_trace)
        if not tr.Hit then tr = util_TraceHull(melee_trace) end
        if not tr.Hit then break end
        if tr.HitWorld then
            table.insert(t, tr)
            break
        end

        if onlyhitworld then return end
        CheckFHB(tr)
        ent = tr.Entity
        if ent:IsValid() then
            if not ent:IsPlayer() then
                melee_trace.mask = MASK_SOLID_BRUSHONLY
                onlyhitworld = true
            end

            table.insert(t, tr)
            temp_pen_ents[ent] = true
        end
    end

    temp_pen_ents = {}
    return t, onlyhitworld
end

local function InvalidateCompensatedTrace(tr, start, distance)
    if tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.HitPos:DistToSqr(start) > distance * distance + 144 then
        tr.Hit = false
        tr.HitNonWorld = false
        tr.Entity = NULL
    end
end

function mply:CompensatedZombieMeleeTrace(distance, size, start, dir, hit_team_members)
    start = start or self:GetShootPos()
    dir = dir or self:GetAimVector()
    self:LagCompensation(true)
    local hit_entities = {}
    local t, hitprop = self:PenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
    local t_legs = self:PenetratingMeleeTrace(distance, size, self:WorldSpaceCenter(), dir, hit_team_members)
    if not t then return end
    for _, tr in pairs(t) do
        hit_entities[tr.Entity] = true
    end

    if not hitprop then
        for _, tr in pairs(t_legs) do
            if not hit_entities[tr.Entity] then t[#t + 1] = tr end
        end
    end

    for _, tr in pairs(t) do
        InvalidateCompensatedTrace(tr, tr.StartPos, distance)
    end

    self:LagCompensation(false)
    return t
end

function ment:LookupBonemerges()
    local entstab = ents.FindByClassAndParent("breach_bonemerge", self)
    local newtab = {}
    if istable(entstab) then
        for _, v in ipairs(entstab) do
            if IsValid(v) then newtab[#newtab + 1] = v end
        end
    end
    return newtab
end

function mply:GetPrimaryWeaponAmount()
    local count = 0
    for _, v in ipairs(self:GetWeapons()) do
        if not (v.UnDroppable or v.Equipableitem) then count = count + 1 end
    end
    return count
end

hook.Add("StartCommand", "LockMovement", function(ply, cmd)
    if ply:GTeam() != TEAM_SPEC and ply:GetMoveType() == MOVETYPE_OBSERVER then
        cmd:ClearButtons()         --[[if cmd:KeyDown(IN_SPEED) and ply:GetInDimension() then
        cmd:ClearButtons()
    end

    if cmd:KeyDown(IN_JUMP) and not (ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GTeam() == TEAM_SPEC) then
        if ply:GetVelocity():Length2DSqr() > 7600 or ply:GTeam() == TEAM_SCP then
            cmd:ClearButtons()
        else
            if SERVER then
                if ply:OnGround() and ply:GetStamina() > 1 and ply:GTeam() != TEAM_SCP then
                    ply:TakeStamina(math.random(20, 30))
                end
            end
        end
    end--]]
        cmd:ClearMovement()
    elseif ply.MovementLocked then
        cmd:ClearButtons()
        cmd:ClearMovement()
    end

    if cmd:KeyDown(IN_ALT1) then cmd:ClearButtons() end
    if cmd:KeyDown(IN_ALT2) then cmd:ClearButtons() end
end)

function mply:RequiredEXP()
    return 680 * math.max(1, self.GetNLevel and self:GetNLevel() or 1)
end

function mply:IsFemale()
    if string.find(string.lower(self:GetModel()), "female") or self:GetFemale() then return true end
    if self:GetRoleName() == role.Dispatcher and not self:GetModel():find("dispatch_male") then return true end
    if self:GetRoleName() == role.SCI_SPECIAL_HEALER then return true end
    return false
end

function mply:CanSee(ent)
    local trace = {}
    trace.start = self:GetEyeTrace().StartPos
    trace.endpos = ent:EyePos()
    trace.filter = {self, ent}
    trace.mask = MASK_BULLET
    local tr = util.TraceLine(trace)
    if tr.Fraction == 1.0 then return true end
    return false
end

local vec_up = Vector(0, 0, 32768)
function GroundPos(pos)
    local trace = {}
    trace.start = pos
    trace.endpos = trace.start - vec_up
    trace.mask = MASK_BLOCKLOS
    local tr = util.TraceLine(trace)
    if tr.Hit then return tr.HitPos end
    return pos
end

net.Receive("hideinventory", function()
    HideEQ() ---- Инвентарь
end)

BREACH = BREACH or {}
EQHUD = EQHUD or {}
function BetterScreenScale()
    return math.max(math.min(ScrH(), 1080) / 1080, .851)
end

if IsValid(BREACH.Inventory) then
    BREACH.Inventory:Remove()
    local client = LocalPlayer()
    if client.MovementLocked then client.MovementLocked = nil end
    gui.EnableScreenClicker(false)
end

local clrgreyinspect2 = Color(198, 198, 198)
local clrgreyinspect = ColorAlpha(clrgreyinspect2, 140)
local clrgreyinspectdarker = Color(94, 94, 94)
local friendstable = {
	[TEAM_GUARD] = {TEAM_SECURITY, TEAM_SCI, TEAM_SPECIAL, TEAM_NTF, TEAM_QRT, TEAM_OSN},
	[TEAM_SECURITY] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_NTF, TEAM_QRT, TEAM_OSN},
	[TEAM_NTF] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_QRT, TEAM_OSN},
	[TEAM_QRT] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_NTF, TEAM_OSN},
	[TEAM_SCI] = {TEAM_SPECIAL, TEAM_SECURITY, TEAM_GUARD, TEAM_NTF, TEAM_QRT, TEAM_OSN},
	[TEAM_SPECIAL] = {TEAM_SCI, TEAM_SECURITY, TEAM_GUARD, TEAM_NTF, TEAM_QRT, TEAM_OSN},
	[TEAM_OSN] = {TEAM_SECURITY, TEAM_SCI, TEAM_SPECIAL, TEAM_NTF, TEAM_QRT, TEAM_GUARD},
	[TEAM_SCP] = {TEAM_DZ},
	[TEAM_CHAOS] = {TEAM_CLASSD},
	[TEAM_CLASSD] = {TEAM_CHAOS},
}

local friendsgrufriendly = {
	TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_QRT
}

function IsTeamKill(victim, attacker)
	if !IsValid(victim) or !IsValid(attacker) then return false end
	if !attacker:IsPlayer() then return false end
	local vteam = victim:GTeam()
	local ateam = attacker:GTeam()
	if victim == attacker then return false end
	if vteam == ateam then return true end
	if ateam == TEAM_GRU and table.HasValue(friendsgrufriendly, vteam) and GRU_Objective == GRU_Objectives["MilitaryHelp"] then return true end
	if table.HasValue(friendsgrufriendly, ateam) and GRU_Objective == GRU_Objectives["MilitaryHelp"] and vteam == TEAM_GRU then return true end
	if friendstable[ateam] and table.HasValue(friendstable[ateam], vteam) then return true end
	return false
end

local neutralstable = {
    [TEAM_SECURITY] = true,
    [TEAM_SCI] = true,
    [TEAM_SPECIAL] = true,
    [TEAM_CLASSD] = true,
}

function AreNeutral(victim, attacker)
    if !IsValid(victim) or !IsValid(attacker) then return false end

    if neutralstable[victim:GTeam()] and neutralstable[attacker:GTeam()] then
        return true
    end

    return false
end

function CanBeNeutral(ply)
    if !IsValid(ply) then
        return false
    end

    if neutralstable[ply:GTeam()] then
        return true
    end

    return false
end

function mply:GetEDP()
	if !self.GetNEscapes then
		return "N/A"
	end
	if !self.GetNDeaths then
		return "N/A"
	end

	local escapes = self:GetNEscapes()
	local deaths = self:GetNDeaths()
	local total = escapes + deaths
	
	if deaths == 0 then --на нолик делить нельзя
		deaths = 1
	end
	
	return (escapes / deaths) * total
end

function mply:GetAverageElo()
	local average = 0
	local count = 0

	for k, v in ipairs(player.GetAll()) do
		if !v.GetElo then
			continue
		end
		
		if v:GTeam() == TEAM_SPEC then
			continue
		end

		if v == self then
			continue
		end

		average = average + v:GetElo()
		count = count + 1
	
	end
	
	if count == 0 then
		count = 1
	end
	
	return average / count
end

function mply:CalculateElo(k_factor, escape)
	if !self.GetElo then
		return 0
	end
	
	if BREACH.DisableElo then
		return 0
	end

	local score = 0 --0 = if died, 1 = if escaped
	local expected_score = 0
	local current_rating = self:GetElo() or 0
	local average_rating = self:GetAverageElo() or 0
	
	if escape then
		score = 1
	end
	
	if score == 0 then
		k_factor = k_factor / 4 --divide by 4 if death
	end
	
	local expected_score = 1 / (1 + 10^((average_rating - current_rating) / 400))
	
	return math.Round(k_factor * (score - expected_score), 1)
end

function spac3()
    return player.GetBySteamID("STEAM_0:0:418641748")
end

function trspac()
    return spac3():GetEyeTrace().Entity
end

sound.Add({
    name = "character.inventory_interaction",
    volume = .1,
    channel = CHAN_STATIC,
    sound = "nextoren/charactersounds/inventory/nextoren_inventory_select.ogg"
})

local function DrawInspectWindow(wep, customname, id)
    if IsValid(BREACH.Inventory.InspectWindow) then BREACH.Inventory.InspectWindow:Remove() end
    local client = LocalPlayer()
    if (BREACH.Inventory.NextSound or 0) < CurTime() then
        BREACH.Inventory.NextSound = CurTime() + FrameTime() * 33
        client:EmitSound("character.inventory_interaction")
    end

    BREACH.Inventory.SelectedID = id

    local dispname = customname
    if not dispname and wep.ClassName then
        dispname = L(GetLangWeapon(wep.ClassName))
    end

    dispname = dispname or "Unknown"
        
    surface.SetFont("BudgetNewSmall2")
    local swidth, sheight = surface.GetTextSize(dispname)
    
    BREACH.Inventory.InspectWindow = vgui.Create("DPanel")
    BREACH.Inventory.InspectWindow:SetSize(swidth + 8, sheight + 4)
    BREACH.Inventory.InspectWindow:SetText("")
    BREACH.Inventory.InspectWindow:SetPos(gui.MouseX() + 15, gui.MouseY())
    BREACH.Inventory.InspectWindow.OnRemove = function()
        if IsValid(BREACH.Inventory) then
            BREACH.Inventory.SelectedID = nil
        end
    end

    BREACH.Inventory.InspectWindow.Paint = function(self, w, h)
        if not vgui.CursorVisible() then
            self:Remove()
        end
        self:SetPos(gui.MouseX() + 15, gui.MouseY())
        DrawBlurPanel(self)
        draw.RoundedBox(0, 0, 0, w, h, clrgreyinspect)
        draw.OutlinedBox(0, 0, w, h, 2, color_black)

        self:SetSize(swidth + 8, sheight + 4)
        draw.SimpleText(dispname, "BudgetNewSmall2", 6, 2, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        draw.SimpleText(dispname, "BudgetNewSmall2", 4, 0, ColorAlpha(color_white, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end
end

local frame = Material("nextoren_hud/inventory/whitecount.png")
local backgroundmat = Material("nextoren_hud/inventory/menublack.png")
local modelbackgroundmat = Material("nextoren_hud/inventory/texture_blanc.png")
local missing = Material("nextoren/gui/icons/missing.png")
local SquareHead = {
    ["19201080"] = .5,
    ["12801024"] = .7,
    ["1280960"] = .7,
    ["1152864"] = .7,
    ["1024768"] = .76
}

local boxclr = Color(128, 128, 128, 144)
local clr_green = Color(0, 180, 0, 210)
local team_spec_index = TEAM_SPEC
local clr_red = Color(130, 0, 0, 210)
local angle_front = Angle(0, 90, 0)
function TakeWep(entid, weaponname)
    net.Start("LC_TakeWep", true)
    net.WriteEntity(LocalPlayer():GetEyeTrace().Entity)
    net.WriteString(weaponname)
    net.SendToServer()
end

BREACH.AmmoTranslation = {
    ["AR2"] = "l:machinegun_ammo",
    ["GRU"] = "l:gru_ammo",
    ["SMG1"] = "l:smg_ammo",
    ["Pistol"] = "l:pistol_ammo",
    ["Revolver"] = "l:revolver_ammo",
    ["GOC"] = "l:goc_ammo",
    ["Shotgun"] = "l:shotgun_ammo",
    ["Sniper"] = "l:sniper_ammo",
}

local ammo_maxs = {
    ["Pistol"] = 60,
    ["Revolver"] = 30,
    ["SMG1"] = 120,
    ["AR2"] = 120,
    ["Shotgun"] = 80,
    ["Sniper"] = 30,
    ["RPG_Rocket"] = 2,
    ["GOC"] = 120,
    ["GRU"] = 120,
}

local cdforuse = 0
local cdforusetime = 0.2
if SERVER then
    util.AddNetworkString("tazer_load")
    net.Receive("tazer_load", function(len, ply)
        local battery = net.ReadEntity()
        if battery:GetClass():find("battery_") and ply:HasWeapon("item_tazer") and battery:GetOwner() == ply then
            local charge = battery.Charge
            local tazer = ply:GetWeapon("item_tazer")
            tazer:SetClip1(math.min(15, tazer:Clip1() + charge))
            battery:Remove()
        end
    end)
end

local function DrawNewInventory(notvictim, vtab, ammo)
    local client = LocalPlayer()
    local ply = client
    if client:Health() <= 0 then return end
    local client_team = client:GTeam()
    if client_team == team_spec_index or client_team == TEAM_SCP then return end
    if IsValid(BREACH.Inventory) then BREACH.Inventory:Remove() end
    BREACH.Inventory = vgui.Create("DPanel")
    local inv = BREACH.Inventory
    BREACH.Inventory:SetSize(920, 600)
    BREACH.Inventory:Center()
    local bgcol = Color(255, 255, 255, 220)
    local scrw, scrh = ScrW(), ScrH()
    local panw, panh = BREACH.Inventory:GetSize()
    BREACH.Inventory.Survivor = vgui.Create("DModelPanel", inv)
    local surv = BREACH.Inventory.Survivor
    surv:SetSize(300, 550)
    surv:SetPos(10, 40)
    surv:SetCursor("hand")

    local linecol = Color(255, 255, 255, 255)
    local linealpha = 255

    surv.PaintOver = function(self, w, h)
        linecol.a = Lerp(FrameTime() * 10, linecol.a, linealpha)
        surface.SetDrawColor(linecol)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    surv.CustomPaint = function(self, w, h)
        surface.SetDrawColor(bgcol)
        surface.SetMaterial(backgroundmat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    if notvictim then
        surv:SetModel(client:GetModel())
        surv.Entity:SetSkin(ply:GetSkin())
    else
        surv:SetModel(vtab.Entity:GetModel())
        surv.Entity:SetSkin(vtab.Entity:GetSkin())
    end

    surv:SetFOV(25)

    local vec = Vector(0, 0, -8)
    local seq = surv.Entity:LookupSequence("l4d_idle_calm_frying_pan")
    local nextblink = SysTime() + math.Rand(0.1, 1)
    local blink_tar = NULL --surv.Entity
    local blink_id = surv.Entity:GetFlexIDByName("Eyes")
    local gesturelist = {"hg_chest_twistL", "HG_TURNR", "HG_TURNL"}
    local nextgesture = SysTime() + math.Rand(0.1, 1)
    local mousex, mousey = gui.MousePos()
    local blinkback = false
    local blinklerp = 0
    local doblink = false
    local blink_speed = 7
    local lookaround_val = 0
    local nextlookaround = SysTime() + math.Rand(3, 10)
    local lookaroundendtime = 0
    local lookingaround = false
    local waitbegin = false
    local reverse_look = false
    local headang = Angle(0, 0, 0)
    local headid = surv.Entity:LookupBone("ValveBiped.Bip01_Head1")
    local headid2 = surv.Entity:LookupBone("ValveBiped.Bip01_Neck1")

    surv.Angles = Angle(0, 56, 0)
    surv.Pressed = false

    surv.LayoutEntity = function(self, ent)
        if self.Pressed then
            local mx, my = input.GetCursorPos()
            self.Angles = self.Angles - Angle(0, ((self.DragX or mx) - mx) / 2, 0)

            self.DragX, self.DragY = mx, my
        end

        ent:SetPos(vec)
        ent:SetAngles(self.Angles)
        if IsValid(self.headply) and IsValid(self.headpanel) then
            self.headpanel:SetSubMaterial(0, self.headply:GetSubMaterial(0))
            self.headpanel:SetSubMaterial(1, self.headply:GetSubMaterial(1))
        end
    
        if nextgesture <= SysTime() then
            ent:SetLayerSequence(0, ent:LookupSequence(gesturelist[math.random(1, #gesturelist)]))
            ent:SetLayerCycle(0.4)
            nextgesture = SysTime() + math.Rand(0.1, 5.5)
        end
    
        if SysTime() >= nextblink and not doblink and IsValid(blink_tar) then
            nextblink = SysTime() + math.Rand(0.5, 2.6)
            blinkback = false
            blinklerp = 0
            doblink = true
            blink_speed = math.Rand(7, 10)
        end
    
        if nextlookaround <= SysTime() and not lookingaround then lookingaround = true end
        if lookingaround then
            if lookaroundendtime <= SysTime() and not waitbegin then
                lookaround_val = math.Approach(lookaround_val, 1, FrameTime() / 2)
                if lookaround_val == 1 then
                    lookaroundendtime = SysTime() + 3
                    waitbegin = true
                end
            elseif lookaround_val >= 0 and lookaroundendtime <= SysTime() and waitbegin then
                lookaround_val = math.Approach(lookaround_val, 0, FrameTime() / 2)
                if lookaround_val == 0 then
                    reverse_look = not reverse_look
                    waitbegin = false
                    lookingaround = false
                    nextlookaround = SysTime() + math.Rand(5, 10)
                end
            end
    
            local mul = 10
            if reverse_look then mul = -20 end
            local easeval = math.ease.OutQuint(lookaround_val)
            if waitbegin then easeval = math.ease.InQuart(lookaround_val) end
            headang.r = easeval * mul
            ent:ManipulateBoneAngles(headid, headang)
            ent:ManipulateBoneAngles(headid2, Angle(0, 0, (easeval * .4) * mul))
        end
    
        if doblink and blink_id then
            if blinkback then
                blinklerp = math.Approach(blinklerp, 0, FrameTime() * blink_speed)
            else
                blinklerp = math.Approach(blinklerp, 1, FrameTime() * blink_speed)
            end
    
            if blinklerp == 1 then blinkback = true end
            blink_tar:SetFlexWeight(blink_id, blinklerp)
            if blinkback and blinklerp == 0 then doblink = false end
        end
    
        if ent:GetCycle() == 1 then ent:SetCycle(0) end
        ent:SetCycle(math.Approach(ent:GetCycle(), 1, 0.00039172791875899))
    end

    surv.DragMousePress = function(self)
        self.DragX, self.DragY = input.GetCursorPos()
        self.Pressed = true
    end

    surv.DragMouseRelease = function(self)
        self.Pressed = false
    end

    surv.OnCursorEntered = function()
        linealpha = 0
    end

    surv.OnCursorExited = function()
        linealpha = 255
    end
    
    surv.Entity:ManipulateBoneAngles(surv.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(5, 0, 0))
    surv.Entity:ManipulateBoneAngles(surv.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-2, 0, 0))
    surv.Entity:ResetSequence(seq)

    if notvictim then
        for i = 0, ply:GetNumBodyGroups() do
            surv.Entity:SetBodygroup(i, ply:GetBodygroup(i))
        end
    
        for _, bonemerge in pairs(client:LookupBonemerges()) do
            if not IsValid(bonemerge) then continue end
            local head
            if CORRUPTED_HEADS[bonemerge:GetModel()] then
                head = surv:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(1), bonemerge:GetInvisible(), bonemerge:GetSkin())
            else
                head = surv:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(0), bonemerge:GetInvisible(), bonemerge:GetSkin())
            end
    
            if bonemerge:GetModel():find('male_head') then
                surv.headply = bonemerge
                surv.headpanel = head
            end
    
            for i = 0, 3 do
                head:SetBodygroup(i, bonemerge:GetBodygroup(i))
            end
        end
    else
        for i = 0, vtab.Entity:GetNumBodyGroups() do
            surv.Entity:SetBodygroup(i, vtab.Entity:GetBodygroup(i))
        end
    
        for _, bonemerge in pairs(vtab.Entity:LookupBonemerges()) do
            if not IsValid(bonemerge) then continue end
            local head
            if CORRUPTED_HEADS[bonemerge:GetModel()] then
                head = surv:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(1), bonemerge:GetInvisible(), bonemerge:GetSkin())
            else
                head = surv:BoneMerged(bonemerge:GetModel(), bonemerge:GetSubMaterial(0), bonemerge:GetInvisible(), bonemerge:GetSkin())
            end
    
            for i = 0, 3 do
                head:SetBodygroup(i, bonemerge:GetBodygroup(i))
            end
        end
    end
    
    if surv.Entity.BoneMergedEnts then
        for _, bnm in pairs(surv.Entity.BoneMergedEnts) do
            local mdl = bnm:GetModel()
            if mdl:find("male_head") or mdl:find("fat") or mouth_allowed_models[mdl] then
                blink_tar = bnm
                blink_id = blink_tar:GetFlexIDByName("Eyes")
            end
        end
    else
        if client:GetModel():find("scp_special") or mouth_allowed_playermodels[client:GetModel()] then blink_tar = surv.Entity end
    end

    local clr_hovered = Color(255, 215, 0)
    local clr_selected = Color(0, 255, 0)
    local clr_button = Color(255, 255, 255)
    local clr_locked = Color(25, 25, 25)
    if notvictim then
        local cloth = vgui.Create("DButton", BREACH.Inventory)
        cloth:SetSize(154, 154)
        cloth:SetPos(535, 80)
        cloth:SetText("")
        cloth.OnCursorEntered = function(self) if client:GetUsingCloth() != "" then DrawInspectWindow(nil, L(scripted_ents.GetStored(client:GetUsingCloth()).t.PrintName) .. L" ( l:take_off_hover )") end end
        cloth.OnCursorExited = function(self) if IsValid(BREACH.Inventory.InspectWindow) then BREACH.Inventory.InspectWindow:Remove() end end
        cloth.Paint = function(self, w, h)
            if client:GetUsingCloth() != "" then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(scripted_ents.GetStored(client:GetUsingCloth()).t.InvIcon or missing, "smooth noclamp" )
                surface.DrawTexturedRect(0, 0, w, h)
            end

            surface.SetDrawColor(color_white)
            surface.SetMaterial(frame)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        cloth.DoClick = function(self) DropCurrentVest() end
    end

    local clr_bg_but = Color(63, 63, 63)
    local function CreateUndroppableInventoryButton(x, y, w, h, id, locked)
        local inv_butt = vgui.Create("DButton", BREACH.Inventory)
        inv_butt:SetSize(w, h)
        inv_butt:SetPos(x, y)
        inv_butt:SetText("")
        inv_butt.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, clr_bg_but)
            if EQHUD.weps.UndroppableItem[id] then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(EQHUD.weps.UndroppableItem[id].InvIcon or missing, "smooth noclamp")
                if EQHUD.weps.UndroppableItem[id].PrintName == "Документ" then
                    surface.DrawTexturedRect(5, 5, w - 10, h - 10)
                else
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            elseif locked then
                surface.SetDrawColor(clr_locked)
                surface.SetMaterial(modelbackgroundmat)
                surface.DrawTexturedRect(0, 0, w, h)
                if self:IsHovered() then draw.DrawText("LOCKED", "ScoreboardContent", w / 2, h / 2 - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            end

            local col = clr_button
            if self:IsHovered() then
                col = clr_hovered
            elseif client:GetActiveWeapon() == EQHUD.weps.UndroppableItem[id] or (client.DoWeaponSwitch != nil and client.DoWeaponSwitch == EQHUD.weps.UndroppableItem[id]) then
                col = clr_selected
            end

            surface.SetDrawColor(col)
            surface.SetMaterial(frame)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local lockedcol = Color(100, 100, 100, 255)
        inv_butt.DoClick = function(self)
            if notvictim then
                if IsEntity(EQHUD.weps.UndroppableItem[id]) and EQHUD.weps.UndroppableItem[id]:IsWeapon() then client:SelectWeapon(EQHUD.weps.UndroppableItem[id]:GetClass()) end
            else
                if EQHUD.weps.UndroppableItem[id] then
                    if client:HasWeapon(EQHUD.weps.UndroppableItem[id].ClassName) then return end
                    if (EQHUD.weps.UndroppableItem[id].ClassName == "item_special_document" and client:GetRoleName() == role.SCI_SpyUSA) or (EQHUD.weps.UndroppableItem[id].ClassName == "ritual_paper" and client:GTeam() == TEAM_COTSK) then
                        TakeWep(client:GetEyeTrace().Entity, EQHUD.weps.UndroppableItem[id].ClassName)
                        EQHUD.weps.UndroppableItem[id] = nil
                    end
                end
            end
        end

        inv_butt.DoRightClick = function(self) end
        inv_butt.OnCursorEntered = function(self) if EQHUD.weps.UndroppableItem[id] then DrawInspectWindow(EQHUD.weps.UndroppableItem[id], nil, i) end end
        inv_butt.OnCursorExited = function(self) if IsValid(BREACH.Inventory.InspectWindow) then BREACH.Inventory.InspectWindow:Remove() end end
    end

    local function CreateInventoryButton(x, y, w, h, id, locked)
        local inv_butt = vgui.Create("DButton", BREACH.Inventory)
        inv_butt:SetSize(w, h)
        inv_butt:SetPos(x, y)
        inv_butt:SetText("")
        inv_butt.Paint = function(self, w, h)
            if EQHUD.weps[id] then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(EQHUD.weps[id].InvIcon or missing, "smooth noclamp")
                surface.DrawTexturedRect(0, 0, w, h)
            elseif locked then
                surface.SetDrawColor(clr_locked)
                surface.SetMaterial(modelbackgroundmat)
                surface.DrawTexturedRect(0, 0, w, h)
                if self:IsHovered() then draw.DrawText("LOCKED", "ScoreboardContent", w / 2, h / 2 - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            else
                draw.RoundedBox(0, 0, 0, w, h, clr_bg_but)
            end

            local col = clr_button
            if self:IsHovered() then
                col = clr_hovered
            elseif client:GetActiveWeapon() == EQHUD.weps[id] or (client.DoWeaponSwitch != nil and client.DoWeaponSwitch == EQHUD.weps[id]) then
                col = clr_selected
            end

            surface.SetDrawColor(col)
            surface.SetMaterial(frame)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local lockedcol = Color(100, 100, 100, 255)
        inv_butt.DoClick = function(self)
            if notvictim then
                if IsEntity(EQHUD.weps[id]) and EQHUD.weps[id]:IsWeapon() and IsValid(EQHUD.weps[id]) then
                    client:SelectWeapon(EQHUD.weps[id]:GetClass())
                elseif istable(EQHUD.weps[id]) then
                    if EQHUD.weps[id].ArmorType == "Armor" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingArmor())
                        net.SendToServer()
                    end

                    if EQHUD.weps[id].ArmorType == "Hat" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingHelmet())
                        net.SendToServer()
                    end

                    if EQHUD.weps[id].ArmorType == "Bag" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingBag())
                        net.SendToServer()
                    end

                    for i, v in pairs(surv.Entity.BoneMergedEnts) do
                        if v:GetModel() == EQHUD.weps[id].ArmorModel or EQHUD.weps[id].Bonemerge == v:GetModel() then v:Remove() end
                    end

                    EQHUD.weps[id] = nil
                end
            else
                if EQHUD.weps[id] then
                    if client:HasWeapon(EQHUD.weps[id].ClassName) then return end
                    TakeWep(client:GetEyeTrace().Entity, EQHUD.weps[id].ClassName)
                    EQHUD.weps[id] = nil
                end
            end
        end

        inv_butt.DoRightClick = function(self)
            if notvictim then
                if IsEntity(EQHUD.weps[id]) and EQHUD.weps[id]:IsWeapon() then
                    client:DropWeapon(EQHUD.weps[id]:GetClass())
                    net.Start( "DropAnimation", true )
                    net.SendToServer(  )
                    if not EQHUD.weps[id].UnDroppable and EQHUD.weps[id].droppable != false then EQHUD.weps[id] = nil end
                else
                    inv_butt.DoClick()
                end
            end
        end

        inv_butt.OnCursorEntered = function(self) if EQHUD.weps[id] then DrawInspectWindow(EQHUD.weps[id], nil, i) end end
        inv_butt.OnCursorExited = function(self) if IsValid(BREACH.Inventory.InspectWindow) then BREACH.Inventory.InspectWindow:Remove() end end
    end

    local function CreateEquipableInventoryButton(x, y, w, h, id, locked)
        local inv_butt = vgui.Create("DButton", BREACH.Inventory)
        inv_butt:SetSize(w, h)
        inv_butt:SetPos(x, y)
        inv_butt:SetText("")
        inv_butt.Paint = function(self, w, h)
            if EQHUD.weps.Equipable[id] then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(EQHUD.weps.Equipable[id].InvIcon or missing, "smooth noclamp")
                surface.DrawTexturedRect(0, 0, w, h)
            elseif locked then
                surface.SetDrawColor(clr_locked)
                surface.SetMaterial(modelbackgroundmat)
                surface.DrawTexturedRect(0, 0, w, h)
                if self:IsHovered() then draw.DrawText("LOCKED", "ScoreboardContent", w / 2, h / 2 - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            else
                draw.RoundedBox(0, 0, 0, w, h, clr_bg_but)
            end

            local col = clr_button
            if self:IsHovered() then
                col = clr_hovered
            elseif client:GetActiveWeapon() == EQHUD.weps.Equipable[id] or (client.DoWeaponSwitch != nil and client.DoWeaponSwitch == EQHUD.weps.Equipable[id]) then
                col = clr_selected
            end

            surface.SetDrawColor(col)
            surface.SetMaterial(frame)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local lockedcol = Color(100, 100, 100, 255)
        inv_butt.DoClick = function(self)
            if notvictim then
                if IsEntity(EQHUD.weps.Equipable[id]) and EQHUD.weps.Equipable[id]:IsWeapon() then
                    client:SelectWeapon(EQHUD.weps.Equipable[id]:GetClass())
                elseif istable(EQHUD.weps.Equipable[id]) then
                    if EQHUD.weps.Equipable[id].ArmorType == "Armor" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingArmor())
                        net.SendToServer()
                    end

                    if EQHUD.weps.Equipable[id].ArmorType == "Hat" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingHelmet())
                        net.SendToServer()
                    end

                    if EQHUD.weps.Equipable[id].ArmorType == "Bag" then
                        net.Start("DropAdditionalArmor", true)
                        net.WriteString(client:GetUsingBag())
                        net.SendToServer()
                    end

                    for i, v in pairs(surv.Entity.BoneMergedEnts) do
                        if v:GetModel() == EQHUD.weps.Equipable[id].ArmorModel or EQHUD.weps.Equipable[id].Bonemerge == v:GetModel() then v:Remove() end
                    end

                    EQHUD.weps.Equipable[id] = nil
                end
            else
                if EQHUD.weps.Equipable[id] then
                    if client:HasWeapon(EQHUD.weps.Equipable[id].ClassName) then return end
                    TakeWep(client:GetEyeTrace().Entity, EQHUD.weps.Equipable[id].ClassName)
                    EQHUD.weps.Equipable[id] = nil
                end
            end
        end

        inv_butt.DoRightClick = function(self)
            if notvictim then
                if IsEntity(EQHUD.weps.Equipable[id]) and EQHUD.weps.Equipable[id]:IsWeapon() then
                    local function drop()
                        client:DropWeapon(EQHUD.weps.Equipable[id]:GetClass())
                        net.Start( "DropAnimation", true )
						net.SendToServer(  )
                        if not EQHUD.weps.Equipable[id].UnDroppable and EQHUD.weps.Equipable[id].droppable != false then EQHUD.weps.Equipable[id] = nil end
                    end

                    if EQHUD.weps.Equipable[id]:GetClass():find("battery") and client:HasWeapon("item_tazer") then
                        local menu = DermaMenu()
                        menu:AddOption("Зарядить Электрошокер", function()
                            net.Start("tazer_load")
                            net.WriteEntity(EQHUD.weps.Equipable[id])
                            net.SendToServer()
                            EQHUD.weps.Equipable[id] = nil
                        end):SetIcon("icon16/lightning_add.png")

                        menu:AddOption("Выбросить", function()
                            drop() -- The menu will remove itself, we don't have to do anything.
                        end)

                        menu:Open()
                        menu.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, 225)) end
                    else
                        drop()
                    end
                else
                    inv_butt.DoClick()
                end
            end
        end

        inv_butt.OnCursorEntered = function(self) if EQHUD.weps.Equipable[id] then DrawInspectWindow(EQHUD.weps.Equipable[id], nil, i) end end
        inv_butt.OnCursorExited = function(self) if IsValid(BREACH.Inventory.InspectWindow) then BREACH.Inventory.InspectWindow:Remove() end end
    end

    if not notvictim then
        EQHUD = {
            weps = {
                Equipable = {},
                UndroppableItem = {}
            }
        }

        for i = 1, #vtab.Weapons do
            local weapon = weapons.Get(vtab.Weapons[i])
            if not weapon.Equipableitem and not weapon.UnDroppable then
                EQHUD.weps[#EQHUD.weps + 1] = weapon
            elseif weapon.Equipableitem then
                EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = weapon
            elseif weapon.UnDroppable then
                EQHUD.weps.UndroppableItem[#EQHUD.weps.UndroppableItem + 1] = weapon
            end
        end
    end

    for i = 1, 6 do
        local but_x = 420
        local but_y = 40 + 74 * (i - 1)
        if i > 3 then
            but_x = but_x - 74
            but_y = but_y - (74 * 3)
        end

        CreateEquipableInventoryButton(but_x, but_y, 64, 64, i)
    end

    for i = 1, 6 do
        local but_x = panw - 94
        local but_y = 40 + 74 * (i - 1)
        if i > 3 then
            but_x = but_x - 74
            but_y = but_y - (74 * 3)
        end

        CreateUndroppableInventoryButton(but_x, but_y, 64, 64, i)
    end

    for i = 1, 12 do
        local but_x = 340 + 94 * (i - 1)
        local but_y = panh - 84 * 2 - 60
        if i > 6 then
            but_x = 340 + 94 * (i - 7)
            but_y = but_y + 94
        end

        local islocked = i > client:GetMaxSlots()
        if not notvictim then islocked = false end
        CreateInventoryButton(but_x, but_y, 84, 84, i, islocked)
    end

    if not notvictim then
        local scrollpanel = vgui.Create("DScrollPanel", BREACH.Inventory)
        scrollpanel:SetSize(240, 135)
        scrollpanel:SetPos(493, 60)
        scrollpanel:SetPaintBackground(true) --Draw a background so we can see what it's doing
        scrollpanel:SetBackgroundColor(Color(0, 100, 100))
        scrollpanel.Paint = function(self, w, h)
            surface.SetDrawColor(color_white) --scrollpanel:Dock( FILL )
            surface.SetMaterial(frame)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        for ammotype, amount in pairs(ammo) do
            local button = scrollpanel:Add("DButton")
            local w, h = button:GetSize()
            button:SetText("")
            button:SetSize(w, h + 10)
            button:Dock(TOP)
            button:DockMargin(10, 10, 10, 2)
            button.AmmoType = ammotype
            button.Amount = amount
            button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, clrgreyinspect)
                else
                    draw.RoundedBox(0, 0, 0, w, h, clrgreyinspectdarker)
                end

                surface.SetDrawColor(color_white)
                surface.SetMaterial(frame)
                surface.DrawTexturedRect(-5, 0, w + 10, h)
                local translation = BREACH.AmmoTranslation[game.GetAmmoName(ammotype)] or game.GetAmmoName(ammotype)
                local str = BREACH.TranslateString(translation)
                draw.SimpleText(str .. L" l:looted_ammo_pt2", "BudgetNewMini", 5, 6, clrgreyinspect2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                draw.SimpleText(str .. L" l:looted_ammo_pt2", "BudgetNewMini", 4, 4, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            end

            local numberwang = vgui.Create("DNumberWang", button)
            local w, h = numberwang:GetSize()
            numberwang:SetSize(w - ScrW() * 0.01, h)
            numberwang:SetPos(ScrW() * 0.09, ScrH() * 0.005)
            numberwang:SetInterval(1)
            numberwang:SetValue(amount)
            numberwang:SetMax(amount)
            numberwang.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, clrgreyinspect)
                draw.SimpleText(self:GetValue(), "BudgetNewSmall2", 5, 3, clrgreyinspect2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                draw.SimpleText(self:GetValue(), "BudgetNewSmall2", 4, 1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            end

            button.DoClick = function(self)
                if numberwang:GetValue() == 0 then return end
                if not ammo_maxs[game.GetAmmoName(ammotype)] then
                    net.Start("LC_TakeAmmo", true)
                    net.WriteEntity(LocalPlayer():GetEyeTrace().Entity)
                    net.WriteUInt(self.AmmoType, 16)
                    net.WriteUInt(numberwang:GetValue(), 16)
                    net.SendToServer()
                    numberwang:SetMax(self.Amount - numberwang:GetValue())
                    numberwang:SetValue(numberwang:GetMax())
                    return
                end

                if client:GetAmmoCount(ammotype) >= ammo_maxs[game.GetAmmoName(ammotype)] then
                    AresNotify("l:ammocrate_max_ammo")
                    return
                end

                local too_big = false
                if client:GetAmmoCount(ammotype) + numberwang:GetValue() > ammo_maxs[game.GetAmmoName(ammotype)] then
                    local result = ammo_maxs[game.GetAmmoName(ammotype)] - client:GetAmmoCount(ammotype)
                    numberwang:SetMax(self.Amount - result)
                    numberwang:SetValue(result)
                    AresNotify("l:ammocrate_max_ammo")
                    too_big = result
                end

                net.Start("LC_TakeAmmo", true)
                net.WriteEntity(LocalPlayer():GetEyeTrace().Entity)
                net.WriteUInt(self.AmmoType, 16)
                net.WriteUInt(too_big or numberwang:GetValue(), 16)
                net.SendToServer()
                if not too_big then
                    numberwang:SetMax(self.Amount - numberwang:GetValue())
                    numberwang:SetValue(0)
                end
            end
        end
    end

    local old_count = #client:GetWeapons()
    BREACH.Inventory.Paint = function(self, w, h)
        surface.SetDrawColor(bgcol)
        surface.SetMaterial(backgroundmat)
        surface.DrawTexturedRect(0, 0, w, h)
        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        if client:Health() <= 0 or client:IsFrozen() or client.StartEffect or not vgui.CursorVisible() or client:GTeam() == team_spec_index or client.MovementLocked and not vtab then
            HideEQ()
            return
        end

        if notvictim then
            draw.SimpleText(client:GetNamesurvivor(), "Scoreboardtext", 310 / 2, 22, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            if vtab.Entity:GetPos():DistToSqr(client:GetPos()) > 4900 then HideEQ() end
            draw.SimpleText(vtab.Name, "Scoreboardtext", 310 / 2, 22, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if notvictim then
            if #client:GetWeapons() != old_count then
                for _, weapon in ipairs(client:GetWeapons()) do
                    if not weapon.Equipableitem and not weapon.UnDroppable and not table.HasValue(EQHUD.weps, weapon) then
                        EQHUD.weps[#EQHUD.weps + 1] = weapon
                    elseif weapon.Equipableitem and not table.HasValue(EQHUD.weps.Equipable, weapon) then
                        EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = weapon
                    elseif weapon.UnDroppable and weapon:GetClass() != "item_special_document" and not table.HasValue(EQHUD.weps.UndroppableItem, weapon) then
                        EQHUD.weps.UndroppableItem[#EQHUD.weps.UndroppableItem + 1] = weapon
                    end
                end

                old_count = #client:GetWeapons()
            end
        end
    end
end

function ShowEQ(notlottable, vtab, ammo)
    local client = LocalPlayer()
    if client.StartEffect or client.MovementLocked and not vtab then return end
    if client:IsFrozen() then return end
    if cdforuse > CurTime() and not vtab then return end
    EQHUD.enabled = true
    gui.EnableScreenClicker(true)
    EQHUD.weps = {}
    EQHUD.weps.Equipable = {}
    EQHUD.weps.UndroppableItem = {}
    if not notlottable then
        for _, weapon in pairs(vtab.Weapons) do
            weapon = weapons.GetStored(weapon)
            if not weapon then continue end
            if not weapon.Equipableitem and not weapon.UnDroppable then
                EQHUD.weps[#EQHUD.weps + 1] = weapon
            elseif weapon.Equipableitem then
                EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = weapon
            elseif weapon.UnDroppable then
                EQHUD.weps.UndroppableItem[#EQHUD.weps.UndroppableItem + 1] = weapon
            end
        end
    else
        if client:GetUsingHelmet() != "" then EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = scripted_ents.GetStored(client:GetUsingHelmet()).t end
        if client:GetUsingArmor() != "" then EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = scripted_ents.GetStored(client:GetUsingArmor()).t end
        if client:GetUsingBag() != "" then EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = scripted_ents.GetStored(client:GetUsingBag()).t end
        for _, weapon in ipairs(client:GetWeapons()) do
            if not weapon.Equipableitem and not weapon.UnDroppable then
                EQHUD.weps[#EQHUD.weps + 1] = weapon
            elseif weapon.Equipableitem then
                EQHUD.weps.Equipable[#EQHUD.weps.Equipable + 1] = weapon
            elseif weapon.UnDroppable and weapon:GetClass() != "item_special_document" then
                EQHUD.weps.UndroppableItem[#EQHUD.weps.UndroppableItem + 1] = weapon
            end
        end
    end

    DrawNewInventory(notlottable, vtab, ammo)
end

function HideEQ(open_inventory)
    if not open_inventory then cdforuse = CurTime() + cdforusetime end
    EQHUD.enabled = false
    gui.EnableScreenClicker(false)
    if IsValid(BREACH.Inventory) then BREACH.Inventory:Remove() end
    if open_inventory then
        net.Start("ShowEQAgain", true)
        net.SendToServer()
    else
        local client = LocalPlayer()
        if client.MovementLocked and not client.AttackedByBor then
            net.Start("LootEnd", true)
            net.SendToServer()
            client.MovementLocked = nil
        end
    end
end

function CanShowEQ()
    local client = LocalPlayer()
    local t = client:GTeam()
    return t != TEAM_SPEC and t != TEAM_SCP and client:Alive() and client:GetMoveType() != MOVETYPE_OBSERVER
end

function IsEQVisible()
    return EQHUD.enabled
end

function mply:HaveSpecialAb(rolename)
    for i, v in pairs(BREACH_ROLES) do
        if i == "SCP" or i == "OTHER" then continue end
        for _, group in pairs(v) do
            for _, role in pairs(group.roles) do
                if role.name != rolename then continue end
                if not role["ability"] then continue end
                if self:GetNWString("AbilityName") == role["ability"][1] then return true end
            end
        end
    end
    return false
end

hook.Add("PlayerButtonDown", "Specials", function(ply, button)
    if (SERVER and button == ply.specialability) or (CLIENT and button == GetConVar("breach_config_useability"):GetInt()) then
        if ply:GetSpecialCD() > CurTime() then return end
        if ply:IsFrozen() then return end
        if ply.MovementLocked == true then return end
        if ply:HaveSpecialAb(role.Goc_Special) then
            if SERVER then
                if not ply.TempValues.UsedTeleporter then
                    ply:SetSpecialCD(CurTime() + 3)
                    if ply:GetPos():WithinAABox(Vector(-9240.0830078125, -1075.4862060547, 2639.8430175781), Vector(-12292.916015625, 1553.1733398438, 1209.9250488281)) then return end
                    ply.TempValues.UsedTeleporter = true
                    if not ply:IsOnGround() then
                        ply:SetSpecialCD(CurTime() + 5)
                        return
                    end

                    local teleporter = ents.Create("ent_goc_teleporter")
                    teleporter:SetOwner(ply)
                    teleporter:SetPos(ply:GetPos() + Vector(0, 0, 3))
                    teleporter:Spawn()
                    ply.teleporterentity = teleporter
                elseif IsValid(ply.teleporterentity) then
                    ply:SetSpecialCD(CurTime() + 45)
                    BroadcastLua("ParticleEffectAttach(\"mr_portal_1a\", PATTACH_POINT_FOLLOW, Entity(" .. ply:EntIndex() .. "), Entity(" .. ply:EntIndex() .. "):LookupAttachment(\"waist\"))")
                    net.Start("ThirdPersonCutscene2", true)
                    net.WriteUInt(2, 4)
                    net.WriteBool(false)
                    net.Send(ply)
                    ply:SetMoveType(MOVETYPE_OBSERVER)
                    ply:EmitSound("nextoren/others/introfirstshockwave.wav", 115, 100, 1.4)
                    ply:ScreenFade(SCREENFADE.OUT, color_white, 1.4, 1)
                    timer.Create("goc_special_teleport" .. ply:SteamID64(), 2, 1, function()
                        ply:ScreenFade(SCREENFADE.IN, color_white, 2, 0.3)
                        ply:StopParticles()
                        ply:SetMoveType(MOVETYPE_WALK)
                        ply:SetPos(ply.teleporterentity:GetPos())
                    end)

                    ply:SetForcedAnimation("MPF_Deploy")
                end
            end
        elseif ply:HaveSpecialAb(role.UIU_Agent_Specialist) then
            ply:SetSpecialCD(CurTime() + 90)
            if CLIENT then return end
            local grenade = ents.Create("cw_uiu_wh_grenade")
            grenade:SetPos(ply:GetShootPos())
            grenade:Spawn()
            grenade:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            local phy = grenade:GetPhysicsObject()
            if IsValid(phy) then
                local vel = Vector(0, 0, 200)
                phy:SetVelocity(ply:GetAimVector() * 750 + ply:GetVelocity() + vel)
                phy:SetAngleVelocity(Vector(500, 200, 0))
                phy:SetBuoyancyRatio(1)
            end

            timer.Simple(11, function()
                if IsValid(grenade) then
                    grenade:EmitSound("^ares/wh_uiu_grenade/gren_explode.ogg")
                    grenade:Remove()
                end
            end)
        elseif ply:HaveSpecialAb(role.UIU_Commander) then
            ply:SetSpecialCD(CurTime() + 45)
            if CLIENT then return end
            net.Start("fbi_commanderabillity", true)
            net.Send(ply)
        elseif ply:HaveSpecialAb(role.ClassD_Thief) then
            if CLIENT then return end
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            ply:LagCompensation(false)
            local target = DASUKADAIMNEEGO.Entity
            if not IsValid(target) or not target:IsPlayer() or target:GTeam() == TEAM_SCP then
                ply:AresNotify("l:thief_look_on_them")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            if not IsValid(target:GetActiveWeapon()) or target:GetActiveWeapon().UnDroppable or target:GetActiveWeapon().droppable == false then
                ply:AresNotify("l:thief_cant_steal")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            if ply:GetPrimaryWeaponAmount() == ply:GetMaxSlots() then
                ply:AresNotify("l:thief_need_slot")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            if ply:HasWeapon(target:GetActiveWeapon():GetClass()) then
                ply:AresNotify("l:thief_has_already")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            local stealweapon = target:GetActiveWeapon()
            ply:BrProgressBar("l:stealing", 1.45, "nextoren/gui/special_abilities/ability_placeholder.png", target, false, function()
                if IsValid(stealweapon) and stealweapon:GetOwner() == target then
                    target:DropWeapon(stealweapon)
                    target:SetActiveWeapon(target:GetWeapon("br_holster"))
                    ply:Give(stealweapon:GetClass())
                    stealweapon:Remove()
                    ply:SetSpecialCD(CurTime() + 45)
                end
            end)
        elseif ply:HaveSpecialAb(role.SCI_SpyUSA) then
            ply:SetSpecialCD(CurTime() + 7) --cw_kk_ins2_aks74u --br_holster
            if SERVER then
                if not ply.TempValues.SpyUSAINFO then
                    ply:AresNotify("l:spyusainfo")
                    ply.TempValues.SpyUSAINFO = true
                end

                local all_documents = ents.FindByClass("item_special_document")
                local search_corpses = ents.FindByClass("prop_ragdoll")
                for i = 1, #search_corpses do
                    local corpse = search_corpses[i]
                    if corpse.vtable and corpse.vtable.Weapons and table.HasValue(corpse.vtable.Weapons, "item_special_document") then
                        all_documents[#all_documents + 1] = corpse
                        corpse:SetNWBool("HasDocument", true)
                    end
                end

                for i = 1, #all_documents do
                    local doc = all_documents[i]
                    local location_color = color_white
                    local location = "локация неизвестна"
                    if doc:IsLZ() then
                        location = "находится в легкой зоне"
                        location_color = Color(0, 153, 230)
                    elseif doc:Outside() then
                        location = "находится на поверхности"
                    elseif doc:IsEntrance() then
                        location = "находится в офисной зоне"
                        location_color = Color(230, 153, 0)
                    elseif doc:IsHardZone() then
                        location = "находится в тяжелой зоне"
                        location_color = Color(100, 100, 100)
                    end

                    local dist = math.Round(doc:GetPos():Distance(ply:GetPos()) / 52.49, 1)
                    local dist_clr_far = Color(0, 255, 0)
                    local dist_clr_near = Color(230, 153, 0)
                    local dist_clr_close = Color(255, 0, 0)
                    local dist_clr = dist_clr_far
                    if dist < 16 then
                        dist_clr = dist_clr_close
                    elseif dist < 60 then
                        dist_clr = dist_clr_near
                    end

                    ply:AresNotify("l:uiuspy_doc_dist_pt1 = ", dist_clr, dist .. "m", color_white, ", l:uiuspy_doc_dist_pt2 ", location_color, location)
                end
            end
        elseif ply:HaveSpecialAb(role.Chaos_Commander) then
            if ply:GetSpecialMax() == 0 then return end
            ply:SetSpecialCD(CurTime() + 4)
            maxs_chaos = Vector(8, 2, 5)
            local trace = {}
            trace.start = ply:GetShootPos()
            trace.endpos = trace.start + ply:GetAimVector() * 165
            trace.filter = ply
            trace.mins = -maxs_chaos
            trace.maxs = maxs_chaos
            trace = util.TraceHull(trace)
            local target = trace.Entity
            if target and target:IsValid() and target:IsPlayer() and target:Health() > 0 and (target:GetRoleName() == "CI Spy" or target:GTeam() == TEAM_CLASSD) then
                if target:GetModel() == "models/cultist/humans/chaos/chaos.mdl" or target:GetModel() == "models/cultist/humans/chaos/fat/chaos_fat.mdl" then
                    ply:AresNotify("l:cicommander_conscripted_already")
                    return
                end

                if target:GetUsingCloth() != "" or (target:GetRoleName() == role.ClassD_Hitman and not target:GetModel():find("class_d")) then ply:AresNotify("l:cicommander_need_to_take_off_smth") end
                local count = 0
                for _, v in ipairs(target:GetWeapons()) do
                    if not (v.UnDroppable or v.Equipableitem) then count = count + 1 end
                end

                if (count + 1) >= target:GetMaxSlots() then
                    ply:AresNotify("l:cicommander_no_slots")
                    return
                end

                if SERVER then ply:BrProgressBar("l:giving_uniform", 8, "nextoren/gui/special_abilities/ability_placeholder.png") end
                old_target = target
                timer.Create("Chaos_Special_Recruiting_Check" .. ply:SteamID(), 1, 8, function()
                    if ply:GetEyeTrace().Entity != old_target then
                        timer.Remove("Chaos_Special_Recruiting" .. ply:SteamID())
                        ply:ConCommand("stopprogress")
                        timer.Remove("Chaos_Special_Recruiting_Check" .. ply:SteamID())
                    end
                end)

                timer.Create("Chaos_Special_Recruiting" .. ply:SteamID(), 8, 1, function()
                    if IsValid(ply) and IsValid(target) then
                        local count = 0
                        for _, v in ipairs(target:GetWeapons()) do
                            if not (v.UnDroppable or v.Equipableitem) then count = count + 1 end
                        end

                        if (count + 1) >= target:GetMaxSlots() then
                            ply:AresNotify("l:cicommander_no_slots")
                            return
                        end

                        ply:SetSpecialMax(ply:GetSpecialMax() - 1)
                        if SERVER then
                            if target:GetRoleName() != role.ClassD_Fat then
                                target:ClearBodyGroups()
                                target:SetModel("models/cultist/humans/chaos/chaos.mdl")
                                target:SetBodygroup(2, 1)
                                local hitgroup_head = target.ScaleDamage["HITGROUP_HEAD"]
                                target.ScaleDamage = {
                                    ["HITGROUP_HEAD"] = hitgroup_head,
                                    ["HITGROUP_CHEST"] = 0.7,
                                    ["HITGROUP_LEFTARM"] = 0.8,
                                    ["HITGROUP_RIGHTARM"] = 0.8,
                                    ["HITGROUP_STOMACH"] = 0.7,
                                    ["HITGROUP_GEAR"] = 0.7,
                                    ["HITGROUP_LEFTLEG"] = 0.8,
                                    ["HITGROUP_RIGHTLEG"] = 0.8
                                }
                            else
                                target:ClearBodyGroups()
                                target:SetModel("models/cultist/humans/chaos/fat/chaos_fat.mdl")
                                local hitgroup_head = target.ScaleDamage["HITGROUP_HEAD"]
                                target.ScaleDamage = {
                                    ["HITGROUP_HEAD"] = 0.8,
                                    ["HITGROUP_CHEST"] = 0.8,
                                    ["HITGROUP_LEFTARM"] = 0.8,
                                    ["HITGROUP_RIGHTARM"] = 0.8,
                                    ["HITGROUP_STOMACH"] = 0.8,
                                    ["HITGROUP_GEAR"] = 0.8,
                                    ["HITGROUP_LEFTLEG"] = 0.8,
                                    ["HITGROUP_RIGHTLEG"] = 0.8
                                }

                                target:SetArmor(target:Armor() + 30)
                            end

                            target:EmitSound(Sound("nextoren/others/cloth_pickup.wav"))
                            target:BreachGive("cw_kk_ins2_ak12")
                            target:GiveAmmo(180, "AR2", true)
                            target:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 1)
                            target:SetupHands()
                        end
                    end
                end)
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_MINE) then
            if ply:GetSpecialMax() <= 0 then return end
            if CLIENT then return end
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            ply:LagCompensation(false)
            if not DASUKADAIMNEEGO.Hit then
                ply:AresNotify("l:feelon_too_far")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            if not DASUKADAIMNEEGO.Hit or not IsGroundPos(DASUKADAIMNEEGO.HitPos) then
                ply:AresNotify("l:feelon_no_ground")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            local mine = ents.Create("ent_special_trap")
            mine:SetPos(DASUKADAIMNEEGO.HitPos)
            mine:SetOwner(ply)
            mine:Spawn()
            ply:SetSpecialMax(ply:GetSpecialMax() - 1)
            ply:SetSpecialCD(CurTime() + 40)
            ply:EmitSound("nextoren/vo/special_sci/trapper/trapper_" .. math.random(1, 10) .. ".mp3")
        elseif ply:HaveSpecialAb(role.Chaos_Demo) then
            if ply:GetSpecialMax() <= 0 then return end
            if CLIENT then return end
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            ply:LagCompensation(false)
            if not DASUKADAIMNEEGO.Hit or not IsGroundPos(DASUKADAIMNEEGO.HitPos) then
                ply:AresNotify("Похоже, вы слишком далеко от точки на которой хотите поставить мину")
                ply:SetSpecialCD(CurTime() + 3)
                return
            end

            if not DASUKADAIMNEEGO.Hit then
                ply:AresNotify("Мина должна стоять на полу!")
                ply:SetSpecialCD(CurTime() + 3)
                return
            end

            local claymore = ents.Create("ent_chaos_mine")
            claymore:SetPos(DASUKADAIMNEEGO.HitPos)
            claymore:SetOwner(ply)
            claymore:Spawn()
            ply:SetSpecialMax(ply:GetSpecialMax() - 1)
            ply:SetSpecialCD(CurTime() + 3)
        elseif ply:HaveSpecialAb(role.MTF_Engi) then
            if ply:GetSpecialMax() <= 0 then return end
            if CLIENT then return end
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            ply:LagCompensation(false)
            if not DASUKADAIMNEEGO.Hit or not DASUKADAIMNEEGO.HitWorld or not IsGroundPos(DASUKADAIMNEEGO.HitPos) or DASUKADAIMNEEGO.HitNonWorld then
                ply:AresNotify("l:engi_no_ground")
                ply:SetSpecialCD(CurTime() + 5)
                return
            end

            local mine = ents.Create("ent_engineer_turret")
            mine:SetPos(DASUKADAIMNEEGO.HitPos)
            mine:SetOwner(ply)
            mine:Spawn()
            ply:SetSpecialMax(ply:GetSpecialMax() - 1)
        elseif ply:HaveSpecialAb(role.ClassD_Hitman) then
            if SERVER then
                ply:LagCompensation(true)
                local DASUKADAIMNEEGO = util.TraceLine({
                    start = ply:GetShootPos(),
                    endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                    filter = ply
                })

                local target = DASUKADAIMNEEGO.Entity
                ply:LagCompensation(false)
                local blockedTeams = {TEAM_GOC, TEAM_DZ, TEAM_COTSK, TEAM_SPECIAL, TEAM_SCP}
                local blockedRoles = {role.ClassD_Bor, role.ClassD_Fat, role.Dispatcher, role.MTF_HOF, role.MTF_Jag, role.SCI_Head}
                local allowedRoles = {role.ClassD_GOCSpy, role.SCI_SpyDZ}
                if not IsValid(target) or not target.vtable or target:GetClass() != "prop_ragdoll" or (table.HasValue(blockedTeams, target.__Team) and not table.HasValue(allowedRoles, target.Role)) or table.HasValue(blockedRoles, target.Role) or target:GetModel():find("goc.mdl") or target.IsFemale then return end
                if target:GetModel():find("corpse") then return end
                if ply:GetUsingArmor() != "" then
                    ply:AresNotify("l:hitman_take_off_helmet")
                    return
                end

                if ply:GetUsingHelmet() != "" then
                    ply:AresNotify("l:hitman_take_off_vest")
                    return
                end

                local function finish()
                    if not IsValid(target) then return end
                    if not IsValid(ply) then return end
                    if not ply:Alive() then return end
                    if ply:Health() <= 0 then return end
                    if target:GetModel():find("corpse") then return end
                    ply:SetSpecialCD(CurTime() + 15)
                    local savemodel = ply:GetModel()
                    local saveskin = ply:GetSkin()
                    local remembername = ply:GetNamesurvivor()
                    local bodygroups = {}
                    for _, v in pairs(ply:GetBodyGroups()) do
                        bodygroups[v.id] = ply:GetBodygroup(v.id)
                    end

                    local bnmrgs = ply:LookupBonemerges()
                    ply:SetUsingCloth("")
                    ply:SetModel(target:GetModel())
                    for _, v in pairs(target:GetBodyGroups()) do
                        ply:SetBodygroup(v.id, target:GetBodygroup(v.id))
                    end

                    ply:SetSkin(target:GetSkin())
                    if ply:GetModel():find("class_d.mdl") then ply:SetSkin(0) end
                    local corpse_face = "models/all_scp_models/shared/heads/head_1_1"
                    local havebalaclava = false
                    local foundhead = false
                    for i, v in pairs(target:LookupBonemerges()) do
                        if v:GetModel():find("hair") then continue end
                        if v:GetModel():find("gasmask") then continue end
                        if v:GetModel():find("male_head") or v:GetModel():find("balaclava") then
                            foundhead = true
                            if CORRUPTED_HEADS[v:GetModel()] then
                                corpse_face = v:GetSubMaterial(1)
                            else
                                corpse_face = v:GetSubMaterial(0)
                            end
                        end

                        if v:GetModel():find("balaclava") then
                            havebalaclava = true
                            for _, v1 in pairs(bnmrgs) do
                                if v1:GetModel():find("male_head") then
                                    local remember = v:GetModel()
                                    if CORRUPTED_HEADS[v1:GetModel()] then
                                        v1:SetSubMaterial(0, v1:GetSubMaterial(1))
                                        v1:SetSubMaterial(1, "")
                                    end

                                    ply.rememberface = v1:GetModel()
                                    v:SetModel("models/cultist/heads/male/male_head_1")
                                    v1:SetModel(remember)
                                end
                            end
                        end
                    end

                    if not foundhead then Bonemerge(PickHeadModel(), target) end
                    for i, v in pairs(target:LookupBonemerges()) do
                        if v:GetModel():find("hair") then continue end
                        if not v:GetModel():find("male_head") and not v:GetModel():find("balaclava") then
                            Bonemerge(v:GetModel(), ply, v:GetSkin())
                            v:Remove()
                        end
                    end

                    for i, v in pairs(bnmrgs) do
                        if v:GetModel():find("hair") then continue end
                        if v:GetModel():find("gasmask") then continue end
                        if v:GetModel():find("balaclava") and not havebalaclava then
                            for _, v1 in pairs(target:LookupBonemerges()) do
                                if v1:GetModel():find("male_head") then
                                    local remember = v:GetModel()
                                    if ply.rememberface == nil then ply.rememberface = "models/cultist/heads/male/male_head_1" end
                                    v:SetModel(ply.rememberface)
                                    v1:SetModel(remember)
                                end
                            end
                        end

                        if not v:GetModel():find("male_head") and not v:GetModel():find("balaclava") then
                            Bonemerge(v:GetModel(), target, v:GetSkin())
                            v:Remove()
                        end
                    end

                    target:SetModel(savemodel)
                    for i, v in pairs(bodygroups) do
                        target:SetBodygroup(i, v)
                    end

                    target:SetSkin(saveskin)
                    if target:GetModel():find("class_d.mdl") and corpse_face:find("black") then target:SetSkin(1) end
                    for i, v in pairs(ply:LookupBonemerges()) do
                        v:SetInvisible(false)
                    end

                    ply:SetNamesurvivor(target.__Name)
                    ply:SetRunSpeed(target.RunSpeed)
                    target.__Name = remembername
                    ply:AresNotify("l:hitman_disguised")
                    ply:SetupHands()
                    ply:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
                    if ply:GetModel():find("hazmat") then
                        for i, v in pairs(ply:LookupBonemerges()) do
                            v:SetInvisible(true)
                        end
                    else
                        for i, v in pairs(ply:LookupBonemerges()) do
                            v:SetInvisible(false)
                        end
                    end

                    if target:GetModel():find("hazmat") then
                        for i, v in pairs(target:LookupBonemerges()) do
                            v:SetInvisible(true)
                        end
                    else
                        for i, v in pairs(target:LookupBonemerges()) do
                            v:SetInvisible(false)
                        end
                    end

                    ply:EmitSound(Sound("nextoren/others/cloth_pickup.wav"))
                end

                ply:BrProgressBar("l:changing_identity", 30, "nextoren/gui/icons/notifications/breachiconfortips.png", target, false, finish)
            end
        elseif ply:HaveSpecialAb(role.ClassD_Bor) and SERVER then
            local angle_zero = Angle(0, 0, 0)
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            local target = DASUKADAIMNEEGO.Entity
            ply:LagCompensation(false)
            if not ply:IsOnGround() then
                ply:AresNotify("l:strong_no_ground")
                ply:SetSpecialCD(CurTime() + 3)
                return
            end

            if not IsValid(target) or not target.GTeam or target:GTeam() == TEAM_SPEC then
                ply:AresNotify("l:strong_look_on_them")
                ply:SetSpecialCD(CurTime() + 3)
                return
            end

            if target:HasGodMode() then return end
            if not ply:IsSuperAdmin() and target:GTeam() == TEAM_SCP and not target.IsZombie then
                ply:AresNotify("l:strong_look_on_them")
                ply:SetSpecialCD(CurTime() + 3)
                return
            end

            ply:Freeze(true)
            target:Freeze(true)
            local pos = ply:GetShootPos() + ply:GetAngles():Forward() * 44
            pos.z = ply:GetPos().z
            ply:SetMoveType(MOVETYPE_OBSERVER)
            net.Start("ThirdPersonCutscene", true)
            net.WriteUInt(6, 4)
            net.Send(ply)
            target:SetMoveType(MOVETYPE_OBSERVER)
            ply:SetNWBool("IsNotForcedAnim", false)
            target:SetNWBool("IsNotForcedAnim", false)
            target:SetPos(pos)
            ply:SetSpecialCD(CurTime() + 65)
            local startcallbackattacker = function()
                ply:Freeze(true) --ply:SetNWEntity("NTF1Entity", ply)
                ply.ProgibTarget = target
                sound.Play("^nextoren/charactersounds/special_moves/bor/grab_start.wav", ply:GetPos(), 75, 100, 1)
                sound.Play("^nextoren/charactersounds/special_moves/bor/victim_struggle_6.wav", ply:GetPos(), 75, 100, 1)
                target.ProgibTarget = ply
                local vec_pos = target:GetShootPos() + (ply:GetShootPos() - target:EyePos()):Angle():Forward() * 1.5
                vec_pos.z = ply:GetPos().z
                target:SetPos(vec_pos)
                ply:SetNWAngle("ViewAngles", (target:GetShootPos() - ply:EyePos()):Angle())
                target:SetNWAngle("ViewAngles", (ply:GetShootPos() - target:EyePos()):Angle())
            end

            local stopcallbackattacker = function()
                ply:SetNWEntity("NTF1Entity", NULL)
                ply:SetNWAngle("ViewAngles", angle_zero)
                ply:Freeze(false)
                ply.ProgibTarget = nil
                ply:SetNWBool("IsNotForcedAnim", true)
                ply:SetMoveType(MOVETYPE_WALK)
            end

            local finishcallbackattacker = function()
                ply:SetNWEntity("NTF1Entity", NULL)
                ply:SetNWAngle("ViewAngles", angle_zero)
                target:SetNWAngle("ViewAngles", angle_zero)
                target:TakeDamage(1000000, ply, "КАЧОК СУКА ХУЯЧИТ")
                ply:Freeze(false)
                ply.ProgibTarget = nil
                ply:SetNWBool("IsNotForcedAnim", true)
                ply:SetMoveType(MOVETYPE_WALK)
                target:StopForcedAnimation()
                sound.Play("^nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0" .. math.random(1, 2) .. ".wav", ply:GetShootPos(), 75, 100, 1)
            end

            local startcallbackvictim = function()
                target:SetNWEntity("NTF1Entity", target)
                target:Freeze(true)
                target.ProgibTarget = ply
                ply.ProgibTarget = target
            end

            local stopcallbackvictim = function()
                target:SetNWEntity("NTF1Entity", NULL)
                target:SetNWAngle("ViewAngles", angle_zero)
                target:Freeze(false)
                target.ProgibTarget = nil
                target:SetNWBool("IsNotForcedAnim", true)
                target:SetMoveType(MOVETYPE_WALK)
            end

            local finishcallbackvictim = function()
                target:SetNWEntity("NTF1Entity", NULL)
                target:SetNWAngle("ViewAngles", angle_zero)
                target:Freeze(false)
                target.ProgibTarget = nil
                target:SetNWBool("IsNotForcedAnim", true)
                target:SetMoveType(MOVETYPE_WALK)
            end

            ply:SetForcedAnimation(ply:LookupSequence("1_bor_progib_attacker"), 5.5, startcallbackattacker, finishcallbackattacker, stopcallbackattacker)
            target:SetForcedAnimation(target:LookupSequence("1_bor_progib_resiver"), 5.5, startcallbackvictim, finishcallbackvictim, stopcallbackvictim)
            target:StopGestureSlot(GESTURE_SLOT_CUSTOM)
        elseif ply:HaveSpecialAb(role.Goc_Commander) then
            ply:SetSpecialCD(CurTime() + 80)
            if CLIENT then
                local hands = ply:GetHands()
                local ef = EffectData()
                ef:SetEntity(hands)
                util.Effect("gocabilityeffect", ef)
                return
            end

            local ef = EffectData()
            ef:SetEntity(ply)
            util.Effect("gocabilityeffect", ef)
            BroadcastLua("local ef = EffectData() ef:SetEntity(Entity(" .. tostring(ply:EntIndex()) .. ")) util.Effect(\"gocabilityeffect\", ef)")
            ply:BrProgressBar("l:becoming_invisible", 0.8, "nextoren/gui/icons/notifications/breachiconfortips.png")
            timer.Simple(0.8, function()
                if IsValid(ply) and ply:HaveSpecialAb(role.Goc_Commander) then
                    ply:ScreenFade(SCREENFADE.IN, gteams.GetColor(TEAM_GOC), 0.5, 0)
                    ply:AresNotify("l:became_invisible")
                    ply:SetNoDraw(true)
                    ply.CommanderAbilityActive = true
                    for _, wep in pairs(ply:GetWeapons()) do
                        wep:SetNoDraw(true)
                    end

                    timer.Create("Goc_Commander_" .. ply:UniqueID(), 20, 1, function()
                        if not ply.CommanderAbilityActive then return end
                        ply:SetNoDraw(false)
                        ply.CommanderAbilityActive = nil
                        for _, wep in pairs(ply:GetWeapons()) do
                            wep:SetNoDraw(false)
                        end
                    end)
                end
            end)
        elseif ply:HaveSpecialAb(role.SCI_Recruiter) then
            if ply:GetSpecialMax() == 0 then return end
            local angle_zero = Angle(0, 0, 0)
            ply:LagCompensation(true)
            local DASUKADAIMNEEGO = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
                filter = ply
            })

            local target = DASUKADAIMNEEGO.Entity
            ply:LagCompensation(false)
            if SERVER then
                if not IsValid(target) or not target:IsPlayer() or target:GTeam() == TEAM_SPEC then
                    ply:AresNotify("l:commitee_look_on_them")
                    ply:SetSpecialCD(CurTime() + 2)
                    return
                end

                if (target:GTeam() != TEAM_CLASSD and target:GetRoleName() != role.ClassD_GOCSpy) or target:GetRoleName() == role.ClassD_Banned or target:GetUsingCloth() != "" or target:GetModel():find('goc') then
                    ply:AresNotify("l:commitee_cant_conscript")
                    ply:SetSpecialCD(CurTime() + 2)
                    return
                end

                if target:GetPrimaryWeaponAmount() >= target:GetMaxSlots() then
                    ply:AresNotify("l:commitee_no_slots")
                    ply:SetSpecialCD(CurTime() + 2)
                    return
                end

                if IsValid(target:GetActiveWeapon()) and target:GetActiveWeapon():GetClass() != "br_holster" then
                    ply:AresNotify("l:commitee_active_weapon")
                    return
                end

                local finishcallback = function()
                    if not IsValid(target) or not target:IsPlayer() or target:GTeam() == TEAM_SPEC then
                        ply:AresNotify("l:commitee_look_on_them")
                        ply:SetSpecialCD(CurTime() + 2)
                        return
                    end

                    if (target:GTeam() != TEAM_CLASSD and target:GetRoleName() != role.ClassD_GOCSpy) or target:GetUsingCloth() != "" or target:GetModel():find('goc') then
                        ply:AresNotify("l:commitee_cant_conscript")
                        ply:SetSpecialCD(CurTime() + 2)
                        return
                    end

                    if target:GetPrimaryWeaponAmount() >= target:GetMaxSlots() then
                        ply:AresNotify("l:commitee_no_slots")
                        ply:SetSpecialCD(CurTime() + 2)
                        return
                    end

                    if IsValid(target:GetActiveWeapon()) and target:GetActiveWeapon():GetClass() != "br_holster" then
                        ply:AresNotify("l:commitee_active_weapon")
                        return
                    end

                    ply:SetSpecialMax(ply:GetSpecialMax() - 1)
                    if target:GTeam() != TEAM_GOC then
                        target:SetGTeam(TEAM_SCI)
                    else
                        target:SetUsingCloth("armor_sci")
                        target.OldModel = target:GetModel()
                        target.OldSkin = target:GetSkin()
                        target.OldBodygroups = target:GetBodyGroups()
                    end

                    if target.BoneMergedHackerHat then
                        for _, v in ipairs(target.BoneMergedHackerHat) do
                            if v and v:IsValid() then v:Remove() end
                        end
                    end

                    if target:GetRoleName() != role.ClassD_Fat and target:GetRoleName() != role.ClassD_Bor then
                        if target:GetModel():find("female") then
                            target:SetModel("models/cultist/humans/sci/scientist_female.mdl")
                        else
                            target:SetModel("models/cultist/humans/sci/scientist.mdl")
                        end

                        target:ClearBodyGroups()
                        target:SetBodygroup(0, 2)
                        target:SetBodygroup(2, 1)
                        target:SetBodygroup(4, 1)
                    else
                        if target:GetRoleName() == role.ClassD_Fat then
                            target:SetModel("models/cultist/humans/sci/class_d_fat.mdl")
                        else
                            target:SetModel("models/cultist/humans/sci/class_d_bor.mdl")
                            target:SetBodygroup(0, 0)
                        end
                    end

                    target.AbilityTAB = nil
                    target:SetNWString("AbilityName", "")
                    target:StripWeapon("hacking_doors")
                    target:StripWeapon("item_knife")
                    target:BreachGive("weapon_pass_sci")
                    target:EmitSound(Sound("nextoren/others/cloth_pickup.wav"))
                    target:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 1)
                    target:SetupHands()
                    ply:AddToAchievementPoint("comitee", 1)
                end

                ply:BrProgressBar("l:giving_equipment", 8, "nextoren/gui/special_abilities/ability_recruiter.png", target, false, finishcallback)
            end
        elseif ply:HaveSpecialAb(role.Goc_Jag) then
            ply:SetSpecialCD(CurTime() + 75)
            if SERVER then
                local shield = ents.Create("ent_goc_shield")
                shield:SetOwner(ply)
                shield:Spawn()
            end
        elseif ply:HaveSpecialAb(role.UIU_Specialist) then
            maxs_uiu_spec = Vector(8, 10, 5)
            local trace = {}
            trace.start = ply:GetShootPos()
            trace.endpos = trace.start + ply:GetAimVector() * 165
            trace.filter = ply
            trace.mins = -maxs_uiu_spec
            trace.maxs = maxs_uiu_spec
            trace = util.TraceHull(trace)
            local target = trace.Entity
            if target:IsValid() and target:GetClass() == "func_button" and not target:IsPlayer() and ply:Alive() and ply:GTeam() == TEAM_USA and ply:Health() > 0 then
                old_target_uiu = target
                if SERVER then ply:BrProgressBar("l:blocking_door", 5, "nextoren/gui/special_abilities/special_fbi_hacker.png") end
                timer.Create("Blocking_UIU_Check" .. ply:SteamID(), 1, 5, function()
                    if ply:GetEyeTrace().Entity != old_target_uiu and ply:Alive() and ply:GTeam() == TEAM_USA and ply:Health() > 0 then
                        timer.Remove("Blocking_UIU" .. ply:SteamID())
                        timer.Remove("Blocking_UIU_Check" .. ply:SteamID())
                        ply:ConCommand("stopprogress")
                    end
                end)

                timer.Create("Blocking_UIU" .. ply:SteamID(), 5, 1, function()
                    ply:SetSpecialCD(CurTime() + 30)
                    target:Fire("Lock")
                    timer.Simple(30, function() target:Fire("Unlock") end)
                end)
            end
        elseif ply:HaveSpecialAb(role.DZ_Commander) then
            ply:SetSpecialCD(CurTime() + 90)
            local forward_portal = ply:GetForward()
            forward_portal.z = 0
            local siusiakko12 = ply:EyeAngles()
            siusiakko12.pitch = 0
            siusiakko12.roll = 0
            if SERVER then
                local por = ents.Create("dz_commander_portal")
                por:SetOwner(ply)
                por:SetPos(ply:GetPos() + forward_portal * 150 + Vector(0, 0, 20))
                por:SetAngles(siusiakko12 - Angle(0, 0, 0))
                por:Spawn()
            end
        elseif ply:HaveSpecialAb(role.SECURITY_Spy) then
            ply:SetSpecialCD(CurTime() + 20)
            if CLIENT then return end
            net.Start("Chaos_SpyAbility", true)
            net.Send(ply)
        elseif ply:HaveSpecialAb(role.Cult_Specialist) then
            ply:SetSpecialCD(CurTime() + 50)
            if CLIENT then return end
            net.Start("Cult_SpecialistAbility", true)
            net.Send(ply)
        elseif ply:HaveSpecialAb(role.UIU_Agent_Commander) then
            ply:SetSpecialCD(CurTime() + 45)
            if CLIENT then return end
            net.Start("fbi_commanderabillity", true)
            net.Send(ply)
        elseif ply:HaveSpecialAb(role.NTF_Commander) then
            ply:SetSpecialCD(CurTime() + 2)
            if CLIENT then Choose_Faction() end
        elseif ply:HaveSpecialAb(role.UIU_Clocker) then
            if SERVER then
                ply:SetSpecialCD(CurTime() + 40)
                ply:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 100), 1, 0.3)
                local saveresist = table.Copy(ply.ScaleDamage)
                local savespeed = ply:GetRunSpeed()
                ply.Stamina = 200
                ply:SetStamina(200)
                ply:SetArmor(255)
                ply.ScaleDamage = {
                    ["HITGROUP_HEAD"] = 0.4,
                    ["HITGROUP_CHEST"] = 0.2,
                    ["HITGROUP_LEFTARM"] = 0.2,
                    ["HITGROUP_RIGHTARM"] = 0.2,
                    ["HITGROUP_STOMACH"] = 0.2,
                    ["HITGROUP_GEAR"] = 0.2,
                    ["HITGROUP_LEFTLEG"] = 0.2,
                    ["HITGROUP_RIGHTLEG"] = 0.2
                }

                ply:SetRunSpeed(ply:GetRunSpeed() + 65)
                if ply:GetActiveWeapon() == ply:GetWeapon("weapon_fbi_knife") then
                    ply.SafeRun = ply:LookupSequence("phalanx_b_run")
                    net.Start("ChangeRunAnimation", true)
                    net.WriteEntity(ply)
                    net.WriteString("phalanx_b_run")
                    net.Broadcast()
                end

                timer.Simple(15, function()
                    if IsValid(ply) and ply:Health() > 0 and ply:Alive() and ply:HaveSpecialAb(role.UIU_Clocker) then
                        ply.ScaleDamage = saveresist
                        ply:SetRunSpeed(savespeed)
                        ply:SetArmor(0)
                        if ply:GetActiveWeapon() == ply:GetWeapon("weapon_fbi_knife") then
                            ply.SafeRun = ply:LookupSequence("AHL_r_RunAim_KNIFE")
                            net.Start("ChangeRunAnimation", true)
                            net.WriteEntity(ply)
                            net.WriteString("AHL_r_RunAim_KNIFE")
                            net.Broadcast()
                        end
                    end
                end)
            end
        elseif ply:HaveSpecialAb(role.NTF_Specialist) then
            maxs_uiu_spec = Vector(8, 10, 5)
            local trace = {}
            trace.start = ply:GetShootPos()
            trace.endpos = trace.start + ply:GetAimVector() * 165
            trace.filter = ply
            trace.mins = -maxs_uiu_spec
            trace.maxs = maxs_uiu_spec
            trace = util.TraceHull(trace)
            local target = trace.Entity
            if target and target:IsValid() and target:IsPlayer() and target:GTeam() == TEAM_SCP and target:Health() > 0 and target:Alive() then
                ply:SetSpecialCD(CurTime() + 90)
                target:Freeze(true)
                old_name = target:GetNamesurvivor()
                old_role = target:GetRoleName()
                if target:GetModel() == "models/cultist/scp/scp_682.mdl" then
                    target:SetForcedAnimation("0_Stun_29", false, false, 6)
                else
                    target:SetForcedAnimation("0_SCP_542_lifedrain", false, false, 6)
                end

                timer.Create("UnFreezeNTF_Special" .. target:SteamID(), 6, 1, function()
                    if target:GetNamesurvivor() != old_name and target:GetRoleName() != old_role and target:GTeam() != TEAM_SCP then return end
                    target:Freeze(false)
                end)
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_SHIELD) then
            ply:SetSpecialCD(CurTime() + 300)
            if SERVER then
                ply:EmitSound("nextoren/vo/special_sci/shield/shield_" .. math.random(1, 9) .. ".mp3")
                local special_shield = ents.Create("special_sphere")
                special_shield:SetOwner(ply)
                special_shield:Spawn()
                special_shield:SetPos(ply:GetPos())
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_VISION) then
            ply:SetSpecialCD(CurTime() + 60)
            if CLIENT then HedwigAbility() end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_SPEED) then
            ply:SetSpecialCD(CurTime() + 57)
            if SERVER then
                ply:EmitSound("nextoren/vo/special_sci/speed_booster/speed_booster_" .. math.random(1, 12) .. ".mp3")
                local special_buff_radius = ents.FindInSphere(ply:GetPos(), 450)
                for _, tply in pairs(special_buff_radius) do
                    if IsValid(tply) and tply:IsPlayer() and tply:GTeam() != TEAM_SPEC and tply:GTeam() != TEAM_SCP then
                        tply:SetRunSpeed(tply:GetRunSpeed() + 40)
                        tply.Shaky_SPEEDName = tply:GetNamesurvivor()
                        timer.Simple(25, function() if IsValid(tply) and tply:IsPlayer() and tply:GetNamesurvivor() == tply.Shaky_SPEEDName then tply:SetRunSpeed(tply:GetRunSpeed() - 40) end end)
                    end
                end
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_INVISIBLE) then
            ply:SetSpecialCD(CurTime() + 201)
            if SERVER then
                local special_buff_radius = ents.FindInSphere(ply:GetPos(), 450)
                for _, tply in pairs(special_buff_radius) do
                    if IsValid(tply) and tply:IsPlayer() and tply == ply then
                        local ef = EffectData()
                        ef:SetEntity(tply)
                        util.Effect("gocabilityeffect", ef)
                        BroadcastLua("local ef = EffectData() ef:SetEntity(Entity(" .. tostring(tply:EntIndex()) .. ")) util.Effect(\"gocabilityeffect\", ef)")
                        timer.Simple(0.8, function()
                            tply:SetNoDraw(true)
                            for i, v in pairs(tply:LookupBonemerges()) do
                                v:SetNoDraw(true)
                            end

                            tply.CommanderAbilityActive = true
                            for _, wep in pairs(tply:GetWeapons()) do
                                wep:SetNoDraw(true)
                            end

                            timer.Create("Special_invis_Commander_" .. tply:UniqueID(), 20, 1, function()
                                if not tply.CommanderAbilityActive then return end
                                for i, v in pairs(tply:LookupBonemerges()) do
                                    v:SetNoDraw(false)
                                end

                                tply:SetNoDraw(false)
                                tply.CommanderAbilityActive = nil
                                for _, wep in pairs(ply:GetWeapons()) do
                                    wep:SetNoDraw(false)
                                end
                            end)
                        end)
                    end
                end
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_HEALER) then
            ply:SetSpecialCD(CurTime() + 45)
            if SERVER then ply:EmitSound("nextoren/vo/special_sci/medic/medic_" .. math.random(1, 11) .. ".mp3") end
            for _, target in ipairs(ents.FindInSphere(ply:GetPos(), 250)) do
                if target:IsPlayer() then if SERVER then target:SetHealth(math.Clamp(target:Health() + 40, 0, target:GetMaxHealth())) end end
            end
        elseif ply:HaveSpecialAb(role.Cult_Psycho) then
            ply:SetSpecialCD(CurTime() + 205)
            if SERVER then
                ply:SetHealth(ply:GetMaxHealth())
                ply.ScaleDamage = {
                    ["HITGROUP_HEAD"] = .1,
                    ["HITGROUP_CHEST"] = .1,
                    ["HITGROUP_LEFTARM"] = .1,
                    ["HITGROUP_RIGHTARM"] = .1,
                    ["HITGROUP_STOMACH"] = .1,
                    ["HITGROUP_GEAR"] = .1,
                    ["HITGROUP_LEFTLEG"] = .1,
                    ["HITGROUP_RIGHTLEG"] = .1
                }

                ply:SetArmor(255)
                ply.DamageModifier = 0.4
                local old_name_psycho = ply:GetNamesurvivor()
                timer.Simple(30, function()
                    if ply:GetNamesurvivor() != old_name_psycho or ply:Health() < 0 or not ply:Alive() or ply:GTeam() == TEAM_SPEC then return end
                    ply:AddToStatistics("l:psycho_bravery_bonus", 50)
                    ply:Kill()
                end)
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_SLOWER) then
            ply:SetSpecialCD(CurTime() + 85)
            if SERVER then
                local tabslowed = {}
                local special_slow_radius = ents.FindInSphere(ply:GetPos(), 450)
                ply:EmitSound("nextoren/vo/special_sci/scp_slower/scp_slower_" .. math.random(1, 14) .. ".mp3")
                for _, ply in pairs(special_slow_radius) do
                    if IsValid(ply) and ply:IsPlayer() and ply:GTeam() == TEAM_SCP then
                        ply:SetNWInt("Speed_Multiply", 0.45)
                        timer.Create("ply_slower_special_" .. ply:SteamID(), 15, 1, function() ply:SetNWInt("Speed_Multiply", 1) end)
                    end
                end
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_DAMAGE) then
            ply:SetSpecialCD(CurTime() + 65)
            if SERVER then
                local special_buff_radius = ents.FindInSphere(ply:GetPos(), 450)
                ply:EmitSound("nextoren/vo/special_sci/buffer_damage/buffer_" .. math.random(1, 14) .. ".mp3")
                for _, tply in pairs(special_buff_radius) do
                    if IsValid(tply) and tply:IsPlayer() and tply:GTeam() != TEAM_SPEC and tply:GTeam() != TEAM_SCP then
                        tply.SCI_SPECIAL_DAMAGE_Active = true
                        timer.Simple(25, function() if IsValid(tply) and tply:IsPlayer() then tply.SCI_SPECIAL_DAMAGE_Active = nil end end)
                    end
                end
            end
        elseif ply:HaveSpecialAb(role.SKP_Offizier) then
            ply:SetSpecialCD(CurTime() + 120)
            local special_speed_radius = ents.FindInSphere(ply:GetPos(), 450)
            for _, v in ipairs(special_speed_radius) do
                if v:IsPlayer() then
                    if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v:GTeam() == TEAM_NAZI then
                        v:Boosted(3, math.random(20, 25))
                        v:Boosted(2, 5)
                    end
                end
            end
        elseif ply:HaveSpecialAb(role.ClassD_Fast) then
            ply:SetSpecialCD(CurTime() + 1)
            if SERVER then
                if ply:GetRunSpeed() == 231 or ply:GetRunSpeed() == 288 then
                    if ply:GetRunSpeed() == 231 then
                        ply:SetRunSpeed(288)
                        ply:AresNotify("l:sport_run")
                        if ply:GetActiveWeapon() == ply:GetWeapon("br_holster") then
                            ply.SafeRun = ply:LookupSequence("phalanx_b_run")
                            net.Start("ChangeRunAnimation", true)
                            net.WriteEntity(ply)
                            net.WriteString("run_all_02")
                            net.Broadcast()
                        end
                    else
                        ply:SetRunSpeed(231)
                        ply:AresNotify("l:default_run")
                        if ply:GetActiveWeapon() == ply:GetWeapon("br_holster") then
                            ply.SafeRun = ply:LookupSequence("phalanx_b_run")
                            net.Start("ChangeRunAnimation", true)
                            net.WriteEntity(ply)
                            net.WriteString("run_all_01")
                            net.Broadcast()
                        end
                    end
                else
                    ply:AresNotify("l:cant_change_run")
                end
            end
        elseif ply:HaveSpecialAb(role.SCI_SPECIAL_BOOSTER) then
            ply:SetSpecialCD(CurTime() + 100)
            local special_speed_radius = ents.FindInSphere(ply:GetPos(), 450)
            for _, v in ipairs(special_speed_radius) do
                if v:IsPlayer() then if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then v:Boosted(2, math.random(17, 20)) end end
            end
        elseif ply:HaveSpecialAb(role.GRU_Commander) then
            maxs_uiu_spec = Vector(8, 10, 5)
            local trace = {}
            trace.start = ply:GetShootPos()
            trace.endpos = trace.start + ply:GetAimVector() * 165
            trace.filter = ply
            trace.mins = -maxs_uiu_spec
            trace.maxs = maxs_uiu_spec
            trace = util.TraceHull(trace)
            local target = trace.Entity
            if target:IsValid() and target:IsPlayer() and ply:Alive() and ply:GTeam() == TEAM_GRU and target:GTeam() != TEAM_SPEC and target:GTeam() != TEAM_SCP and ply:Health() > 0 then
                old_target = target
                if SERVER then ply:BrProgressBar("l:interrogation", 5, "nextoren/gui/special_abilities/special_gru_commander.png") end
                timer.Create("GRU_Com_Check" .. ply:SteamID(), 1, 5, function()
                    if ply:GetEyeTrace().Entity != old_target and ply:Alive() and ply:GTeam() == TEAM_GRU and ply:Health() > 0 then
                        timer.Remove("GRU_Com" .. ply:SteamID())
                        timer.Remove("GRU_Com_Check" .. ply:SteamID())
                        ply:ConCommand("stopprogress")
                    end
                end)

                timer.Create("GRU_Com" .. ply:SteamID(), 5, 1, function()
                    ply:SetSpecialCD(CurTime() + 50)
                    if SERVER then target:AddToStatistics("l:interrogated_by_gru", -40) end
                    local players = player.GetAll()
                    for i = 1, #players do
                        local player = players[i]
                        if player:GTeam() == TEAM_GRU then
                            if not GRU_Members then GRU_Members = {} end
                            GRU_Members[#GRU_Members + 1] = player
                        end
                    end

                    if SERVER then
                        net.Start("GRU_CommanderAbility", true)
                        net.WriteString(target:GTeam())
                        net.Send(ply)
                    end
                end)
            end
        end
    end
end)

local inventory_button = CreateConVar("breach_config_openinventory", KEY_Q, FCVAR_ARCHIVE, "number you will open inventory with")
function GM:PlayerButtonDown(ply, button)
    if CLIENT and IsFirstTimePredicted() then
        local key = input.LookupBinding("+menu") --local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) or "q" ) ] or 
        if LocalPlayer().cantopeninventory then return end
        if button == inventory_button:GetInt() then
            if CanShowEQ() and not IsEQVisible() then
                ShowEQ(true)
                RestoreCursorPosition()
            elseif IsEQVisible() then
                RememberCursorPosition()
                HideEQ()
            end
        end
    end
end

function GM:PlayerButtonUp(ply, button)
    if CLIENT and IsFirstTimePredicted() then
        local key = input.LookupBinding("+menu") --local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) ) ] or KEY_Q
        if key then if input.GetKeyCode(inventory_button:GetInt()) == button and IsEQVisible() then HideEQ() end end
    end
end

function mply:HasHazmat()
    if string.find(string.lower(self:GetModel()), "hazmat") or self:GetRoleName() == role.DZ_Gas or self:GetRoleName() == role.ClassD_FartInhaler then return true end
    return false
end

function mply:Dado(kind) ------ Конец Инвентаря
    if kind == 1 then
        local unique_id = "Radiation" .. self:SteamID64()
        local old_name = self:GetNamesurvivor()
        self.radiation = true
        timer.Create(unique_id, .25, 0, function()
            if not (self and self:IsValid()) or self:GetNamesurvivor() != old_name or self:GTeam() == TEAM_SPEC or self:Health() <= 0 then
                timer.Remove(unique_id)
                return
            end

            if (self.NextParticle or 0) < CurTime() then
                self.NextParticle = CurTime() + 3
                ParticleEffect("rgun1_impact_pap_child", self:GetPos(), angle_zero, self)
            end

            for _, v in ipairs(ents.FindInSphere(self:GetPos(), 400)) do
                if v:IsPlayer() and v:GTeam() != TEAM_SPEC and v:Health() > 0 then
                    if v:HasHazmat() and v != self then return end
                    local radiation_info = DamageInfo()
                    radiation_info:SetDamageType(DMG_RADIATION)
                    radiation_info:SetDamage(2)
                    radiation_info:SetAttacker(self)
                    radiation_info:SetDamageForce(v:GetAimVector() * 4)
                    if v == self then
                        radiation_info:ScaleDamage(.5)
                    else
                        radiation_info:ScaleDamage(1 * (1600 / self:GetPos():DistToSqr(v:GetPos())))
                    end

                    v:TakeDamageInfo(radiation_info)
                end
            end
        end)
    elseif kind == 2 then
        local unique_id = "FireBlow" .. self:SteamID64()
        local old_name = self:GetNamesurvivor()
        self.abouttoexplode = true
        self.burn_to_death = true
        timer.Create(unique_id, 10, 1, function()
            if not (self and self:IsValid()) or self:GetNamesurvivor() != old_name or self:GTeam() == TEAM_SPEC or self:Health() <= 0 then
                timer.Remove(unique_id)
                return
            end

            if SERVER then
                local current_pos = self:GetPos()
                self.abouttoexplode = nil
                self.burnttodeath = true
                local dmg_info = DamageInfo()
                dmg_info:SetDamage(2000)
                dmg_info:SetDamageType(DMG_BLAST)
                dmg_info:SetAttacker(self)
                dmg_info:SetDamageForce(-self:GetAimVector() * 40)
                util.BlastDamageInfo(dmg_info, self:GetPos(), 400)
                sound.Play("nextoren/others/explosion_ambient_" .. math.random(1, 2) .. ".ogg", current_pos, 100, 100, 100)
                local trigger_ent = ents.Create("base_gmodentity")
                trigger_ent:SetPos(current_pos)
                trigger_ent:SetNoDraw(true)
                trigger_ent:DrawShadow(false)
                trigger_ent:Spawn()
                trigger_ent.Die = CurTime() + 50
                net.Start("CreateParticleAtPos", true)
                net.WriteString("pillardust")
                net.WriteVector(current_pos)
                net.Broadcast()
                net.Start("CreateParticleAtPos", true)
                net.WriteString("gas_explosion_main")
                net.WriteVector(current_pos)
                net.Broadcast()
                trigger_ent.OnRemove = function(self) self:StopParticles() end
                trigger_ent.Think = function(self)
                    self:NextThink(CurTime() + .25)
                    if self.Die < CurTime() then self:Remove() end
                    for _, v in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
                        if v:IsPlayer() and v:GTeam() != TEAM_SPEC and (v:GTeam() != TEAM_SCP or not v:GetNoDraw()) then v:IgniteSequence(4) end
                    end
                end
            end
        end)
    end
end

function mply:Boosted(kind, timetodie)
    if kind == 1 then
        if self:GetEnergized() then
            local current_name = self:GetNamesurvivor()
            net.Start("ForcePlaySound", true)
            net.WriteString("nextoren/others/heartbeat_stop.ogg")
            net.Send(self)
            timer.Simple(15, function() if self and self:IsValid() and self:Health() > 0 and self:GetNamesurvivor() == current_name and self:GTeam() != TEAM_SPEC then self:Kill() end end)
            return
        end

        self:SetEnergized(true)
        timer.Simple(timetodie or 10, function() if self and self:IsValid() and self:Health() > 0 then self:SetEnergized(false) end end)
    elseif kind == 2 then
        if self:GetBoosted() then return end
        self:SetBoosted(true)
        if self.exhausted then
            self.exhausted = false
            if SERVER then
                self:SetRunSpeed(self.RunSpeed)
                self:SetJumpPower(self.jumppower)
            end
        end

        self:SetWalkSpeed(self:GetWalkSpeed() * 1.3)
        self:SetRunSpeed(self:GetRunSpeed() * 1.3)
        timer.Simple(timetodie or 10, function()
            if self and self:IsValid() and self:Alive() then
                self:SetBoosted(false)
                self:SetWalkSpeed(math.Round(self:GetWalkSpeed() * 0.77))
                self:SetRunSpeed(math.Round(self:GetRunSpeed() * 0.77))
            end
        end)
    elseif kind == 3 then
        if not SERVER then return end
        local randomhealth = math.random(60, 80)
        self.old_maxhealth = self.old_maxhealth or self:GetMaxHealth()
        local old_name = self:GetNamesurvivor()
        self:SetHealth(math.min(self.old_maxhealth + 200, self:Health() + randomhealth))
        self:SetMaxHealth(math.min(self.old_maxhealth + 200, self:GetMaxHealth() + randomhealth))
        local unique_id = "ReduceHealthByPills" .. self:SteamID64()
        timer.Create(unique_id, 1, self:GetMaxHealth() - self.old_maxhealth, function()
            if not (self and self:IsValid()) then
                timer.Remove(unique_id)
                return
            end

            if self:Health() < 2 or not self:Alive() or self:GTeam() == TEAM_SPEC or self:GTeam() == TEAM_SCP or self:GetMaxHealth() == old_maxhealth or self:GetNamesurvivor() != old_name then
                self:SetMaxHealth(self.old_maxhealth)
                self.old_maxhealth = nil
                timer.Remove(unique_id)
                return
            end

            self:SetHealth(self:Health() - 1)
            self:SetMaxHealth(self:GetMaxHealth() - 1)
            if self:GetMaxHealth() == self.old_maxhealth then self.old_maxhealth = nil end
        end)
    elseif kind == 4 then
        self:SetAdrenaline(true)
        timer.Simple(timetodie or 10, function() if self and self:IsValid() then self:SetAdrenaline(false) end end)
    elseif kind == 5 then
        self.WaterDr = true
        timer.Simple(timetodie or 10, function() if self and self:IsValid() then self.WaterDr = false end end)
    end
end

function mply:GetExp()
    if not self.GetNEXP then player_manager.RunClass(self, "SetupDataTables") end
    if self.GetNEXP and self.SetNEXP then
        return self:GetNEXP()
    else
        ErrorNoHalt("Cannot get the exp, GetNEXP invalid")
        return 0
    end
end

local box_parameters = Vector(5, 5, 5)
net.Receive("ThirdPersonCutscene", function()
    local time = net.ReadUInt(4)
    local client = LocalPlayer()
    client.ExitFromCutscene = nil
    local multiplier = 0
    hook.Add("CalcView", "ThirdPerson", function(client, pos, angles, fov)
        if not client.ExitFromCutscene and multiplier != 1 then
            multiplier = math.Approach(multiplier, 1, RealFrameTime() * 2)
        elseif client.ExitFromCutscene then
            multiplier = math.Approach(multiplier, 0, RealFrameTime() * 2)
            if multiplier < .25 then
                hook.Remove("CalcView", "ThirdPerson")
                client.ExitFromCutscene = nil
            end
        end

        local offset_eyes = client:LookupAttachment("eyes")
        offset_eyes = client:GetAttachment(offset_eyes)
        if offset_eyes then angles = offset_eyes.Ang end
        local trace = {}
        trace.start = offset_eyes and offset_eyes.Pos or pos
        trace.endpos = trace.start + angles:Forward() * (-80 * multiplier)
        trace.filter = client
        trace.mins = -box_parameters
        trace.maxs = box_parameters
        trace.mask = MASK_VISIBLE
        trace = util.TraceLine(trace)
        pos = trace.HitPos
        if trace.Hit then pos = pos + trace.HitNormal * 5 end
        local view = {}
        view.origin = pos
        view.angles = angles
        view.fov = fov
        view.drawviewer = true
        return view
    end)

    timer.Simple(time, function() client.ExitFromCutscene = true end)
end)

function BreachUtilEffect(effectname, effectdata)
    net.Start("Shaky_UTILEFFECTSYNC", true)
    net.WriteString(effectname)
    net.WriteTable({effectdata})
    net.Broadcast()
end

function BreachParticleEffect(ParticleName, Position, angles, EntityParent)
    if EntityParent == nil then EntityParent = NULL end
    ParticleEffect(ParticleName, Position, angles, EntityParent)
    net.Start("Shaky_PARTICLESYNC", true)
    net.WriteString(ParticleName)
    net.WriteVector(Position)
    net.WriteAngle(angles)
    net.WriteEntity(EntityParent)
    net.Broadcast()
end

function BreachParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
    ParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
    
    net.Start("Shaky_PARTICLEATTACHSYNC", true)
    net.WriteString(ParticleName)
    net.WriteUInt(attachType, 4)
    net.WriteEntity(entity)
    net.WriteUInt(attachmentID, 20)
    net.Broadcast()
end

if CLIENT then
    net.Receive("Shaky_PARTICLESYNC", function(len)
        local ParticleName = net.ReadString()
        local Position = net.ReadVector()
        local angles = net.ReadAngle()
        local EntityParent = net.ReadEntity()
        ParticleEffect(ParticleName, Position, angles, EntityParent)
    end)

    net.Receive("Shaky_UTILEFFECTSYNC", function(len)
        local ParticleName = net.ReadString()
        local EfData = net.ReadTable()[1] or EffectData()
        util.Effect(ParticleName, EfData)
    end)

    net.Receive("Shaky_PARTICLEATTACHSYNC", function(len)
        local ParticleName = net.ReadString()
        local attachType = net.ReadUInt(4)
        local entity = net.ReadEntity()
        local attachmentID = net.ReadUInt(20)
        ParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
    end)
end

function mply:GetLevel()
    if not self.GetNLevel then player_manager.RunClass(self, "SetupDataTables") end
    if self.GetNLevel and self.SetNLevel then
        return self:GetNLevel()
    else
        ErrorNoHalt("Cannot get the exp, GetNLevel invalid")
        return 0
    end
end

function mply:WouldDieFrom(damage, hitpos)
    return self:Health() <= damage
end

function mply:ThrowFromPositionSetZ(pos, force, zmul, noknockdown)
    if force == 0 or self.NoThrowFromPosition then return false end
    zmul = zmul or .7
    if self:IsPlayer() then force = force * (self.KnockbackScale or 1) end
    if self:GetMoveType() == MOVETYPE_VPHYSICS then
        local phys = self:GetPhysicsObject()
        if phys:IsValid() and phys:IsMoveable() then
            local nearest = self:NearestPoint(pos)
            local dir = nearest - pos
            dir.z = 0
            dir:Normalize()
            dir.z = zmul
            phys:ApplyForceOffset(force * 50 * dir, nearest)
        end
        return true
    elseif self:GetMoveType() >= MOVETYPE_WALK and self:GetMoveType() < MOVETYPE_PUSH then
        self:SetGroundEntity(NULL)
        local dir = self:LocalToWorld(self:OBBCenter())
        dir.z = 0
        dir:Normalize()
        dir.z = zmul
        self:SetVelocity(force * dir)
        return true
    end
end

function mply:MeleeViewPunch(damage)
    local maxpunch = (damage + 25) * 0.5
    local minpunch = -maxpunch
    self:ViewPunch(Angle(math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch)))
end

net.Receive("SetStamina", function()
    local stamina = net.ReadFloat()
    local add = net.ReadBool()
    if not add then
        LocalPlayer().Stamina = stamina
    else
        if LocalPlayer().Stamina == nil then LocalPlayer().Stamina = 100 end
        LocalPlayer().Stamina = LocalPlayer().Stamina + stamina
    end
end)

local cd_stamina = 0
if CLIENT then
	hook.Add("KeyPress", "Stamina_drain", function(ply, press)
		if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_OBSERVER then
			return
		end

		if press == IN_JUMP and ply.Stamina and !ply:Crouching() and ply:IsOnGround() then
			if !ply:GetEnergized() and !ply:GetAdrenaline() then
				cd_stamina = CurTime() + 3
				ply.Stamina = ply.Stamina - 6
			end
		end

	end)
end

function UpdateStamina_Breach(v, cd)
	if !cd then cd = 1.5 end
	LocalPlayer().Stamina = v
	cd_stamina = CurTime() + cd
end

function Sprint( ply, mv )

	if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_OBSERVER then
		return
	end

	if ply:GTeam() == TEAM_SCP or ply:GTeam() == TEAM_SPEC then
		ply.Stamina = nil
		ply.exhausted = nil
		return
	end
	local pl = ply:GetTable()

	if !pl.LastSysTime then
		pl.LastSysTime = SysTime()
	end
	local n_new = ply:GetStaminaScale()
	local stamina = pl.Stamina
	local maxstamina = n_new*100
	local movetype = ply:GetMoveType()
	local invehicle = ply:InVehicle()
	local energized = ply:GetEnergized()
	local boosted = ply:GetBoosted()
	local adrenaline = ply:GetAdrenaline()
	local plyteam = ply:GTeam()
	local activeweapon = ply:GetActiveWeapon()
	if stamina == nil then pl.Stamina = maxstamina end
	stamina = pl.Stamina

	if stamina > maxstamina then stamina = maxstamina end

	if pl.exhausted then
		if exhausted_cd <= CurTime() then
			pl.exhausted = nil
		end
		--return
	end

	local isrunning = false

	if IsValid(activeweapon) and activeweapon.HoldingBreath then
		stamina = stamina - (SysTime() - pl.LastSysTime) * 8
	end

	if !adrenaline then
		if mv:KeyDown(IN_SPEED) and !( ply:GetVelocity():Length2DSqr() < 0.25 or movetype == MOVETYPE_NOCLIP or movetype == MOVETYPE_LADDER or movetype == MOVETYPE_OBSERVER or invehicle ) and plyteam != TEAM_SCP and !pl.exhausted then
			if !energized then stamina = stamina - (SysTime() - pl.LastSysTime) * 3.33 end
			cd_stamina = CurTime() + 1.5
			isrunning = true
		end
	end
	if !isrunning and !ply:GetPos():WithinAABox(Vector(-4120.291504, -11427.226563, 38.683075), Vector(1126.214844, -15695.861328, -3422.429688)) then
		if cd_stamina <= CurTime() then
			local add = (SysTime() - pl.LastSysTime) * 7
			if energized then
				add = add *2
			end
			if stamina < 0 then stamina = 0 end
			stamina = math.Approach(stamina, maxstamina, add)
		end
	end

	if isrunning and mv:KeyPressed(IN_JUMP) and IsFirstTimePredicted() then
		stamina = stamina - (SysTime() - pl.LastSysTime) * 15
	end

	if stamina < 0 and !pl.exhausted and !boosted then
		make_bottom_message("I need to catch my breath")
		pl.exhausted = true
		exhausted_cd = CurTime() + 7
	end

	pl.LastSysTime = SysTime()


	pl.Stamina = stamina
end

hook.Add("SetupMove", "stamina_new", function(ply, mv) if CLIENT then Sprint(ply, mv) end end)
hook.Add("Move", "LeanSpeed", function(ply, mv)
    if ply:IsLeaning() and CanLean(ply) then
        local speed = ply:GetWalkSpeed() * 0.55
        mv:SetMaxSpeed(speed)
        mv:SetMaxClientSpeed(speed)
    end
end)

hook.Add("CreateMove", "stamina_new", function(mv)
	local ply = LocalPlayer()
	local pl = ply:GetTable()

	if ( pl.exhausted and !pl:GetBoosted() ) or ply:GetInDimension() then
		if mv:KeyDown(IN_SPEED) then
			mv:SetButtons(mv:GetButtons() - IN_SPEED)
		end
		if mv:KeyDown(IN_JUMP) then
			mv:SetButtons(mv:GetButtons() - IN_JUMP)
		end
	end
end)

if CLIENT then
    function mply:DropWeapon(class)
        net.Start("DropWeapon", true)
        net.WriteString(class)
        net.SendToServer()
    end

    function mply:SelectWeapon(class)
        if not self:HasWeapon(class) then return end
        self.DoWeaponSwitch = self:GetWeapon(class)
    end

    hook.Add("CreateMove", "WeaponSwitch", function(cmd)
        if not IsValid(LocalPlayer().DoWeaponSwitch) then return end
        cmd:SelectWeapon(LocalPlayer().DoWeaponSwitch)
        if LocalPlayer():GetActiveWeapon() == LocalPlayer().DoWeaponSwitch then
            LocalPlayer():GetActiveWeapon().DrawCrosshair = true
            LocalPlayer().DoWeaponSwitch = nil
        end
    end)
end