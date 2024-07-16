--[[


addons/[weapons]_no_260_kk_ins2/lua/effects/cw_kk_ins2_muzzleflash.lua

--]]

AddCSLuaFile()

function EFFECT:Init(fx)
	local wep = fx:GetEntity()

	if not IsValid(wep) then
		return
	end

	local weptable = wep:GetTable()
	local owner = wep:GetOwner()

	if not IsValid(owner) then
		return
	end

	if not owner:ShouldDrawLocalPlayer() and owner == LocalPlayer() then
		return
	end

	local ent = wep:getMuzzleModel()

	if not IsValid(ent) then
		return
	end

	local ammotype = game.GetAmmoName(wep:GetPrimaryAmmoType())

	-- particleEffect = wep:getFireParticles()
	local particleEffect = weptable.dt.Suppressed and weptable.MuzzleEffectSupp or (weptable.MuzzleEffectWorld or weptable.MuzzleEffect)

	if not wep.dt.Suppressed then
		if ammotype == "Shotgun" then
			particleEffect = "muzzleflash_shotgun_npc"
		elseif ammotype == "Sniper" then
			particleEffect = "muzzleflash_sniper_npc"
		elseif ammotype == "AR2" then
			particleEffect = "muzzleflash_sniper_npc"
		elseif ammotype == "Revolver" then
			particleEffect = "muzzleflash_pistol_npc"
		elseif ammotype == "Pistol" then
			particleEffect = "muzzleflash_pistol_npc"
		elseif ammotype == "SMG1" then
			particleEffect = "muzzleflash_smg_npc"
		end
	end
	--[[
	if owner == LocalPlayer() then
		if CW_ALTERNATIVE_MUZZLEFLASH_1P[particleEffect] then
			particleEffect = CW_ALTERNATIVE_MUZZLEFLASH_1P[particleEffect]
		end
	else
		if CW_ALTERNATIVE_MUZZLEFLASH_3P[particleEffect] then
			particleEffect = CW_ALTERNATIVE_MUZZLEFLASH_3P[particleEffect]
		end
	end]]

	local att = ent:GetAttachment(weptable.WorldMuzzleAttachmentID)

	if particleEffect and att then
		ParticleEffectAttach(particleEffect, PATTACH_POINT_FOLLOW, ent, weptable.WorldMuzzleAttachmentID)

		if not weptable.dt.Suppressed then
			if particleEffect != "blue_weapon_muzzle_flash" then
				local dlight = DynamicLight(self:EntIndex())

				dlight.r = 255
				dlight.g = 218
				dlight.b = 74
				dlight.Brightness = 7
				dlight.pos = att.Pos + att.Ang:Forward() * 60
				dlight.minlight = 0.001
				dlight.Size = 150
				dlight.Decay = 4000
				dlight.DieTime = CurTime() + 15
			else
				local dlight = DynamicLight(self:EntIndex())

				dlight.r = 0
				dlight.g = 100
				dlight.b = 255
				dlight.Brightness = 4
				dlight.pos = att.Pos + att.Ang:Forward() * 60
				dlight.minlight = 0.001
				dlight.Size = 200
				dlight.Decay = 4000
				dlight.DieTime = CurTime() + FrameTime()
			end
		end
	end

	if weptable.RearEffectw then	// RPGs
		local att = ent:GetAttachment(2)

		if att then
			-- ParticleEffectAttach("muzzleflash_m3", PATTACH_POINT_FOLLOW, ent, 2)
			-- ParticleEffectAttach("muzzleflash_m3", PATTACH_POINT_FOLLOW, ent, 2)
			ParticleEffectAttach(particleEffect, PATTACH_POINT_FOLLOW, ent, 2)

			local dlight = DynamicLight(self:EntIndex())

			dlight.r = 255
			dlight.g = 150
			dlight.b = 25
			dlight.Brightness = 7
			dlight.Pos = att.Pos
			dlight.Size = 128
			dlight.Decay = 128
			dlight.DieTime = CurTime() + FrameTime()
		end
	end

	--if weptable.NoShells then
		--return
	--end

	--if weptable.ShellDelay then
		--timer.Simple(weptable.ShellDelay, function()
			--if IsValid(wep) then
				--wep:shellEvent()
			--end
		--end)
	--else
		--wep:shellEvent()
	--end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end