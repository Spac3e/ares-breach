AddCSLuaFile()
ENT.Type = "anim"
ENT.Name = "OBR Spawner"
ENT.Uses = 0
ENT.ObrIcon = Material("nextoren/obr_call/obr_idle")
ENT.Model = Model("models/hunter/plates/plate4x24.mdl")

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Activate")
    self:NetworkVar("Bool", 1, "Called")
    self:NetworkVar("Bool", 2, "Hacking")
    self:NetworkVar("Int", 1, "CD")
end

local vec_spawn = Vector(-2847.389404, 2269.2, 320.649048)
local angle_spawn = Angle(90, -90, 0)
function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetActivate(true)
    self:SetCalled(false)
    self:SetCD(CurTime() + 350)
    self:SetSolidFlags(bit.bor(FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS))
    self:SetRenderMode(1)
    self.Calling = false
    self:SetPos(vec_spawn)
    self:SetAngles(angle_spawn)
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
    if SERVER then self:SetUseType(SIMPLE_USE) end
    self:SetColor(ColorAlpha(color_white, 1))
end

function ENT:Use(activator, caller)
    if caller:GetRoleName() == role.SCI_SpyUSA then
        if timer.TimeLeft("RoundTime") < 400 then
            if caller:GetNWInt("CollectedDocument") == 0 then
                caller:AresNotify("l:spyusa_toolate_for_hacking")
                return
            end
        end

        if timer.TimeLeft("RoundTime") < 300 then
            if caller:GetNWInt("CollectedDocument") > 0 then
                caller:AresNotify("l:spyusa_toolate_for_hacking_document")
                return
            end
        end

        for k, v in ipairs(player.GetAll()) do
            if v:GetRoleName() == role.MTF_HOF and v:Alive() and caller:GetNWInt("CollectedDocument") == 0 then
                caller:AresNotify("l:spyusa_hofnotdead")
                return
            end
        end

        if caller:GetNWInt("CollectedDocument") == 0 and not self:GetHacking() then
            caller:BrProgressBar("l:spyusa_hacking", 5, "nextoren/gui/icons/hand.png", target, false, function()
                self:EmitSound("^nextoren/others/monitor/start_hacking.wav")
                self:SetHacking(true)
                PlayAnnouncer("nextoren/entities/intercom/start.mp3")
                for k, v in ipairs(player.GetAll()) do
                    v:AresNotify("l:spyusa_hacking_notify")
                end

                timer.Create("SpyUsaWentInsane", 100, 1, function()
                    if caller:GetRoleName() == role.SCI_SpyUSA then caller:AresNotify("l:spyusa_hacking_successful") end
                    BREACH.PowerfulUIUSupport()
                    self:Remove()
                    self:SetHacking(false)
                    caller.TempValues.FBIHackedTerminal = true
                end)
            end)
        elseif caller:GetNWInt("CollectedDocument") > 0 then
            self:EmitSound("^nextoren/others/monitor/start_hacking.wav")
            timer.Remove("SpyUsaWentInsane")
            caller:AresNotify("l:spyusa_hacking_successful")
            BREACH.PowerfulUIUSupport(caller)
            self:Remove()
            self:SetHacking(false)
            caller.TempValues.FBIHackedTerminal = true
        end
    end

    if caller:GTeam() ~= TEAM_SPEC and caller:GTeam() ~= TEAM_SCP and caller:GTeam() ~= TEAM_USA then
        if self:GetHacking() then
            for k, v in ipairs(player.GetAll()) do
                v:AresNotify("l:spyusa_hacking_stopped")
            end

            PlayAnnouncer("sound/nextoren/entities/intercom/stop.mp3")
            self:SetHacking(false)
            timer.Remove("SpyUsaWentInsane")
        end
    end

    if caller:IsPlayer() and caller:GetRoleName() ~= role.MTF_HOF then return end
    if self:GetCD() > CurTime() then return end
    self:SetCD(CurTime() + 525)
    if caller:IsPlayer() and not self:GetActivate() then caller:Tip(3, "Подождите, следующий отряд ещё не готов к вызову.", Color(255, 0, 0)) end
    local count = 0
    for i, v in pairs(player.GetAll()) do
        if v.GTeam and v:GTeam() == TEAM_SPEC then count = count + 1 end
    end

    count = math.floor(math.min(count * 0.7, 10))
    if caller and caller:IsValid() and caller:IsPlayer() and self:GetActivate() and not GetGlobalBool("NukeTime", false) then
        self.Uses = self.Uses + 1
        self:SetCalled(true)
        caller:CompleteAchievement("protocol")
        if self.Uses >= 3 then self:SetActivate(false) end
        timer.Simple(10, function()
            if self and self:IsValid() then
                self:SetCalled(false)
                if SERVER then
                    BREACH.OBRSpawn(count)
                    BroadcastLua('surface.PlaySound( "nextoren/round_sounds/intercom/obr_enter.wav" )')
                end
            end
        end)
    end
end

function ENT:GetRotatedVec(vec)
    local v = self:WorldToLocal(vec)
    v:Rotate(self:GetAngles())
    return self:LocalToWorld(v)
end

local clr_green = Color(0, 200, 0)
local clr_red = Color(200, 0, 0)
function ENT:Draw()
    local oang = self:GetAngles()
    local opos = self:GetPos()
    local ang = self:GetAngles()
    local pos = self:GetPos()
    ang:RotateAroundAxis(oang:Up(), 90)
    ang:RotateAroundAxis(oang:Right(), 0)
    ang:RotateAroundAxis(oang:Up(), 0)
    self:DestroyShadow()
    if self:GetCalled() then
        self.ObrIcon = Material("nextoren/obr_call/obr_window")
    else
        self.ObrIcon = Material("nextoren/obr_call/obr_idle")
    end

    local up = self.Entity:GetUp() ------------------------------------------
    local position = self:GetRotatedVec(self.Entity:GetPos() + up * 2 + self.Entity:GetRight() * 4)
    local _, maxs = self:GetCollisionBounds()
    local w = math.floor(math.max(maxs.x, maxs.y) / 32)
    local pos = self.Entity:GetPos() + up * 1
    render.SetMaterial(self.ObrIcon)
    render.DrawQuadEasy(position, up, 18, 14, color_white, 180)
    render.SetMaterial(self.ObrIcon)
    render.DrawQuadEasy(position, up * -1, 18, 14, color_white, 180)
    if not self:GetCalled() then ------------------------------------------
        cam.Start3D2D(pos + oang:Forward() * -3 + oang:Up() * 0.4 + oang:Right() * 2, ang, 0.1)
        if self:GetCD() > CurTime() then
            draw.SimpleText(math.Round(self:GetCD() - CurTime()), "LZTextVerySmall", 0, 0, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("SQR ready!", "LZTextVerySmall", 0, 0, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        cam.End3D2D()
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

if CLIENT then
    local scarletmat = Material("nextoren_hud/faction_icons/fbispec.png")
    local ultravector = Vector(-2847.375000, 2269.187500, 295.625000)
    local shawms = shawms or {}
    hook.Add("OnEntityCreated", "OBRCALL_SoftEntityList", function(ent) if ent:GetClass() == "obr_call" then table.insert(shawms, ent) end end)
    hook.Add("EntityRemoved", "OBRCALL_SoftEntityList", function(ent)
        if ent:GetClass() == "obr_call" then
            for k, v in pairs(shawms) do
                if not IsValid(v) then table.remove(shawms, k) end
            end
        end
    end)

    hook.Add("PostDrawTranslucentRenderables", "uiu_spy_draw_mark", function(bDepth, bSkybox)
        local client = LocalPlayer()
        for i = 1, #shawms do
            local entity = shawms[i]
            if not IsValid(entity) then return end
            if client:GetRoleName() ~= role.SCI_SpyUSA and entity:GetHacking() == false then return end
            if client:GetNWInt("CollectedDocument") == 0 then
                for k, v in ipairs(player.GetAll()) do
                    if v:GetRoleName() == role.MTF_HOF then return end
                end
            end

            local capos = entity:GetPos()
            local ang = client:EyeAngles()
            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)
            capos = capos + Vector(0, 0, -25)
            local dist = client:GetPos():Distance(ultravector)
            local size = 140 * math.Clamp(dist * .005, 1, 30)
            cam.Start3D2D(capos, ang, 0.1)
            cam.IgnoreZ(true)
            surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
            surface.SetMaterial(scarletmat)
            surface.DrawTexturedRect(-(size / 2), -(size / 2), size, size)
            cam.End3D2D()
            cam.IgnoreZ(false)
        end
    end)
end