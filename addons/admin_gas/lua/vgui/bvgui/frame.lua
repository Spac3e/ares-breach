--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/frame.lua

--]]

bVGUI.Frames = {}

local voice_enum
local voice_key
local function GetVoiceKeyEnum()
	voice_key = input.LookupBinding("+voicerecord", true)
	if (voice_key) then
		for i,v in pairs(_G) do
			if (i:sub(1,4) == "KEY_") then
				if (input.GetKeyName(v) == voice_key) then
					voice_enum = v
					break
				end
			end
		end
	end
end
GetVoiceKeyEnum()
timer.Create("bVGUI.voicerecord_bind", 10, 0, function()
	if (voice_key ~= input.LookupBinding("+voicerecord", true)) then
		GetVoiceKeyEnum()
	end
end)

local PANEL = {}

function PANEL:OnKeyCodePressed(key_code)
	if (GAS and GAS.LocalConfig and GAS.LocalConfig.AllowVoiceChat == false) then return end
	if (voice_enum and key_code == voice_enum) then
		RunConsoleCommand("+voicerecord")
	end
end
function PANEL:OnKeyCodeReleased(key_code)
	if (GAS and GAS.LocalConfig and GAS.LocalConfig.AllowVoiceChat == false) then return end
	if (voice_enum and key_code == voice_enum) then
		RunConsoleCommand("-voicerecord")
	end
end

function PANEL:Init()
	table.insert(bVGUI.Frames, self)

	local this = self

	self:DockPadding(0, 24, 0, 0)
	self.lblTitle:SetVisible(false)
	self.btnClose:SetVisible(false)
	self.btnMaxim:SetVisible(false)
	self.btnMinim:SetVisible(false)

	self.ColorCycling = {}
	self.ColorCycling.IntendedColor = table.Copy(bVGUI.COLOR_GMOD_BLUE)
	self.ColorCycling.CurrentColor = table.Copy(bVGUI.COLOR_GMOD_BLUE)

	self.bVGUI_Toolbar = vgui.Create("DPanel", self)
	self.bVGUI_Toolbar:SetTall(24)
	self.bVGUI_Toolbar:SetCursor("sizeall")
	function self.bVGUI_Toolbar:OnMousePressed()
		if (this.Fullscreened ~= false or this:GetDraggable() == false) then return end
		this.Dragging = { gui.MouseX() - this.x, gui.MouseY() - this.y }
	end
	function self.bVGUI_Toolbar:OnMouseReleased()
		this.Dragging = nil
	end
	function self.bVGUI_Toolbar:Paint(w,h)
		surface.SetDrawColor(this.ColorCycling.CurrentColor)
		surface.DrawRect(0,0,w,h)

		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
		surface.DrawTexturedRect(0,0,w,h)
	end
	function self.bVGUI_Toolbar:PaintOver(w,h)
		if (this.DrawBorder ~= false) then
			surface.SetDrawColor(bVGUI.COLOR_BLACK)
			surface.DrawLine(0,h - 1,w,h - 1)
		end
	end

	self.MenuOpen = false
	self.bVGUI_MenuButton = vgui.Create("bVGUI.ToolbarButton_IMGText", self.bVGUI_Toolbar)
	self.bVGUI_MenuButton:Dock(LEFT)
	self.bVGUI_MenuButton:SetMaterial(bVGUI.ICON_MENU)
	self.bVGUI_MenuButton:SetHoverMaterial(bVGUI.ICON_MENU_INVERTED)
	self.bVGUI_MenuButton:SetText(self:GetTitle())
	self.bVGUI_MenuButton.bVGUI_Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 14))
	function self.bVGUI_MenuButton:DoClick()
		if (GAS and GAS.PlaySound) then GAS:PlaySound("btn_light") end
		if (this.MenuClicked) then
			this:MenuClicked()
		elseif (not IsValid(this.DermaMenu) and this.DermaMenuOptions) then
			this.DermaMenu = DermaMenu()
			this:DermaMenuOptions(this.DermaMenu)
			this.DermaMenu:Open(self:LocalToScreen(0,self:GetTall() - 1))
			function this.DermaMenu:OptionSelected()
				this.DermaMenu = nil
			end
		elseif (IsValid(this.DermaMenu)) then
			this.DermaMenu:Hide()
			this.DermaMenu:Remove()
			this.DermaMenu = nil
		elseif (this.DermaMenu ~= nil) then
			this.DermaMenu = nil
		end
	end

	self.bVGUI_CloseButton = vgui.Create("bVGUI.ToolbarButton_IMG", self.bVGUI_Toolbar)
	self.bVGUI_CloseButton:SetSize(20,24)
	self.bVGUI_CloseButton:Dock(RIGHT)
	self.bVGUI_CloseButton:SetMaterial(bVGUI.ICON_CLOSE)
	self.bVGUI_CloseButton:SetHoverMaterial(bVGUI.ICON_CLOSE_INVERTED)
	function self.bVGUI_CloseButton:DoClick()
		if (GAS and GAS.PlaySound) then GAS:PlaySound("btn_heavy") end
		this:Close()
	end

	self.Fullscreened = false
	self.bVGUI_FullscreenButton = vgui.Create("bVGUI.ToolbarButton_IMG", self.bVGUI_Toolbar)
	self.bVGUI_FullscreenButton:SetSize(24,24)
	self.bVGUI_FullscreenButton:Dock(RIGHT)
	self.bVGUI_FullscreenButton:SetMaterial(bVGUI.ICON_FULLSCREEN)
	self.bVGUI_FullscreenButton:SetHoverMaterial(bVGUI.ICON_FULLSCREEN_INVERTED)

	function self.bVGUI_FullscreenButton:DoClick()
		if (this.Fullscreened == false) then
			if (GAS and GAS.PlaySound) then GAS:PlaySound("jump") end

			this.Fullscreened = {this:GetWide(), this:GetTall()}
			this.bVGUI_Toolbar:SetCursor("arrow")

			this:Stop()
			this:SizeTo(ScrW() - (self.OffsetX or 0), ScrH(), 0.5, 0, 0.5)
			this:MoveTo(self.OffsetX or 0, 0, 0.5, 0, 0.5)
		else
			if (GAS and GAS.PlaySound) then GAS:PlaySound("delete") end

			this:Stop()
			this:MoveTo((ScrW() / 2) - (this.Fullscreened[1] / 2), (ScrH() / 2) - (this.Fullscreened[2] / 2), 0.5, 0, 0.5)
			this:SizeTo(this.Fullscreened[1], this.Fullscreened[2], 0.5, 0, 0.5)

			this.Fullscreened = false
			this.bVGUI_Toolbar:SetCursor("sizeall")
		end
		timer.Simple(0.5, function()
			if (IsValid(this)) then
				this:InvalidateLayout(true)
				local function recursive(children)
					for _,child in ipairs(children) do
						if (child.RerenderMarkups) then
							child:RerenderMarkups()
						end
						recursive(child:GetChildren())
					end
				end
				recursive(this:GetChildren())
			end
		end)
	end

	self.Pinned = false
	self.bVGUI_PinButton = vgui.Create("bVGUI.ToolbarButton_IMG", self.bVGUI_Toolbar)
	self.bVGUI_PinButton:SetSize(24,24)
	self.bVGUI_PinButton:Dock(RIGHT)
	self.bVGUI_PinButton:SetMaterial(bVGUI.ICON_PIN)
	self.bVGUI_PinButton:SetHoverMaterial(bVGUI.ICON_PIN_INVERTED)

	function self.bVGUI_PinButton:DoClick()
		self:TogglePin()
		if (GAS and GAS.PlaySound) then
			if (this.Pinned) then
				GAS:PlaySound("drip_up")
			else
				GAS:PlaySound("drip_down")
			end
		end
	end
	function self.bVGUI_PinButton:TogglePin()
		this.Pinned = not this.Pinned
		if (this.Pinned) then
			this:KillFocus()
			this:SetMouseInputEnabled(false)
			this:SetKeyboardInputEnabled(false)
			this:SetAlpha(200)

			gui.HideGameUI()
			timer.Simple(0, function()

				this.pin_overlay = vgui.Create("DPanel")
				this.pin_overlay:SetCursor("hand")
				this.pin_overlay:SetMouseInputEnabled(true)
				function this.pin_overlay:Paint(w,h)
					if (not IsValid(this)) then
						self:Remove()
						return
					end
					self:SetSize(this:GetSize())
					self:SetPos(this:GetPos())
					if (gui.IsGameUIVisible()) then
						bVGUI_GlobalPinned = nil
						for _,v in ipairs(bVGUI.Frames) do
							if (v.Pinned and IsValid(v.bVGUI_PinButton) and v.bVGUI_PinButton:IsVisible()) then
								v.bVGUI_PinButton:TogglePin()
							end
						end
					end
				end
				function this.pin_overlay:OnMouseReleased(m)
					self:Remove()
					this.bVGUI_PinButton:DoClick()

					for _,v in ipairs(bVGUI.Frames) do
						if (v ~= this and v.Pinned and IsValid(v.bVGUI_PinButton) and v.bVGUI_PinButton:IsVisible()) then
							v.bVGUI_PinButton:TogglePin()
						end
					end
				end

			end)

			for _,v in ipairs(bVGUI.Frames) do
				if (v ~= this and not v.Pinned and IsValid(v.bVGUI_PinButton) and v.bVGUI_PinButton:IsVisible()) then
					v.bVGUI_PinButton:TogglePin()
				end
			end
		else
			if (IsValid(this.pin_overlay)) then
				this.pin_overlay:Remove()
			end
			this:MakePopup()
			this:SetAlpha(255)
		end
		
		gui.EnableScreenClicker(false)

		if (this.Pinned) then
			if (not bVGUI_GlobalPinned) then
				bVGUI_GlobalPinned = true
				notification.AddLegacy(bVGUI.L("pin_tip"), NOTIFY_UNDO, 3)
			end
		else
			bVGUI_GlobalPinned = nil
		end

		if (this.Pinned and this.OnPinned) then
			this:OnPinned()
		elseif (not this.Pinned and this.OnUnpinned) then
			this:OnUnpinned()
		end
	end

	function self:OnChildAdded(child)
		child.IsDefaultChild = false
	end
end

local drag_icon = Material("vgui/bvgui/drag.png", "smooth")
function PANEL:EnableUserResize()
	local this = self
	self.UserResize = vgui.Create("bVGUI.BlankPanel", self)
	self.UserResize:SetMouseInputEnabled(true)
	self.UserResize:SetCursor("sizenwse")
	self.UserResize:SetSize(18,18)
	self.UserResize:MoveToFront()
	function self.UserResize:OnMousePressed(m)
		self.Dragging = true
	end
	function self.UserResize:Think()
		if (self.Dragging == true) then
			if (input.IsMouseDown(MOUSE_LEFT)) then
				local x,y = gui.MousePos()
				if (not self.StartingCoords) then
					self.StartingCoords = {x,y}
				end
				if (not self.StartingSize) then
					self.StartingSize = {this:GetSize()}
				end
				local new_x, new_y = self.StartingSize[1] + (x - self.StartingCoords[1]), self.StartingSize[2] + (y - self.StartingCoords[2])
				this:SetSize(math.max(new_x, this:GetMinWidth()), math.max(new_y, this:GetMinHeight()))
				this:InvalidateChildren(true)
			else
				self.StartingCoords = nil
				self.StartingSize = nil
				self.Dragging = false

				local function recursive(children)
					for _,child in ipairs(children) do
						if (child.RerenderMarkups) then
							child:RerenderMarkups()
						end
						recursive(child:GetChildren())
					end
				end
				recursive(this:GetChildren())
			end
		end
	end
	function self.UserResize:Paint(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(drag_icon)
		local width,height = 12,12
		surface.DrawTexturedRect(w / 2 - width / 2, h / 2 - height / 2, width, height)
	end
end

function PANEL:ShowCloseButton(showclosebutton)
	self.bVGUI_CloseButton:SetVisible(showclosebutton)
end

function PANEL:ShowFullscreenButton(showfullscreenbutton)
	self.bVGUI_FullscreenButton:SetVisible(showfullscreenbutton)
end

function PANEL:ShowPinButton(showpinbutton)
	self.bVGUI_PinButton:SetVisible(showpinbutton)
end

function PANEL:SetDraggable(draggable)
	self.m_bDraggable = draggable
	if (draggable) then
		self.bVGUI_Toolbar:SetCursor("sizeall")
	else
		self.bVGUI_Toolbar:SetCursor("default")
	end
end

function PANEL:PaintOver(w,h)
	if (self.DrawBorder ~= false) then
		surface.SetDrawColor(bVGUI.COLOR_BLACK)
		surface.DrawOutlinedRect(0,0,w,h)
	end
end

function PANEL:PerformLayout()
	self.bVGUI_Toolbar:SetWide(self:GetWide())
	for _,v in pairs(self:GetChildren()) do
		v:InvalidateLayout(true)
	end
	if (IsValid(self.UserResize)) then
		self.UserResize:AlignRight(0)
		self.UserResize:AlignBottom(0)
	end
	if (self.PostPerformLayout) then
		self:PostPerformLayout()
	end
end

function PANEL:SetTitle(title)
	self.lblTitle:SetText(title)
	self.bVGUI_MenuButton:SetText(title)
end

local frame_bg = Color(30,34,42,250)
local blur = Material("pp/blurscreen")
function PANEL:Paint(w,h)
	if (self.DrawBlur == true) then
		local x,y = self:LocalToScreen(0,0)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(blur)
		for i = -0.2, 2, 0.2 do
			blur:SetFloat("$blur", i * 1.0)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
		end

		surface.SetDrawColor(frame_bg)
		surface.DrawRect(0,0,w,h)
	else
		surface.SetDrawColor(30,34,42,253)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(255,255,255,210)
		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LARGE)
		surface.DrawTexturedRect(0,0,w,h)
	end

	local r = Lerp(0.01, self.ColorCycling.CurrentColor.r, self.ColorCycling.IntendedColor.r)
	local g = Lerp(0.01, self.ColorCycling.CurrentColor.g, self.ColorCycling.IntendedColor.g)
	local b = Lerp(0.01, self.ColorCycling.CurrentColor.b, self.ColorCycling.IntendedColor.b)
	if (self.ColorCycling.r_ceil) then r = bVGUI.CEIL(r) else r = bVGUI.FLOOR(r) end
	if (self.ColorCycling.g_ceil) then g = bVGUI.CEIL(g) else g = bVGUI.FLOOR(g) end
	if (self.ColorCycling.b_ceil) then b = bVGUI.CEIL(b) else b = bVGUI.FLOOR(b) end
	self.ColorCycling.CurrentColor.r = r
	self.ColorCycling.CurrentColor.g = g
	self.ColorCycling.CurrentColor.b = b
end
function PANEL:CycleColors(col)
	self.ColorCycling.r_ceil = col.r > self.ColorCycling.IntendedColor.r
	self.ColorCycling.g_ceil = col.g > self.ColorCycling.IntendedColor.g
	self.ColorCycling.b_ceil = col.b > self.ColorCycling.IntendedColor.b
	self.ColorCycling.IntendedColor = table.Copy(col)
end

derma.DefineControl("bVGUI.Frame", nil, PANEL, "DFrame")