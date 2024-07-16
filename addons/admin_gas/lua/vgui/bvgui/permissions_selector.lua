--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/permissions_selector.lua

--]]

local PANEL = {}

function PANEL:Init()
	self.Rows = {}
	self.Headers = {}
	self.Categories = {}
	self.Permissions = {}
end

function PANEL:NormalCheckboxes()
	self.UseNormalCheckboxes = true
end

function PANEL:Clear()
	for i,v in ipairs(table.Merge(self.Rows, self.Headers)) do
		v:Remove()
	end
	self.Rows = {}
	self.Headers = {}
	self.Categories = {}
	self.Permissions = {}
	self:InvalidateLayout(true)
end

function PANEL:AddPermission(permission)
	table.insert(self.Permissions, permission)
end

function PANEL:AddHeader(header_text, header_col)
	local header = vgui.Create("bVGUI.Header", self)
	header.HeaderIndex = table.insert(self.Headers, header)
	header:Dock(TOP)
	header:SetText(header_text)
	header:SetColor(header_col)
end

function PANEL:AddPermissionGroup(header_text, header_col, rows, header_val)
	self:AddHeader(header_text, header_col)

	self.Categories[header_val or header_text] = {}

	for _,v in ipairs(rows) do
		local row = vgui.Create("bVGUI.PermissionsSelector_Row", self)
		row.RowIndex = table.insert(self.Rows, row)
		row.CategoryIndex = table.insert(self.Categories[header_val or header_text], row)
		row.Category = header_val or header_text
		row:Dock(TOP)
		row:SetText(v.text)
		row:SetTextColor(v.text_col)
		row:SetControlsAll(v.controls_all or false)
		row.PermissionValue = v.value
		if (v.checked) then
			row:SetChecks(v.checked)
		end
	end
end

function PANEL:AddSuperGroup(text, text_col)
	local row = vgui.Create("bVGUI.PermissionsSelector_Row", self)
	row.RowIndex = table.insert(self.Rows, row)
	row:Dock(TOP)
	row:SetText(text)
	row:SetTextColor(text_col)
	row:SetSuperGroup(true)
	self.SuperGroupRow = row
end

function PANEL:AddRow(header_val, v, header_text)
	local i = 0
	local last_row
	local found = false
	for row_i, row in pairs(self.Rows) do
		i = i + 1
		if (row.Category == (header_val or header_text)) then
			last_row = row
			found = true
		elseif (found) then
			break
		end
	end
	local row = vgui.Create("bVGUI.PermissionsSelector_Row", self)
	row.RowIndex = table.insert(self.Rows, i, row)
	row.CategoryIndex = table.insert(self.Categories[header_val or header_text], row)
	row.Category = header_val or header_text
	row:Dock(TOP)
	row:MoveToAfter(last_row)
	row:SetText(v.text)
	row:SetTextColor(v.text_col)
	row:SetControlsAll(v.controls_all or false)
	row.PermissionValue = v.value
	if (v.checked) then
		row:SetChecks(v.checked)
	end
end

function PANEL:GetPermissions()
	local permissions = {}
	if (self.SuperGroupRow) then
		for checkbox_i, checkbox in ipairs(self.SuperGroupRow.Checkboxes) do
			if (self.UseNormalCheckboxes) then
				if (checkbox:GetChecked() ~= false) then
					permissions["*"] = {}
					permissions["*"][checkbox_i] = true
					return permissions
				end
			else
				if (checkbox:GetChecked() ~= 0) then
					permissions["*"] = {}
					permissions["*"][checkbox_i] = checkbox:GetChecked()
					return permissions
				end
			end
		end
	end
	for category_i, rows in pairs(self.Categories) do
		permissions[category_i] = {}
		for row_i, row in ipairs(rows) do
			if (row.ControlsAll == true) then
				for checkbox_i, checkbox in ipairs(table.Reverse(row.Checkboxes)) do
					if (checkbox:GetChecked() ~= 0) then
						permissions[category_i]["*"] = permissions[category_i]["*"] or {}
						permissions[category_i]["*"][checkbox_i] = checkbox:GetChecked()
					end
				end
				if (permissions[category_i]["*"]) then
					if (table.Count(permissions[category_i]["*"]) == #row.Checkboxes) then
						break
					end
				end
			else
				permissions[category_i][row.PermissionValue or row.Label:GetText()] = {}
				for checkbox_i, checkbox in ipairs(table.Reverse(row.Checkboxes)) do
					if (checkbox:GetChecked() ~= 0) then
						permissions[category_i][row.PermissionValue or row.Label:GetText()][checkbox_i] = checkbox:GetChecked()
					end
				end
			end
		end
		if (permissions[category_i]["*"] and table.Count(permissions[category_i]) > 1) then
			permissions[category_i]["*"] = nil
		end
	end
	return permissions
end

function PANEL:UpdateCheckboxes()
	--[[
	local super_merges = {}
	local merges = {}
	for category_i, rows in pairs(self.Categories) do
		merges[category_i] = {}
		for row_i, row in ipairs(rows) do
			if (row.ControlsAll) then continue end
			for checkbox_i, checkbox in ipairs(row.Checkboxes) do
				if (super_merges[checkbox_i] == nil) then
					super_merges[checkbox_i] = checkbox:GetChecked()
				elseif (super_merges[checkbox_i] ~= false and super_merges[checkbox_i] ~= checkbox:GetChecked()) then
					super_merges[checkbox_i] = false
				end
				if (merges[category_i][checkbox_i] == nil) then
					merges[category_i][checkbox_i] = checkbox:GetChecked()
				elseif (merges[category_i][checkbox_i] ~= false and merges[category_i][checkbox_i] ~= checkbox:GetChecked()) then
					merges[category_i][checkbox_i] = false
				end
			end
		end
	end
	for category_i, checkboxes in pairs(merges) do
		for checkbox_i, checked in ipairs(checkboxes) do
			if (not self.Categories[category_i][1].ControlsAll) then continue end
			self.Categories[category_i][1].Checkboxes[checkbox_i]:SetChecked(checked or 0)
		end
	end
	if (IsValid(self.SuperGroupRow)) then
		for checkbox_i, checked in ipairs(super_merges) do
			self.SuperGroupRow.Checkboxes[checkbox_i]:SetChecked(checked or 0)
		end
	end
	]]
end

derma.DefineControl("bVGUI.PermissionsSelector", nil, PANEL, "bVGUI.LoadingScrollPanel")

local PANEL = {}

function PANEL:Init()
	local this = self
	self.PermissionsSelector = self:GetParent():GetParent()

	self:Dock(TOP)
	self:DockPadding(5,0,5,0)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:Dock(LEFT)

	self.Checkboxes = {}
	for i,v in ipairs(table.Reverse(self.PermissionsSelector.Permissions)) do
		local checkbox
		if (self.PermissionsSelector.UseNormalCheckboxes) then
			checkbox = vgui.Create("bVGUI.Checkbox", self)
		else
			checkbox = vgui.Create("bVGUI.Checkbox_Crossable", self)
		end
		checkbox.CheckboxIndex = table.insert(self.Checkboxes, checkbox)
		checkbox:Dock(RIGHT)
		checkbox:SetTooltip(v)
		checkbox:DockMargin(0,3.5,5,3.5)
		function checkbox:OnChange()
			if (this.PermissionsSelector.SuperGroupRow) then
				local super_checkbox = this.PermissionsSelector.SuperGroupRow.Checkboxes[self.CheckboxIndex]
				if (self:GetChecked() ~= super_checkbox:GetChecked()) then
					if (this.PermissionsSelector.UseNormalCheckboxes) then
						super_checkbox:SetChecked(false)
					else
						super_checkbox:SetChecked(0)
					end
				end
			end
			if (self:GetParent().IsSuperGroup == true) then
				for category_i, rows in pairs(this.PermissionsSelector.Categories) do
					for row_i, row in ipairs(rows) do
						row.Checkboxes[self.CheckboxIndex]:SetChecked(self:GetChecked())
					end
				end
			else
				for i,v in ipairs(this.PermissionsSelector.Categories[self:GetParent().Category]) do
					if (v.ControlsAll) then
						local controls_all_checkbox = v.Checkboxes[self.CheckboxIndex]
						if (self:GetChecked() ~= controls_all_checkbox:GetChecked()) then
							if (this.PermissionsSelector.UseNormalCheckboxes) then
								controls_all_checkbox:SetChecked(false)
							else
								controls_all_checkbox:SetChecked(0)
							end
						end
						break
					end
				end

				if (self:GetParent().ControlsAll == true) then
					for i,v in ipairs(this.PermissionsSelector.Categories[self:GetParent().Category]) do
						if (v.ControlsAll) then continue end
						v.Checkboxes[self.CheckboxIndex]:SetChecked(self:GetChecked())
					end
				end

				this.PermissionsSelector:UpdateCheckboxes()
			end
			if (this.PermissionsSelector.OnPermissionsChanged) then
				this.PermissionsSelector:OnPermissionsChanged()
			end
		end
	end
end

function PANEL:Paint(w,h)
	if (self.RowIndex % 2 == 0) then
		surface.SetDrawColor(31, 35, 43)
	else
		surface.SetDrawColor(33, 37, 45)
	end
	surface.DrawRect(0,0,w,h)
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self.Label:SizeToContents()
end

function PANEL:SetTextColor(text_col)
	self.Label:SetTextColor(text_col)
end

function PANEL:SetControlsAll(controls_all)
	self.ControlsAll = controls_all
end

function PANEL:SetSuperGroup(supergroup)
	self.IsSuperGroup = supergroup
end

function PANEL:SetChecks(checked)
	for i,v in ipairs(table.Reverse(self.Checkboxes)) do
		if (checked[i]) then
			v:SetChecked(checked[i])
		end
	end
end

derma.DefineControl("bVGUI.PermissionsSelector_Row", nil, PANEL, "DPanel")