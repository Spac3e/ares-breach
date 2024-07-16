--[[


addons/[admin]_gmodadminsuite/lua/includes/modules/billyserrors.lua

--]]

AddCSLuaFile()

local BillysErrors_Version = 1
if (BillysErrors) then
	if (BillysErrors.Version >= BillysErrors_Version) then
		return
	elseif (CLIENT and IsValid(BillysErrors.Menu)) then
		BillysErrors.Menu:Close()
	end
end

BillysErrors = {}
BillysErrors.Version = BillysErrors_Version

BillysErrors.IMPORTANCE_NOTICE  = 0
BillysErrors.IMPORTANCE_WARNING = 1
BillysErrors.IMPORTANCE_FATAL   = 2

BillysErrors.COLOR_RED        = Color(255,0,0)
BillysErrors.COLOR_YELLOW     = Color(255,255,0)
BillysErrors.COLOR_LIGHT_BLUE = Color(0,255,255)
BillysErrors.COLOR_WHITE      = Color(255,255,255)

local function UnvectorizeColor(col)
	return col.r, col.g, col.b, col.a
end

function BillysErrors:ProcessConsoleMsg(print_items, msg)
	if (msg.Importance == BillysErrors.IMPORTANCE_NOTICE) then
		table.insert(print_items, BillysErrors.COLOR_LIGHT_BLUE)
		table.insert(print_items, "[NOTICE] ")
	elseif (msg.Importance == BillysErrors.IMPORTANCE_WARNING) then
		table.insert(print_items, BillysErrors.COLOR_YELLOW)
		table.insert(print_items, "[WARNING] ")
	elseif (msg.Importance == BillysErrors.IMPORTANCE_FATAL) then
		table.insert(print_items, BillysErrors.COLOR_RED)
		table.insert(print_items, "[FATAL] ")
	end
	if (#msg.TextItems > 0) then
		local prev_color
		if (not IsColor(msg.TextItems[1])) then
			table.insert(print_items, BillysErrors.COLOR_WHITE)
			prev_color = BillysErrors.COLOR_WHITE
		else
			prev_color = msg.TextItems[1]
		end
		for _,item in ipairs(msg.TextItems) do
			if (type(item) == "string") then
				table.insert(print_items, item)
			elseif (IsColor(item)) then
				table.insert(print_items, item)
				prev_color = item
			elseif (type(item) == "table" and item.Link ~= nil) then
				table.insert(print_items, BillysErrors.COLOR_LIGHT_BLUE)
				table.insert(print_items, item.Link)
				table.insert(print_items, prev_color)
			end
		end
	end
end

if (CLIENT) then
	function BillysErrors:ProcessRichTextMsg(rich_text, msg)
		if (msg.Importance == BillysErrors.IMPORTANCE_NOTICE) then
			rich_text:InsertColorChange(UnvectorizeColor(BillysErrors.COLOR_LIGHT_BLUE))
			rich_text:AppendText("[NOTICE] ")
		elseif (msg.Importance == BillysErrors.IMPORTANCE_WARNING) then
			rich_text:InsertColorChange(UnvectorizeColor(BillysErrors.COLOR_YELLOW))
			rich_text:AppendText("[WARNING] ")
		elseif (msg.Importance == BillysErrors.IMPORTANCE_FATAL) then
			rich_text:InsertColorChange(UnvectorizeColor(BillysErrors.COLOR_RED))
			rich_text:AppendText("[FATAL] ")
		end
		if (#msg.TextItems > 0) then
			local prev_color
			if (not IsColor(msg.TextItems[1])) then
				rich_text:InsertColorChange(UnvectorizeColor(BillysErrors.COLOR_WHITE))
				prev_color = BillysErrors.COLOR_WHITE
			else
				prev_color = msg.TextItems[1]
			end
			for i,item in ipairs(msg.TextItems) do
				if (IsColor(item)) then
					rich_text:InsertColorChange(UnvectorizeColor(item))
					prev_color = item
				elseif (type(item) == "table") then
					rich_text:InsertColorChange(0,125,255,255)
					rich_text:InsertClickableTextStart("OpenURL " .. item.Link)
					rich_text:AppendText(item.Link)
					rich_text:InsertClickableTextEnd()
					rich_text:InsertColorChange(UnvectorizeColor(prev_color))
				else
					rich_text:AppendText(tostring(item))
				end
			end
		end
	end
end

if (SERVER) then
	util.AddNetworkString("billyserrors")

	BillysErrors.Addons = {}
	BillysErrors.HasMessage = false

	local ADDON = {}
	function ADDON:Init(options)
		self.Name = options.Name
		self.Color = options.Color
		self.Icon = options.Icon
		self.Messages = options.Messages or {}
	end
	function ADDON:AddMessage(importance, ...)
		local msg = {
			Importance = importance,
			TextItems = {...}
		}
		table.insert(self.Messages, msg)

		local print_items = {}
		BillysErrors:ProcessConsoleMsg(print_items, msg)
		table.insert(print_items, "\n")
		MsgC(unpack(print_items))

		BillysErrors.HasMessage = true
		BillysErrors:SendData()
	end

	function BillysErrors:AddAddon(options)
		local addon = table.Copy(ADDON)
		addon:Init(options)
		table.insert(BillysErrors.Addons, addon)
		return addon
	end

	function BillysErrors:SendData(ply)
		if (not BillysErrors.HasMessage) then return end
		local data = util.Compress(util.TableToJSON(BillysErrors.Addons))
		if (ply ~= nil) then
			if (not IsValid(ply) or not ply:IsSuperAdmin()) then return end
			net.Start("billyserrors")
				net.WriteData(data, #data)
			net.Send(ply)
		else
			for _,ply in ipairs(player.GetHumans()) do
				if (not ply:IsSuperAdmin()) then continue end
				net.Start("billyserrors")
					net.WriteData(data, #data)
				net.Send(ply)
			end
		end
	end
	net.Receive("billyserrors", function(_, ply)
		BillysErrors:SendData(ply)
	end)
else
	function BillysErrors:OpenMenu()
		if (IsValid(BillysErrors.Menu)) then
			BillysErrors.Menu.Categories:Remove()
			BillysErrors.Menu.Categories = vgui.Create("bVGUI.Categories", BillysErrors.Menu.Content)
			BillysErrors.Menu.Categories:Dock(LEFT)
			BillysErrors.Menu.Categories:SetWide(175)
			BillysErrors.Menu.Categories:MoveToBefore(BillysErrors.Menu.Header)

			BillysErrors.Menu:LoadMessages(true)
			return
		end

		BillysErrors.Menu = vgui.Create("bVGUI.Frame")
		BillysErrors.Menu:SetSize(600,500)
		BillysErrors.Menu:SetMinimumSize(600,500)
		BillysErrors.Menu:Center()
		BillysErrors.Menu:SetTitle("BillysErrors")
		BillysErrors.Menu:MakePopup()
		function BillysErrors.Menu:OnClose()
			hook.Remove("SetupMove", "BillysErrors:ScrollRichText")
		end

		BillysErrors.Menu.Content = vgui.Create("bVGUI.BlankPanel", BillysErrors.Menu)
		BillysErrors.Menu.Content:Dock(FILL)
		function BillysErrors.Menu.Content:PaintOver(w,h)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
			surface.DrawTexturedRect(175,0,10,h)
		end

		BillysErrors.Menu.Categories = vgui.Create("bVGUI.Categories", BillysErrors.Menu.Content)
		BillysErrors.Menu.Categories:Dock(LEFT)
		BillysErrors.Menu.Categories:SetWide(175)

		BillysErrors.Menu.Header = vgui.Create("bVGUI.Header", BillysErrors.Menu.Content)
		BillysErrors.Menu.Header:Dock(TOP)
		BillysErrors.Menu.Header:SetText("Help")
		BillysErrors.Menu.Header:SetColor(Color(76,216,76))
		BillysErrors.Menu.Header:SetIcon("icon16/help.png")

		local function CreateRichText()
			if (IsValid(BillysErrors.Menu.Text)) then
				BillysErrors.Menu.Text:Remove()
			end
			BillysErrors.Menu.Text = vgui.Create("RichText", BillysErrors.Menu.Content)
			BillysErrors.Menu.Text:Dock(FILL)
			BillysErrors.Menu.Text:DockMargin(10,10,10,10)
			BillysErrors.Menu.Text:SetVerticalScrollbarEnabled(true)
			BillysErrors.Menu.Text:InsertColorChange(255,255,255,255)

			local font_name = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14)
			function BillysErrors.Menu.Text:PerformLayout()
				self:SetFontInternal(font_name)
			end

			function BillysErrors.Menu.Text:ActionSignal(signalName, signalValue)
				if (signalName == "TextClicked" and signalValue:sub(1,8) == "OpenURL ") then
					if (GAS) then
						GAS:OpenURL(signalValue:sub(9))
					else
						gui.OpenURL(signalValue:sub(9))
					end
				end
			end
		end

		function BillysErrors.Menu:LoadMessages(is_refresh)
			BillysErrors.Menu.Categories:Clear()

			local function ShowHelpText()
				if (not is_refresh) then
					BillysErrors.LastSelectedAddon = nil
				end

				CreateRichText()
				BillysErrors.Menu.Text:InsertColorChange(255,0,0,255)
				BillysErrors.Menu.Text:AppendText("(This window is only visible to superadmins)\n\n")
				BillysErrors.Menu.Text:InsertColorChange(255,255,255,255)
				BillysErrors.Menu.Text:AppendText(([[

					Uh oh! Something's wrong with an addon you have installed to your server.

					Click the addon's name on the left to see what's wrong, and how to fix the problem.

				]]):gsub("\t", ""):gsub("^%s",""):gsub("%s$",""))

				BillysErrors.Menu.Header:SetText("Help")
				BillysErrors.Menu.Header:SetColor(Color(76,216,76))
				BillysErrors.Menu.Header:SetIcon("icon16/help.png")
			end
			BillysErrors.Menu.Categories:AddItem("Help", ShowHelpText, Color(76,216,76)):SetActive(not is_refresh or BillysErrors.LastSelectedAddon == nil)

			ShowHelpText()

			local category_col = Color(216,76,76)
			if (BillysErrors.Addons[1] ~= nil and BillysErrors.Addons[1].Color ~= nil) then
				category_col = BillysErrors.Addons[1].Color
			end
			local category = BillysErrors.Menu.Categories:AddCategory("Addons", category_col)
			for _,addon in ipairs(BillysErrors.Addons) do
				if (#addon.Messages == 0) then continue end
				local item = category:AddItem(addon.Name, function()

					BillysErrors.LastSelectedAddon = addon.Name

					BillysErrors.Menu.Header:SetText(addon.Name)
					BillysErrors.Menu.Header:SetColor(addon.Color or Color(0,125,255))
					BillysErrors.Menu.Header:SetIcon(addon.Icon or false)

					CreateRichText()
					for i,msg in ipairs(addon.Messages) do
						local print_items = {}
						BillysErrors:ProcessConsoleMsg(print_items, msg)
						table.insert(print_items, "\n\n")
						MsgC(unpack(print_items))

						BillysErrors:ProcessRichTextMsg(BillysErrors.Menu.Text, msg)
						if (i ~= #msg) then BillysErrors.Menu.Text:AppendText("\n\n") end
					end

				end, addon.Color, addon.Icon)
				if (BillysErrors.LastSelectedAddon == addon.Name) then
					item:OnMouseReleased(MOUSE_LEFT)
				end
			end
		end
		BillysErrors.Menu:LoadMessages()

		BillysErrors.Menu:EnableUserResize()
		surface.PlaySound("gmodadminsuite/oof.mp3")
	end

	net.Receive("billyserrors", function(l)
		BillysErrors.Addons = util.JSONToTable(util.Decompress(net.ReadData(l)))
		BillysErrors:OpenMenu()
	end)

	if (BillysErrors_InitPostEntity) then
		net.Start("billyserrors")
		net.SendToServer()
	else
		hook.Add("InitPostEntity", "BillysErrors:InitPostEntity", function()
			BillysErrors_InitPostEntity = true

			net.Start("billyserrors")
			net.SendToServer()

			hook.Remove("InitPostEntity", "BillysErrors:InitPostEntity")
		end)
	end
end