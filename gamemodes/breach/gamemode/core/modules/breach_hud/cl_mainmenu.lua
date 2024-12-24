local MenuTable = {}
MenuTable.url = "https://nextoren.fandom.com/ru/wiki/NextOren"
MenuTable.start = "Play"
MenuTable.Leave = "Leave"
MenuTable.OurGroup = "Wiki"
MenuTable.FAQ = "Information"
MenuTable.Settings = "Settings"
local dark_clr = Color(0, 0, 0, 155)
local gradient = Material("vgui/gradient-r")
local gradient2 = Material("vgui/gradient-l")
local gradients = Material("gui/center_gradient")
local grad1 = Material("vgui/gradient-u")
local grad2 = Material("vgui/gradient-d")
local backgroundlogo = Material("nextoren/menu")
local scp = Material("nextoren/gui/icons/notifications/breachiconfortips.png", "noclamp smooth")
local garland = Material("happy_new_year/happy_new_year.png", "noclamp smooth")
local function drawmat(x, y, w, h, mat)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, w, h)
end

concommand.Add("debug_reset_mainmenu", function()
    INTRO_PANEL:Remove()
    ShowMainMenu = false
end)

function draw.RotatedText(text, x, y, font, color, ang)
    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    local m = Matrix()
    m:Translate(Vector(x, y, 0))
    m:Rotate(Angle(0, ang, 0))
    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)
    m:Translate(-Vector(w / 2, h / 2, 0))
    cam.PushModelMatrix(m)
    draw.DrawText(text, font, 0, 0, color)
    cam.PopModelMatrix()
    render.PopFilterMag()
    render.PopFilterMin()
end

local button_lang = {
    play = "l:menu_play",
    resume = "l:menu_resume",
    disconnect = "l:menu_disconnect",
    credits = "l:menu_credits",
    settings = "l:menu_settings",
    wiki = "l:menu_wiki",
    rules = "l:menu_my_life_my_rules",
}

local function get_button_lang(str)
    return L(button_lang[str]) --["english"]
end

BREACH = BREACH or {}
ShowMainMenu = ShowMainMenu or false
local clr1 = Color(128, 128, 128)
local whitealpha = Color(255, 255, 255, 90)
local clrblackalpha = Color(0, 0, 0, 220)
local Material_To_Check = {"nextoren_hud/overlay/frost_texture", "weapons/weapon_flashlight", "cultist/door_1", "models/balaclavas/balaclava", "models/cultist/heads/zombie_face", "models/all_scp_models/shared/arms_new", "nextoren/gui/special_abilities/special_fbi_commander.png", "models/breach_items/ammo_box/ammocrate_smg1"}
local desc_premium = BREACH.TranslateString"l:menu_desc_premium"

local function CreateMainMenuQuery(text, str1, func1, str2, func2)
    if IsValid(INTRO_PANEL.credits) then INTRO_PANEL.credits:Remove() end
    if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end
    if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
    MAIN_MENU_DERMA_QUERY = vgui.Create("DPanel", INTRO_PANEL)
    MAIN_MENU_DERMA_QUERY:SetSize(400, 70)
    MAIN_MENU_DERMA_QUERY:SetAlpha(0)
    MAIN_MENU_DERMA_QUERY:AlphaTo(255, 1)
    local x, y = gui.MousePos()
    x = x + 10
    x = math.max(x, 170)
    if y > ScrH() - 70 then y = ScrH() - 80 end
    MAIN_MENU_DERMA_QUERY:SetPos(x, y)
    MAIN_MENU_DERMA_QUERY.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, dark_clr)
        DrawBlurPanel(self)
        draw.DrawText(text, "MainMenuFontmini", w / 2, 2, color_white, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, 0, w / 2, 1)
        surface.DrawTexturedRect(0, h - 1, w / 2, 1)
        surface.SetMaterial(gradient2)
        surface.DrawTexturedRect(w / 2, 0, w / 2, 1)
        surface.DrawTexturedRect(w / 2, h - 1, w / 2, 1)
        MAIN_MENU_DERMA_QUERY:MakePopup() --surface.DrawOutlinedRect(0,0,w,h,1)
    end

    local butt1 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
    if not str2 then
        butt1:SetSize(400, 30)
    else
        butt1:SetSize(200, 30)
    end

    butt1:SetPos(0, 40)
    butt1:SetText("")
    butt1.DoClick = function()
        if func1 then func1() end
        MAIN_MENU_DERMA_QUERY:Remove()
    end

    butt1.Paint = function(self, w, h) draw.DrawText(str1, "MainMenuFontmini", w / 2, 0, color_white, TEXT_ALIGN_CENTER) end
    if str2 then
        local butt2 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
        butt2:SetSize(200, 30)
        butt2:SetPos(200, 40)
        butt2:SetText("")
        butt2.DoClick = function()
            if func2 then func2() end
            MAIN_MENU_DERMA_QUERY:Remove()
        end

        butt2.Paint = function(self, w, h) draw.DrawText(str2, "MainMenuFontmini", w / 2, 0, color_white, TEXT_ALIGN_CENTER) end
    end
end

local function CreateMainMenuQueryWithHover(text,str1,hoverstr1,func1,str2,hoverstr2,func2)

    local butt1hovered = false
    local butt2hovered = false
  
    if IsValid(INTRO_PANEL.credits) then INTRO_PANEL.credits:Remove() end
    if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end
    if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
    MAIN_MENU_DERMA_QUERY = vgui.Create("DPanel", INTRO_PANEL)
    MAIN_MENU_DERMA_QUERY:SetSize(400,70)
    MAIN_MENU_DERMA_QUERY:SetAlpha(0)
    MAIN_MENU_DERMA_QUERY:AlphaTo(255,1)
    local x, y = gui.MousePos()
    x = x + 10
    x = math.max(x, 170)
    if y > ScrH() - 70 then
      y = ScrH() - 80
    end
    MAIN_MENU_DERMA_QUERY:SetPos(x, y)
    MAIN_MENU_DERMA_QUERY.Paint = function(self,w,h)
      draw.RoundedBox(0,0,0,w,h,dark_clr)
      DrawBlurPanel(self)
      draw.DrawText(text, "MainMenuFontmini", w/2, 2, color_white, TEXT_ALIGN_CENTER)
      surface.SetDrawColor(color_white)
      surface.SetMaterial(gradient)
      surface.DrawTexturedRect(0,0,w/2,1)
      surface.DrawTexturedRect(0,h-1,w/2,1)
      surface.SetMaterial(gradient2)
      surface.DrawTexturedRect(w/2,0,w/2,1)
      surface.DrawTexturedRect(w/2,h-1,w/2,1)
      --surface.DrawOutlinedRect(0,0,w,h,1)
      MAIN_MENU_DERMA_QUERY:MakePopup()
    end
    local butt1 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
    if !str2 then
      butt1:SetSize(400, 30)
    else
      butt1:SetSize(200, 30)
    end
    butt1:SetPos(0,40)
    butt1:SetText("")
    butt1.DoClick = function()
      if func1 then func1() end
      MAIN_MENU_DERMA_QUERY:Remove()
      butt1hovered = false
      butt2hovered = false
    end
    butt1.Paint = function(self, w, h)
      draw.DrawText(str1, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)
  
      if self:IsHovered() then
        butt1hovered = true
      else
        butt1hovered = false
      end
    end
  
    if str2 then
      local butt2 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
      butt2:SetSize(200, 30)
      butt2:SetPos(200,40)
      butt2:SetText("")
      butt2.DoClick = function()
        if func2 then func2() end
        MAIN_MENU_DERMA_QUERY:Remove()
        butt1hovered = false
        butt2hovered = false
      end
      butt2.Paint = function(self, w, h)
        draw.DrawText(str2, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)
  
        if self:IsHovered() then
          butt2hovered = true
        else
          butt2hovered = false
        end
      end
    end
  
    local hovertextlabel = vgui.Create("DLabel", INTRO_PANEL)
    hovertextlabel:SetSize(ScrW(), ScrH())
    hovertextlabel:SetPos(0, 0)
    hovertextlabel:SetText("")
    hovertextlabel.Paint = function(self, w, h)
      local cx, cy = input.GetCursorPos()
      if butt1hovered and string.len(hoverstr1) > 0 then
        --hovertextlabel:SetPos(cx, cy)
        draw.DrawText(hoverstr1, "BudgetLabel", cx + ScrH()*0.03, cy + ScrH()*0.04, color_white, TEXT_ALIGN_CENTER)
      end
  
      if butt2hovered and string.len(hoverstr2) > 0 then
        --hovertextlabel:SetPos(cx, cy)
        draw.DrawText(hoverstr2, "BudgetLabel", cx + ScrH()*0.03, cy + ScrH()*0.04, color_white, TEXT_ALIGN_CENTER)
      end
    end
  
  end
  
function GM:DrawDeathNotice(x, y)
end

local intro_clr = Color(200, 200, 200)
local function StartIntro()
    surface.PlaySound("nextoren/unity/wakingup.ogg")

    local screenfade = vgui.Create("DPanel")

    screenfade:SetSize(ScrW(), ScrH())
    screenfade:AlphaTo(0, 5, 1, function()
        if IsValid(screenfade) then 
            screenfade:Remove() 
        end
    end)

    timer.Simple(6, function()
        local intropanel = vgui.Create("DPanel")
        intropanel:SetPos(ScrW() * .75, ScrH() * .7)
        intropanel:SetSize(math.min(ScrW() * .35, 500), 128)
        intropanel:SetText("")
        intropanel.Paint = function(self, w, h) end
        local NextSymbolTime = RealTime()
        local count = 0
        local alpha = 255
        local TextPanel = vgui.Create("DLabel", intropanel)
        TextPanel:SetPos(5, 0)
        TextPanel:SetFont("SubScoreboardHeader")
        TextPanel:SetText("")
        local roundstring
        if gamestarted then
            roundstring = "l:startintro_round_will_begin " .. string.ToMinutesSeconds(cltime)
        else
            roundstring = "l:startintro_no_round"
        end
    
        local teststring = tostring(L"l:startintro_welcome_pt1 " .. LocalPlayer():GetName() .. "!\n " .. L(roundstring) .. L" l:startintro_welcome_pt2")
        local stringtable = utf8.Explode("", teststring, false)
        surface.SetFont("SubScoreboardHeader")
        local stringw, stringh = surface.GetTextSize(teststring)
        TextPanel:SetSize(stringw, stringh)
        TextPanel.Paint = function(self, w, h)
            draw.DrawText(tostring(os.date("%X")), "SubScoreboardHeader", 0, 0, intro_clr, TEXT_ALIGN_LEFT)
            if NextSymbolTime <= RealTime() and count ~= #stringtable then
                NextSymbolTime = NextSymbolTime + 0.08
                count = count + 1
                if stringtable[count] ~= " " then surface.PlaySound("common/talk.wav") end
                if count == #stringtable then NextSymbolTime = NextSymbolTime + 10 end
                TextPanel:SetText(TextPanel:GetText() .. stringtable[count])
            end
    
            if NextSymbolTime <= RealTime() and count == #stringtable then
                alpha = math.Approach(alpha, 0, FrameTime() * 45)
                TextPanel:SetAlpha(alpha)
                if TextPanel:GetAlpha() == 0 then intropanel:Remove() end
            end
        end    
    end)
end

function music_menu()
    surface.PlaySound("nextoren/unity/menutheme.ogg")
end

concommand.Add("music_menu", music_menu)
function Fluctuate(c) --used for flashing colors
    return (math.cos(CurTime() * c) + 1) / 2
end

function Pulsate(c) --Использование флешей
    return math.abs(math.sin(CurTime() * c))
end

weareprecaching = weareprecaching or false
if FIRSTTIME_MENU == nil then FIRSTTIME_MENU = true end
local credits = {"----------------------------------------------------------", "| Cultist_kun - Creator of 1.0, inspired to make our server", "| Ghelid - Creator of 1.0, inspired to make our server", "----------------------------------------------------------", "| Jithead - server tester", "| Dest - server tester", "| Solyanka - server tester", "| kotiknr - server tester", "| бутерброд - server tester", "| Suoh/Cyox - помощь с кодом", "----------------------------------------------------------", "| You - thanks for playing on the server!", "| Bismillahi rahmani rahim ☪", "----------------------------------------------------------",}
function OpenCreditsMenu()
    if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end
    if IsValid(INTRO_PANEL.credits) then
        INTRO_PANEL.credits:AlphaTo(0, 1, 0, function()
            INTRO_PANEL.credits:Remove()
            INTRO_PANEL.credits = nil
        end)
        return
    end

    local creditspanel = vgui.Create("DScrollPanel", INTRO_PANEL)
    local sbar = creditspanel:GetVBar()
    function sbar:Paint(w, h)
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, w - 3, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, w - 3, h / 2)
    end

    INTRO_PANEL.credits = creditspanel
    INTRO_PANEL.credits:SetAlpha(0)
    INTRO_PANEL.credits:SetSize(400, 400)
    INTRO_PANEL.credits:Center()
    INTRO_PANEL.credits:AlphaTo(255, 1)
    INTRO_PANEL.credits.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, dark_clr)
        DrawBlurPanel(INTRO_PANEL.credits)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, 3, h / 2)
        surface.DrawTexturedRect(w - 3, 0, 3, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, 3, h / 2)
        surface.DrawTexturedRect(w - 3, h / 2, 3, h / 2)
        INTRO_PANEL.credits:MakePopup()
    end

    for i = 1, #credits do
        local text = credits[i]
        local label = vgui.Create("DLabel", creditspanel)
        label:Dock(TOP)
        label:SetSize(0, 20)
        label:SetFont("ChatFont_new")
        label:SetText("  " .. text)
    end
end

local function firsttimeshit(precache)
    RunConsoleCommand("stopsound")
    net.Start("Player_FullyLoadMenu", true)
    net.SendToServer()
    timer.Create("Player_FullyLoadMenu", 1, 0, function()
        if LocalPlayer():GetNWBool("Player_IsPlaying", false) then
            timer.Remove("Player_FullyLoadMenu")
            return
        end

        net.Start("Player_FullyLoadMenu")
        net.SendToServer()
    end)

    if precache then weareprecaching = true end
    timer.Simple(0.1, function()
        if precache then
            PrecachePlayerSounds()
            weareprecaching = false
        end

        FIRSTTIME_MENU = false
        surface.PlaySound("nextoren/gui/main_menu/confirm.wav")
        if mainmenumusic then mainmenumusic:Stop() end
        INTRO_PANEL:SetVisible(false)
        if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
        if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
        if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
        if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
        gui.EnableScreenClicker(false)
        ShowMainMenu = false --mainmenumusic:Stop()
        if mainmenumusic then mainmenumusic:Stop() end
        MenuTable.start = L"l:menu_resume"
        local ply = LocalPlayer()
        ply:ConCommand("r_decals 4096")
        ply:ConCommand("gmod_mcore_test 1")
        StartIntro()
        ply:ConCommand("lounge_chat_clear")
    end)
end

function StartBreach(firsttime)
    local buttons = {
        {
          name = "play",
          notfirsttime_name = "play",
          func = function()
    
            if ( FIRSTTIME_MENU ) then
              CreateMainMenuQueryWithHover(L"l:menu_do_precache_or_nah",
                L"l:menu_yes", L"l:menu_precache_hover",
                function()
                  firsttimeshit(true)
                end,
    
                L"l:menu_no", L"l:menu_no_precache_hover",
                function()
                  firsttimeshit(false)
                end
                )
                    else
                    surface.PlaySound("nextoren/gui/main_menu/confirm.wav")
                    INTRO_PANEL:SetVisible(false)
                    if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
                    if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
                    if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
                    if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
                    gui.EnableScreenClicker(false)
                    if mainmenumusic then mainmenumusic:Stop() end
                    ShowMainMenu = false
                end
            end
        },
        {
            name = "settings",
            func = function()
                OpenConfigMenu()
                surface.PlaySound("nextoren/gui/main_menu/main_menu_select_1.wav")
            end,
        },
        {
            name = "rules",
            func = function()
                INTRO_PANEL:OpenUrl("https://book.vaultcommunity.net/books/arkhiv/page/pravila-servera-breach")
                surface.PlaySound("nextoren/gui/main_menu/main_menu_select_1.wav")
            end,
        },
        {
            name = "wiki",
            func = function()
                gui.OpenURL(MenuTable.url)
                surface.PlaySound("nextoren/gui/main_menu/main_menu_select_1.wav")
            end,
        },
        {
            name = "credits",
            func = function()
                OpenCreditsMenu()
                surface.PlaySound("nextoren/gui/main_menu/main_menu_select_1.wav")
            end,
        },
        {
            name = "disconnect",
            func = function()
                CreateMainMenuQueryWithHover(L"l:menu_sure", 
                L"l:menu_yes", "", function()
                    LocalPlayer():ConCommand("disconnect")
                end,
    
                L"l:menu_no", "", function()
                    INTRO_PANEL:SetVisible(false)
                    if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
                    if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
                    if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
                    if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
                    gui.EnableScreenClicker(false)
                    if mainmenumusic then mainmenumusic:Stop() end
                    ShowMainMenu = false

                    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
                end)
            end,
          }
    }

    local scrw, scrh = ScrW(), ScrH()
    INTRO_PANEL = vgui.Create("DPanel")
    INTRO_PANEL:SetSize(scrw, scrh)
    INTRO_PANEL:SetPos(0, 0)
    INTRO_PANEL.OpenTime = RealTime()
    function INTRO_PANEL:OpenUrl(url)
        if jit.arch == "x86" then
            gui.OpenURL(url)
        else
            if IsValid(INTRO_PANEL.HTML_PANEL) then
                INTRO_PANEL.HTML_PANEL:Remove()
                return
            end

            local HTML_PANEL = vgui.Create("DPanel", self)
            INTRO_PANEL.HTML_PANEL = HTML_PANEL
            HTML_PANEL:SetSize(450, scrh - 100)
            HTML_PANEL:SetPos(scrw - 500, 50)
            HTML_PANEL:SetAlpha(0)
            HTML_PANEL:AlphaTo(255, 1)
            local html = vgui.Create("DHTML", HTML_PANEL)
            html:Dock(FILL)
            html:OpenURL(url)
            HTML_PANEL.Paint = function(self, w, h)
                if html:IsLoading() then
                    draw.RoundedBox(0, 0, 0, w, h, dark_clr)
                    DrawBlurPanel(self)
                    surface.SetDrawColor(color_white)
                    surface.SetMaterial(grad2)
                    surface.DrawTexturedRect(0, 0, 3, h / 2)
                    surface.DrawTexturedRect(w - 3, 0, 3, h / 2)
                    surface.SetMaterial(grad1)
                    surface.DrawTexturedRect(0, h / 2, 3, h / 2)
                    surface.DrawTexturedRect(w - 3, h / 2, 3, h / 2)
                    draw.DrawText("Loading...", "ScoreboardHeader", w / 2, h / 2, _, TEXT_ALIGN_CENTER)
                end
            end
        end
    end

    INTRO_PANEL.ButtonsList = vgui.Create("DScrollPanel", INTRO_PANEL)
    INTRO_PANEL.ButtonsList:SetSize(300, 37 * #buttons + 5)
    INTRO_PANEL.ButtonsList:SetPos(24, scrh - (37 * #buttons + 29))
    INTRO_PANEL.ButtonsList.PaintOver = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, 2, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, 2, h / 2)
    end

    INTRO_PANEL.Discord = vgui.Create("DButton", INTRO_PANEL)
    INTRO_PANEL.Discord:SetPos(ScrW() / 2 + 850, ScrH() / 2 + 450)
    INTRO_PANEL.Discord:SetSize(64, 64)
    INTRO_PANEL.Discord:SetText("")
    INTRO_PANEL.Discord.Paint = function(self, w, h)
        local bIsHovered = self:IsHovered() and true or false

        local col = ColorAlpha(color_white, 75)

        if bIsHovered then
            col = color_white
        end

        surface.SetMaterial(Material("aresmenu/discord.png", "smooth"))
        surface.SetDrawColor(col)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    INTRO_PANEL.Discord.DoClick = function()
        gui.OpenURL("https://discord.gg/aresproject")
    end

    for _, but_data in pairs(buttons) do
        local button = vgui.Create("DButton", INTRO_PANEL.ButtonsList)
        button:Dock(TOP)
        button:SetSize(0, 37)
        button:SetText("")
        button.lerp = 0
        local clr_butt = Color(255, 255, 255, 115)
        local add_x = 0
        button.Paint = function(self, w, h)
            if self:IsHovered() then
                add_x = math.Approach(add_x, 17, FrameTime() * 350)
                button.lerp = math.Approach(button.lerp, 1, FrameTime())
            else
                add_x = math.Approach(add_x, 0, FrameTime() * 150)
                button.lerp = math.Approach(button.lerp, 0, FrameTime())
            end

            local font = "MainMenuFont_new"
            if langtouse == "russian" or langtouse == "ukraine" then font = "MainMenuFont_new_russian" end
            surface.SetFont(font)
            local text = get_button_lang(but_data.name)
            if but_data.notfirsttime_name and not FIRSTTIME_MENU then text = get_button_lang(but_data.notfirsttime_name) end
            local text_length = surface.GetTextSize(text)
            if self:IsHovered() then --draw.RoundedBox(0, 10, h-2, text_length*button.lerp, 2, color_white)
                draw.DrawText(">", font, 10, 0, ColorAlpha(color_white, 115 + (140 * (button.lerp * 3))))
            end

            draw.DrawText(text, font, 10 + add_x, 0, ColorAlpha(color_white, 115 + (140 * (button.lerp * 3))))
        end

        button.DoClick = function(self) but_data.func() end
    end

    local clr_black = color_black
    local ico = Material("nextoren/gui/icons/notifications/breachiconfortips.png", "noclamp smooth")
    local Backgrounds = {}
    local function updatebackgrounds()
        if not GetConVar("breach_config_mge_mode"):GetBool() then
            Backgrounds = {"aresmenu/pics/ntf_sniper.png", "aresmenu/pics/goc_commander.png", "aresmenu/pics/is_agent.png", "aresmenu/pics/scp.png", "aresmenu/pics/scp_096.png", "aresmenu/pics/scp_294.png", "aresmenu/pics/scp_303.png", "aresmenu/pics/scp_items.png", "aresmenu/pics/uiu_soldier.png", "aresmenu/pics/uiu_inflitrator.png",}
        else
            Backgrounds = {}
            for i = 1, 8 do
                table.insert(Backgrounds, "aresmenu/hard_pics/hard_pic_" .. i .. ".png")
            end
        end
    end

    updatebackgrounds()
    local lerp = 0
    local curbg = math.random(1, #Backgrounds)
    local nextbg = curbg + 1
    if nextbg > #Backgrounds then nextbg = 1 end
    local function CreateBackgroundImage(firsttime)
        if not IsValid(INTRO_PANEL) then return end
        if IsValid(INTRO_PANEL.bg_img) then
            INTRO_PANEL.bg_img:MoveTo(25, 0, 1.5, 0, -1)
            INTRO_PANEL.bg_img:AlphaTo(0, 1.5, 0, function(_, self) self:Remove() end)
        end

        INTRO_PANEL.bg_img = vgui.Create("DImage", INTRO_PANEL)
        INTRO_PANEL.bg_img:SetSize(scrw, scrh)
        INTRO_PANEL.bg_img:SetImage(Backgrounds[curbg])
        INTRO_PANEL.bg_img:SetZPos(-255)
        if not firsttime then
            INTRO_PANEL.bg_img:SetPos(15, 0)
            INTRO_PANEL.bg_img:MoveTo(0, 0, 1.5, 1.5, 0.5)
            INTRO_PANEL.bg_img:SetAlpha(0)
            INTRO_PANEL.bg_img:AlphaTo(255, 1.5, 1.5)
        end
    end

    local offset_height = 0
    INTRO_PANEL.OverrideDraw = vgui.Create("DImage", INTRO_PANEL)
    INTRO_PANEL.OverrideDraw:SetSize(scrw, scrh)
    INTRO_PANEL.OverrideDraw.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(ico)
        surface.DrawTexturedRect(5, 0 + offset_height, 100, 100)
        draw.DrawText("Ares Breach", "ScoreboardHeader", 105, 25 + offset_height)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(gradients)
        surface.DrawTexturedRect(100, 80 + offset_height, 305, 3)
        draw.RoundedBox(0, 100, 60, 305, 3, color_white)
        draw.DrawText("Beta-Testing Stage | Version " .. BREACH.Version, "ScoreboardContent", 105, 65)
        if weareprecaching then
            draw.RoundedBox(0, scrw * 0.44, scrh * 0.487, scrw * 0.12, scrh * 0.03, Color(0, 0, 0))
            draw.SimpleText(L"l:precaching_resources", "MainMenuFont", scrw * 0.5, scrh * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local creatorlist = vgui.Create("DPanel", INTRO_PANEL)
    creatorlist:SetSize(300, 300)
    creatorlist:SetPos(20, 100 + offset_height)
    creatorlist.Paint = function() end
    local spisok = {
        {
            defaultname = "-Spac3",
            id = "76561198797549224",
            who = BREACH.TranslateString"l:menu_lead l:menu_dev"
        },
    }

    local sin, cos, rad = math.sin, math.cos, math.rad
    local rad0 = rad(0)
    local function DrawCircle(x, y, radius, seg)
        local cir = {
            {
                x = x,
                y = y
            }
        }

        for i = 0, seg do
            local a = rad((i / seg) * -360)
            table.insert(cir, {
                x = x + sin(a) * radius,
                y = y + cos(a) * radius
            })
        end

        table.insert(cir, {
            x = x + sin(rad0) * radius,
            y = y + cos(rad0) * radius
        })

        surface.DrawPoly(cir)
    end

    for i = 1, #spisok do
        local v = spisok[i]
        local a = vgui.Create("DPanel", creatorlist)
        a:Dock(TOP)
        a:SetSize(0, 49)
        local hsiz = 44 / 2
        a.Paint = function() end
        local avatar = vgui.Create("AvatarImage", a)
        avatar:SetSteamID(v.id, 64)
        avatar:SetSize(44, 44)
        avatar:SetPaintedManually(true)
        a.Paint = function(w, h)
            render.ClearStencil()
            render.SetStencilEnable(true)
            render.SetStencilWriteMask(1)
            render.SetStencilTestMask(1)
            render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
            render.SetStencilPassOperation(STENCILOPERATION_ZERO)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
            render.SetStencilReferenceValue(1)
            draw.NoTexture()
            surface.SetDrawColor(color_black)
            DrawCircle(hsiz, hsiz, hsiz, hsiz)
            render.SetStencilFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
            render.SetStencilReferenceValue(1)
            avatar:PaintManual()
            render.SetStencilEnable(false)
            render.ClearStencil()
        end

        local name = vgui.Create("DLabel", a)
        name:SetSize(300, 20)
        name:SetPos(50, 5)
        name:SetFont("dev_name")
        name:SetTextColor(color_white)
        local who = vgui.Create("DLabel", a)
        who:SetSize(300, 20)
        who:SetPos(50, 25)
        who:SetFont("dev_desc")
        who:SetTextColor(color_white)
        who:SetText(v.who)
        local bootun = vgui.Create("DButton", a)
        bootun:SetSize(300, 44)
        bootun:SetText("")
        local hoverclr = Color(255, 255, 255, 20)
        bootun.Paint = function(self, w, h) if self:IsHovered() then draw.RoundedBoxEx(100, 0, 0, w, h, hoverclr, true, false, true, false) end end
        bootun.DoClick = function(self) gui.OpenURL("https://steamcommunity.com/profiles/" .. v.id) end
        local namer = v.defaultname
        name:SetText(namer)
        steamworks.RequestPlayerInfo(v.id, function(steamName)
            namer = steamName
            if v.defaultname:lower() ~= string.lower(steamName) and not string.lower(steamName):find(string.lower(v.defaultname)) then namer = namer .. " (" .. v.defaultname .. ")" end
            name:SetText(namer)
        end)
    end

    CreateBackgroundImage(true)
    timer.Create("MainMenu_UpdateBackground", 6, 0, function()
        curbg = nextbg
        nextbg = curbg + 1
        if nextbg > #Backgrounds then nextbg = 1 end
        CreateBackgroundImage()
    end)

    INTRO_PANEL.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, clr_black)
        if input.IsKeyDown(KEY_ESCAPE) and INTRO_PANEL.OpenTime < RealTime() - .2 and not FIRSTTIME_MENU then
            ShowMainMenu = CurTime() + .1
            gui.HideGameUI()
            INTRO_PANEL:SetVisible(false)
            gui.EnableScreenClicker(false)
            mainmenumusic:Stop()
            if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
            if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
            if IsValid(INTRO_PANEL.HTML_PANEL) then INTRO_PANEL.HTML_PANEL:Remove() end
            if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
            if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
        end
    end
end

function send_prefix_data()
    local data = util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA"))
    net.Start("SendPrefixData")
    net.WriteString(data.prefix)
    net.WriteBool(data.enabled)
    net.WriteString(data.color)
    net.WriteBool(data.rainbow)
    net.SendToServer()
end

hook.Add("InitPostEntity", "StartBreachIntro", function()
    StartBreach(true)
    if not file.Exists("breach_prefix_settings.txt", "DATA") then
        file.Write("breach_prefix_settings.txt", util.TableToJSON({
            enabled = false,
            prefix = "my prefix",
            color = "255,255,255",
            rainbow = false,
        }, true))
    end

    send_prefix_data()
end)

concommand.Add("send_prefix_data", send_prefix_data)
CreateConVar("breach_config_cw_viewmodel_fov", 70, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 50, 100) --breach config
CreateConVar("breach_config_cw_viewmodel_offset_z", 0, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 0, 30)
CreateConVar("breach_config_announcer_volume", GetConVar("volume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change announcer's volume", 0, 100)
CreateConVar("breach_config_language", GetConVar("cvar_br_language"):GetString() or "english", FCVAR_ARCHIVE, "Change gamemode language")
CreateConVar("breach_config_name_color", "255,255,255", FCVAR_ARCHIVE, "Change your nick color in chat. Example: 150,150,150. Premium or higher only")
CreateConVar("breach_config_mge_mode", 0, FCVAR_ARCHIVE, "MGE MODE", 0, 1)
CreateConVar("breach_config_overall_music_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 200)
CreateConVar("breach_config_music_ambient_volume", 25, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_spawn_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_panic_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_misc_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_screenshot_mode", 0, FCVAR_NONE, "Completely disables HUD. Can be buggy", 0, 1)
CreateConVar("breach_config_screen_effects", 1, FCVAR_ARCHIVE, "Enables bloom and toytown", 0, 1)
CreateConVar("breach_config_filter_textures", 1, FCVAR_ARCHIVE, "Disabling this will decrease texture quality. Alias: mat_filtertextures", 0, 1)
CreateConVar("breach_config_filter_lightmaps", 1, FCVAR_ARCHIVE, "Disabling this will decrease lightmap(shadows) quality. Alias: mat_filterlightmaps", 0, 1)
CreateConVar("breach_config_display_premium_icon", 1, FCVAR_ARCHIVE, "Disabling display on scoreboard/chat/voice", 0, 1)
CreateConVar("breach_config_spawn_female_only", 0, FCVAR_ARCHIVE, "Spawn only as female characters", 0, 1)
CreateConVar("breach_config_spawn_male_only", 0, FCVAR_ARCHIVE, "Spawn only as male characters", 0, 1)
CreateConVar("breach_config_no_role_description", 0, FCVAR_ARCHIVE, "Disables role description", 0, 1)
CreateConVar("breach_config_scp_red_screen", 1, FCVAR_ARCHIVE, "Enables the red screen for SCP", 0, 1)
CreateConVar("breach_config_spawn_support", 1, FCVAR_ARCHIVE, "Spawn as support", 0, 1)
CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)
CreateConVar("breach_config_filter_yellow", 0, FCVAR_ARCHIVE, "Patrolling the Site-19 makes you wish for a nuclear winter.", 0, 1) --CreateConVar("breach_config_holsters", 1, FCVAR_ARCHIVE, "Very resource intensive, not recommended", 0, 1)
CreateConVar("breach_config_filter_blue", 0, FCVAR_ARCHIVE, "Enables blue color filter", 0, 1)
CreateConVar("breach_config_filter_outside", 0, FCVAR_ARCHIVE, "Enables color filter outside", 0, 1)
CreateConVar("breach_config_filter_intensity", 0, FCVAR_ARCHIVE, "Changes intensity of color filter", 1, 10)
CreateConVar("breach_config_hide_title", 0, FCVAR_ARCHIVE, "Disable bottom title", 0, 1)
CreateConVar("breach_config_sexual_chemist", 1, FCVAR_ARCHIVE, "Sexy Chemist", 0, 1)
CreateConVar("breach_config_disable_voice_spec", 0, FCVAR_NONE, "You won't hear other spectators as a spectator", 0, 1)
CreateConVar("breach_config_disable_voice_alive", 0, FCVAR_NONE, "You won't hear alive people as a spectator", 0, 1)
CreateConVar("breach_config_useability", KEY_H, FCVAR_ARCHIVE, "number you will use ability with")
CreateConVar("breach_config_openinventory", KEY_Q, FCVAR_ARCHIVE, "number you will open inventory with")
CreateConVar("breach_config_leanright", KEY_3, FCVAR_ARCHIVE, "Leans to the right")
CreateConVar("breach_config_leanleft", KEY_1, FCVAR_ARCHIVE, "Leans to the left")
CreateConVar("breach_config_quickchat", KEY_C, FCVAR_ARCHIVE, "Quick chat menu")
CreateConVar("breach_config_draw_legs", 1, FCVAR_ARCHIVE, "Draw legs")
CreateConVar("breach_config_killfeed", 1, FCVAR_ARCHIVE, "Show killfeed")
CreateConVar("breach_config_scphudleft", 0, FCVAR_ARCHIVE, "SCP Ability style")
function GetAnnouncerVolume() --announcer helper function
    return GetConVar("breach_config_announcer_volume"):GetInt() or 50
end

RunConsoleCommand("mat_filtertextures", GetConVar("breach_config_filter_textures"):GetInt()) --filter shit
RunConsoleCommand("mat_filterlightmaps", GetConVar("breach_config_filter_lightmaps"):GetInt())
cvars.AddChangeCallback("breach_config_filter_textures", function(cvar, old, new) RunConsoleCommand("mat_filtertextures", tonumber(new)) end)
cvars.AddChangeCallback("breach_config_filter_lightmaps", function(cvar, old, new) RunConsoleCommand("mat_filterlightmaps", tonumber(new)) end)
cvars.AddChangeCallback("breach_config_screenshot_mode", function(_, _, new) end)
RunConsoleCommand("breach_config_language", GetConVar("breach_config_language"):GetString()) --language
cvars.AddChangeCallback("breach_config_language", function(cvar, old, new) RunConsoleCommand("cvar_br_language", new) end)
BREACH.AllowedNameColorGroups = {
    ["superadmin"] = true,
    ["spectator"] = true,
    ["admin"] = true,
    ["premium"] = true,
}

function NameColorSend(cvar, old, new) --name color
    if LocalPlayer():IsPremium() then
        if not new:find(",") then return end
        local color_tbl = string.Explode(",", new)
        if isnumber(tonumber(color_tbl[1])) and isnumber(tonumber(color_tbl[2])) and isnumber(tonumber(color_tbl[3])) then
            color = Color(tonumber(color_tbl[1]), tonumber(color_tbl[2]), tonumber(color_tbl[3]))
            if IsColor(color) then
                color.a = 255 --xyecocs
                net.Start("NameColor") --don't even fucking try to exploit it or you will suck my dick or BAN
                net.WriteColor(color)
                net.SendToServer()
            end
        end
    end
end

cvars.AddChangeCallback("breach_config_name_color", NameColorSend)
local function ChangeServerValue(id, bool)
    net.Start("Change_player_settings")
    net.WriteUInt(id, 12)
    net.WriteBool(bool)
    net.SendToServer()
end

local function ChangeServerValueInt(id, int)
    net.Start("Change_player_settings_id")
    net.WriteUInt(id, 12)
    net.WriteUInt(int, 32)
    net.SendToServer()
end

cvars.AddChangeCallback("breach_config_disable_voice_spec", function(_, _, new) ChangeServerValue(5, tobool(new)) end)
cvars.AddChangeCallback("breach_config_sexual_chemist", function(_, _, new) ChangeServerValue(7, tobool(new)) end)
cvars.AddChangeCallback("breach_config_disable_voice_alive", function(_, _, new) ChangeServerValue(6, tobool(new)) end)
cvars.AddChangeCallback("breach_config_spawn_female_only", function(_, _, new) ChangeServerValue(2, tobool(new)) end)
cvars.AddChangeCallback("breach_config_useability", function(_, _, new)
    LocalPlayer().AbilityKey = string.upper(input.GetKeyName(new))
    LocalPlayer().AbilityKeyCode = new
    ChangeServerValueInt(1, new)
end)

cvars.AddChangeCallback("breach_config_spawn_male_only", function(_, _, new) ChangeServerValue(3, tobool(new)) end)
cvars.AddChangeCallback("breach_config_spawn_support", function(_, _, new) ChangeServerValue(1, tobool(new)) end)
cvars.AddChangeCallback("breach_config_display_premium_icon", function(_, _, new) ChangeServerValue(4, tobool(new)) end)
hook.Add("InitPostEntity", "NameColorSend", function()
    timer.Simple(30, function()
        local tab = {
            spawnsupport = GetConVar("breach_config_spawn_support"):GetBool(),
            spawnmale = GetConVar("breach_config_spawn_male_only"):GetBool(),
            spawnfemale = GetConVar("breach_config_spawn_female_only"):GetBool(),
            displaypremiumicon = GetConVar("breach_config_display_premium_icon"):GetBool(),
            useability = GetConVar("breach_config_useability"):GetInt(),
            leanright = GetConVar("breach_config_leanright"):GetInt(),
            leanleft = GetConVar("breach_config_leanleft"):GetInt(),
            sexychemist = GetConVar("breach_config_sexual_chemist"):GetBool(),
        }

        net.Start("Load_player_data")
        net.WriteTable(tab)
        net.SendToServer()
        NameColorSend("pidr", "pidr", GetConVar("breach_config_name_color"):GetString())
    end)
end)

hook.Add("HUDShouldDraw", "Breach_Screenshot_Mode", function(name)
    if GetConVar("breach_config_screenshot_mode"):GetInt() == 0 then return end
    return false
end)

local yellow = GetConVar("breach_config_filter_yellow")
local blue = GetConVar("breach_config_filter_blue")
local mult = GetConVar("breach_config_filter_intensity")
local noutisde = GetConVar("breach_config_filter_outside")
local colormodify_yellow = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,
}

local colormodify_blue = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,
}

local _DrawColorModify = DrawColorModify
local translate_translations = {
    ["russian"] = "русский",
    ["english"] = "english"
}

BREACH.Options = {
    {
        name = "l:menu_settings",
        settings = {
            {
                name = "SEXY CHEMIST",
                checkplayer = NEXTOREN_SEXY_CHEMISTS,
                cvar = "breach_config_sexual_chemist",
                type = "bool",
            },
            {
                name = "l:menu_weapon_fov",
                cvar = "breach_config_cw_viewmodel_fov",
                type = "slider",
                min = 50,
                max = 100,
            },
            {
                name = "l:menu_weapon_z_offset",
                cvar = "breach_config_cw_viewmodel_offset_z",
                type = "slider",
                min = 0,
                max = 30,
            },
            {
                name = "l:menu_no_role_desc",
                cvar = "breach_config_no_role_description",
                type = "bool",
            },
            {
                name = "l:menu_spawn_as_sup",
                cvar = "breach_config_spawn_support",
                type = "bool",
            },
            {
                name = "l:menu_useability",
                cvar = "breach_config_useability",
                type = "bind",
            },
            {
                name = "l:menu_inventory_key",
                cvar = "breach_config_openinventory",
                type = "bind",
            },
            {
                name = "l:menu_lean_left",
                cvar = "breach_config_leanleft",
                type = "bind",
            },
            {
                name = "l:menu_lean_right",
                cvar = "breach_config_leanright",
                type = "bind",
            },
            {
                name = "l:menu_quickchat",
                cvar = "breach_config_quickchat",
                type = "bind",
            },
            {
                name = "l:menu_lang",
                cvar = "breach_config_language",
                type = "choice",
                value = {"russian", "english"},
            },
        },
    },
    {
        name = "l:menu_chat_voice",
        settings = {
            {
                name = "l:menu_gradient_voice",
                cvar = "br_gradient_voice_chat",
                type = "bool"
            },
            {
                name = "l:menu_voice_show_alive",
                cvar = "br_voicechat_showalive",
                type = "bool"
            },
            {
                name = "l:menu_disable_flashes",
                cvar = "lounge_chat_disable_flashes",
                type = "bool"
            },
            {
                name = "l:menu_disable_avatars",
                cvar = "lounge_chat_hide_avatars",
                type = "bool"
            },
            {
                name = "l:menu_roundavatars",
                cvar = "lounge_chat_roundavatars",
                type = "bool"
            },
            {
                name = "l:menu_clearemoji",
                cvar = "br_voicechat_showalive",
                type = "unique",
                createpanel = function(panel)
                    local siz = 0
                    local pa = LOUNGE_CHAT.ImageDownloadFolder .. "/"
                    local fil = file.Find(pa .. "*.png", "DATA")
                    for _, f in pairs(fil) do
                        siz = siz + file.Size(pa .. f, "DATA")
                    end

                    local clear_dpanel = vgui.Create("DPanel", panel)
                    clear_dpanel:Dock(TOP)
                    clear_dpanel:SetSize(0, 30)
                    clear_dpanel.Paint = function() end
                    local clear_panel = vgui.Create("DButton", clear_dpanel)
                    clear_panel:Dock(FILL)
                    clear_panel:DockMargin(3, 3, 3, 3)
                    clear_panel:SetText("")
                    clear_panel.Text = "l:menu_clear_downloaded_images (" .. string.NiceSize(siz) .. ")"
                    local col = Color(255, 255, 255, 100)
                    clear_panel.Paint = function(self, w, h)
                        if self:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, col) end
                        drawmat(5, 0, w - 10, 1, gradients)
                        drawmat(5, h - 1, w - 10, 1, gradients)
                        draw.DrawText(L(self.Text), "ScoreboardContent", w / 2, 4, nil, TEXT_ALIGN_CENTER)
                    end

                    clear_panel.DoClick = function(self)
                        local pa = LOUNGE_CHAT.ImageDownloadFolder .. "/"
                        local fil = file.Find(pa .. "*.png", "DATA")
                        for _, f in pairs(fil) do
                            file.Delete(pa .. f)
                        end

                        self.Text = "l:menu_clear_downloaded_images (" .. string.NiceSize(0) .. ")"
                    end
                end
            },
        },
    },
    {
        name = "l:menu_audio",
        settings = {
            {
                name = "l:menu_mute_spec",
                cvar = "breach_config_disable_voice_spec",
                type = "bool",
            },
            {
                name = "l:menu_mute_spec_if_alive",
                cvar = "breach_config_disable_voice_alive",
                type = "bool",
            },
            {
                name = "l:menu_overall_music_volume",
                cvar = "breach_config_overall_music_volume",
                type = "slider",
                min = 0,
                max = 200,
            },
            {
                name = "l:menu_spawn_music_volume",
                cvar = "breach_config_music_spawn_volume",
                type = "slider",
                min = 0,
                max = 100,
            },
            {
                name = "l:menu_panic_music_volume",
                cvar = "breach_config_music_panic_volume",
                type = "slider",
                min = 0,
                max = 100,
            },
            {
                name = "l:menu_ambience_music_volume",
                cvar = "breach_config_music_ambient_volume",
                type = "slider",
                min = 0,
                max = 100,
            },
            {
                name = "l:menu_misc_music_volume",
                cvar = "breach_config_music_misc_volume",
                type = "slider",
                min = 0,
                max = 100,
            },
            {
                name = "l:menu_announcer_volume",
                cvar = "breach_config_announcer_volume",
                type = "slider",
                min = 0,
                max = 100,
            },
        },
    },
    {
        name = "l:menu_visual_settings",
        settings = {
            {
                name = "l:menu_drawlegs",
                cvar = "breach_config_draw_legs",
                type = "bool"
            },
            {
                name = "l:menu_scp_hud_left",
                cvar = "breach_config_scphudleft",
                type = "bool"
            },
            {
                name = "l:menu_killfeed",
                cvar = "breach_config_killfeed",
                type = "bool"
            },
            {
                name = "l:menu_hide_title",
                cvar = "breach_config_hide_title",
                type = "bool"
            },
            {
                name = "l:menu_hudstyle",
                cvar = "breach_config_hud_style",
                type = "bool"
            },
            {
                name = "l:menu_scp_red_vision",
                cvar = "breach_config_scp_red_screen",
                type = "bool"
            },
            {
                name = "l:menu_screenshot_mode",
                cvar = "breach_config_screenshot_mode",
                type = "bool",
            },
            {
                name = "l:menu_screen_effects",
                cvar = "breach_config_screen_effects",
                type = "bool",
            },
            {
                name = "l:menu_filter_textures",
                cvar = "breach_config_filter_textures",
                type = "bool",
            },
            {
                name = "l:menu_filter_lightmaps",
                cvar = "breach_config_filter_lightmaps",
                type = "bool",
            },
        }
    },
    {
        name = "l:menu_special_settings",
        prefix = true,
        settings = {
            {
                name = "l:menu_chat_prefix",
                cvar = "breach_config_name_color",
                type = "prefix",
            },
        }
    },
    {
        name = "l:menu_premium_settings",
        premium = true,
        settings = {
            {
                name = "l:menu_nick_grb_color",
                cvar = "breach_config_name_color",
                type = "color",
                premium = true,
            },
            {
                name = "l:menu_display_premium_icon",
                cvar = "breach_config_display_premium_icon",
                type = "bool",
                premium = true,
            },
            {
                name = "l:menu_spawn_male_only",
                cvar = "breach_config_spawn_male_only",
                type = "bool",
                premium = true,
            },
            {
                name = "l:menu_spawn_female_only",
                cvar = "breach_config_spawn_female_only",
                type = "bool",
                premium = true,
            },
        }
    }
}

function OpenConfigMenu()
    local scrw, scrh = ScrW(), ScrH()
    if IsValid(INTRO_PANEL.settings_frame) then
        INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
            INTRO_PANEL.settings_frame:Remove()
            INTRO_PANEL.settings_frame = nil
        end)
        return
    end

    local settings_frame = vgui.Create("DScrollPanel", INTRO_PANEL)
    INTRO_PANEL.settings_frame = settings_frame
    local sbar = settings_frame:GetVBar()
    function sbar:Paint(w, h)
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(6, 0, 6, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(6, h / 2, 6, h / 2)
    end

    settings_frame:SetAlpha(0)
    settings_frame:AlphaTo(255, 1)
    settings_frame:SetSize(450, scrh - 100)
    settings_frame:SetPos(scrw - 500, 50)
    settings_frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, dark_clr)
        DrawBlurPanel(self)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, 3, h / 2)
        surface.DrawTexturedRect(w - 3, 0, 3, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, 3, h / 2)
        surface.DrawTexturedRect(w - 3, h / 2, 3, h / 2)
    end

    local function choicepanel(choices, convar)
        if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
        choices_panel_settings = vgui.Create("DScrollPanel", INTRO_PANEL)
        local x, y = gui.MousePos()
        x = math.min(x, INTRO_PANEL.settings_frame:GetX())
        choices_panel_settings:SetSize(80, 200)
        choices_panel_settings:SetPos(x - 100, y)
        choices_panel_settings:SetAlpha(0)
        choices_panel_settings:AlphaTo(255, 1)
        for _, value in pairs(choices) do
            local apply = vgui.Create("DButton", choices_panel_settings)
            apply:Dock(TOP)
            apply:SetSize(80, 30)
            apply:SetPos(90, 300 - 40)
            apply:SetText("")
            apply.Paint = function(self, w, h)
                drawmat(0, 0, w, 1, gradients)
                drawmat(0, h - 1, w, 1, gradients)
                if translate_translations[value] then
                    draw.DrawText(translate_translations[value], "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                else
                    draw.DrawText(value, "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end
            end

            apply.DoClick = function()
                GetConVar(convar):SetString(value)
                choices_panel_settings:Remove()
            end
        end
    end

    local function create_prefix_panel(data)
        if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
        COLOR_PANEL_SETTINGS = vgui.Create("DFrame", INTRO_PANEL)
        COLOR_PANEL_SETTINGS:SetSize(300, 400)
        COLOR_PANEL_SETTINGS:Center()
        COLOR_PANEL_SETTINGS:SetAlpha(0)
        COLOR_PANEL_SETTINGS:AlphaTo(255, 1)
        COLOR_PANEL_SETTINGS:ShowCloseButton(false)
        EDITABLEBAPENL = vgui.Create("DTextEntry", COLOR_PANEL_SETTINGS)
        EDITABLEBAPENL:SetPos(10, 325)
        EDITABLEBAPENL:SetSize(280, 20)
        EDITABLEBAPENL:SetFont("ChatFont_new")
        EDITABLEBAPENL:SetText(data.prefix)
        local visible_panel = vgui.Create("DPanel", COLOR_PANEL_SETTINGS)
        visible_panel:SetPos(10, 300)
        visible_panel:SetSize(100, 25)
        visible_panel.Paint = function() draw.DrawText("Enabled", "ChatFont_new", 30, 4) end
        local visible = vgui.Create("DCheckBox", visible_panel)
        visible:SetSize(25, 25)
        visible:SetValue(data.enabled)
        visible.OnChange = function(self, val) data.enabled = val end
        local rainbow_panel = vgui.Create("DPanel", COLOR_PANEL_SETTINGS)
        rainbow_panel:SetPos(110, 300)
        rainbow_panel:SetSize(100, 25)
        rainbow_panel.Paint = function() draw.DrawText("Rainbow", "ChatFont_new", 30, 4) end
        local rainbow = vgui.Create("DCheckBox", rainbow_panel)
        rainbow:SetSize(25, 25)
        rainbow:SetValue(data.rainbow)
        rainbow.OnChange = function(self, val) data.rainbow = val end
        EDITABLEBAPENL.OnTextChanged = function(self)
            local val = self:GetText()
            if utf8.len(val) > 20 then self:SetText(utf8.sub(val, 0, 20)) end
        end

        local colt = string.Explode(",", data.color)
        local color = Color(tonumber(colt[1]), tonumber(colt[2]), tonumber(colt[3]))
        local col = vgui.Create("DColorCombo", COLOR_PANEL_SETTINGS)
        col:SetSize(300, 250)
        col:SetColor(color)
        COLOR_PANEL_SETTINGS.Paint = function(self, w, h)
            local mycol = col:GetColor()
            draw.DrawText("RGB: " .. mycol.r .. "," .. mycol.g .. "," .. mycol.b, "BudgetLabel", w, 3, mycol, TEXT_ALIGN_RIGHT)
            COLOR_PANEL_SETTINGS:MakePopup()
        end

        local apply = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
        apply:SetSize(80, 30)
        apply:SetPos(50, 300 - 40)
        apply:SetText("")
        apply.Paint = function(self, w, h)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText("APPLY", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
        end

        apply.DoClick = function()
            local color = col:GetColor()
            data.color = tostring(color.r) .. "," .. tostring(color.g) .. "," .. tostring(color.b)
            data.prefix = EDITABLEBAPENL:GetText()
            file.Write("breach_prefix_settings.txt", util.TableToJSON(data, true))
            send_prefix_data()
            pub_text_panel.prefix:SizeToContents()
            timer.Simple(0.1, function() pub_text_panel.prefix:SizeToContents() end)
            COLOR_PANEL_SETTINGS:Remove()
        end

        local cancel = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
        cancel:SetSize(80, 30)
        cancel:SetPos(300 - 80 - 50, 300 - 40)
        cancel:SetText("")
        cancel.Paint = function(self, w, h)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText("CANCEL", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
        end

        cancel.DoClick = function() COLOR_PANEL_SETTINGS:Remove() end
    end

    local function create_color_panel(color)
        if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
        COLOR_PANEL_SETTINGS = vgui.Create("DPanel", INTRO_PANEL)
        COLOR_PANEL_SETTINGS:SetSize(300, 300)
        COLOR_PANEL_SETTINGS:Center()
        COLOR_PANEL_SETTINGS:SetAlpha(0)
        COLOR_PANEL_SETTINGS:AlphaTo(255, 1)
        local convar = GetConVar("breach_config_name_color")
        local col = vgui.Create("DColorCombo", COLOR_PANEL_SETTINGS)
        col:SetSize(300, 250)
        col:SetColor(color)
        COLOR_PANEL_SETTINGS.Paint = function(self, w, h)
            local mycol = col:GetColor()
            draw.RoundedBox(0, 5, h - 45, 40, 40, mycol)
            draw.DrawText("RGB: " .. mycol.r .. "," .. mycol.g .. "," .. mycol.b, "BudgetLabel", w, 3, mycol, TEXT_ALIGN_RIGHT)
        end

        local apply = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
        apply:SetSize(80, 30)
        apply:SetPos(90, 300 - 40)
        apply:SetText("")
        apply.Paint = function(self, w, h)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText("APPLY", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
        end

        apply.DoClick = function()
            local col = col:GetColor()
            convar:SetString(tostring(col.r) .. "," .. tostring(col.g) .. "," .. tostring(col.b))
            COLOR_PANEL_SETTINGS:Remove()
        end

        local cancel = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
        cancel:SetSize(80, 30)
        cancel:SetPos(90 + 90, 300 - 40)
        cancel:SetText("")
        cancel.Paint = function(self, w, h)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText("CANCEL", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
        end

        cancel.DoClick = function() COLOR_PANEL_SETTINGS:Remove() end
    end

    for _, category in pairs(BREACH.Options) do
        if category.premium and not LocalPlayer():IsPremium() then continue end
        if category.prefix and not LocalPlayer():GetNWBool("have_prefix") then continue end
        local category_panel = vgui.Create("DPanel", settings_frame)
        local clr_gray = Color(0, 0, 0, 100)
        local clr_text = color_white
        if category.premium then
            clr_text = Color(255, 215, 0)
            clr_gray = Color(255, 215, 0, 5)
        end

        category_panel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, clr_gray)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText(L(category.name), "ScoreboardContent", w / 2, 5, clr_text, TEXT_ALIGN_CENTER)
        end

        category_panel:Dock(TOP)
        category_panel:SetSize(0, 25)
        for _, data in pairs(category.settings) do
            if data.premium and not LocalPlayer():IsPremium() then continue end
            if data.checkplayer and not data.checkplayer[LocalPlayer():SteamID64()] and not LocalPlayer():IsSuperAdmin() then continue end
            local convar = GetConVar(data.cvar)
            if data.type == "unique" then
                data.createpanel(settings_frame)
            elseif data.type == "bind" then
                local panel = vgui.Create("DPanel", settings_frame)
                local swap = vgui.Create("DBinder", panel)
                panel:Dock(TOP)
                panel:SetSize(0, 40)
                panel.Paint = function(self, w, h)
                    draw.DrawText(L(data.name), "ScoreboardContent", 140, 5)
                    if swap.editmode then draw.DrawText(BREACH.TranslateString"l:menu_cancel", "ScoreboardContent", 140, 20) end
                end

                swap:SetSize(120, 30)
                swap:SetPos(10, 5)
                swap:SetText("")
                swap.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    surface.SetDrawColor(color_white)
                    surface.SetMaterial(grad2)
                    surface.DrawTexturedRect(1, 0, 1, h / 2)
                    surface.SetMaterial(grad1)
                    surface.DrawTexturedRect(1, h / 2, 1, h / 2)
                    surface.SetDrawColor(color_white)
                    surface.SetMaterial(grad2)
                    surface.DrawTexturedRect(w - 1, 0, 1, h / 2)
                    surface.SetMaterial(grad1)
                    surface.DrawTexturedRect(w - 1, h / 2, 1, h / 2)
                    if self.editmode then
                        draw.DrawText(BREACH.TranslateString"l:menu_press_any_key", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                    elseif self:IsHovered() then
                        draw.DrawText(BREACH.TranslateString"l:menu_swap", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                    else
                        draw.DrawText(input.GetKeyName(convar:GetInt()):upper(), "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                    end
                end

                swap.DoClick = function()
                    swap.editmode = true
                    input.StartKeyTrapping()
                    swap.Trapping = true
                end

                swap.OnChange = function(self, new)
                    swap.editmode = false
                    swap:SetText("")
                    if new ~= KEY_END and isstring(input.GetKeyName(new)) then convar:SetInt(new) end
                end
            elseif data.type == "slider" then
                local panel = vgui.Create("DPanel", settings_frame)
                panel.Paint = function(self, w, h)
                    draw.DrawText(L(data.name), "ScoreboardContent", 115, 8)
                    draw.DrawText(tostring(math.floor(convar:GetInt())), "ScoreboardContent", 57, 12, nil, TEXT_ALIGN_CENTER)
                end

                panel:Dock(TOP)
                panel:SetSize(0, 40)
                local left = vgui.Create("DButton", panel)
                left:SetSize(30, 30)
                left:SetPos(10, 5)
                left:SetText("")
                left.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    draw.DrawText("<-", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end

                left.OnMousePressed = function(self) self.pressed = true end
                local speed2 = 1
                local holdtime2 = 0
                left.Think = function(self)
                    self.cd = self.cd or 0
                    if self.cd <= SysTime() then
                        if self.pressed and input.IsMouseDown(MOUSE_LEFT) then
                            holdtime2 = holdtime2 + FrameTime() * 12
                            if holdtime2 >= 1 then speed2 = speed2 + FrameTime() * 15 end
                            convar:SetInt(math.max(convar:GetInt() - 1 * speed2, data.min))
                            self.cd = SysTime() + 0.075
                        else
                            holdtime2 = 0
                            speed2 = 1
                            self.pressed = false
                        end
                    end
                end

                local right = vgui.Create("DButton", panel)
                right:SetSize(30, 30)
                right:SetPos(75, 5)
                right:SetText("")
                right.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    draw.DrawText("->", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end

                right.OnMousePressed = function(self) self.pressed = true end
                local speed = 1
                local holdtime = 0
                right.Think = function(self)
                    self.cd = self.cd or 0
                    if self.cd <= SysTime() then
                        if self.pressed and input.IsMouseDown(MOUSE_LEFT) then
                            holdtime = holdtime + FrameTime() * 12
                            if holdtime >= 1 then speed = speed + FrameTime() * 15 end
                            convar:SetInt(math.max(convar:GetInt() + 1 * speed, data.min))
                            self.cd = SysTime() + 0.075
                        else
                            holdtime = 0
                            speed = 1
                            self.pressed = false
                        end
                    end
                end
            elseif data.type == "choice" then
                local panel = vgui.Create("DPanel", settings_frame)
                panel:Dock(TOP)
                panel:SetSize(0, 40)
                panel.Paint = function(self, w, h)
                    draw.DrawText(L(data.name), "ScoreboardContent", 100, 5)
                    local translation = translate_translations[convar:GetString()] or "unknown"
                    draw.DrawText(BREACH.TranslateString"l:menu_current_lang " .. translation, "ScoreboardContent", 100, 20)
                end

                local swap = vgui.Create("DButton", panel)
                swap:SetSize(80, 30)
                swap:SetPos(10, 5)
                swap:SetText("")
                swap.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    draw.DrawText(BREACH.TranslateString"l:menu_swap", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end

                swap.DoClick = function() choicepanel(data.value, data.cvar) end
            elseif data.type == "prefix" then
                local panel = vgui.Create("DPanel", settings_frame)
                panel:Dock(TOP)
                panel:SetSize(0, 40)
                panel.Paint = function(self, w, h) end
                local text_panel = vgui.Create("DPanel", panel)
                text_panel:SetSize(200, 20)
                text_panel:SetPos(100, 7)
                text_panel.Paint = function() end
                local prefix = vgui.Create("DLabel", text_panel)
                prefix:SetText("[" .. LocalPlayer():GetNWString("prefix_title", "") .. "]")
                prefix:SetFont("ChatFont_new")
                prefix:SizeToContents()
                prefix:Dock(LEFT)
                prefix.m_iHue = 0
                prefix.m_iRate = 72
                text_panel.prefix = prefix
                pub_text_panel = text_panel
                local name = vgui.Create("DLabel", text_panel)
                name:SetText(" " .. LocalPlayer():Name())
                name:SetFont("ChatFont_new")
                name:SetColor(color_white)
                name:SizeToContents()
                name:Dock(LEFT)
                text_panel.name = name
                panel.Think = function(self)
                    local data = util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA"))
                    local coltab = string.Explode(",", data.color)
                    local color = Color(tonumber(coltab[1]), tonumber(coltab[2]), tonumber(coltab[3]))
                    if not data.rainbow then
                        prefix:SetTextColor(color)
                    else
                        prefix.m_iHue = (prefix.m_iHue + FrameTime() * math.min(720, prefix.m_iRate)) % 360
                        prefix:SetTextColor(HSVToColor(prefix.m_iHue, 1, 1))
                    end

                    prefix:SetText("[" .. data.prefix .. "]")
                end

                local edit = vgui.Create("DButton", panel)
                edit:SetSize(80, 30)
                edit:SetPos(10, 5)
                edit:SetText("")
                edit.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    draw.DrawText("EDIT", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end

                edit.DoClick = function() create_prefix_panel(util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA"))) end
            elseif data.type == "color" then
                local panel = vgui.Create("DPanel", settings_frame)
                panel:Dock(TOP)
                panel:SetSize(0, 40)
                panel.Paint = function(self, w, h)
                    draw.DrawText(L(data.name), "ScoreboardContent", 100, 5)
                    local currentcolor = convar:GetString()
                    local tab = string.Split(currentcolor, ",")
                    local color = Color(tonumber(tab[1]), tonumber(tab[2]), tonumber(tab[3]))
                    self.curcolor = color
                    draw.RoundedBox(0, 225, 5, 30, 30, color)
                end

                local edit = vgui.Create("DButton", panel)
                edit:SetSize(80, 30)
                edit:SetPos(10, 5)
                edit:SetText("")
                edit.Paint = function(self, w, h)
                    drawmat(0, 0, w, 1, gradients)
                    drawmat(0, h - 1, w, 1, gradients)
                    draw.DrawText("EDIT", "ScoreboardContent", w / 2, 7, nil, TEXT_ALIGN_CENTER)
                end

                edit.DoClick = function() create_color_panel(panel.curcolor) end
            elseif data.type == "bool" then
                local panel = vgui.Create("DPanel", settings_frame)
                panel:Dock(TOP)
                panel:SetSize(0, 40)
                panel.Paint = function(self, w, h) draw.DrawText(L(data.name), "ScoreboardContent", 50, 5) end
                local but = vgui.Create("DButton", panel)
                but:SetSize(30, 30)
                but:SetPos(10, 5)
                but:SetText("")
                but.DoClick = function(self) convar:SetBool(not convar:GetBool()) end
                but.lerp = 0
                but.Paint = function(self, w, h)
                    surface.SetDrawColor(color_white)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    if convar:GetBool() then
                        but.lerp = math.Approach(but.lerp, 1, FrameTime() * 5)
                    else
                        but.lerp = math.Approach(but.lerp, 0, FrameTime() * 5)
                    end

                    draw.RoundedBox(0, 2, 2, w - 4, h - 4, ColorAlpha(color_white, but.lerp * 255))
                end
            end
        end
    end
end

function GM:PreRender()
    local ply = LocalPlayer()
    if IsValid(INTRO_PANEL) and not gui.IsGameUIVisible() then INTRO_PANEL:MakePopup() end
    if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
        if isnumber(ShowMainMenu) then
            gui.HideGameUI()
            if ShowMainMenu < CurTime() then ShowMainMenu = false end
            return
        end

        if not ShowMainMenu then
            gui.HideGameUI()
            if INTRO_PANEL and INTRO_PANEL:IsValid() then
                INTRO_PANEL.OpenTime = RealTime()
                INTRO_PANEL:SetVisible(true)
                ShowMainMenu = true
                mainmenumusic = CreateSound(ply, "nextoren/unity/menutheme.ogg")
                mainmenumusic:Play()
            else
                StartBreach(false) -- syka
                ShowMainMenu = true
                mainmenumusic = CreateSound(ply, "nextoren/unity/menutheme.ogg")
                mainmenumusic:Play()
            end
        end
    end
end