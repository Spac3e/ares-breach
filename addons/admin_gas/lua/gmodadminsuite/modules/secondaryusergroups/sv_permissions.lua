local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "secondaryusergroups:OpenPermissions")

	function GAS.SecondaryUsergroups:ReloadPermissions()
		GAS.SecondaryUsergroups.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_secondaryusergroups", {
			Name = "GmodAdminSuite Secondary Usergroups",
			Color = Color(0,100,255),
			Icon = "icon16/group_add.png",
			Logo = {
				Path = "gmodadminsuite/secondaryusergroups.vtf",
				Width = 256,
				Height = 256
			}
		})

		GAS.Database:Query("SELECT DISTINCT `usergroup` FROM " .. GAS.Database:ServerTable("gas_secondaryusergroups"), function(rows)
			if (not rows or #rows == 0) then return end
			table.SortByMember(rows, "usergroup", true)
			for _,row in ipairs(rows) do
				local usergroup_category = GAS.SecondaryUsergroups.OpenPermissions:AddToTree({
					Label = row.usergroup,
					Value = row.usergroup,
					Icon = "icon16/user_group.png",
				})

				usergroup_category:AddToTree({
					Label = "Give usergroup",
					Value = "give_usergroup",
					Icon = "icon16/add.png",
				})

				usergroup_category:AddToTree({
					Label = "Revoke usergroup",
					Value = "revoke_usergroup",
					Icon = "icon16/delete.png",
				})
			end
		end)
	end

	GAS.SecondaryUsergroups:ReloadPermissions()
end
if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "secondaryusergroups:OpenPermissions", OpenPermissions_Init)
end