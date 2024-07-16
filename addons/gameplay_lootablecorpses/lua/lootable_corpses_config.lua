--[[


addons/[gameplay]_lootable_corpses/lua/lootable_corpses_config.lua

--]]

LC = {}
-- READ THIS DARKRP USERS
-- Please change the following settings in your DarkRP config to false in order to prevent issues with the script:
-- GM.Config.dropweapondeath 
-- GM.Config.dropmoneyondeath
-- If you don't want your players to be able to pick up the loot boxes using pockets you should add "loot_box" to the GM.Config.PocketBlacklist in the darkrp config file.

-- WORKSHOP CONTENT: https://steamcommunity.com/sharedfiles/filedetails/?id=1404582844

-- Main config:

-- Model used for the loot box -- Download: https://steamcommunity.com/sharedfiles/filedetails/?id=1404582844
LC.BoxModel = "models/cultist/armor_pickable/clothing.mdl"

-- Should players drop money on death? False to disable. If you're not using Darkrp set it to false, otherwise you might get errors.
LC.MoneyEnabled = true

-- Percentage of money players will drop on death.
LC.MoneyDropPercent = 2

-- Class names of undroppable weapons.
LC.UndroppableWeapons = { "keys", "weapon_physcannon", "gmod_tool", "pocket", "weapon_physgun", "weapon_fists", "weapon_keypadchecker", "door_ram", "arrest_stick", "unarrest_stick", "weaponchecker", "weapon_scp_049_2_1", "weapon_scp_049_2_2" }

-- Primary color - Default is white - Color(235,235,235). RGB color model
LC.MenuColor = Color(235,235,235)

-- Secondary color - Default is almost black - Color(20,20,20). RGB color model
LC.MenuAltColor = Color(20,20,20)

-- ID of the button used for closing the menu. See https://wiki.garrysmod.com/page/Enums/BUTTON_CODE for more info.
LC.CloseMenuButton = 67

-- ID of the "take all" button.
LC.TakeAllButton = 85

-- Should loot boxes despawn after certain amount of time? (Might increase performance).
LC.ShouldDespawn = false

-- Amount of time it takes to despawn inactive loot box (In seconds). Default is 600.
LC.TimeToDespawn = 600

-- Set to false if you want the loot boxes to spawn exactly where the player is, instead of the nearest ground underneath him.
LC.PUBGlike = false

-- Should dropped weapons not contain ammo in them? ( May not work with some weapons )
LC.GunsNoAmmo = false

-- Should additional menu with weapon model be displayed?
LC.ShowSideMenu = true

-- Sounds used when box is being removed.
LC.DespawnSounds = {
      "physics/wood/wood_box_break1.wav",  
      "physics/wood/wood_box_break2.wav"
}

-- Sounds used when player takes an item from the box.
LC.PickupSounds = {  
      "weapons/m249/handling/m249_armmovement_01.wav",  
      "weapons/m249/handling/m249_armmovement_02.wav",	
      "weapons/universal/uni_weapon_draw_01.wav",	
      "weapons/universal/uni_weapon_draw_02.wav",	
}

-- Text used in the script. 
LC.TextLoot = "Loot"
LC.TextBox = "Loot box"
LC.TextClose = "Close"
LC.TextTakeAll = "Take all"

-- Font config. See https://wiki.garrysmod.com/page/surface/CreateFont for more info.
if CLIENT then
	surface.CreateFont( "LC.MenuHeader", {
		font = "Bebas Neue",    
		size = 44
	})
	surface.CreateFont( "LC.MenuFont", {
		font = "Bebas Neue",    
		size = 34
	})
	surface.CreateFont( "LC.MenuWeaponFont", {
		font = "Bebas Neue",    
		size = 22
	})
end