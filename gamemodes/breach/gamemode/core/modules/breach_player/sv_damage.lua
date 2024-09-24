local PLAYER = FindMetaTable("Player")

local stomach_hit = {
    [HITGROUP_STOMACH] = true,
    [HITGROUP_CHEST] = true,
    --[HITGROUP_LEFTARM] = true,
    --[HITGROUP_RIGHTARM] = true
}

AR2_AMMO = "AR2"
AR2_AMMO_2 = "7.62x39MM"
SMG1_AMMO = "SMG1"
SMG1_AMMO_2 = "4.6x30MM"
GOC_AMMO = "GOC"
SHOTGUN_AMMO = "Buckshot"
SHOTGUN_AMMO_2 = "Shotgun"
SNIPER_AMMO = "Sniper"
SNIPER_AMMO_2 = "SCP062Ammo"
SNIPER_AMMO_3 = "SniperRound"
PISTOL_AMMO = "Pistol"
PISTOL_AMMO_2 = "9mmRound"
REVOLVER_AMMO = "Revolver"
REVOLVER_AMMO_2 = "357"
REVOLVER_AMMO_3 = "357Round"
REVOLVER_AMMO_4 = ".357 Magnum"
REVOLVER_AMMO_5 = ".38 Special"
GRU_AMMO = "GRU"

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
    if not IsValid(ply) or not ply:Alive() then
        return
    end

    local attacker = dmginfo:GetAttacker()
	local dmgtype = dmginfo:GetDamageType()
	--local ammo = dmginfo:GetAmmoType() -- Выдаёт -1
	local dmg = dmginfo:GetDamage()

    local attackerpos = attacker:GetPos()
    local plypos = ply:GetPos()
    local distsqr = attackerpos:DistToSqr(plypos)
    local damagedrop = 0
	
    if IsValid(attacker) and attacker:IsPlayer() then
		local wep = attacker:GetActiveWeapon()
		local ammo = wep.Primary.Ammo or ""

        damagedrop = math.Clamp(math.ceil(distsqr * 0.000009) - 1, 0, 15)

		if ammo == AR2_AMMO or ammo == AR2_AMMO_2 then
			dmginfo:SetDamage(dmg + 25 - damagedrop)
		elseif ammo == SMG1_AMMO or ammo == SMG1_AMMO_2 then
			dmginfo:SetDamage(dmg + 20 - damagedrop)
		elseif ammo == GOC_AMMO then
			dmginfo:SetDamage(dmg + 15 - damagedrop)
		elseif ammo == SHOTGUN_AMMO or ammo == SHOTGUN_AMMO_2 then
			dmginfo:SetDamage(dmg + 6 - damagedrop)
		elseif ammo == PISTOL_AMMO or ammo == PISTOL_AMMO_2 then
			dmginfo:SetDamage(dmg + 15 - damagedrop)
		elseif ammo == REVOLVER_AMMO or ammo == REVOLVER_AMMO_2 or ammo == REVOLVER_AMMO_3 or ammo == REVOLVER_AMMO_4 or ammo == REVOLVER_AMMO_5 then
			dmginfo:SetDamage(dmg + 30 - damagedrop)
		elseif ammo == GRU_AMMO then
			dmginfo:SetDamage(dmg + 30 - damagedrop)
		elseif ammo == SNIPER_AMMO or ammo == SNIPER_AMMO_2 or ammo == SNIPER_AMMO_3 then
			dmginfo:SetDamage(dmg + math.random(150, 160) - damagedrop / 3)
		else
			dmginfo:SetDamage(dmg + 20 - damagedrop)
		end

		if hitgroup == HITGROUP_HEAD and ply.HasHelmet and ply.BoneMergedEnts then
			ply.MaxHitsHelmet = (ply.MaxHitsHelmet or 0) - 1
			if ply.MaxHitsHelmet <= 0 then
				ply.MaxHitsHelmet = nil
				ply.HasHelmet = nil
				for _, v in ipairs(ply.BoneMergedEnts) do
					if v and v:IsValid() and v:GetModel() == ply.Bonemergetoremove then v:Remove() end
					ply.Bonemergetoremove = nil
				end
			end

			dmginfo:ScaleDamage(0.5)
		elseif stomach_hit[hitgroup] and ply.HasArmor and ply.BoneMergedEnts then
			ply.MaxHitsArmor = (ply.MaxHitsArmor or 0) - 1
			if ply.MaxHitsArmor <= 0 then
				ply.MaxHitsArmor = nil
				ply.HasArmor = nil
				for _, v in ipairs(ply.BoneMergedEnts) do
					if v and v:IsValid() and v:GetModel() == ply.Bonemergetoremove_armor then v:Remove() end
					ply.Bonemergetoremove_armor = nil
				end
			end
		
			dmginfo:ScaleDamage(0.7)
		end

		if ply.DamageModifier then
            dmginfo:ScaleDamage(ply.DamageModifier)
		end

		if ply.ScaleTypeDamage and ply.ScaleTypeDamage[dmgtype] then
			dmginfo:ScaleDamage(ply.ScaleTypeDamage[dmgtype])
		elseif ply.ClothMultipliersType and ply.ClothMultipliersType[dmgtype]  then
			dmginfo:ScaleDamage(ply.ClothMultipliersType[dmgtype])
        end

		if ply.ScaleDamage and ply.ScaleDamage[hitgroup] then
			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage(ply.ScaleDamage[hitgroup] * 2.8)
			else
				dmginfo:ScaleDamage(ply.ScaleDamage[hitgroup])
			end
		elseif hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(4)
		elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage(0.5)
		else
			dmginfo:ScaleDamage(1.5)
		end

		if ply:GTeam() == TEAM_GUARD and dmginfo:IsBulletDamage() then
			local currentTime = CurTime()

			for _, igrok in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
				if IsValid(igrok) and igrok:IsPlayer() and igrok:GTeam() == TEAM_GUARD and igrok != ply then
					igrok.некричимное = igrok.некричимное or 0
					if currentTime >= igrok.некричимное then
						igrok.некричимное = currentTime + 10

						if igrok:GetRoleName() == role.MTF_Com then
							igrok:EmitSound("nextoren/vo/mtf/cmd_mtf_alert_"..math.random(1, 3)..".wav")
						else
							igrok:EmitSound("nextoren/vo/mtf/mtf_alert_"..math.random(1, 5)..".wav")
						end
					end
				end
			end
		end

		if dmginfo:IsBulletDamage() and hitgroup == HITGROUP_HEAD then
			for k,v in pairs(ply:LookupBonemerges()) do
				if v:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" or v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" then
					ply.DamageSpark1 = ents.Create("env_spark")
					ply.DamageSpark1:SetKeyValue("spawnflags","256")
					ply.DamageSpark1:SetKeyValue("Magnitude","1")
					ply.DamageSpark1:SetKeyValue("Spark Trail Length","1")
					ply.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
					ply.DamageSpark1:SetAngles(ply:GetAngles())
					ply.DamageSpark1:SetParent(ply)
					ply.DamageSpark1:Spawn()
					ply.DamageSpark1:Activate()
					ply.DamageSpark1:Fire("StartSpark", "", 0)
					ply.DamageSpark1:Fire("StopSpark", "", 0.001)
					ply:DeleteOnRemove(ply.DamageSpark1)
					ply:EmitSound("bullet/impact/player/headshot/helmetshot_0"..math.random(1,4)..'.wav',120,math.random(90,110),1,CHAN_BODY)
				end
				
				if ply:GTeam() == TEAM_GUARD then
					dmginfo:ScaleDamage(0.9)
				end
			end
		end
	
        if ply:GTeam() == TEAM_SCP and ammo != GOC_AMMO and ammo != REVOLVER_AMMO and dmginfo:IsBulletDamage() then
			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage(0.52)
			else
				dmginfo:SetDamage(math.Rand(1.3, 2.1))
			end
        end

		if attacker:GTeam() == TEAM_GOC and ammo == GOC_AMMO and ply:GTeam() == TEAM_SCP then
			dmginfo:SetDamage(dmg * 1.25)
		end
    
        --[[if ply:GTeam() == TEAM_SCP and dmginfo:IsDamageType(DMG_BLAST) then
            dmginfo:SetDamage(450)
        end--]]
    end

	return dmginfo
end


hook.Add("ScalePlayerDamage", "Breach-Damage.Flinch", function(ply, grp)
    if ply:IsPlayer() then
        local group = nil
        local hitpos = {
            [HITGROUP_HEAD] = { "flinch_head_01", "flinch_head_02" },
            [HITGROUP_CHEST] = { "flinch_phys_01", "flinch_phys_02" },
            [HITGROUP_STOMACH] = { "flinch_stomach_01", "flinch_stomach_02" },
            [HITGROUP_LEFTARM] = "flinch_shoulder_l",
            [HITGROUP_RIGHTARM] = "flinch_shoulder_r",
            [HITGROUP_LEFTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_01")),
            [HITGROUP_RIGHTLEG] = ply:GetSequenceActivity(ply:LookupSequence("flinch_02"))
        }

		if not hitpos[grp] then return end

		local group = nil
		if istable(hitpos[grp]) then
			group = ply:LookupSequence(table.Random(hitpos[grp]))
		else
			group = ply:LookupSequence(hitpos[grp])
		end
	
		net.Start("BreachFlinch")
		net.WriteEntity(ply)
		net.Send(ply)
    end
end)
