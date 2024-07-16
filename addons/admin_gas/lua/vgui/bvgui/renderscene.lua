--[[


addons/[admin]_gmodadminsuite/lua/vgui/bvgui/renderscene.lua

--]]

local IsInspecting = false

local LockView
local ViewOrigin, ViewAngle
local Velocity = Vector(0,0,0)
local CalcView_tbl = {}
hook.Add("CalcView", "bvgui_renderscene_CalcView", function(ply, origin, angles, fov)
	if (IsInspecting) then
		if (not ViewOrigin or not ViewAngle) then
			ViewOrigin, ViewAngle = origin, angles
		end
		CalcView_tbl.origin = ViewOrigin
		CalcView_tbl.angles = ViewAngle
	end

	if (GAS and GAS.Logging and GAS.Logging.Scenes) then
		if (IsInspecting) then
			GAS.Logging.Scenes.ViewOrigin = ViewOrigin
		else
			GAS.Logging.Scenes.ViewOrigin = nil
		end
	end

	if (IsInspecting) then return CalcView_tbl end
end)

local tr = { collisiongroup = COLLISION_GROUP_WORLD }
local function IsInWorld( pos )
	tr.start = pos
	tr.endpos = pos
	return util.TraceLine( tr ).HitWorld
end

hook.Add("CreateMove", "bvgui_renderscene_CreateMove", function(cmd)
	if (not IsInspecting) then
		LockView = nil
		Velocity.x, Velocity.y, Velocity.z = 0,0,0
		return
	end

	if (not LockView) then
		LockView = cmd:GetViewAngles()
	else
		cmd:SetViewAngles(LockView)
	end
	
	cmd:ClearMovement()

	local time = FrameTime()
   
	local sensitivity = 0.022
	ViewAngle:Normalize()
	ViewAngle.p = math.Clamp(ViewAngle.p + (cmd:GetMouseY() * sensitivity), -89, 89)
	ViewAngle.y = ViewAngle.y + (cmd:GetMouseX() * -1 * sensitivity)

	local NewViewOrigin = ViewOrigin + (Velocity * time)
   
	local add = Vector(0,0,0)
	local ang = ViewAngle
	if (cmd:KeyDown(IN_FORWARD)) then add = add + ang:Forward() end
	if (cmd:KeyDown(IN_BACK)) then add = add - ang:Forward() end
	if (cmd:KeyDown(IN_MOVERIGHT)) then add = add + ang:Right() end
	if (cmd:KeyDown(IN_MOVELEFT)) then add = add - ang:Right() end
	if (cmd:KeyDown(IN_JUMP)) then add = add + ang:Up() end
	if (cmd:KeyDown(IN_DUCK)) then add = add - ang:Up() end
   
	add = add:GetNormal() * time * 1000
	if (cmd:KeyDown(IN_SPEED)) then add = add * 2 end

	Velocity = Velocity * 0.95
	ViewOrigin = NewViewOrigin
   
	Velocity = Velocity + add

	cmd:ClearButtons()
end)

local function ResetNoDraw()
	for _,ent in ipairs(ents.GetAll()) do
		if (ent.bVGUI_RenderScene_SetNoDraw) then
			ent.bVGUI_RenderScene_SetNoDraw = nil
			ent:SetNoDraw(false)
		end
	end
end
local function SetNoDraw()
	for _,ent in ipairs(ents.GetAll()) do
		if (ent:GetNoDraw() == false and not ent.bVGUI_RenderScene_ForceDraw) then
			ent.bVGUI_RenderScene_SetNoDraw = true
			ent:SetNoDraw(true)
		end
	end
end
hook.Add("NotifyShouldTransmit", "bvgui_renderscene_KeepNoDraw", function(ent)
	if (IsInspecting) then
		if (ent:GetNoDraw() == false and not ent.bVGUI_RenderScene_ForceDraw) then
			ent.bVGUI_RenderScene_SetNoDraw = true
			ent:SetNoDraw(true)
		end
	else
		if (ent.bVGUI_RenderScene_SetNoDraw) then
			ent.bVGUI_RenderScene_SetNoDraw = nil
			ent:SetNoDraw(false)
		end
	end
end)

local static = Material("vgui/bvgui/static.vtf")

local PANEL = {}

function PANEL:Init()
	local this = self

	local function find_dframe(pnl)
		if (IsValid(pnl.bVGUI_PinButton)) then
			return pnl
		elseif (IsValid(pnl:GetParent())) then
			return find_dframe(pnl:GetParent())
		end
	end
	self.PvPEventFrame = find_dframe(self:GetParent())

	self.Inspecting = false
	self.Rendering = false
	self.CanRender = true
	self.Origin = Vector(0,0,0)
	self.Angle = Angle(0,0,0)

	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.RenderView = {
		origin = self.Origin,
		angles = self.Angle,
		drawviewmodel = false,
		fov = 120,
		bloomtone = false,
		aspectratio = 0
	}

	self.Toolbar = vgui.Create("bVGUI.BlankPanel", self)
	self.Toolbar:DockPadding(2,2,2,2)
	self.Toolbar:SetPos(5,5)
	function self.Toolbar:Paint(w,h)
		surface.SetDrawColor(47,79,115,255)
		surface.DrawRect(0,0,w,h)

		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
		surface.DrawTexturedRect(0,0,w,h)
	end

	self.InspectBtn = vgui.Create("DImageButton", self.Toolbar)
	self.InspectBtn:Dock(LEFT)
	self.InspectBtn:DockMargin(0,0,5,0)
	self.InspectBtn:SetSize(16,16)
	self.InspectBtn:SetImage("icon16/world.png")
	function self.InspectBtn:DoClick()
		if (IsInspecting and not this.Inspecting) then return end
		if (IsInspecting) then
			IsInspecting = false
			this.Inspecting = false
			if (ViewOrigin and ViewAngle) then
				this:SetOrigin(ViewOrigin)
				this:SetAngle(ViewAngle)
			end
			ResetNoDraw()

			this.PvPEventFrame:SetPos(this.PvPEventFrame.GAS_RenderScene_FramePosX, this.PvPEventFrame.GAS_RenderScene_FramePosY)
			for _,dframe in ipairs(bVGUI.Frames) do
				if (IsValid(dframe) and dframe.GAS_RenderScene_Hidden) then
					dframe:SetVisible(true)
				end
			end
		else
			ViewOrigin, ViewAngle = this.Origin, this.Angle

			SetNoDraw()

			this.PvPEventFrame.bVGUI_PinButton:TogglePin()
			this.PvPEventFrame.GAS_RenderScene_FramePosX, this.PvPEventFrame.GAS_RenderScene_FramePosY = this.PvPEventFrame:GetPos()
			this.PvPEventFrame:SetPos(ScrW() - this.PvPEventFrame:GetWide() - 20, ScrH() - this.PvPEventFrame:GetTall() - 20)
			for _,dframe in ipairs(bVGUI.Frames) do
				if (IsValid(dframe) and dframe ~= this.PvPEventFrame and dframe:IsVisible()) then
					dframe:SetVisible(false)
					dframe.GAS_RenderScene_Hidden = true
				end
			end

			IsInspecting = true
			this.Inspecting = true
		end
		GAS:PlaySound("jump")
	end
	bVGUI.AttachTooltip(self.InspectBtn, {Text = bVGUI.L("inspect")})

	local screenshot = vgui.Create("DImageButton", self.Toolbar)
	screenshot:Dock(LEFT)
	screenshot:SetSize(16,16)
	screenshot:DockMargin(0,0,5,0)
	screenshot:SetImage("icon16/camera.png")
	function screenshot:Capture()
		gui.HideGameUI()
		bVGUI.DestroyTooltip()

		timer.Simple(0, function()
			hook.Add("PostRender", "GAS_RenderScene_Screenshot", function()
				local img = render.Capture({
					format = "png",
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					alpha = false
				})

				local name = "gas_scene_screenshot_" .. os.date("%d_%m_%Y_%H_%M_%S")
				local function screenshot_name(i)
					if (i == nil) then
						if (file.Exists(name, "DATA")) then
							return screenshot_name(2)
						else
							return name
						end
					else
						if (file.Exists(name .. "_" .. i, "DATA")) then
							return screenshot_name(i + 1)
						else
							return name .. "_" .. i
						end
					end
				end
				local screenshot_name = screenshot_name() .. ".png"
				file.Write(screenshot_name, img)

				hook.Remove("PostRender", "GAS_RenderScene_Screenshot")

				bVGUI.RichMessage({
					title = bVGUI.L("screenshot_saved"),
					button = bVGUI.L("ok"),
					textCallback = function(text)
						local full_path = util.RelativePathToFull("data/" .. screenshot_name)

						text:InsertColorChange(255,255,255,255)
						local t = bVGUI.L("screenshot_saved_to")
						local s,e = t:find("%%s")
						text:AppendText(t:sub(1,s-1))

						text:InsertColorChange(0,255,255,255)
						text:InsertClickableTextStart("CopyFilePath")
						text:AppendText(full_path)
						text:InsertClickableTextEnd()

						text:InsertColorChange(255,255,255,255)
						text:AppendText(t:sub(e+1))

						function text:ActionSignal(signalName, signalValue)
							if (signalName == "TextClicked" and signalValue == "CopyFilePath") then
								GAS:SetClipboardText(full_path)
							end
						end
					end
				})

				if (IsValid(self) and IsValid(this) and this.Inspecting) then
					this.InspectBtn:DoClick()
				end

				GAS:PlaySound("success")
			end)
		end)
	end
	function screenshot:DoClick()
		if (this.Inspecting) then
			self:Capture()
		elseif (not IsInspecting) then
			this.InspectBtn:DoClick()
			self:Capture()
		end
	end
	bVGUI.AttachTooltip(screenshot, {Text = bVGUI.L("screenshot")})

	local reset = vgui.Create("DImageButton", self.Toolbar)
	reset:Dock(LEFT)
	reset:SetSize(16,16)
	reset:SetImage("icon16/arrow_refresh.png")
	function reset:DoClick()
		if (this.OriginalOrigin) then
			this:SetOrigin(Vector(this.OriginalOrigin.x, this.OriginalOrigin.y, this.OriginalOrigin.z))
		end
		if (this.OriginalAngles) then
			this:SetAngle(Angle(this.OriginalAngles.p, this.OriginalAngles.y, this.OriginalAngles.r))
		end
		GAS:PlaySound("delete")
	end
	bVGUI.AttachTooltip(reset, {Text = bVGUI.L("reset")})
end

function PANEL:OnRemove()
	if (self.Inspecting) then
		IsInspecting = false
		ResetNoDraw()
	end
end

function PANEL:PerformLayout(w,h)
	self.Toolbar:SetSize(w - 10,20)
end

local click_to_render_font = bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 18)
function PANEL:Paint(w,h)
	if (not self.Rendering or IsInspecting) then
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(static)
		local d = math.max(w,h)
		surface.DrawTexturedRect((w - d) / 2,(h - d) / 2,d,d)

		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT)
		surface.DrawTexturedRect(0,(((SysTime() % 5) / 5) * (h + 30)) - 30,w,30)

		if (self.CanRender and not IsInspecting) then
			draw.SimpleTextOutlined(bVGUI.L("click_to_render"), click_to_render_font, w / 2, (h - 20) / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, bVGUI.COLOR_BLACK)
		end
		if (self.Inspecting) then
			draw.SimpleTextOutlined(bVGUI.L("inspecting"), click_to_render_font, w / 2, (h - 20) / 2, bVGUI.COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, bVGUI.COLOR_BLACK)
		elseif (not self.CanRender) then
			draw.SimpleTextOutlined(bVGUI.L("no_data"), click_to_render_font, w / 2, (h - 20) / 2, bVGUI.COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, bVGUI.COLOR_BLACK)
		end
	else
		local x,y = self:LocalToScreen(0,0)
		self.RenderView.x, self.RenderView.y, self.RenderView.w, self.RenderView.h = x,y,w,h
		render.RenderView(self.RenderView)
	end

	surface.SetDrawColor(0,0,0)
	surface.DrawRect(0,0,5,h)
	surface.DrawRect(0,0,w,5)
	surface.DrawRect(w - 5,0,5,h)
	surface.DrawRect(0,h - 30,w,30)

	self.Toolbar:SetVisible(self.Rendering)
end

function PANEL:SetLabel(txt)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(txt)
	self.Label:Dock(FILL)
	self.Label:DockMargin(0,0,0,7.5)
	self.Label:SetContentAlignment(2)
end

function PANEL:SetOrigin(origin)
	self.Origin = origin
	self.RenderView.origin = self.Origin
	if (not self.OriginalOrigin) then
		self.OriginalOrigin = Vector(origin.x,origin.y,origin.z)
	end
end

function PANEL:SetAngle(ang)
	self.Angle = ang
	self.RenderView.angles = self.Angle
	if (not self.OriginalAngles) then
		self.OriginalAngles = Angle(ang.p,ang.y,ang.r)
	end
end

function PANEL:SetRendering(rendering)
	self.Rendering = rendering
	if (self.Rendering and self.OnStartRender) then
		self:OnStartRender()
	elseif (not self.Rendering and self.OnEndRender) then
		self:OnEndRender()
	end

	if (not self.Rendering and self.Inspecting) then
		self.Inspecting = false
		IsInspecting = false
	end
end

function PANEL:SetCanRender(can_render)
	self.CanRender = can_render
	if (not self.CanRender) then
		self:SetCursor("none")
	else
		self:SetCursor("hand")
	end
	if (self.Rendering) then
		self:SetRendering(false)
	end
end

function PANEL:DoClick()
	if (not self.Rendering) then
		if (not self.CanRender) then
			GAS:PlaySound("error")
		else
			self:SetRendering(true)
			GAS:PlaySound("btn_on")
			notification.AddLegacy(bVGUI.L("right_click_to_stop_rendering"), NOTIFY_HINT, 2)
		end
	else
		self.InspectBtn:DoClick()
	end
end

function PANEL:DoRightClick()
	if (self.Rendering) then
		self:SetRendering(false)
		GAS:PlaySound("btn_off")
	end
end

function PANEL:OnMousePressed(m)
	self.m_pressing = m
end
function PANEL:OnMouseReleased(m)
	if (self.m_pressing == m) then
		if (m == MOUSE_LEFT) then
			self:DoClick()
		elseif (m == MOUSE_RIGHT) then
			self:DoRightClick()
		end
	end
	self.m_pressing = nil
end

derma.DefineControl("bVGUI.RenderScene", nil, PANEL, "bVGUI.BlankPanel")