include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end

local line0 = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local line1 = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}
local line2 = {"a", "s", "d", "f", "g", "h", "j", "k", "l"}
local line3 = {"z", "x", "c", "v", "b", "n", "m"}
surface.CreateFont("294_text", {
    font = "Arial",
    extended = false,
    size = 20,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

net.Receive("create_294_menu", function(len)
    local client = LocalPlayer()
    if IsValid(BREACH.SCP294) then BREACH.SCP294:Remove() end
    BREACH.SCP294 = vgui.Create("DFrame")
    BREACH.SCP294:SetSize(ScrW(), ScrH())
    BREACH.SCP294:SetTitle("SCP-294 MENU")
    local curtext = ""
    BREACH.SCP294:SetAlpha(0)
    BREACH.SCP294:AlphaTo(255, 0.45)
    BREACH.SCP294.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, color_black) end
    BREACH.SCP294.OnRemove = function(self) gui.EnableScreenClicker(false) end
    local bg = vgui.Create("DPanel", BREACH.SCP294)
    bg:Dock(FILL)
    bg.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15, 255)) end
    local keyboard = vgui.Create("DPanel", bg)
    keyboard.Paint = function() end
    local y = 0
    local x = 15
    for i = 1, #line0 do
        local letter = line0[i]
        local let_gui = vgui.Create("DButton", keyboard)
        let_gui:SetPos(x, y)
        let_gui:SetSize(45, 45)
        x = x + 45
        let_gui:SetText("")
        let_gui:SetAlpha(0)
        local _l = 0
        let_gui.Hovered = false
        let_gui.OnCursorEntered = function(self) self.Hovered = true end
        let_gui.OnCursorExited = function(self) self.Hovered = false end
        timer.Simple(.1 * i, function() if IsValid(let_gui) then let_gui:AlphaTo(255, 0.6) end end)
        let_gui.DoClick = function(self) curtext = curtext .. letter end
        let_gui.Paint = function(self, w, h)
            local wh = 255 - (_l * 255)
            local col = Color(wh, wh, wh, 255)
            if not self.Hovered then
                _l = math.Approach(_l, 0, FrameTime() * 4)
            else
                _l = 1
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, _l * 255))
            surface.SetDrawColor(col)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            draw.DrawText(string.upper(letter), "294_text", w / 2, h / 2 - 11, col, TEXT_ALIGN_CENTER)
        end
    end

    x = 0
    y = y + 45
    for i = 1, #line1 + 1 do
        local letter = line1[i]
        if i == #line1 + 1 then letter = "DELETE" end
        local let_gui = vgui.Create("DButton", keyboard)
        let_gui:SetPos(x, y)
        if i == #line1 + 1 then
            let_gui:SetSize(100, 45)
            x = x + 100
        else
            let_gui:SetSize(45, 45)
            x = x + 45
        end

        let_gui:SetText("")
        let_gui:SetAlpha(0)
        local _l = 0
        let_gui.Hovered = false
        let_gui.OnCursorEntered = function(self) self.Hovered = true end
        let_gui.OnCursorExited = function(self) self.Hovered = false end
        timer.Simple(.1 * i, function() if IsValid(let_gui) then let_gui:AlphaTo(255, 0.6) end end)
        let_gui.DoClick = function(self)
            if letter == "DELETE" then
                curtext = string.sub(curtext, 0, #curtext - 1)
            else
                curtext = curtext .. letter
            end
        end

        let_gui.Paint = function(self, w, h)
            local wh = 255 - (_l * 255)
            local col = Color(wh, wh, wh, 255)
            if not self.Hovered then
                _l = math.Approach(_l, 0, FrameTime() * 4)
            else
                _l = 1
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, _l * 255))
            surface.SetDrawColor(col)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            draw.DrawText(string.upper(letter), "294_text", w / 2, h / 2 - 11, col, TEXT_ALIGN_CENTER)
        end
    end

    keyboard:SetSize(x, 180)
    keyboard:SetPos(ScrW() / 2 - (x / 2), ScrH() / 2 - 67)
    local text = vgui.Create("DPanel", bg)
    text:SetSize(x, 50)
    text:SetPos(ScrW() / 2 - (x / 2), ScrH() / 2 - 130)
    local _l = 0
    text.Paint = function(self, w, h)
        _l = math.Approach(_l, 1, FrameTime() / 2.4)
        draw.RoundedBox(0, 0, h - 2, _l * w, 2, color_white)
        draw.DrawText(curtext, "294_text", 0, h - 25, col, TEXT_ALIGN_LEFT)
    end

    x = 5
    y = y + 45
    for i = 1, #line2 + 1 do
        local letter = line2[i]
        if i == #line2 + 1 then letter = "SUBMIT" end
        local let_gui = vgui.Create("DButton", keyboard)
        let_gui:SetPos(x, y)
        if i == #line2 + 1 then
            let_gui:SetSize(76, 45)
            x = x + 76
        else
            let_gui:SetSize(45, 45)
            x = x + 45
        end

        let_gui:SetText("")
        let_gui:SetAlpha(0)
        local _l = 0
        let_gui.Hovered = false
        let_gui.OnCursorEntered = function(self) self.Hovered = true end
        let_gui.OnCursorExited = function(self) self.Hovered = false end
        let_gui.DoClick = function(self)
            if letter == "SUBMIT" then
                BREACH.SCP294.noclicker = true
                gui.EnableScreenClicker(false)
                BREACH.SCP294:AlphaTo(0, 1, 0, function() BREACH.SCP294:Remove() end)
                net.Start("send_drink")
                net.WriteString(curtext)
                net.WriteEntity(LocalPlayer():GetEyeTrace().Entity)
                net.SendToServer()
            else
                curtext = curtext .. letter
            end
        end

        timer.Simple(.1 * i, function() if IsValid(let_gui) then let_gui:AlphaTo(255, 0.6) end end)
        let_gui.Paint = function(self, w, h)
            local wh = 255 - (_l * 255)
            local col = Color(wh, wh, wh, 255)
            if not self.Hovered then
                _l = math.Approach(_l, 0, FrameTime() * 4)
            else
                _l = 1
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, _l * 255))
            surface.SetDrawColor(col)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            surface.SetDrawColor(color_white)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            draw.DrawText(string.upper(letter), "294_text", w / 2, h / 2 - 11, col, TEXT_ALIGN_CENTER)
        end
    end

    x = 25
    y = y + 45
    for i = 1, #line3 do
        local letter = line3[i]
        local let_gui = vgui.Create("DButton", keyboard)
        let_gui:SetSize(45, 45)
        let_gui:SetPos(x, y)
        let_gui:SetText("")
        let_gui:SetAlpha(0)
        local _l = 0
        let_gui.Hovered = false
        let_gui.OnCursorEntered = function(self) self.Hovered = true end
        let_gui.OnCursorExited = function(self) self.Hovered = false end
        let_gui.DoClick = function(self) curtext = curtext .. letter end
        timer.Simple(.1 * i, function() if IsValid(let_gui) then let_gui:AlphaTo(255, 0.6) end end)
        let_gui.Paint = function(self, w, h)
            local wh = 255 - (_l * 255)
            local col = Color(wh, wh, wh, 255)
            if not self.Hovered then
                _l = math.Approach(_l, 0, FrameTime() * 4)
            else
                _l = 1
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, _l * 255))
            surface.SetDrawColor(col)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            surface.SetDrawColor(color_white)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            draw.DrawText(string.upper(letter), "294_text", w / 2, h / 2 - 11, col, TEXT_ALIGN_CENTER)
        end

        x = x + 45
    end

    BREACH.SCP294.Think = function(self)
        if not self.noclicker then gui.EnableScreenClicker(true) end
        if not client:Alive() or client:Health() <= 0 or client:GTeam() == TEAM_SPEC then
            self:Remove()
            gui.EnableScreenClicker(false)
        end
    end
end)