include( "shared.lua" )

function ENT:Draw()
    self:DrawModel()
end

net.Receive("CreatePage", function()
    local index = net.ReadInt(3)
    local client = LocalPlayer()
    if client.SCP_1025_MainWindow then client.SCP_1025_MainWindow:Remove() end
    surface.PlaySound("nextoren/others/turn_page.wav")
    gui.EnableScreenClicker(true)
    client.SCP_1025_MainWindow = vgui.Create("DPanel")
    client.SCP_1025_MainWindow:SetSize(ScrW(), ScrH())
    client.SCP_1025_MainWindow:SetText("")
    client.SCP_1025_MainWindow.Paint = function(self)
        if input.IsKeyDown(KEY_BACKSPACE) then
            self:Remove()
            surface.PlaySound("nextoren/others/turn_page.wav")
            gui.EnableScreenClicker(false)
        end

        DrawBlurPanel(self)
        draw.SimpleText("BACKSPACE to close", "HUDFont", ScrW() / 2, ScrH() * .9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    client.SCP_1025_MainWindow_DiseaseImage = vgui.Create("DImage", client.SCP_1025_MainWindow)
    client.SCP_1025_MainWindow_DiseaseImage:SetSize(450, 634)
    client.SCP_1025_MainWindow_DiseaseImage:SetImage("nextoren/gui/scp_1025/1025_" .. index .. ".png")
    client.SCP_1025_MainWindow_DiseaseImage:SetPos(ScrW() / 2 - (450 / 2), ScrH() / 2 - (634 / 2))
end)