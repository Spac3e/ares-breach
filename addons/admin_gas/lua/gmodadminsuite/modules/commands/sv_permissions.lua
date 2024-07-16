local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "commands:OpenPermissions")

	function GAS.Commands:ReloadPermissions()
		GAS.Commands.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_commands", {
			Name = "GmodAdminSuite Commands",
			Color = Color(216,39,76),
			Icon = "icon16/script_gear.png"
		})

		for cmd, options in pairs(GAS.Commands.Config.Commands) do
			GAS.Commands.OpenPermissions:AddToTree({
				Label = cmd,
				Value = cmd,
				Icon = "icon16/user_comment.png",
				Default = OpenPermissions.CHECKBOX.TICKED
			})
		end
	end

	GAS.Commands:ReloadPermissions()
end
if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "commands:OpenPermissions", OpenPermissions_Init)
end