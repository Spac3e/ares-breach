local surface = surface
local draw = draw
local math = math
local string = string
local vgui = vgui
RanksIcons = {}
RanksIcons["owner"] = "icon16/key.png"
RanksIcons["founder"] = "icon16/key.png"
RanksIcons["admin"] = "icon16/shield.png"
GROUP_COUNT = 3
local PANEL = {}
function ScoreGroup(p) --include( "team_score.lua" )
    if not IsValid(p) then return -999 end
    local teamn = p:GTeam()
    return teamn
end

function PaintVBar(vbar)
    local ScrollBar = vbar
    local bg_color = Color(40, 40, 40)
    local fg_color = Color(30, 30, 30)
    local t_color = Color(150, 150, 150)
    ScrollBar.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, fg_color) end
    ScrollBar.btnUp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, bg_color)
        draw.DrawText("▴", "char_title20", w / 2 - 1, h / 2 - 10, t_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    ScrollBar.btnDown.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, bg_color)
        draw.DrawText("▾", "char_title20", w / 2 - 2, h / 2 - 12, t_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    ScrollBar.btnGrip.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, bg_color) end
end

function PANEL:Init()
    self.hostdesc = vgui.Create("DLabel", self)
    self.hostdesc:SetText("")
    self.hostdesc:SetContentAlignment(5)
    self.hostname = vgui.Create("DLabel", self)
    self.hostname:SetText("Test ScoreBoard Head")
    self.hostname:SetContentAlignment(5)
    self.version = vgui.Create("DLabel", self)
    self.version:SetText("")
    self.version:SetContentAlignment(9)
    self.ply_frame = vgui.Create("BrPlayerFrame", self)
    self.ply_groups = {}
    for k, v in ipairs(gteams.Teams) do
        local GroupColor = v.color
        GroupColor = Color(GroupColor.r, GroupColor.g, GroupColor.b, 50)
        local GroupPos = k
        local t = vgui.Create("BrScoreGroup", self.ply_frame:GetCanvas())
        self.ply_groups[GroupPos] = t
    end

    self.cols = {}
    self:AddColumn(BREACH.TranslateString("l:scoreboard_ping"))
    self:AddColumn(BREACH.TranslateString("l:scoreboard_level"))
    self:AddColumn(BREACH.TranslateString("l:scoreboard_achievements"))
    self:AddColumn(BREACH.TranslateString("l:scoreboard_score"))
    local country = self:AddColumn(BREACH.TranslateString("l:scoreboard_country"))
    hook.Call("BrScoreboardColumns", nil, self)
    self:UpdateScoreboard()
    self:StartUpdateTimer()
end

function PANEL:AddColumn(label, func, width)
    self.cols = self.cols or {}
    local lbl = vgui.Create("DLabel", self)
    lbl:SetText(label)
    lbl.IsHeading = true
    lbl.Width = width or 50
    table.insert(self.cols, lbl)
    return lbl
end

function PANEL:StartUpdateTimer()
    if not timer.Exists("BrScoreboardUpdate") then
        timer.Create("BrScoreboardUpdate", .1, 0, function()
            local pnl = GAMEMODE:GetScoreboardPanel()
            if IsValid(pnl) then pnl:UpdateScoreboard() end
        end)
    end
end

local colors = {
    bg = Color(30, 30, 30, 235),
    bar = Color(220, 0, 0, 50)
}

function PANEL:Paint()
    draw.RoundedBox(8, 0, 72, self:GetWide(), self:GetTall() - 72, colors.bg)
end

function PANEL:PerformLayout()
    if not LocalPlayer():IsSuperAdmin() and not GetGlobalBool("Breach_ScoreboardForAlive", false) then if not (LocalPlayer():GTeam() == TEAM_SPEC or LocalPlayer():GTeam() == TEAM_ARENA) then return end end
    local gy = 0
    for i, v in pairs(gteams.Teams) do
        local group = self.ply_groups[i]
        if ValidPanel(group) then
            if group:HasRows() then
                group:SetVisible(true)
                group:SetPos(0, gy)
                group:SetSize(self.ply_frame:GetWide(), group:GetTall())
                group:InvalidateLayout()
                gy = gy + group:GetTall() + 5
            else
                group:SetVisible(false)
            end
        else
            if gteams.Teams[i] then
                local GroupPos = i
                local GroupColor = gteams.Teams[i].Color
                GroupColor = Color(GroupColor.r, GroupColor.g, GroupColor.b, 50)
                local t = vgui.Create("BrScoreGroup", self.ply_frame:GetCanvas())
                t:SetGroupInfo(gteams.Teams[i].name, GroupColor, GroupPos, "None")
                self.ply_groups[GroupPos] = t
                if ValidPanel(t) then
                    if t:HasRows() then
                        t:SetVisible(true)
                        t:SetPos(0, gy)
                        t:SetSize(self.pry_frame:GetWide(), t:GetTall())
                        t:InvalidateLayout()
                        gy = gy + t:GetTall() + 5
                    else
                        t:SetVisible(false)
                    end
                end
            end
        end
    end

    self.ply_frame:GetCanvas():SetSize(self.ply_frame:GetCanvas():GetWide(), gy)
    local h = 72 + 110 + self.ply_frame:GetCanvas():GetTall()
    local screenheight = ScrH()
    local scrolling = h > screenheight * .95
    self.ply_frame:SetScroll(scrolling)
    h = math.Clamp(h, 110 + 72, screenheight * .95)
    local w = math.max(ScrW() * .6, 640)
    self:SetSize(w, h)
    self:SetPos((ScrW() - w) / 2, math.min(72, (screenheight - h) / 4))
    self.ply_frame:SetPos(8, 72 + 109)
    self.ply_frame:SetSize(self:GetWide() - 16, self:GetTall() - 109 - 72 - 5)
    self.hostdesc:SizeToContents()
    self.hostdesc:SetPos(w / 2 - self.hostdesc:GetWide() / 2, 72 + 5)
    local hw = w - 180 - 8
    self.hostname:SetSize(hw, 40)
    self.hostname:SetPos(w / 2 - self.hostname:GetWide() / 2, 72 + 27)
    self.version:SetPos(w - self.version:GetWide() - 5, 72 + 17)
    self.version:SizeToContents()
    surface.SetFont("ScoreboardHeader")
    local hname = "[Ares] Breach 1.0"
    local tw, _ = surface.GetTextSize(hname)
    while tw > hw do
        hname = string.sub(hname, 1, -6) .. "..."
        tw, th = surface.GetTextSize(hname)
    end

    self.hostname:SetText(hname .. " < " .. BREACH.TranslateString("l:scoreboard_rounds_left") .. ": " .. GetGlobalInt("RoundUntilRestart", 1) .. " > ")
    self.hostdesc:SetText("Stable Server")
    local cy = 72 + 90
    local cx = w - 8 - (scrolling and 16 or 0)
    self.cols = self.cols or {}
    for _, v in ipairs(self.cols) do
        v:SizeToContents()
        cx = cx - v.Width
        v:SetPos(cx - v:GetWide() / 2, cy)
    end
end

local hostdesc_clr = Color(255, 0, 0, 180)
function PANEL:ApplySchemeSettings()
    self.hostdesc:SetFont("ScoreboardContent")
    self.hostname:SetFont("SubScoreboardHeader")
    self.version:SetFont("Cyb_Inv_Label")
    self.hostdesc:SetTextColor(hostdesc_clr)
    self.hostname:SetTextColor(COLOR_BLACK)
    self.version:SetTextColor(COLOR_GREY)
    for _, v in ipairs(self.cols) do
        v:SetFont("Cyb_Inv_Label")
        v:SetTextColor(COLOR_WHITE)
    end
end

function PANEL:UpdateScoreboard(force)
    if not force and not self:IsVisible() then return end
    for k, v in ipairs(gteams.Teams) do
        local GroupPos = k - 1
        local GroupColor = v.Color
        GroupColor = Color(v.color.r, v.color.g, v.color.b, 50)
        if not self.ply_groups[GroupPos] then
            local t = vgui.Create("BrScoreGroup", self.ply_frame:GetCanvas())
            t:SetGroupInfo(BREACH.TranslateNonPrefixedString(v.name), GroupColor, GroupPos)
            self.ply_groups[GroupPos] = t
        else
            self.ply_groups[GroupPos]:SetGroupInfo(BREACH.TranslateNonPrefixedString(v.name), GroupColor, GroupPos)
        end
    end

    for _, p in ipairs(player.GetAll()) do
        if p and p:IsValid() then
            local group = ScoreGroup(p)
            if self.ply_groups[group] and not self.ply_groups[group]:HasPlayerRow(p) then self.ply_groups[group]:AddPlayerRow(p) end
        end
    end

    for _, group in pairs(self.ply_groups) do
        if ValidPanel(group) then
            group:SetVisible(group:HasRows())
            group:UpdatePlayerData()
        end
    end

    self:PerformLayout()
end

vgui.Register("BrScoreboard", PANEL, "Panel")
local PANEL = {}
function PANEL:Init()
    self.pnlCanvas = vgui.Create("Panel", self)
    self.YOffset = 0
    self.scroll = vgui.Create("DVScrollBar", self)
    PaintVBar(self.scroll)
end

function PANEL:GetCanvas()
    return self.pnlCanvas
end

function PANEL:OnMouseWheeled(dlta)
    self.scroll:AddScroll(dlta * -2)
    self:InvalidateLayout()
end

function PANEL:SetScroll(st)
    self.scroll:SetEnabled(st)
end

function PANEL:PerformLayout()
    self.pnlCanvas:SetVisible(self:IsVisible())
    self.scroll:SetPos(self:GetWide() - 16, 0)
    self.scroll:SetSize(16, self:GetTall())
    local was_on = self.scroll.Enabled
    self.scroll:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
    self.scroll:SetEnabled(was_on)
    self.YOffset = self.scroll:GetOffset()
    self.pnlCanvas:SetPos(0, self.YOffset)
    self.pnlCanvas:SetSize(self:GetWide() - (self.scroll.Enabled and 16 or 0), self.pnlCanvas:GetTall())
end

vgui.Register("BrPlayerFrame", PANEL, "Panel")
local table = table
local surface = surface
local draw = draw
local math = math
local team = team
GM = GM or GAMEMODE
local namecolor = {
    admin = Color(220, 180, 0, 255) --include( "main_score.lua" )
}

sboard_panel = sboard_panel or nil
local function ScoreboardRemove()
    if sboard_panel then
        sboard_panel:Remove()
        sboard_panel = nil
    end
end

function GM:ScoreboardCreate()
    ScoreboardRemove()
    sboard_panel = vgui.Create("BrScoreboard")
end

function GM:ScoreboardShow()
    if not LocalPlayer():IsSuperAdmin() and not GetGlobalBool("Breach_ScoreboardForAlive", false) then if not (LocalPlayer():GTeam() == TEAM_SPEC or LocalPlayer():GTeam() == TEAM_ARENA) then return end end
    self.ShowScoreboard = true
    ScoreboardRemove()
    if not IsValid(sboard_panel) then self:ScoreboardCreate() end
    gui.EnableScreenClicker(true)
    sboard_panel:SetVisible(true)
    sboard_panel:UpdateScoreboard(true)
    sboard_panel:StartUpdateTimer()
end

function GM:ScoreboardHide()
    self.ShowScoreboard = false
    gui.EnableScreenClicker(false)
    if sboard_panel and sboard_panel:IsValid() then sboard_panel:SetVisible(false) end
end

function GM:GetScoreboardPanel()
    return sboard_panel
end

function GM:HUDDrawScoreBoard()
end

function GM:BRScoreboardColorForPlayer(ply)
    if not IsValid(ply) then return namecolor.default end
    return namecolor.default
end

SB_ROW_HEIGHT = 20 --include( "info_score.lua" )
local PANEL = {}
function PANEL:Init()
    self.info = nil
    self.open = false
    self.cols = {}
    self:AddColumn("Ping", function(ply) return "" end)
    self:AddColumn("Level", function(ply) return ply.GetNLevel and ply:GetNLevel() or 0 end)
    self:AddColumn("Ach", function(ply) return ply:GetAchievementsNum() or 0 end)
    self:AddColumn("Rep", function(ply) return math.Round(ply:GetElo(), 1) or 0 end)
    hook.Call("BrScoreboardColumns", nil, self)
    for _, c in ipairs(self.cols) do
        c:SetMouseInputEnabled(false)
    end

    self.tag = vgui.Create("DLabel", self)
    self.tag:SetText("")
    self.tag:SetMouseInputEnabled(false)
    self.rank = vgui.Create("DImage", self)
    self.rank:SetSize(16, 16)
    self.rank:SetImage("nextoren_hud/scoreboard/user.png")
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)
    self.avatar:SetMouseInputEnabled(false)
    self.title = vgui.Create("DLabel", self)     --[[self.avatar_layout = vgui.Create( "DImage", self.avatar )
  self.avatar_layout:SetSize( SB_ROW_HEIGHT, SB_ROW_HEIGHT )
  self.avatar_layout:SetText( "" )
  self.avatar_layout:SetMouseInputEnabled( false )
  self.avatar_layout:SetImage( "passjj.png" )]]
    self.title:SetMouseInputEnabled(false)
    self.nick = vgui.Create("DLabel", self)
    self.nick:SetMouseInputEnabled(false)
    self.voice = vgui.Create("DImageButton", self)
    self.voice:SetSize(16, 16)
    self:SetCursor("hand")
end

function PANEL:AddColumn(label, func, width)
    self.cols = self.cols or {}
    local lbl = vgui.Create("DLabel", self)
    lbl.GetPlayerText = func
    lbl.IsHeading = false
    lbl.Width = width or 50
    table.insert(self.cols, lbl)
    return lbl
end

local namecolor = {
    default = COLOR_WHITE,
    admin = Color(220, 180, 0, 225),
    dev = Color(100, 240, 105, 255)
}

local function ColorForPlayer(ply)
    if ply and ply:IsValid() then
        if ply:GetFriendStatus() == "friend" then --if ply:IsSuperAdmin() then return Color(0,255,255) end
            return Color(100, 255, 100)
        end

        local c = hook.Call("BRScoreboardColorForPlayer", GM, ply)
        if c and istable(c) and c.r and c.b and c.g and c.a then return c end
    end
    return namecolor.default
end

local function ColorForPlayerTitle(ply)
    return namecolor.default
end

local blackalpha = Color(0, 0, 0, 150)
local clrgreen = Color(0, 255, 0, 255)
local clrgray = Color(155, 155, 155, 255)
local clrred = Color(255, 0, 0, 255)
local clryellow = Color(255, 255, 0, 255)
local whitealpha = Color(255, 255, 255, 150)
BREACH.FLAGS = BREACH.FLAGS or {}
function PrecacheAllFlags()
    local materials = file.Find("materials/flags16/*", "GAME")
    for _, v in pairs(materials) do
        local name = string.upper(string.StripExtension(v))
        BREACH.FLAGS[name] = Material("flags16/" .. v)
    end
end

hook.Add("InitPostEntity", "precache_flags", function() PrecacheAllFlags() end)
function PANEL:Paint()
    if not IsValid(self.Player) then return end
    local ply = self.Player
    surface.SetDrawColor(blackalpha)
    surface.DrawRect(0, 0, self:GetWide(), SB_ROW_HEIGHT)
    if ply == LocalPlayer() then
        surface.SetDrawColor(200, 200, 200, math.Clamp(math.sin(RealTime() * 2) * 50, 0, 100))
        surface.DrawRect(0, 0, self:GetWide(), SB_ROW_HEIGHT)
    end

    local pingx, pingy = self:GetWide() - 60, 5
    if ply and ply:IsValid() then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(BREACH.FLAGS[ply:GetNWString("country", "RU")])
        surface.DrawTexturedRect(pingx - 199, 3, 20, 15)
        local ping = ply:Ping()
        if ping < 100 then
            draw.RoundedBox(0, pingx, pingy + 8, 4, 4, clrgreen)
            draw.RoundedBox(0, pingx + 5, pingy + 4, 4, 8, clrgreen)
            draw.RoundedBox(0, pingx + 10, pingy, 4, 12, clrgreen)
        elseif ping < 225 then
            draw.RoundedBox(0, pingx, pingy + 8, 4, 4, clryellow)
            draw.RoundedBox(0, pingx + 5, pingy + 4, 4, 8, clryellow)
            draw.RoundedBox(0, pingx + 10, pingy, 4, 12, clrgray)
        else
            draw.RoundedBox(0, pingx, pingy + 8, 4, 4, clrred)
            draw.RoundedBox(0, pingx + 5, pingy + 4, 4, 8, clrgray)
            draw.RoundedBox(0, pingx + 10, pingy, 4, 12, clrgray)
        end

        draw.DrawText(ping, "Cyb_HudTEXTSmall", pingx + 17, pingy, whitealpha, TEXT_ALIGN_LEFT)
    end
    return true
end

function PANEL:SetPlayer(ply)
    self.Player = ply
    self.avatar:SetPlayer(ply)
    if not self.info then
        self:InvalidateLayout() --local g = ScoreGroup( ply )
        --[[self.info = vgui.Create( "BrScorePlayerInfoTags", self )
    self.info:SetPlayer( ply )]]
    else
        self.info:SetPlayer(ply)
        self:InvalidateLayout()
    end

    self.voice.DoClick = function() if ply and ply:IsValid() and ply != LocalPlayer() then ply:SetMuted(not ply:IsMuted()) end end
    self:UpdatePlayerData()
end

function PANEL:GetPlayer()
    return self.Player
end

function PANEL:UpdatePlayerData()
    if not IsValid(self.Player) then return end
    local ply = self.Player
    for i = 1, #self.cols do
        self.cols[i]:SetText(self.cols[i].GetPlayerText(ply, self.cols[i]))
    end

    self.title:SetText("")
    if ply:GTeam() == TEAM_SPEC then
        self.nick:SetText(ply:Nick())
    elseif ply:GTeam() == TEAM_SCP and not ply.IsZombie then
        self.nick:SetText(ply:Nick())
    else
        local surv_name = ply:GetNamesurvivor()
        if surv_name != "none" then
            self.nick:SetText(ply:Nick() .. " (" .. surv_name .. ")")
        else
            self.nick:SetText(ply:Nick())
        end
    end

    if ply:IsAdmin() and ply:GetUserGroup() != "superadmin" then
        self.rank:SetImage("nextoren_hud/scoreboard/shield.png")
    elseif NEXTOREN_YOUTUBERS[ply:SteamID64()] then
        self.rank:SetImage("icon16/user_red.png")
    elseif ply:IsSuperAdmin() then
        self.rank:SetImage("nextoren_hud/scoreboard/user.png")
    elseif ply:GetUserGroup() == "premium" and ply:GetNWBool("display_premium_icon", true) then
        self.rank:SetImage("icon16/asterisk_yellow.png")
    end

    self.nick:SizeToContents()
    self.nick:SetTextColor(ColorForPlayer(ply))
    
    self.tag:SetText(GetLangRole(ply:GetRoleName()))

    self:LayoutColumns()
    if self.info then self.info:UpdatePlayerData() end
    if self.Player != LocalPlayer() then
        local muted = self.Player:IsMuted()
        self.voice:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")
    else
        self.voice:Hide()
    end
end

function PANEL:ApplySchemeSettings()
    for _, v in ipairs(self.cols) do
        v:SetFont("Cyb_Inv_Label")
        v:SetTextColor(COLOR_WHITE)
    end

    self.nick:SetFont("Cyb_Inv_Bar")
    self.nick:SetTextColor(ColorForPlayer(self.Player))
    self.title:SetFont("Cyb_Inv_Bar")
    self.title:SetTextColor(ColorForPlayerTitle(self.Player))
    self.tag:SetFont("HUDFont")
    local pl_team = (self.Player and self.Player:IsValid()) and self.Player:GTeam() or TEAM_SPEC
    if pl_team == TEAM_USA or pl_team == TEAM_QRT or pl_team == TEAM_NAZI then
        self.tag:SetTextColor(ColorAlpha(color_white, 190))
    else
        self.tag:SetTextColor(gteams.GetColor(pl_team))
    end
end

function PANEL:LayoutColumns()
    local cx = self:GetWide()
    for _, v in ipairs(self.cols) do
        v:SizeToContents()
        cx = cx - v.Width
        v:SetPos(cx - v:GetWide() / 2, (SB_ROW_HEIGHT - v:GetTall()) / 2)
    end

    self.tag:SizeToContents()
    cx = cx - 90
    self.tag:SetPos(cx - self.tag:GetWide(), (SB_ROW_HEIGHT - self.tag:GetTall()) / 2)
end

function PANEL:PerformLayout()
    self.avatar:SetPos(24, 0)
    self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)
    self.rank:SetPos(4, 4)
    if not sboard_panel then return end
    local fw = sboard_panel.ply_frame:GetWide()
    self:SetWide(sboard_panel.ply_frame.scroll.Enabled and fw - 16 or fw)
    if not self.open then
        self:SetSize(self:GetWide(), SB_ROW_HEIGHT)
        if self.info then self.info:SetVisible(false) end
    elseif self.info then
        self:SetSize(self:GetWide(), 100 + SB_ROW_HEIGHT)
        self.info:SetVisible(true)
        self.info:SetPos(5, SB_ROW_HEIGHT + 5)
        self.info:SetSize(self:GetWide(), 100)
        self.info:PerformLayout()
        self:SetSize(self:GetWide(), SB_ROW_HEIGHT + self.info:GetTall())
    end

    self.nick:SetPos(SB_ROW_HEIGHT + 30, (SB_ROW_HEIGHT - self.nick:GetTall()) / 2)
    self:LayoutColumns()
    self.voice:SetVisible(not self.open)
    self.voice:SetSize(16, 16)
    self.voice:DockMargin(4, 4, 4, 4)
    self.voice:Dock(RIGHT)
end

function PANEL:DoClick(x, y)
end

function PANEL:SetOpen(o)
    if self.open then
        surface.PlaySound("ui/buttonclickrelease.wav")
    else
        surface.PlaySound("ui/buttonclick.wav")
    end

    self.open = o
    if self.info then self.info:UpdateData() end
    self:PerformLayout()
    self:GetParent():PerformLayout()
    sboard_panel:PerformLayout()
end

function PANEL:DoRightClick()
    local menu = DermaMenu(self)
    menu.Player = self:GetPlayer()
    local close = hook.Call("BrScoreboardMenu", nil, menu)
    if close then menu:Remove() end
    local name = GAS and GAS.CountryCodes[menu.Player:GetNWString("country", "RU")] or "RU"
    local country = menu:AddOption("", function()
        SetClipboardText(name)
        surface.PlaySound("buttons/button9.wav")
    end)

    country:SetIcon("flags16/" .. menu.Player:GetNWString("country", "RU") .. ".png")
    country.Paint = function(self, w, h) draw.DrawText(name, "HUDFont", 30, 2) end
    if NEXTOREN_YOUTUBERS[menu.Player:SteamID64()] then
        menu:AddOption("YouTube Channel", function()
            gui.OpenURL(NEXTOREN_YOUTUBERS[menu.Player:SteamID64()])
            surface.PlaySound("buttons/button9.wav")
        end):SetIcon("icon16/user_red.png")
    end

    menu:AddSpacer()
    local CopyMenu, CopyMenuOption = menu:AddSubMenu("Copy")
    CopyMenuOption:SetIcon("icon16/page_copy.png")
    CopyMenu:AddOption(menu.Player:Nick(true), function()
        SetClipboardText(menu.Player:Nick(true))
        surface.PlaySound("buttons/button9.wav")
    end):SetIcon("icon16/page_copy.png")

    CopyMenu:AddOption("SteamID", function()
        SetClipboardText(menu.Player:SteamID())
        surface.PlaySound("buttons/button9.wav")
    end):SetIcon("icon16/page_copy.png")

    CopyMenu:AddOption("SteamID64", function()
        SetClipboardText(menu.Player:SteamID64())
        surface.PlaySound("buttons/button9.wav")
    end):SetIcon("icon16/page_copy.png")

    if not menu.Player:IsBot() then
        menu:AddOption("Open Achievements", function()
            OpenAchievementTab(menu.Player)
            surface.PlaySound("buttons/button9.wav")
        end):SetIcon("icon16/chart_bar.png")
    end

    menu:AddOption("Open Steam Community URL", function()
        gui.OpenURL("http://steamcommunity.com/profiles/" .. menu.Player:SteamID64())
        surface.PlaySound("buttons/button9.wav")
    end):SetIcon("icon16/world_link.png")

    menu:AddSpacer()
    menu:Open()
    menu.Paint = function(self, w, h)
        if not GAMEMODE.ShowScoreboard then self:Remove() end
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_black, 225))
    end

    for _, v in ipairs(menu:GetCanvas():GetChildren()) do
        if v.SetTextColor then
            v:SetTextColor(ColorAlpha(color_white, 225))
        end
    end
end

vgui.Register("BrScoreboardPlayerRow", PANEL, "Button")
local function CompareScore(pa, pb)
    if not ValidPanel(pa) then return false end
    if not ValidPanel(pb) then return true end
    local a = pa:GetPlayer()
    local b = pb:GetPlayer()
    if not IsValid(a) then return false end
    if not IsValid(b) then return true end
    if a:Frags() == b:Frags() then return a:Deaths() < b:Deaths() end
    return a:Frags() > b:Frags()
end

local PANEL = {}
function PANEL:Init()
    local name = "Unnamed"
    self.color = COLOR_WHITE
    self.rows = {}
    self.rowcount = 0
    self.rows_sorted = {}
    self.group = "spec"
end

function PANEL:SetGroupInfo(name, color, group, groupowner)
    self.name = name
    self.color = color
    self.group = group
end

local bgcolor = Color(20, 20, 20, 150)
local clrgray = Color(198, 198, 198, 210)
function PANEL:Paint()
    draw.RoundedBox(2, 0, 0, self:GetWide(), self:GetTall(), self.color)
    surface.SetFont("HUDFont")
    local txt
    if self.name == BREACH.TranslateString("l:spectators") then
        txt = self.name .. " ( " .. BREACH.TranslateString("l:players") .. ": " .. self.rowcount .. " )"
    else
        txt = self.name .. " ( " .. BREACH.TranslateString("l:alive") .. ": " .. self.rowcount .. " )"
    end

    local w, h = surface.GetTextSize(txt)
    draw.SimpleTextOutlined(txt, "HUDFont", self:GetWide() / 2, 18 - h / 2, clrgray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.4, color_black) --draw.RoundedBox( 2, 0, 0, w + 24, 20, self.color ) --surface.SetTextPos( self:GetWide() / 2, 11 - h / 2 ) --surface.SetTextColor( 0, 0, 0, 200 )
end

function PANEL:AddPlayerRow(ply) --[[surface.SetTextPos( self:GetWide() / 2, 10 - h / 2 )
  surface.SetTextColor( 255, 255, 255, 255 )
  surface.DrawText( txt )
]]
    if not self.rows[ply] then
        local row = vgui.Create("BrScoreboardPlayerRow", self)
        row:SetPlayer(ply)
        self.rows[ply] = row
        self.rowcount = table.Count(self.rows)
        self:PerformLayout()
    end
end

function PANEL:HasPlayerRow(ply)
    return self.rows[ply] != nil
end

function PANEL:HasRows()
    return self.rowcount > 0
end

function PANEL:UpdateSortCache()
    self.rows_sorted = {}
    for _, v in pairs(self.rows) do
        table.insert(self.rows_sorted, v)
    end

    table.sort(self.rows_sorted, CompareScore)
end

function PANEL:UpdatePlayerData()
    local to_remove = {}
    for k, v in pairs(self.rows) do
        if ValidPanel(v) and IsValid(v:GetPlayer()) and ScoreGroup(v:GetPlayer(), self.custgroup) == self.group then
            v:UpdatePlayerData()
        else
            table.insert(to_remove, k)
        end
    end

    if #to_remove == 0 then return end
    for _, ply in pairs(to_remove) do
        local pnl = self.rows[ply]
        if ValidPanel(pnl) then pnl:Remove() end
        self.rows[ply] = nil
    end

    self.rowcount = table.Count(self.rows)
    self:UpdateSortCache()
    self:InvalidateLayout()
end

function PANEL:PerformLayout()
    if self.rowcount < 1 then
        self:SetVisible(false)
        return
    end

    self:SetSize(self:GetWide(), 30 + self.rowcount + self.rowcount * SB_ROW_HEIGHT)
    self:UpdateSortCache()
    local y = 24
    for _, v in ipairs(self.rows_sorted) do
        v:SetPos(0, y)
        v:SetSize(v:GetWide(), v:GetTall())
        y = y + v:GetTall() + 1
    end

    self:SetSize(self:GetWide(), 30 + (y - 24))
end

vgui.Register("BrScoreGroup", PANEL, "Panel")