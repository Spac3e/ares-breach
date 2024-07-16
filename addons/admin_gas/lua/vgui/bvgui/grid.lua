--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/grid.lua

--]]

local PANEL = {}

bVGUI.GRID_ALIGN_LEFT   = 0
bVGUI.GRID_ALIGN_CENTER = 1
bVGUI.GRID_ALIGN_RIGHT  = 2

function PANEL:Init()
	self.Items = {}
	self.ColumnPadding = 0
	self.RowPadding = 0
	self.Alignment = bVGUI.GRID_ALIGN_CENTER

	function self.pnlCanvas:PerformLayout()
		self:GetParent():LayoutItems()
	end

	self.BottomPadding = vgui.Create("bVGUI.BlankPanel", self)
	self.BottomPadding:Dock(BOTTOM)
	self.BottomPadding:SetTall(1)
end

function PANEL:SetAlignment(alignment)
	self.Alignment = alignment
end

function PANEL:SetPadding(c,r)
	self:SetColumnPadding(c)
	self:SetRowPadding(r)
end

function PANEL:SetColumnPadding(padding)
	self.ColumnPadding = padding
end

function PANEL:SetRowPadding(padding)
	self.RowPadding = padding
end

function PANEL:AddToGrid(item)
	table.insert(self.Items, item)
end

function PANEL:LayoutItems()
	self:CalculateGridSize()

	local columns = math.floor(self:GetWide() / self.MinColumnSize)
	local column_w = self:GetWide() / columns
	local column_i = 0
	local column_x = 0
	local row_y = 0
	for _,child in ipairs(self.Items) do
		if (self.Alignment == bVGUI.GRID_ALIGN_CENTER) then
			child:SetPos(column_x + (column_w / 2 - child:GetWide() / 2), row_y + (self.MinRowSize / 2 - child:GetTall() / 2))
		elseif (self.Alignment == bVGUI.GRID_ALIGN_LEFT) then
			child:SetPos(column_x, row_y + (self.MinRowSize / 2 - child:GetTall() / 2))
		elseif (self.Alignment == bVGUI.GRID_ALIGN_RIGHT) then
			child:SetPos(column_x + (column_w - child:GetWide()), row_y + (self.MinRowSize / 2 - child:GetTall() / 2))
		end
		column_x = column_x + column_w

		column_i = column_i + 1
		if (column_i >= columns) then
			column_i = 0
			column_x = 0
			row_y = row_y + self.MinRowSize + self.RowPadding
		end
	end

	self.BottomPadding:SetPos(0, row_y - 1)

	self:InvalidateLayout(true)
end

function PANEL:CalculateGridSize()
	local biggest_column = 0
	local biggest_row = 0
	for _,child in ipairs(self.Items) do
		if (child:GetWide() > biggest_column) then
			biggest_column = child:GetWide()
		end
		if (child:GetTall() > biggest_row) then
			biggest_row = child:GetTall()
		end
	end
	self.MinRowSize = biggest_row + (self.RowPadding * 2)
	self.MinColumnSize = biggest_column + (self.ColumnPadding * 2)
end

derma.DefineControl("bVGUI.Grid", nil, PANEL, "bVGUI.ScrollPanel")