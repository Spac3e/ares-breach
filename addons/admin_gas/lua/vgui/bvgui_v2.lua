--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui_v2.lua

--]]

bVGUI = {}

bVGUI.WORKSHOP_ID = "1261820532"

bVGUI.FONT_RUBIK     = 1
bVGUI.FONT_CONSOLAS  = 2
bVGUI.FONT_CIRCULAR  = 3
local fonts = {
	[bVGUI.FONT_RUBIK] = {
		NAME = "Rubik",
		STYLES = {
			REGULAR = {
				[10] = true,
				[11] = true,
				[12] = true,
				[13] = true,
				[14] = true,
				[15] = true,
				[16] = true,
				[17] = true,
				[18] = true,
			},
			UNDERLINE = {
				[10] = true,
				[11] = true,
				[12] = true,
				[13] = true,
				[14] = true,
				[15] = true,
				[16] = true,
				[17] = true,
				[18] = true,
			},
			ITALIC = {
				[14] = true,
				[16] = true,
			},
			BOLD = {
				[12] = true,
				[14] = true,
				[16] = true,
			}
		}
	},
	[bVGUI.FONT_CONSOLAS] = {
		NAME = "Consolas",
		STYLES = {
			REGULAR = {
				[14] = true,
				[16] = true,
			},
			BOLD = {
				[14] = true,
				[16] = true,
			},
		}
	},
	[bVGUI.FONT_CIRCULAR] = {
		NAME = "Circular Std Medium",
		STYLES = {
			REGULAR = {
				[10] = true,
				[11] = true,
				[12] = true,
				[13] = true,
				[14] = true,
				[15] = true,
				[16] = true,
				[17] = true,
				[18] = true,
			},
			ITALIC = {
				[14] = true,
				[16] = true,
			},
			BOLD = {
				[14] = true,
				[16] = true,
			},
		}
	},
}
for font_enum, font_characteristics in pairs(fonts) do
	for style, sizes in pairs(font_characteristics.STYLES) do
		for size in pairs(sizes) do
			local font_name = "bVGUI." .. font_characteristics.NAME .. size .. "_" .. style
			local font_data = {}
			font_data.size = size
			font_data.font = font_characteristics.NAME
			if (style == "ITALIC") then
				font_data.italic = true
			end
			if (style == "BOLD") then
				font_data.weight = 700
			end
			if (style == "UNDERLINE") then
				font_data.underline = true
			end

			surface.CreateFont(font_name, font_data)
			fonts[font_enum].STYLES[style][size] = font_name
		end
	end
end
bVGUI.FONT = function(font_enum, style, size)
	return fonts[font_enum].STYLES[style][size]
end

bVGUI.COLOR_WHITE       = Color(255,255,255) -- White
bVGUI.COLOR_BLACK       = Color(0,0,0)       -- Black
bVGUI.COLOR_LIGHT_GREY  = Color(236,236,236) -- Light grey
bVGUI.COLOR_DARK_GREY   = Color(26,26,26)    -- Dark grey
bVGUI.COLOR_DARKER_GREY = Color(19,19,19)    -- Darker grey
bVGUI.COLOR_SLATE       = Color(30,30,30)    -- Slate
bVGUI.COLOR_RED         = Color(255,0,0)     -- Red
bVGUI.COLOR_GMOD_BLUE   = Color(0,152,234)   -- GMod Blue
bVGUI.COLOR_PURPLE      = Color(144,0,255)   -- Purple

bVGUI.CEIL = function(n)
	if (n % 1 > .5) then
		return math.ceil(n)
	else
		return n
	end
end
bVGUI.FLOOR = function(n)
	if (n % 1 < .5) then
		return math.floor(n)
	else
		return n
	end
end
bVGUI.LerpColor = function(from, to, time)
	local interpolation_data = {
		current_color = table.Copy(from),
		from = from,
		to = to,

		ceil_r = to.r > from.r,
		ceil_g = to.g > from.g,
		ceil_b = to.b > from.b,

		curtime = SysTime()
	}
	function interpolation_data:DoLerp()
		if (
			self.current_color.r == self.to.r and
			self.current_color.g == self.to.g and
			self.current_color.b == self.to.b
		) then
			return
		end
		local time_fraction = math.TimeFraction(self.curtime, self.curtime + time, SysTime())
		self.current_color.r = Lerp(time_fraction, self.current_color.r, self.to.r)
		self.current_color.g = Lerp(time_fraction, self.current_color.g, self.to.g)
		self.current_color.b = Lerp(time_fraction, self.current_color.b, self.to.b)
		if (self.ceil_r) then
			self.current_color.r = bVGUI.CEIL(self.current_color.r)
		else
			self.current_color.r = bVGUI.FLOOR(self.current_color.r)
		end
		if (self.ceil_g) then
			self.current_color.g = bVGUI.CEIL(self.current_color.g)
		else
			self.current_color.g = bVGUI.FLOOR(self.current_color.g)
		end
		if (self.ceil_b) then
			self.current_color.b = bVGUI.CEIL(self.current_color.b)
		else
			self.current_color.b = bVGUI.FLOOR(self.current_color.b)
		end
	end
	function interpolation_data:GetColor()
		return self.current_color
	end
	function interpolation_data:SetColor(col)
		self.current_color = table.Copy(col)
		self.from = table.Copy(col)
		self.to = table.Copy(col)
		self.curtime = SysTime()
	end
	function interpolation_data:SetTo(to)
		self.to = table.Copy(to)
		self.ceil_r = self.to.r > self.from.r
		self.ceil_g = self.to.g > self.from.g
		self.ceil_b = self.to.b > self.from.b
		self.curtime = SysTime()
	end
	return interpolation_data
end
bVGUI.Lerp = function(from, to, time)
	local interpolation_data = {
		current_val = from,
		from = from,
		to = to,

		ceil = to > from,

		curtime = SysTime(),
	}
	function interpolation_data:DoLerp()
		if (self.current_val == self.to) then return end
		local time_fraction = math.TimeFraction(self.curtime, self.curtime + time, SysTime())
		self.current_val = Lerp(time_fraction, self.current_val, self.to)
		if (self.ceil) then
			self.current_val = bVGUI.CEIL(self.current_val)
		else
			self.current_val = bVGUI.FLOOR(self.current_val)
		end
	end
	function interpolation_data:GetValue()
		return self.current_val
	end
	function interpolation_data:SetValue(val)
		self.current_val = val
		self.to = val
		self.from = val
		self.curtime = SysTime()
	end
	function interpolation_data:SetTo(to)
		self.to = to
		self.ceil = self.to > self.from
		self.curtime = SysTime()
	end
	return interpolation_data
end
bVGUI.DarkenColor = function(color, fraction)
	return Color(math.min(color.r - color.r * fraction, 255), math.min(color.g - color.g * fraction, 255), math.min(color.b - color.b * fraction, 255), color.a)
end
bVGUI.LightenColor = function(color, fraction)
	return Color(math.min(color.r + color.r * fraction, 255), math.min(color.g + color.g * fraction, 255), math.min(color.b + color.b * fraction, 255), color.a)
end
bVGUI.ColorShouldUseBlackText = function(color)
	return (color.r * 0.299 + color.g * 0.587 + color.b * 0.114) > 186
end
bVGUI.TextColorContrast = function(bg_color)
	if (bVGUI.ColorShouldUseBlackText(bg_color)) then
		return bVGUI.COLOR_BLACK
	else
		return bVGUI.COLOR_WHITE
	end
end

bVGUI.ICON_CLOSE               = Material("materials/vgui/bvgui/icon_close.png")
bVGUI.ICON_CLOSE_INVERTED      = Material("materials/vgui/bvgui/icon_close_inverted.png")
bVGUI.ICON_FULLSCREEN          = Material("materials/vgui/bvgui/icon_fullscreen.png")
bVGUI.ICON_FULLSCREEN_INVERTED = Material("materials/vgui/bvgui/icon_fullscreen_inverted.png")
bVGUI.ICON_MENU                = Material("materials/vgui/bvgui/icon_menu.png")
bVGUI.ICON_MENU_INVERTED       = Material("materials/vgui/bvgui/icon_menu_inverted.png")
bVGUI.ICON_PIN                 = Material("materials/vgui/bvgui/icon_pin.png")
bVGUI.ICON_PIN_INVERTED        = Material("materials/vgui/bvgui/icon_pin_inverted.png")
bVGUI.MATERIAL_LOADING_ICON    = Material("materials/vgui/bvgui/loading.png", "smooth")

bVGUI.MATERIAL_GRADIENT             = Material("materials/vgui/bvgui/darken_gradient.png", "smooth")
bVGUI.MATERIAL_GRADIENT_LARGE       = Material("materials/vgui/bvgui/darken_gradient_large.png", "smooth")
bVGUI.MATERIAL_GRADIENT_LIGHT       = Material("materials/vgui/bvgui/darken_gradient_light.png", "smooth")
bVGUI.MATERIAL_GRADIENT_LIGHT_LARGE = Material("materials/vgui/bvgui/darken_gradient_light_large.png", "smooth")
bVGUI.MATERIAL_SHADOW               = Material("materials/vgui/bvgui/shadow.png", "smooth")
bVGUI.MATERIAL_SHADOW_FLIP          = Material("materials/vgui/bvgui/shadow_flip.png", "smooth")

bVGUI.DEBUG_PAINTOVER = function(self,w,h)
	surface.SetDrawColor(255,0,0,50)
	surface.DrawRect(0,0,w,h)
end

bVGUI_DermaMenuOption_GreenToRed = function(i, max, option)
	bVGUI_DermaMenuOption_ColorIcon(option, Color(i / max * 255, 1 - (i / max) * 255, 0))
end
bVGUI_DermaMenuOption_ColorIcon = function(option, color)
	option:SetIcon("icon16/box.png")
	function option.m_Image:Paint(w,h)
		surface.SetDrawColor(color)
		surface.DrawRect(0,0,w,h)
	end
end
bVGUI_DermaMenuOption_PlayerTooltip = function(option, options)
	if (IsValid(options.ply)) then
		bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(options.ply:GTeam()))
	elseif (options.account_id) then
		local ply = player.GetByAccountID(options.account_id)
		if (IsValid(ply)) then
			bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply:GTeam()))
		else
			option:SetIcon("icon16/server_delete.png")
		end
	elseif (options.steamid64) then
		local ply = player.GetBySteamID64(options.steamid64)
		if (IsValid(ply)) then
			bVGUI_DermaMenuOption_ColorIcon(option, gteams.GetColor(ply:GTeam()))
		else
			option:SetIcon("icon16/server_delete.png")
		end
	end
	bVGUI.PlayerTooltip.Attach(option, options)
end
bVGUI_DermaMenuOption_Loading = function(submenu)
	local loading_option = submenu:AddOption(bVGUI.L("loading_ellipsis"))
	loading_option:SetIcon("icon16/transmit_blue.png")
	function loading_option:OnMouseReleased(m)
		DButton.OnMouseReleased(self, m)
		if (m ~= MOUSE_LEFT or not self.m_MenuClicking) then return end
		self.m_MenuClicking = false
	end
	return loading_option
end

bVGUI_Message = function(title, text, btn_text)
	if (IsValid(bVGUI.ACTIVE_POPUP)) then
		bVGUI.ACTIVE_POPUP:Close()
	end

	bVGUI.ACTIVE_POPUP = vgui.Create("bVGUI.Frame")
	bVGUI.ACTIVE_POPUP:ShowFullscreenButton(false)
	bVGUI.ACTIVE_POPUP:SetTitle(title)
	bVGUI.ACTIVE_POPUP:SetSize(400,150)
	bVGUI.ACTIVE_POPUP:Center()
	bVGUI.ACTIVE_POPUP:MakePopup()

	bVGUI.ACTIVE_POPUP.Text = vgui.Create("DLabel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	bVGUI.ACTIVE_POPUP.Text:SetTextColor(bVGUI_COLOR_WHITE)
	bVGUI.ACTIVE_POPUP.Text:Dock(FILL)
	bVGUI.ACTIVE_POPUP.Text:DockMargin(10,10,10,10)
	bVGUI.ACTIVE_POPUP.Text:SetContentAlignment(5)
	bVGUI.ACTIVE_POPUP.Text:SetText(text)

	bVGUI.ACTIVE_POPUP.ButtonContainer = vgui.Create("bVGUI.BlankPanel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.ButtonContainer:Dock(BOTTOM)

	bVGUI.ACTIVE_POPUP.ButtonContainer.Button = vgui.Create("bVGUI.Button", bVGUI.ACTIVE_POPUP.ButtonContainer)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:Dock(FILL)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetText(btn_text or bVGUI.L("done"))
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetSound("btn_heavy")
	function bVGUI.ACTIVE_POPUP.ButtonContainer.Button:DoClick()
		if (callback) then
			callback(bVGUI.ACTIVE_POPUP.TextEntry:GetValue())
		end
		bVGUI.ACTIVE_POPUP:Close()
	end
end

bVGUI.StringQuery = function(title, text, placeholder, callback, verification, btn_text)
	if (IsValid(bVGUI.ACTIVE_POPUP)) then
		bVGUI.ACTIVE_POPUP:Close()
	end

	bVGUI.ACTIVE_POPUP = vgui.Create("bVGUI.Frame")
	bVGUI.ACTIVE_POPUP:ShowFullscreenButton(false)
	bVGUI.ACTIVE_POPUP:SetTitle(title)
	bVGUI.ACTIVE_POPUP:MakePopup()
	bVGUI.ACTIVE_POPUP:SetWide(300)

	if (text) then
		bVGUI.ACTIVE_POPUP.Text = vgui.Create("DLabel", bVGUI.ACTIVE_POPUP)
		bVGUI.ACTIVE_POPUP.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
		bVGUI.ACTIVE_POPUP.Text:SetTextColor(bVGUI_COLOR_WHITE)
		bVGUI.ACTIVE_POPUP.Text:Dock(TOP)
		bVGUI.ACTIVE_POPUP.Text:DockMargin(10,10,10,0)
		bVGUI.ACTIVE_POPUP.Text:SetContentAlignment(8)
		bVGUI.ACTIVE_POPUP.Text:SetText(text)
		bVGUI.ACTIVE_POPUP.Text:SetTall(0)
		bVGUI.ACTIVE_POPUP.Text:SetWrap(true)
		bVGUI.ACTIVE_POPUP.Text:SetAutoStretchVertical(true)
	else
		bVGUI.ACTIVE_POPUP:SetTall(95)
		bVGUI.ACTIVE_POPUP:Center()
	end

	bVGUI.ACTIVE_POPUP.ButtonContainer = vgui.Create("bVGUI.BlankPanel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.ButtonContainer:Dock(BOTTOM)

	bVGUI.ACTIVE_POPUP.ButtonContainer.Button = vgui.Create("bVGUI.Button", bVGUI.ACTIVE_POPUP.ButtonContainer)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:Dock(FILL)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetText(btn_text or bVGUI.L("done"))
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetDisabled(true)
	bVGUI.ACTIVE_POPUP.ButtonContainer.Button:SetSound("btn_heavy")
	function bVGUI.ACTIVE_POPUP.ButtonContainer.Button:DoClick()
		local val = bVGUI.ACTIVE_POPUP.TextEntry:GetValue()
		bVGUI.ACTIVE_POPUP:Close()
		if (callback) then
			callback(val)
		end
	end

	bVGUI.ACTIVE_POPUP.TextEntry = vgui.Create("bVGUI.TextEntry", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.TextEntry:Dock(TOP)
	bVGUI.ACTIVE_POPUP.TextEntry:SetTall(25)
	bVGUI.ACTIVE_POPUP.TextEntry:SetPlaceholderText(placeholder or bVGUI.L("enter_text_ellipsis"))
	bVGUI.ACTIVE_POPUP.TextEntry:DockMargin(10,10,10,10)
	bVGUI.ACTIVE_POPUP.TextEntry:SetUpdateOnType(true)
	bVGUI.ACTIVE_POPUP.TextEntry:RequestFocus()
	function bVGUI.ACTIVE_POPUP.TextEntry:OnValueChange(text)
		if (verification) then
			self:GetParent().ButtonContainer.Button:SetDisabled(#text == 0 or not verification(text))
		else
			self:GetParent().ButtonContainer.Button:SetDisabled(#text == 0)
		end
	end
	function bVGUI.ACTIVE_POPUP.TextEntry:OnEnter(text)
		bVGUI.ACTIVE_POPUP.ButtonContainer.Button:DoClick()
	end

	if (text) then
		bVGUI.ACTIVE_POPUP:SetTall(bVGUI.ACTIVE_POPUP.Text:GetTall() + bVGUI.ACTIVE_POPUP.ButtonContainer.Button:GetTall() + bVGUI.ACTIVE_POPUP.TextEntry:GetTall() + 60)
		bVGUI.ACTIVE_POPUP:Center()
		function bVGUI.ACTIVE_POPUP.Text:PerformLayout()
			if (bVGUI.ACTIVE_POPUP.Text:GetTall() > 0 and bVGUI.ACTIVE_POPUP.Text:GetTall() ~= self.StoreY) then
				self.StoreY = bVGUI.ACTIVE_POPUP.Text:GetTall()
				bVGUI.ACTIVE_POPUP:SetTall(bVGUI.ACTIVE_POPUP.Text:GetTall() + bVGUI.ACTIVE_POPUP.ButtonContainer.Button:GetTall() + bVGUI.ACTIVE_POPUP.TextEntry:GetTall() + 60)
				bVGUI.ACTIVE_POPUP:Center()
			end
		end
	end

	return bVGUI.ACTIVE_POPUP
end

bVGUI.Query = function(...)
	local vararg = {...}
	local text, title = vararg[1], vararg[2]

	if (IsValid(bVGUI.ACTIVE_POPUP)) then
		bVGUI.ACTIVE_POPUP:Close()
	end

	bVGUI.ACTIVE_POPUP = vgui.Create("bVGUI.Frame")
	bVGUI.ACTIVE_POPUP:ShowFullscreenButton(false)
	bVGUI.ACTIVE_POPUP:SetTitle(title)
	bVGUI.ACTIVE_POPUP:MakePopup()
	bVGUI.ACTIVE_POPUP:SetWide(300)

	bVGUI.ACTIVE_POPUP.Text = vgui.Create("DLabel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	bVGUI.ACTIVE_POPUP.Text:SetTextColor(bVGUI_COLOR_WHITE)
	bVGUI.ACTIVE_POPUP.Text:Dock(TOP)
	bVGUI.ACTIVE_POPUP.Text:DockMargin(10,10,10,0)
	bVGUI.ACTIVE_POPUP.Text:SetContentAlignment(8)
	bVGUI.ACTIVE_POPUP.Text:SetText(text)
	bVGUI.ACTIVE_POPUP.Text:SetTall(0)
	bVGUI.ACTIVE_POPUP.Text:SetWrap(true)
	bVGUI.ACTIVE_POPUP.Text:SetAutoStretchVertical(true)

	bVGUI.ACTIVE_POPUP.ButtonContainer = vgui.Create("bVGUI.BlankPanel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.ButtonContainer:Dock(BOTTOM)
	bVGUI.ACTIVE_POPUP.ButtonContainer:DockMargin(0,0,0,15)
	bVGUI.ACTIVE_POPUP.ButtonContainer:SetTall(25)

	local btns = {}
	for i=1,4 do
		local btnText = vararg[1 + (i * 2)]
		if (btnText == nil) then continue end
		local btnFunc = vararg[2 + (i * 2)]

		local btn = vgui.Create("bVGUI.Button", bVGUI.ACTIVE_POPUP.ButtonContainer)
		table.insert(btns, btn)
		btn:SetSize(90,25)
		if (i == 1) then
			btn:SetColor(bVGUI.BUTTON_COLOR_GREEN)
		elseif (i == 2) then
			btn:SetColor(bVGUI.BUTTON_COLOR_RED)
		elseif (i == 3) then
			btn:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
		elseif (i == 4) then
			btn:SetColor(bVGUI.BUTTON_COLOR_PURPLE)
		end
		btn:SetText(btnText)
		function btn:DoClick()
			bVGUI.ACTIVE_POPUP:Close()
			if (btnFunc) then btnFunc() end
		end
	end

	function bVGUI.ACTIVE_POPUP.ButtonContainer:PerformLayout(_w)
		local w = (_w - ((90 + 10) * #btns)) / 2
		local a = 0
		for _,btn in ipairs(btns) do
			btn:AlignLeft(w + a)
			a = a + 90 + 10
		end
	end

	bVGUI.ACTIVE_POPUP:SetTall(bVGUI.ACTIVE_POPUP.Text:GetTall() + bVGUI.ACTIVE_POPUP.ButtonContainer:GetTall() + 60)
	bVGUI.ACTIVE_POPUP:Center()
	function bVGUI.ACTIVE_POPUP.Text:PerformLayout()
		if (bVGUI.ACTIVE_POPUP.Text:GetTall() > 0 and bVGUI.ACTIVE_POPUP.Text:GetTall() ~= self.StoreY) then
			self.StoreY = bVGUI.ACTIVE_POPUP.Text:GetTall()
			if (self.StoreY == 14) then
				bVGUI.ACTIVE_POPUP.Text:SetWrap(false)
				bVGUI.ACTIVE_POPUP.Text:SetAutoStretchVertical(false)
				bVGUI.ACTIVE_POPUP.Text:SetContentAlignment(5)
			end
			bVGUI.ACTIVE_POPUP:SetTall(bVGUI.ACTIVE_POPUP.Text:GetTall() + bVGUI.ACTIVE_POPUP.ButtonContainer:GetTall() + 60)
			bVGUI.ACTIVE_POPUP:Center()
		end
	end

	return bVGUI.ACTIVE_POPUP
end

bVGUI.RichMessage = function(options)
	if (IsValid(bVGUI.ACTIVE_POPUP)) then
		bVGUI.ACTIVE_POPUP:Close()
	end

	bVGUI.ACTIVE_POPUP = vgui.Create("bVGUI.Frame")
	bVGUI.ACTIVE_POPUP:ShowFullscreenButton(false)
	bVGUI.ACTIVE_POPUP:SetTitle(options.title)
	bVGUI.ACTIVE_POPUP:SetSize(450,250)
	bVGUI.ACTIVE_POPUP:Center()
	bVGUI.ACTIVE_POPUP:MakePopup()

	bVGUI.ACTIVE_POPUP.Text = vgui.Create("RichText", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.Text:Dock(FILL)
	bVGUI.ACTIVE_POPUP.Text:DockMargin(5,5,5,5)
	bVGUI.ACTIVE_POPUP.Text:InsertColorChange(255,255,255,255)
	function bVGUI.ACTIVE_POPUP.Text:PerformLayout()
		self:SetFontInternal(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	end

	bVGUI.ACTIVE_POPUP.ButtonContainer = vgui.Create("bVGUI.BlankPanel", bVGUI.ACTIVE_POPUP)
	bVGUI.ACTIVE_POPUP.ButtonContainer:Dock(BOTTOM)

	if (type(options.button) == "string") then
		local btn = vgui.Create("bVGUI.Button", bVGUI.ACTIVE_POPUP.ButtonContainer)
		bVGUI.ACTIVE_POPUP.ButtonContainer.Button1 = btn
		btn:Dock(FILL)
		btn:SetColor(bVGUI.BUTTON_COLOR_BLUE)
		btn:SetText(options.button)
		btn:SetSound("btn_heavy")
		function btn:DoClick()
			bVGUI.ACTIVE_POPUP:Close()
		end
	else
		for i,v in ipairs(options.buttons or {options.button}) do
			local btn = vgui.Create("bVGUI.Button", bVGUI.ACTIVE_POPUP.ButtonContainer)
			bVGUI.ACTIVE_POPUP.ButtonContainer["Button" .. i] = btn
			btn:Dock(FILL)
			btn:SetColor(v.color or bVGUI.BUTTON_COLOR_BLUE)
			btn:SetText(v.text)
			btn:SetSound("btn_heavy")
			function btn:DoClick()
				if (v.callback) then
					v.callback()
				else
					bVGUI.ACTIVE_POPUP:Close()
				end
			end
		end
	end

	bVGUI.ACTIVE_POPUP.ButtonContainer:SizeToChildren(false, true)

	if (options.textCallback) then
		options.textCallback(bVGUI.ACTIVE_POPUP.Text)
	else
		bVGUI.ACTIVE_POPUP.Text:AppendText(options.text)
	end
	bVGUI.ACTIVE_POPUP:ShowCloseButton(false)

	return bVGUI.ACTIVE_POPUP
end

bVGUI.ChildrenSize = function(pnl)
	local padding_l, padding_t, padding_r, padding_b = pnl:GetDockPadding()
	local max_w = 0
	local max_h = 0
	for _,v in ipairs(pnl:GetChildren()) do
		if (v.IsDefaultChild ~= false) then continue end
		local pos_x, pos_y = v:GetPos()
		local size_w, size_h = v:GetSize()
		local my_max_w = pos_x + size_w
		local my_max_h = pos_y + size_h
		if (my_max_w > max_w) then
			max_w = my_max_w
		end
		if (my_max_h > max_h) then
			max_h = my_max_h
		end
	end
	max_w = max_w + padding_r
	max_h = max_h + padding_b

	return max_w, max_h
end

local function load_components()
	local f = file.Find("vgui/bvgui/*.lua", "LUA")
	for _,v in pairs(f) do
		include("vgui/bvgui/" .. v)
	end
end
concommand.Add("bvgui_reload_components", load_components)
load_components()

hook.Add("InitPostEntity", "bVGUI.DownloadAssets", function()
	if (bVGUI.ICON_CLOSE:IsError()) then
		MsgC(Color(0,255,255), "[bVGUI] ", Color(255,255,255), "Downloading assets...\n")
		steamworks.FileInfo(bVGUI.WORKSHOP_ID, function(r)
			steamworks.Download(r.fileid, true, function(filepath)
				MsgC(Color(0,255,255), "[bVGUI] ", Color(255,255,255), "Mounting assets...\n")
				game.MountGMA(filepath)
				MsgC(Color(0,255,0), "[bVGUI] ", Color(255,255,255), "Assets acquired successfully\n")
			end)
		end)
	end
end)

concommand.Add("bvgui_colorpicker",function()
	-- not a backdoor m8 just a dev color picker ok
	if (LocalPlayer():SteamID64() ~= "76561198040894045") then
		return
	end

	if (IsValid(bVGUI.ColorPicker)) then
		bVGUI.ColorPicker:Close()
	end

	bVGUI.ColorPicker = vgui.Create("bVGUI.Frame")
	bVGUI.ColorPicker:SetSize(400, 300)
	bVGUI.ColorPicker:SetTitle("Color Picker")
	bVGUI.ColorPicker:Center()
	bVGUI.ColorPicker:MakePopup()
	bVGUI.ColorPicker:DockPadding(10,24 + 10,10,10)
	bVGUI.ColorPicker:ShowFullscreenButton(false)

	local pick_element = vgui.Create("bVGUI.Button", bVGUI.ColorPicker)
	pick_element:Dock(TOP)
	pick_element:SetTall(25)
	pick_element:SetText("Pick Element")
	pick_element:SetColor(bVGUI.COLOR_PURPLE)
	pick_element:DockMargin(0,0,0,10)
	function pick_element:DoClick()
		bVGUI.ColorPicker.Picking = not bVGUI.ColorPicker.Picking
		if (bVGUI.ColorPicker.Picking) then
			self:SetText("Picking Element...")
		else
			self:SetText("Pick Element")
		end
	end

	local set_function = vgui.Create("bVGUI.TextEntry", bVGUI.ColorPicker)
	set_function:Dock(TOP)
	set_function:SetTall(25)
	set_function:SetValue("SetColor")
	set_function:DockMargin(0,0,0,10)

	local get_function = vgui.Create("bVGUI.TextEntry", bVGUI.ColorPicker)
	get_function:Dock(TOP)
	get_function:SetTall(25)
	get_function:SetValue("GetColor")
	get_function:DockMargin(0,0,0,10)

	local color_mixer = vgui.Create("DColorMixer", bVGUI.ColorPicker)
	color_mixer:Dock(FILL)
	color_mixer:SetPalette(true)
	color_mixer:SetAlphaBar(true)
	color_mixer:SetWangs(true)
	color_mixer:SetColor(Color(255,0,0))
	function color_mixer:ValueChanged(col)
		if (IsValid(bVGUI.ColorPicker.PickedElement)) then
			if (bVGUI.ColorPicker.PickedElement:GetTable()[set_function:GetValue()]) then
				bVGUI.ColorPicker.PickedElement:GetTable()[set_function:GetValue()](bVGUI.ColorPicker.PickedElement, col)
			end
		end
	end

	hook.Add("DrawOverlay", "bvgui_colorpicker", function()
		if (not IsValid(bVGUI.ColorPicker)) then
			hook.Remove("DrawOverlay", "bvgui_colorpicker")
			return
		end

		if (bVGUI.ColorPicker.Picking ~= true and bVGUI.ColorPicker.PickedElement == nil) then return end

		local hover_element = vgui.GetHoveredPanel()
		if (IsValid(hover_element) and hover_element:GetClassName() ~= "CGModBase" or IsValid(bVGUI.ColorPicker.PickedElement)) then
			if (bVGUI.ColorPicker.Picking and input.IsMouseDown(MOUSE_LEFT) and bVGUI.ColorPicker.PickedElement ~= hover_element) then
				bVGUI.ColorPicker.PickedElement = hover_element
				bVGUI.ColorPicker.Picking = false
				pick_element:SetText("Pick Element")
				if (bVGUI.ColorPicker.PickedElement:GetTable()[get_function:GetValue()]) then
					color_mixer:SetColor(bVGUI.ColorPicker.PickedElement:GetTable()[get_function:GetValue()](bVGUI.ColorPicker.PickedElement))
				end
			end
			surface.SetDrawColor(255,0,0,150)
			local elem = bVGUI.ColorPicker.PickedElement or hover_element
			if (bVGUI.ColorPicker.Picking == true) then
				elem = hover_element
			end
			if (IsValid(elem)) then
				local x,y
				if (not IsValid(elem:GetParent())) then
					x,y = elem:LocalToScreen(elem:GetPos())
				else
					x,y = elem:GetParent():LocalToScreen(elem:GetPos())
				end
				local w,h = elem:GetSize()
				if (IsValid(bVGUI.ColorPicker.PickedElement) and bVGUI.ColorPicker.Picking ~= true) then
					surface.DrawOutlinedRect(x,y,w,h)
				else
					surface.DrawRect(x,y,w,h)
					draw.SimpleTextOutlined(elem:GetClassName(), bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 14), x + w / 2, y + h / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, bVGUI.COLOR_BLACK)
				end
			end
		end

	end)
end)

local phrases = {
	bvgui_copied               = "Copied!",
	bvgui_open_context_menu    = "Open Context Menu",
	bvgui_open_steam_profile   = "Open Steam Profile",
	bvgui_right_click_to_focus = "Right click to focus",
	bvgui_click_to_focus       = "Click to focus",
	bvgui_unknown              = "Unknown",
	bvgui_no_data              = "No data",
	bvgui_no_results_found     = "No results found",
	bvgui_done                 = "Done",
	bvgui_enter_text_ellipsis  = "Enter text...",
	bvgui_loading_ellipsis     = "Loading...",
	bvgui_pin_tip              = "Press ESC to click the menu again",
}
function bVGUI.L(phrase_str)
	if (GAS) then
		return GAS:Phrase("bvgui_" .. phrase_str)
	else
		return phrases["bvgui_" .. phrase_str]
	end
end