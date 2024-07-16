local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Pickups"
MODULE.Colour   = Color(150,0,255)

MODULE:Setup(function()
	GAS.Logging:InferiorHook("PlayerCanPickupWeapon", "Pickups:PlayerCanPickupWeapon", function(ply, wep)
		if (ROLE_TRAITOR ~= nil and WEPS ~= nil and ply.CanCarryWeapon ~= nil) then -- love that TTT has no standardized way of detecting whether it is running
			-- TTT spams this hook for some stupid reason, so here's a stupid fix
			if not IsValid(wep) or not IsValid(ply) then
				return
			elseif ply:HasWeapon(wep:GetClass()) then
				return
			elseif not ply:CanCarryWeapon(wep) then
				return
			elseif WEPS.IsEquipment(wep) and wep.IsDropped and (not ply:KeyDown(IN_USE)) then
				return
			end
			-- see what I did there? I literally copied the code from TTT's PlayerCanPickupWeapon.
			-- fuck this gamemode. fuck this hook.
		end
		if (not IsValid(wep)) then return end
		if (ply.GAS_Logging_WeaponPickups == false) then return end
		if (wep:GetClass() == "gas_weapon_hands") then return end
		MODULE:LogPhrase("picked_up_weapon", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(wep))
	end)
	GAS.Logging:InferiorHook("PlayerCanPickupItem", "Pickups:PlayerCanPickupItem", function(ply, item)
		if (not IsValid(item) or ((item:GetClass() == "item_healthvial" or item:GetClass() == "item_healthkit") and ply:Health() >= ply:GetMaxHealth()) or (item:GetClass() == "item_battery" and ply:Armor() >= 100)) then return end
		MODULE:LogPhrase("picked_up_item", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(item))
	end)

	local function Pickup_Antispam(ply)
		ply.GAS_Logging_WeaponPickups = false
		timer.Simple(2, function()
			if (not IsValid(ply)) then return end
			ply.GAS_Logging_WeaponPickups = nil
		end)
	end
	GAS:hook("PlayerSpawn", "Pickups:PlayerSpawn", Pickup_Antispam)
	GAS:hook("OnPlayerChangedTeam", "Pickups:OnPlayerChangedTeam", Pickup_Antispam)
end)

GAS.Logging:AddModule(MODULE)