--[[


addons/[weapons]_no_260_kk_ins2/lua/autorun/cw_kk_menu.lua

--]]

AddCSLuaFile()

if CLIENT then
	hook.Add("PopulateToolMenu", "CW_KK_PopulateToolMenu", function()
		spawnmenu.AddToolMenuOption("Utilities", "CW 2.0 SWEPs", "Client (ext.)", "Client (ext.)", "", "", function(panel)
			panel:ClearControls()

			if CustomizableWeaponry_KK.panels then
				for k,v in pairs(CustomizableWeaponry_KK.panels) do
					v(panel)
				end
			end
		end)
	end)
end
