--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/table.lua

--]]

bVGUI.TABLE_COLUMN_GROW   = 0
bVGUI.TABLE_COLUMN_SHRINK = 1

--/// bVGUI.Table ///--

local PANEL = {}

function PANEL:Init()
	self.Columns = {}
	self.Rows = {}
	self.ColumnWidths = {}

	self.ColumnContainer = vgui.Create("DPanel", self)
	self.ColumnContainer:Dock(TOP)
	self.ColumnContainer.Paint = nil

	self.RowContainer = vgui.Create("bVGUI.ScrollPanel", self)
	self.RowContainer:Dock(FILL)
	self.RowContainer.Paint = nil

	self.TextSize = 14
	self.RowContainer.OnMouseWheeled_Old = self.RowContainer.OnMouseWheeled
	function self.RowContainer:OnMouseWheeled(delta)
		if (input.IsKeyDown(KEY_LCONTROL)) then
			local tbl = self:GetParent()
			if (delta > 0) then
				tbl.TextSize = math.min(tbl.TextSize + 1, 18)
			else
				tbl.TextSize = math.max(tbl.TextSize - 1, 10)
			end
			for _,row in ipairs(tbl.Rows) do
				row.Font = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", tbl.TextSize)
			end
			tbl:InvalidateLayout(true)
			tbl:InvalidateChildren(true)
		else
			self:OnMouseWheeled_Old(delta)
		end
	end

	self.NoData = vgui.Create("DLabel", self)
	self.NoData:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.NoData:SetTextColor(bVGUI.COLOR_WHITE)
	self.NoData:SetText(bVGUI.L("no_data"))
	self.NoData:SizeToContents()

	self.NoResultsFound = vgui.Create("DLabel", self)
	self.NoResultsFound:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16))
	self.NoResultsFound:SetTextColor(bVGUI.COLOR_WHITE)
	self.NoResultsFound:SetText(bVGUI.L("no_results_found"))
	self.NoResultsFound:SizeToContents()
	self.NoResultsFound:SetVisible(false)
end

function PANEL:SetRowCursor(cursor)
	self.RowCursor = cursor
end
function PANEL:GetRowCursor()
	return self.RowCursor
end

function PANEL:Clear()
	for _,v in ipairs(self.Rows) do
		v:Remove()
	end
	self.Rows = {}
	self:InvalidateLayout(true)
end

function PANEL:AddColumn(name, sizing, alignment, color)
	local column = vgui.Create("bVGUI.Table_Column", self.ColumnContainer)
	column:SetText(name)
	column:SetColor(color or Color(51, 80, 114))
	column:SetSizing(sizing or bVGUI.TABLE_COLUMN_GROW)
	column:SetAlignment(alignment or TEXT_ALIGN_LEFT)
	column:SetDrawBorder(false)

	table.insert(self.Columns, column)

	return column
end

function PANEL:AddRow(...)
	local row = vgui.Create("bVGUI.Table_Row", self.RowContainer)
	row.RowIndex = table.insert(self.Rows, row)
	row.LabelsData = {...}
	row:InvalidateLayout(true)
	if (self.RowCursor) then
		row:SetCursor(self.RowCursor)
	end
	self:InvalidateLayout(true)

	return row
end

function PANEL:RemoveRow(index_or_row)
	local row
	if (type(index_or_row) == "number") then
		row = self.Rows[index_or_row]
	elseif (IsValid(index_or_row)) then
		row = index_or_row
	else
		return
	end
	self.Rows[row.RowIndex] = nil
	row:Remove()
	local new_rows = {}
	local i = 0
	for _,v in pairs(self.Rows) do
		i = i + 1
		table.insert(new_rows, v)
		v.RowIndex = i
	end
	self.Rows = new_rows
	self:InvalidateLayout(true)
end

function PANEL:RerenderMarkups()
	for _,row in pairs(self.Rows) do
		row.LabelsMarkup = nil
	end
end

function PANEL:PerformLayout()
	self.ColumnWidths = {}

	local cur_space = self:GetWide()
	if (self.IconLayout) then cur_space = cur_space - 16 - 10 end
	local grow_count = 0
	for i,v in pairs(self.Columns) do
		if (v.Sizing == bVGUI.TABLE_COLUMN_SHRINK) then
			v:SizeToContents()
			v.Label:SizeToContents()
			local width = v.Label:GetWide() + 26
			for _,row in ipairs(self.Rows) do
				if (row.LabelsMarkup) then
					width = math.max(width, row.LabelsMarkup[i]:GetWidth() + 14)
				end
			end
			v:SetWide(width)
			v:InvalidateLayout(true)
			cur_space = cur_space - width
			self.ColumnWidths[i] = width
		else
			grow_count = grow_count + 1
		end
	end

	local grow_width = cur_space / grow_count
	for i,v in pairs(self.Columns) do
		if (v.Sizing == bVGUI.TABLE_COLUMN_GROW) then
			v:SetWide(grow_width)
			self.ColumnWidths[i] = grow_width
			for _,row in ipairs(self.Rows) do
				if (row.LabelsMarkup) then
					row.LabelsMarkup[i] = markup.Parse("<colour=225,225,225><font=" .. row.Font .. ">" .. row.LabelsData[i] .. "</font></colour>", grow_width - 14)
				end
			end
		end
	end

	self.NoData:Center()
	self.NoResultsFound:Center()
end

function PANEL:SortRows()
	local size_y = 0
	local no_rows = true
	for i,v in pairs(self.Rows) do
		if (not v:IsVisible()) then continue end
		v:AlignTop(size_y)
		size_y = size_y + v:GetTall()
		no_rows = false
	end
	self.NoResultsFound.Visible = no_rows
end

function PANEL:Paint(w,h)
	self:LoadingPaint(w,h)
	if (not self.LoadingState or self.LoadingState ~= self:GetLoading()) then
		self.LoadingState = self:GetLoading()
		self.NoData:SetVisible(self:GetLoading() == false and #self.Rows == 0)
	end
	self.NoResultsFound:SetVisible(not self.NoData:IsVisible() and self:GetLoading() ~= true and self.NoResultsFound.Visible)

	surface.SetDrawColor(51, 80, 114)
	surface.DrawRect(0,0,w,23)

	surface.SetDrawColor(31, 48, 68)
	surface.DrawLine(0,23,w,23)
end

derma.DefineControl("bVGUI.Table", nil, PANEL, "bVGUI.LoadingPanel")

--/// bVGUI.Table_Column ///--

local PANEL = {}

function PANEL:Init()
	self:Dock(LEFT)
	self:SetDrawBorder(false)
end

function PANEL:GetSizing()
	return self.Sizing
end
function PANEL:SetSizing(size_enum)
	self.Sizing = size_enum
end

function PANEL:SetAlignment(alignment)
	self.Alignment = alignment
end
function PANEL:GetAlignment(alignment)
	return self.Alignment
end

function PANEL:PaintOver(w,h)
	if (not self:IsHovered() or not input.IsMouseDown(MOUSE_LEFT)) then
		if (not self.ColumnBorderColor) then
			self.ColumnBorderColor = bVGUI.DarkenColor(self.OriginalBarColor, 0.4)
		end
		surface.SetDrawColor(self.ColumnBorderColor)
		surface.DrawLine(-1,h - 1,w + 1,h - 1)
	end
end

derma.DefineControl("bVGUI.Table_Column", nil, PANEL, "bVGUI.Button")

--/// bVGUI.Table_Row ///--

local PANEL = {}

function PANEL:Init()
	self.Table = self:GetParent():GetParent():GetParent()
	self:Dock(TOP)

	self.Font = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", self.Table.TextSize)
	self.CurrentFont = self.Font
end

local row_1 = Color(39,44,53)
local row_2 = Color(35,40,48)
function PANEL:Paint(w,h)
	if (self.RowIndex % 2 == 0) then
		surface.SetDrawColor(31, 35, 43)
	else
		surface.SetDrawColor(33, 37, 45)
	end
	surface.DrawRect(0,0,w,h)
	if (self.Highlight) then
		surface.SetDrawColor(255,255,0,4)
		surface.DrawRect(0,0,w,h)
	elseif (self:IsHovered()) then
		surface.SetDrawColor(255,255,255,4)
		surface.DrawRect(0,0,w,h)
	end
	if (not self.LabelsMarkup or self.CurrentFont ~= self.Font) then
		self.CurrentFont = self.Font
		self.LabelsMarkup = {}
		for i,v in pairs(self.LabelsData) do
			if (self.Table.Columns[i]:GetSizing() ~= bVGUI.TABLE_COLUMN_SHRINK) then
				self.LabelsMarkup[i] = markup.Parse("<colour=225,225,225><font=" .. self.Font .. ">" .. v .. "</font></colour>", self.Table.ColumnWidths[i] - 14)
			else
				self.LabelsMarkup[i] = markup.Parse("<colour=225,225,225><font=" .. self.Font .. ">" .. v .. "</font></colour>")
			end
		end
	end
	local cumulative = 0
	local tall = self:GetTall()
	local max_height = 0
	for i,v in pairs(self.LabelsMarkup) do
		local l_padding = 0
		if (self.Table.IconLayout) then
			l_padding = 16 + 10
			if (i == 1) then
				l_padding = l_padding - 5
			end
		end
		if (v:GetWidth() > self.Table.ColumnWidths[i]) then
			self.Table:InvalidateLayout(true)
		end
		local alignment = self.Table.Columns[i]:GetAlignment()
		if (alignment == TEXT_ALIGN_CENTER) then
			v:Draw(l_padding + cumulative + (self.Table.ColumnWidths[i] / 2), tall / 2 - v:GetHeight() / 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		elseif (alignment == TEXT_ALIGN_RIGHT) then
			v:Draw(l_padding + cumulative + self.Table.ColumnWidths[i] - 7, tall / 2 - v:GetHeight() / 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			v:Draw(l_padding + 7 + cumulative, tall / 2 - v:GetHeight() / 2, self.Table.Columns[i]:GetAlignment(), TEXT_ALIGN_TOP)
		end
		if (v:GetHeight() + 10 > max_height) then
			max_height = v:GetHeight() + 10
		end
		cumulative = cumulative + self.Table.ColumnWidths[i]
	end
	if (h ~= max_height) then
		self:SetTall(max_height)
	end
end

function PANEL:OnMouseReleased(key_code)
	if (key_code == MOUSE_LEFT) then
		self.Table.SelectedRow = self.RowIndex
		if (self.Table.OnRowClicked) then
			self.Table:OnRowClicked(self, self.CurrentHoveredColumn)
		end
	elseif (key_code == MOUSE_RIGHT) then
		if (self.Table.OnRowRightClicked) then
			self.Table:OnRowRightClicked(self, self.CurrentHoveredColumn)
		end
	end
end

function PANEL:OnCursorMoved(x)
	if (not self.Table.OnColumnHovered) then return end
	local cumulative_width = 0
	local hovered_column = nil
	for i,v in pairs(self.Table.ColumnWidths) do
		if (x >= cumulative_width) then
			hovered_column = i
		else
			break
		end
		cumulative_width = cumulative_width + v
	end
	if (self.CurrentHoveredColumn ~= hovered_column) then
		self.CurrentHoveredColumn = hovered_column
		self.Table:OnColumnHovered(self, hovered_column)
	end
end
function PANEL:OnCursorExited()
	if (not self.Table.OnColumnHovered) then return end
	self.CurrentHoveredColumn = nil
	self.Table:OnColumnHovered(self, nil)
end

function PANEL:SetIcon(path)
	self:SetMaterial(Material(path))
end
function PANEL:SetMaterial(mat)
	self.Table.IconLayout = true
	self.Table.ColumnContainer:DockPadding(16 + 10,0,0,0)
	self.Table.RowContainer:DockPadding(16 + 10,0,0,0)
	if (not IsValid(self.Icon)) then
		self.Icon = vgui.Create("DImage", self)
		self.Icon:SetSize(16,16)
		self.Icon:AlignLeft(5)
		self.Icon:CenterVertical()
	end
	self.Icon:SetMaterial(mat)
end

derma.DefineControl("bVGUI.Table_Row", nil, PANEL, "DPanel")