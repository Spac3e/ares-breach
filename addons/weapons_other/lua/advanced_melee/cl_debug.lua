--[[


addons/[begotten]_advmelee/lua/advanced_melee/cl_debug.lua

--]]

local developermode = CreateConVar("advmelee_developermode", "0", FCVAR_SERVER_CAN_EXECUTE, "Debug weapons", 0, 1)

function advmelee.GetHitBone(ply, radius)
	local weapon = ply:GetActiveWeapon()
	local startpos = ply:GetShootPos()
	local dir = ply:GetAimVector()
	local len = advmelee.CMtoHU(weapon.Length)
	local sphere_pos_trace = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = ply,
		mask = MASK_SHOT_HULL
	} )
	local sphere_ents = ents.FindInSphere(sphere_pos_trace.HitPos, radius)
	local closest_ent
	for k, v in ipairs(sphere_ents) do
		--we don't want to hit ourselves
		if ply == v then
			continue
		end

		--we want to hit something alive
		if !(v:IsNPC() or v:IsPlayer()) then
			continue
		end

		--our closest entity is not set yet
		if !IsValid(closest_ent) then
			closest_ent = v
		end

		--replace closest ent if we found even closest one
		if v:GetPos():DistToSqr(sphere_pos_trace.HitPos) < closest_ent:GetPos():DistToSqr(sphere_pos_trace.HitPos) then
			closest_ent = v
		end

	end

	--we hit nobody
	if !closest_ent then
		return
	end

	--check if entity can have bones
	local closest_bone
	local closest_bone_pos
	if closest_ent.GetBoneCount then
		for i = 0, closest_ent:GetBoneCount() - 1 do
			--our closest entity is not set yet
			if closest_bone == nil then
				closest_bone = i
			end

			--these bones are always being returned, our calculation will only be better without them
			local bonename = closest_ent:GetBoneName(i)
			if bonename:find("_Hand") or bonename:find("_Shoulder") or bonename:find("_UpperArm") then
				continue
			end

			--get bone position
			local pos = closest_ent:GetBonePosition(i)

			--our closest bone position is not set yet
			if closest_bone_pos == nil then
				closest_bone_pos = pos
			end

        	if pos:DistToSqr(sphere_pos_trace.HitPos) < closest_bone_pos:DistToSqr(sphere_pos_trace.HitPos) then
				closest_bone = i
				closest_bone_pos = pos
			end
    	end
    end

    return closest_ent, closest_bone
end

local red = Color(255, 0, 0)
local sphere_mat = Material("models/wireframe")
hook.Add("PostDrawTranslucentRenderables", "adv_melee_debug", function()
	if developermode:GetInt() != 1 then
		return
	end

	local client = LocalPlayer()
	local actwep = client:GetActiveWeapon()

	if !IsValid(actwep) then
		return
	end

	local actwep_class = actwep:GetClass()

	if actwep_class == "adv_melee_base" or weapons.IsBasedOn(actwep_class, "adv_melee_base") then
		local mins = Vector(-10, -10, -10)
		local maxs = Vector(10, 10, 10)
		local startpos = client:GetShootPos()
		local dir = client:GetAimVector()
		local len = advmelee.CMtoHU(actwep.Length)

		local trace = util.TraceHull( {
			start = startpos,
			endpos = startpos + dir * len,
			maxs = maxs,
			mins = mins,
			filter = client,
			mask = MASK_BLOCKLOS_AND_NPCS
		} )

		render.DrawLine(client:GetShootPos(), trace.HitPos, red)
		render.SetMaterial(sphere_mat)
		local radius = 20
		render.DrawSphere(trace.HitPos, radius, 30, 30, color_white)

		local hitent, bone = advmelee.GetHitBone(client, radius)
		if hitent then
			render.DrawLine(trace.HitPos, hitent:GetBonePosition(bone), red)
		end
	end
end)

local black = Color(0, 0, 0, 255)
hook.Add("HUDPaint", "adv_melee_debug", function()
	if developermode:GetInt() != 1 then
		return
	end

	local client = LocalPlayer()
	local actwep = client:GetActiveWeapon()

	if !IsValid(actwep) then
		return
	end

	local actwep_class = actwep:GetClass()

	if actwep_class == "adv_melee_base" or weapons.IsBasedOn(actwep_class, "adv_melee_base") then
		local scrw = ScrW()
		local scrh = ScrH()

		draw.SimpleTextOutlined("Weapon sequences:", "BudgetLabel", scrw / 24, scrh / 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		for k, v in ipairs(actwep:GetSequenceList()) do
			draw.SimpleTextOutlined(v, "BudgetLabel", scrw / 24, (scrh / 12) + k*15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		end

		draw.SimpleTextOutlined("Weapon netvars:", "BudgetLabel", scrw / 5, scrh / 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		local count = 0
		for k, v in pairs(actwep:GetNetworkVars()) do
			count = count + 1
			draw.SimpleTextOutlined(k.." "..tostring(v), "BudgetLabel", scrw / 5, (scrh / 12) + count*15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		end

		draw.SimpleTextOutlined("Weapon stats:", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing windup "..actwep.SwingWindUp.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing release "..actwep.SwingRelease.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing recovery "..actwep.SwingRecovery.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab windup "..actwep.StabWindUp.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 90, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab release "..actwep.StabRelease.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 105, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab recovery "..actwep.StabRecovery.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 120, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Parry window "..actwep.ParryWindow.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 135, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Parry cooldown "..actwep.ParryCooldown.."ms", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 150, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Weapon length "..actwep.Length.."cm", "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 165, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Miss cost "..actwep.MissCost, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 180, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Feint cost "..actwep.FeintCost, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 195, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Morph cost "..actwep.MorphCost, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 210, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stamina drain "..actwep.StaminaDrain, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 225, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Parry drain negation "..actwep.ParryDrainNegation, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 240, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing damage "..actwep.SwingDamage, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 255, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing damage type "..actwep.SwingDamageType, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 270, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab damage "..actwep.StabDamage, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 285, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab damage type "..actwep.StabDamageType, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 300, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Main holdtype "..actwep.MainHoldType, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 315, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Current holdtype "..actwep:GetHoldType(), "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 330, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Swing holdtype "..actwep.SwingHoldType, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 345, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
		draw.SimpleTextOutlined("Stab holdtype "..actwep.StabHoldType, "BudgetLabel", scrw / 5, (scrh / 12) + count*15 + 360, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.4, black)
	end
end)