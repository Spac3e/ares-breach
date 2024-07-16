
BreachAchievements = BreachAchievements || {}

local mply = FindMetaTable("Player")

function OpenAchievementTab(ply)
	
	if !IsValid(ply) or !ply:IsPlayer() then return end
	net.Start("OpenAchievementMenu")
	net.WriteEntity(ply)
	net.SendToServer()

end

function mply:GetAchievementsNum()
	return self:GetNWInt("CompletedAchievements", 0)
end

local FUNNYACHIEVEMENTS = {
	{
		achievements_name = "Developer",
		desc = "",
		image = "nextoren/achievements/ahive5.jpg",
		owners = {},
		ownersusergroup = {"headadmin"},
	},
	{
		achievements_name = "Admin",
		desc = "Следит за твоей попкой",
		image = "nextoren/achievements/ahive146.jpg",
		owners = {},
		ownersusergroup = {"spectator", "admin", "headadmin"},
	},
	{
		achievements_name = "Alpha-Tester",
		desc = "",
		image = "nextoren/achievements/ahive2.jpg",
		owners = {},
		ownersusergroup = {},
		customcheck = function(ply) return ply:GetNWBool("AlphaTester") end,
	},
}

local bgmat = Material("nextoren_hud/inventory/menublack.png")
local bgmat2 = Material("nextoren_hud/inventory/texture_blanc.png")
local gradient = Material("vgui/gradient-l")
function OpenAchievementList(ply, tab, completedtab)

	BreachAchievements.GUI = BreachAchievements.GUI || {}

	if IsValid(BreachAchievements.GUI.Panel) then BreachAchievements.GUI.Panel:Remove() end

	BreachAchievements.GUI.Panel = vgui.Create("DFrame")
	BreachAchievements.GUI.Panel:SetDraggable(false)
	BreachAchievements.GUI.Panel:SetSize(600, ScrH() - 150)
	BreachAchievements.GUI.Panel:Center()
	BreachAchievements.GUI.Panel:SetTitle(ply:Name().."'s Achievements")
	BreachAchievements.GUI.Panel:SetBackgroundBlur(true)
	BreachAchievements.GUI.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bgmat)
		surface.DrawTexturedRect(0,0,w,h)
		return true
	end

	local AchievementList = vgui.Create( "DScrollPanel", BreachAchievements.GUI.Panel )
	AchievementList.Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bgmat2)
		surface.DrawTexturedRect(0,0,w,h)
	end
	AchievementList:Dock( FILL )

	BreachAchievements.GUI.Panel.Think = function(self)
		gui.EnableScreenClicker(true)
		self:MakePopup()
	end

	BreachAchievements.GUI.Panel.OnRemove = function(self)
		gui.EnableScreenClicker(false)
	end


	local achievementlist = tab

	for i = 1, #FUNNYACHIEVEMENTS do
		local tabl = FUNNYACHIEVEMENTS[i]
		if !table.HasValue(tabl.owners, ply:SteamID()) and !table.HasValue(tabl.owners, ply:SteamID64()) and !table.HasValue(tabl.ownersusergroup, ply:GetUserGroup()) and !tabl.customcheck then continue end
		if ( isfunction(tabl.customcheck) and !tabl.customcheck(ply) ) then continue end
		local iscompleted = true
		local panel = AchievementList:Add("DPanel")
		panel:SetSize(260, 50)
		panel:Dock(TOP)
		local image = Material(tabl.image)
		local gradientcol = Color(0,125,125)
		panel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, gradientcol)
			surface.SetDrawColor(0,0,0, 255)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			surface.SetMaterial(gradient)
			surface.SetDrawColor(255,255,255,150)
			surface.DrawTexturedRect(0,0,w,h)

			draw.RoundedBox(0, 0, 0, 50, 50, color_black)

			surface.SetFont("TargetID")
			local x, y = surface.GetTextSize("\""..tabl.achievements_name.."\"")
			surface.SetDrawColor(0,0,0)
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(0, 5, w, y)

			surface.SetMaterial(image)
			surface.SetDrawColor(0,255,255,255)
			surface.DrawTexturedRect(2,2,46,46)

			draw.DrawText("\""..tabl.achievements_name.."\"", "TargetID", 55, 5, color_white)
			draw.DrawText(tabl.desc, "DebugFixed", 55, 22, color_black)

			return true

		end
	end

	for i = 1, #achievementlist do
		local tabl = achievementlist[i]
		local iscompleted = false
		local cnt = 0
		for i, v in pairs(completedtab) do
			if v.achivid == tabl.name then
				cnt = tonumber(v.count) || 0
				if !tabl.countable then
					iscompleted = true
				else
					if tabl.countnum <= tonumber(v.count) then
						iscompleted = true
					end
				end
				break
			end
		end
		if tabl.secret and !iscompleted then continue end
		local panel = AchievementList:Add("DPanel")
		panel:SetSize(260, 50)
		panel:Dock(TOP)
		local image = Material(tabl.image)
		local gradientcol = Color(70,70,70)
		if !iscompleted then gradientcol = Color(90,0,0) end

		local addon = ""
		if tabl.countable then
			addon = tostring(cnt).."/"..tabl.countnum
		end

		panel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, gradientcol)
			surface.SetDrawColor(0,0,0, 255)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			surface.SetMaterial(gradient)
			surface.SetDrawColor(255,255,255,150)
			surface.DrawTexturedRect(0,0,w,h)

			draw.RoundedBox(0, 0, 0, 50, 50, color_black)

			surface.SetFont("TargetID")
			local x, y = surface.GetTextSize("\""..tabl.achievements_name.."\"")
			surface.SetDrawColor(0,0,0)
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(0, 5, w, y)

			surface.SetMaterial(image)
			if iscompleted then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(255,0,0,255)
			end
			surface.DrawTexturedRect(2,2,46,46)
			local additionaltext = ""
			draw.DrawText("\""..tabl.achievements_name.."\"", "TargetID", 55, 5, color_white)
			draw.DrawText(addon or "", "TargetID", 55 + x + 5, 5, color_white)
			draw.DrawText(tabl.desc or "", "DebugFixed", 55, 22, color_black)

			return true

		end
	end



end

local AchievementQuery = AchievementQuery || {}

local nextsound = nextsound || 0

function AchievementNotification(data)

	local multiplier = #AchievementQuery + 1

	if nextsound < CurTime() then
		if data.secret then
			surface.PlaySound("nextoren/achievement/secret_achievement_unlock.ogg")
		else
			surface.PlaySound("nextoren/achievement/achievement_unlock.ogg")
		end
		nextsound = CurTime() + 2
	end

	local AchievementPanel = vgui.Create("DPanel")
	AchievementPanel:SetSize(260, 50)
	AchievementPanel:SetPos(ScrW(), ScrH() - 50 * multiplier - 5)
	AchievementPanel:MoveTo(ScrW()-264, ScrH() - 50 * multiplier - 5, 1, 0.5)
	local image = Material(data.image)
	local gradientcol = Color(70,70,70)
	if data.secret then gradientcol = Color(0,0,0) end
	--AchievementPanel:SetPaintBackground(false)
	AchievementPanel.dietime = CurTime() + 8
	AchievementPanel.Paint = function(self, w, h)

		if self.dietime <= CurTime() then self:Remove() end

		draw.RoundedBox(0, 0, 0, w, h, gradientcol)
		surface.SetDrawColor(0,0,0, 255)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetMaterial(gradient)
		surface.SetDrawColor(255,255,255,150)
		surface.DrawTexturedRect(0,0,w,h)

		draw.RoundedBox(0, 0, 0, 50, 50, color_black)

		surface.SetMaterial(image)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(2,2,46,46)

		draw.DrawText("Открыто новое достижение:", "TargetID", 55, 5, color_white)
		draw.DrawText("\""..data.achievements_name.."\"", "TargetID", 55, 22, color_white)

		return true

	end


	local tyb = {
		dietime = CurTime() + 6,
		panel = AchievementPanel,
	}
	table.insert(AchievementQuery, tyb)
end

local nextcheck = 0
hook.Add("Think", "BreachAchievement_Think", function()
	if nextcheck < CurTime() then
		for i = 1, #AchievementQuery do
			local achievementtable = AchievementQuery[i]
			if !achievementtable or !IsValid(achievementtable.panel) then
				table.remove(AchievementQuery, i)
				continue
			end
			if achievementtable.dietime < CurTime() and !achievementtable.IsClosing then
				achievementtable.IsClosing = true
				achievementtable.panel:MoveTo(ScrW(), achievementtable.panel:GetY(), 1, 0, -1, function()
					achievementtable.panel:Remove()
					table.remove(AchievementQuery, i)
				end)
			end
		end
		nextcheck = CurTime() + 1
	end
end)

net.Receive("OpenAchievementMenu", function()
	local readentity = net.ReadEntity()
	local readtable = net.ReadTable()
	local completedtable = net.ReadTable()
	OpenAchievementList(readentity, readtable, completedtable)
end)

net.Receive("AchievementBar", function()

	local tab = net.ReadTable()
	AchievementNotification(tab)

end)