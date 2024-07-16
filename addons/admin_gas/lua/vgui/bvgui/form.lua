--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/form.lua

--]]

local PANEL = {}

function PANEL:Init()
	self:SetColumns(bVGUI.COLUMN_LAYOUT_COLUMN_SHRINK, bVGUI.COLUMN_LAYOUT_COLUMN_GROW_COLUMN, bVGUI.COLUMN_LAYOUT_COLUMN_GROW)
end

function PANEL:SetTextSize(textsize)
	self.TextSize = textsize
end

function PANEL:CreateLabel(text, icon)
	if (ispanel(text)) then return text end
	local icon_container
	if (icon) then
		icon_container = vgui.Create("bVGUI.BlankPanel", self)
		icon_container:SetTall(16)
		icon_container.icon = vgui.Create("DImage", icon_container)
		icon_container.icon:SetSize(16,16)
		icon_container.icon:SetImage(icon)
	end

	local label
	if (icon) then
		label = vgui.Create("DLabel", icon_container)
	else
		label = vgui.Create("DLabel", self)
	end
	label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", self.TextSize or 16))
	label:SetTextColor(bVGUI.COLOR_WHITE)
	label:SetText(text)
	label:SizeToContents()
	label:SetContentAlignment(7)
	label:SetWrap(true)
	label:SetAutoStretchVertical(true)
	if (icon) then
		function label:PerformLayout()
			icon_container:SetSize(16 + 5 + self:GetWide(), self:GetTall())
			self:AlignLeft(16 + 5)
		end
		return icon_container
	else
		return label
	end
end

function PANEL:AddSpacing(h)
	local pnl1 = vgui.Create("bVGUI.BlankPanel", self)
	pnl1:SetSize(0,h)
	local pnl2 = vgui.Create("bVGUI.BlankPanel", self)
	pnl2:SetSize(0,h)
	local pnl3 = vgui.Create("bVGUI.BlankPanel", self)
	pnl3:SetSize(0,h)
	self:AddRow(pnl1,pnl2,pnl3)
end

function PANEL:AddButton(text, btncolor, help, func)
	local btn = vgui.Create("bVGUI.Button", self)
	btn:SetColor(btncolor)
	btn:SetText(text)
	btn:SetTall(25)
	if (func) then
		function btn:DoClick()
			func()
		end
	end

	local l1 = self:CreateLabel(text)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, btn, l2)

	return l1, btn, l2
end

function PANEL:AddSwitch(text, state, help, func)
	local switch = vgui.Create("bVGUI.Switch", self)
	switch:SetChecked(state)
	switch:SetText("")
	if (func) then
		function switch:OnChange()
			func(switch:GetChecked())
		end
	end

	local l1 = self:CreateLabel(text)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, switch, l2)

	return l1, switch, l2
end

function PANEL:AddCheckbox(text, state, help, func)
	local switch = vgui.Create("bVGUI.Checkbox_Crossable", self)
	switch:SetChecked(state)
	switch:SetText("")
	if (func) then
		function switch:OnChange()
			func(switch:GetChecked())
		end
	end

	local l1 = self:CreateLabel(text)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, switch, l2)

	return l1, switch, l2
end

function PANEL:AddComboBox(text, selected, help, func, icon)
	local combobox = vgui.Create("bVGUI.ComboBox", self)
	if (selected) then combobox:SetValue(selected) end
	if (func) then
		function combobox:OnSelect(index, value, data)
			func(index, value, data)
		end
	end

	local l1 = self:CreateLabel(text, icon)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, combobox, l2)

	return l1, combobox, l2
end

function PANEL:AddTextEntry(text, value, help, func, validation, placeholder, icon)
	local textentry = vgui.Create("bVGUI.TextEntry", self)
	textentry:SetValue(value)
	if (placeholder) then
		textentry:SetPlaceholderText(placeholder)
	end
	local prev_val = value
	function textentry:OnValueChange(val)
		if (validation == nil or validation(val) == true) then
			prev_val = val
			if (func) then func(val) end
		else
			self:SetValue(prev_val)
			self:SetText(prev_val)
			GAS:PlaySound("error")
		end
	end

	local l1 = self:CreateLabel(text, icon)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, textentry, l2)

	return l1, textentry, l2
end

function PANEL:AddLongTextEntry(...)
	local l1, textentry, l2 = self:AddTextEntry(...)

	textentry:SetMultiline(true)
	textentry:SetContentAlignment(7)
	textentry:SetTall(75)

	return l1, textentry, l2
end

function PANEL:AddNumberEntry(text, value, help, func, allow_negative)
	local textentry = vgui.Create("bVGUI.TextEntry", self)
	textentry:SetNumeric(true)
	textentry:SetValue(value)
	local prev_val = value
	function textentry:OnValueChange(val)
		if (not tonumber(self:GetValue()) or (allow_negative ~= true and tonumber(self:GetValue()) < 0)) then
			self:SetValue(prev_val)
			self:SetText(prev_val)
			GAS:PlaySound("error")
		else
			prev_val = self:GetValue()
			if (func) then func(tonumber(val)) end
		end
	end

	local l1 = self:CreateLabel(text)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, textentry, l2)

	return l1, textentry, l2
end

function PANEL:AddColorMixer(text, value, help, func, alpha)
	local colormixer = vgui.Create("DColorMixer", self)
	colormixer:SetAlphaBar(alpha == true)
	colormixer:SetPalette(false)
	colormixer:SetTall(120)
	if (value) then
		colormixer:SetColor(value)
	end
	if (func) then
		function colormixer:ValueChanged(col)
			func(col)
		end
	end

	local l1 = self:CreateLabel(text)
	local l2 = self:CreateLabel(help)

	self:AddRow(l1, colormixer, l2)

	return l1, colormixer, l2
end

derma.DefineControl("bVGUI.Form", nil, PANEL, "bVGUI.ColumnLayout")