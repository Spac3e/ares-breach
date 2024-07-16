--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/httplogo.lua

--]]

file.CreateDir("gas_http_png")

local PANEL = {}

local logo_mat = Material("gmodadminsuite/gmodadminsuite.vtf")
function PANEL:Init()
	local this = self

	self.Directory = "gas_http_png"

	self:Dock(TOP)
	self:SetTall(128 + 20 + 10 + 25 + 10)

	self.Logo = vgui.Create("DImage", self)
	self.Logo:SetSize(128,128)
	self.Logo:SetMaterial(logo_mat)

	self.LoadingOverlay = vgui.Create("bVGUI.LoadingPanel", self)
	self.LoadingOverlay:Dock(FILL)
	self.LoadingOverlay:SetLoading(false)

	self.URLContainer = vgui.Create("bVGUI.BlankPanel", self)
	self.URLContainer:Dock(TOP)
	self.URLContainer:DockMargin(0,128 + 20 + 20,0,0)
	self.URLContainer:SetTall(25)
	function self.URLContainer:PerformLayout()
		this.URLField:Center()
	end

	self.URLField = vgui.Create("bVGUI.TextEntry", self.URLContainer)
	self.URLField:SetPlaceholderText("URL...")
	self.URLField:SetSize(128 + 20 + 40, 25)
	function self.URLField:OnLoseFocus()
		self:ResetValidity()
		if (self:GetValue() == "") then
			this.Logo:SetVisible(true)
			this.Logo:SetMaterial(logo_mat)
			return
		end

		this.Logo:SetVisible(false)
		this.LoadingOverlay:SetLoading(true)

		local crc = util.CRC(os.date("%d%m%Y") .. self:GetValue()) .. ".png"

		http.Fetch(self:GetValue(), function(body, size, headers, code)
			this.LoadingOverlay:SetLoading(false)
			if (body:find("^.PNG")) then
				file.Write(this.Directory .. "/" .. crc, body)
				this.Logo:SetVisible(true)
				this.Logo:SetMaterial(Material("data/" .. this.Directory .. "/" .. crc))
				self:SetValid(true)
			else
				self:SetInvalid(true)
			end
			if (this.Always) then
				this:Always()
			end
			if (this.Success) then
				this:Success()
			end
		end, function()
			this.LoadingOverlay:SetLoading(false)
			self:SetInvalid(true)
			if (this.Always) then
				this:Always()
			end
			if (this.Failure) then
				this:Failure()
			end
		end)
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect((w - (128 + 20)) / 2,0,128 + 20,128 + 20)

	if (self.URLField._Invalid) then
		surface.SetDrawColor(255,0,0,100)
		surface.DrawRect((w - 128) / 2,10,128,128)
	end
end

function PANEL:GetURL()
	if (this.URLField._Valid) then
		return self.URLField:GetValue()
	else
		return false
	end
end

function PANEL:SetPlaceholderText(text)
	self.URLField:SetPlaceholderText(text)
end

function PANEL:SetDirectory(path)
	self.Directory = path
	file.CreateDir(path)
end

function PANEL:PerformLayout()
	self.Logo:AlignTop(10)
	self.Logo:CenterHorizontal()
end

derma.DefineControl("bVGUI.HTTPImageInput", nil, PANEL, "bVGUI.BlankPanel")