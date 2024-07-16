util.AddNetworkString("GASMASK_RequestToggle")
util.AddNetworkString("GASMASK_SendEquippedStatus")

local meta = FindMetaTable("Player")

function meta:GASMASK_RequestToggle()
    net.Start("GASMASK_RequestToggle")
    net.WriteBool(self.GASMASK_Equiped)
    net.Send(self)

    local model = "models/gmod4phun/w_contagion_gasmask_equipped.mdl"

    if self:GetModel() == "models/cultist/humans/mog/mog.mdl" then
        model = "models/cultist/humans/mog/mask/mask_gasmask.mdl"
    end

    if self.GASMASK_Equiped == true then
        local gasmask = Bonemerge(model, self)
        for _, v in ipairs(self.BoneMergedEnts) do
            if v and v:IsValid() and (v:GetModel():find("_gasmask_") or v:GetModel():find("mask_gasmask")) then
                self.GASMASK_Bonemerged = gasmask
                --self:EmitSound("nextoren/weapons/items/nightvision/nvgturnon.wav", 75, 100, 1, CHAN_STATIC)
            end
        end
    else
        for _, v in ipairs(self.BoneMergedEnts) do
            if v and v:IsValid() and (v:GetModel():find("_gasmask_") or v:GetModel():find("mask_gasmask")) then
                v:Remove()
            end
        end
    end
end


function meta:GASMASK_SetEquipped(b)
	self.GASMASK_Equiped = b
	net.Start("GASMASK_SendEquippedStatus")
		net.WriteBool(b)
	net.Send(self)
end

hook.Add("PlayerSpawn", "GASMASK_PlayerSpawn", function(ply)
	ply.GASMASK_Ready = true
	ply:GASMASK_SetEquipped(false)
end)

hook.Add("PostPlayerDeath", "GASMASK_PostDeath", function(ply)
	ply:GASMASK_SetEquipped(false)
end)

local gasmask_class = "g4p_gasmask"
concommand.Add("g4p_gasmask_toggle", function(ply)
	if !ply.GASMASK_Ready then return end

	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end
	
	if wep:GetClass() != gasmask_class then
		if !ply.GASMASK_SpamDelay or ply.GASMASK_SpamDelay < CurTime() then
			ply.GASMASK_SpamDelay = CurTime() + 0.75
			ply.GASMASK_LastWeapon = wep
			ply:StripWeapon(gasmask_class)
			ply:SetSuppressPickupNotices(true)

			// manual weapon pickup fix
			if ConVarExists("sv_manualweaponpickup") then 
				ply:Give(gasmask_class)
				timer.Simple(0.1, function()
					local mask = ply:GetWeapon(gasmask_class)
					mask.GASMASK_SignalForDeploy = true
					ply:SetSuppressPickupNotices(false)
					ply:SelectWeapon(gasmask_class)
				end)
			else // default behaviour
				ply:Give(gasmask_class).GASMASK_SignalForDeploy = true
				ply:SetSuppressPickupNotices(false)
				ply:SelectWeapon(gasmask_class)
			end

		end
	end
end)

local dmgtypes = {
	["DMG_GENERIC"] = DMG_GENERIC,
	["DMG_CRUSH"] = DMG_CRUSH,
	["DMG_BULLET"] = DMG_BULLET,
	["DMG_SLASH"] = DMG_SLASH,
	["DMG_BURN"] = DMG_BURN,
	["DMG_VEHICLE"] = DMG_VEHICLE,
	["DMG_FALL"] = DMG_FALL,
	["DMG_BLAST"] = DMG_BLAST,
	["DMG_CLUB"] = DMG_CLUB,
	["DMG_SHOCK"] = DMG_SHOCK,
	["DMG_SONIC"] = DMG_SONIC,
	["DMG_ENERGYBEAM"] = DMG_ENERGYBEAM,
	["DMG_PREVENT_PHYSICS_FORCE"] = DMG_PREVENT_PHYSICS_FORCE,
	["DMG_NEVERGIB"] = DMG_NEVERGIB,
	["DMG_ALWAYSGIB"] = DMG_ALWAYSGIB,
	["DMG_DROWN"] = DMG_DROWN,
	["DMG_PARALYZE"] = DMG_PARALYZE,
	["DMG_NERVEGAS"] = DMG_NERVEGAS,
	["DMG_POISON"] = DMG_POISON,
	["DMG_RADIATION"] = DMG_RADIATION,
	["DMG_DROWNRECOVER"] = DMG_DROWNRECOVER,
	["DMG_ACID"] = DMG_ACID,
	["DMG_SLOWBURN"] = DMG_SLOWBURN,
	["DMG_REMOVENORAGDOLL"] = DMG_REMOVENORAGDOLL,
	["DMG_PHYSGUN"] = DMG_PHYSGUN,
	["DMG_PLASMA"] = DMG_PLASMA,
	["DMG_AIRBOAT"] = DMG_AIRBOAT,
	["DMG_DISSOLVE"] = DMG_DISSOLVE,
	["DMG_BLAST_SURFACE"] = DMG_BLAST_SURFACE,
	["DMG_DIRECT"] = DMG_DIRECT,
	["DMG_BUCKSHOT"] = DMG_BUCKSHOT,
	["DMG_SNIPER"] = DMG_SNIPER,
	["DMG_MISSILEDEFENSE"] = DMG_MISSILEDEFENSE
}

local function CheckDMGTypes(dmginfo)
	print(dmginfo:GetDamageType())
	print("Damage types included:")
	for name, dmgtype in pairs(dmgtypes) do
		if dmginfo:IsDamageType(dmgtype) then
			print(name)
		end
	end
end

local gasmask_dmgtypes = {
	[DMG_NERVEGAS] = 0,
	[DMG_RADIATION] = 0.05
}

hook.Add("EntityTakeDamage", "GASMASK_TakeDamage", function(ent, dmginfo)
	if ent:IsPlayer() and ent.GASMASK_Equiped then
		local dmgtype = dmginfo:GetDamageType()
		if gasmask_dmgtypes[dmgtype] then
			dmginfo:ScaleDamage(gasmask_dmgtypes[dmgtype])
		end
	end
end)
