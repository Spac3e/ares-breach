hook.Add("Initialize", "Breach_Optimize", function()

 	hook.Remove("PlayerTick", "TickWidgets")

 	if SERVER then
 		if timer.Exists("CheckHookTimes") then
 			timer.Remove("CheckHookTimes")
 		end
 	end

	hook.Remove("PlayerTick", "TickWidgets")
	hook.Remove( "Think", "CheckSchedules")
	timer.Remove("HostnameThink")
	hook.Remove("LoadGModSave", "LoadGModSave")

	if CLIENT then
		RunConsoleCommand("cl_threaded_client_leaf_system", "1")
		RunConsoleCommand("cl_smooth", "0")
		RunConsoleCommand("mat_queue_mode", "2")
		RunConsoleCommand("cl_threaded_bone_setup", "1")
		RunConsoleCommand("gmod_mcore_test", "1")
		RunConsoleCommand("r_threaded_client_shadow_manager", "1")
		RunConsoleCommand("r_queued_post_processing", "1")
		RunConsoleCommand("r_threaded_renderables", "1")
		RunConsoleCommand("r_threaded_particles", "1")
		RunConsoleCommand("r_queued_ropes", "1")
		RunConsoleCommand("studio_queue_mode", "1")
		RunConsoleCommand("r_decals", "4096")
		RunConsoleCommand("cw_rt_scope_quality", "5")
		RunConsoleCommand("cw_kk_ins2_rig", "1")
		RunConsoleCommand("r_queued_decals", "1")
		--RunConsoleCommand("mat_hdr_level", "2")
		RunConsoleCommand("gm_demo_icon", "0")
		RunConsoleCommand("cw_simple_telescopics", "0")
		RunConsoleCommand("r_radiosity", "4")
		RunConsoleCommand("mat_specular", "0")
		RunConsoleCommand("cl_cmdrate", "101")
		RunConsoleCommand("cl_updaterate", "101")
		RunConsoleCommand("cl_interp", "0.07")
		RunConsoleCommand("cl_interp_npcs", "1")
		RunConsoleCommand("cl_timeout", "2400")

		hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
		hook.Remove("RenderScreenspaceEffects", "RenderBloom")
		hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
		hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
		hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
		hook.Remove("RenderScreenspaceEffects", "RenderSobel")
		hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
		hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
		hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
		hook.Remove("RenderScene", "RenderStereoscopy")
		hook.Remove("RenderScene", "RenderSuperDoF")
		hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
		hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
		hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
		hook.Remove("PostRender", "RenderFrameBlend")
		hook.Remove("PreRender", "PreRenderFrameBlend")
		hook.Remove("Think", "DOFThink")
		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
		hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
		hook.Remove("PostDrawEffects", "RenderWidgets")
		hook.Remove("PostDrawEffects", "RenderHalos")
		
		--some actual render fuckery
		--if LocalPlayer() == uracos() then
			if GetConVar("mat_picmip"):GetInt() < 0 then
				RunConsoleCommand("mat_picmip", "0") --high texture details is enough
				print("set mat_picmip to 0 from -1")
			end
			--вся эта хуйня нужна была только для фонариков кв2.0
			--RunConsoleCommand("r_shadowrendertotexture", "1") --medium shadow details
			--print("set r_shadowrendertotexture(low/medium shadow details) to 1")
			--RunConsoleCommand("r_flashlightdepthtexture", "1") --high shadow details
			--print("set r_flashlightdepthtexture(high shadow details) to 1")
			RunConsoleCommand("r_flashlightdepthres", "512")
			print("set r_flashlightdepthres(projected texture resolution) to 512")
			--RunConsoleCommand("mat_reducefillrate", "0") --high shader details
			--print("set mat_reducefillrate(shader details) to 0")
			--RunConsoleCommand("r_rootlod", "0") --high model details
			--print("set r_rootlod(model details) to 0")
		--end

	end

end)

--[[
if CLIENT then

hook.Add("InitPostEntity", "OptimizedRenderInit", function()
	initrender = true
end)

local entities = {}
local entities_noloscheck = {}
local entities_loscheck = {}
local entities_potato = {}
local table = table

function ents.GetAll()
    return entities
end

function ents.GetNoLOSCheck()
	return entities_noloscheck
end

function ents.GetLOSCheck()
	return entities_loscheck
end

function ents.GetPotato()
	return entities_potato
end

local ignoreents = {
	--["gmod_hands"] = true,
	--["viewmodel"] = true,
}

local insert_in_noloscheck = {
	["player"] = true,
	["prop_ragdoll"] = true,
	--["prop_dynamic"] = true,
	["breach_bonemerge"] = true,
}

local insert_in_potato = {
	["prop_physics"] = true,
	["player"] = true,
	["prop_ragdoll"] = true,
	["prop_dynamic"] = true,
}

hook.Add("NotifyShouldTransmit", "optimized_entity_list", function(ent, shouldTransmit)
    if !shouldTransmit then
        local oldthink = ent.Think
        ent.Think = function(self)
            if self:IsDormant() then return end
            return oldthink
        end

        for k, v in ipairs(entities) do
            if v == ent then
                table.remove(entities, k)
            end
			
			if !v:IsValid() then
				table.remove(entities, k)
			end
        end
		
		for k, v in ipairs(entities_noloscheck) do
            if v == ent then
                table.remove(entities_noloscheck, k)
            end
			
			if !v:IsValid() then
				table.remove(entities_noloscheck, k)
			end
        end
		
		for k, v in ipairs(entities_loscheck) do
            if v == ent then
                table.remove(entities_loscheck, k)
            end
			
			if !v:IsValid() then
				table.remove(entities_loscheck, k)
			end
        end
		
		for k, v in ipairs(entities_potato) do
            if v == ent then
                table.remove(entities_potato, k)
            end
			
			if !v:IsValid() then
				table.remove(entities_potato, k)
			end
        end
    end

    if shouldTransmit then
		if !ignoreents[ent:GetClass()] then
			table.insert(entities, ent)
		end

		if ignoreents[ent:GetClass()] then return end

		if insert_in_noloscheck[ent:GetClass()] then
			local find1, find2 = ent:GetModel():find("door")
			local my_bonemerge = false

			if ent.GetInvisible then
				if ent:GetParent() == LocalPlayer() then
					my_bonemerge = true
				end
			end

			if !isnumber(find1) and !my_bonemerge and ent != LocalPlayer() then
				table.insert(entities_noloscheck, ent)
			end
		end

		if ent:IsWeapon() or string.StartWith(ent:GetClass(), "item_") or string.StartWith(ent:GetClass(), "armor_") then
			table.insert(entities_loscheck, ent)
		end

		if insert_in_potato[ent:GetClass()] or ent:IsScripted() then
			local find1, find2 = ent:GetModel():find("door")
			if !isnumber(find1) then
				table.insert(entities_potato, ent)
			end
		end
    end
end)

local LocalPlayer = LocalPlayer
local GetShootPos = GetShootPos
local GetAimVector = GetAimVector
local Dot = Dot
local Length = Length
local IsLineOfSightClear = IsLineOfSightClear
local GetFOV = GetFOV
local math = math

local shootpos
local aimvector
local dot

local function EntityNotVisible(entPos, los)
	if los then
		if !LocalPlayer():IsLineOfSightClear(entPos) then
			return true
		end
	end

    local entVector = entPos - shootpos
    local dot = aimvector:Dot(entVector) / entVector:Length()
    directionAngle = math.pi / (360 / ( fov / 2 ))
    return dot < directionAngle
end

BREACHOptimize = GetConVar("breach_config_optimize"):GetBool()
--BREACHPotato = GetConVar("breach_config_potato"):GetBool()

timer.Create("optimizedrender", 0.1, 0, function()
	if !initrender then return end
	if !BREACHOptimize then return end

	shootpos = LocalPlayer():GetShootPos() or Vector(0,0,0)
	aimvector = LocalPlayer():GetAimVector() or Vector(0,0,0)
	fov = LocalPlayer():GetFOV() or 90

    for i = 1, #entities_noloscheck do
		local v = entities_noloscheck[i]
        if !IsValid(v) then continue end
		--for other
		if EntityNotVisible(v:GetPos()) then
			--v:SetLOD(8)
			v:SetNoDraw(true)
		else
			--v:SetLOD(-1)
			--if v["GetInvisible"] and !v:GetInvisible() and !v["CommanderAbilityActive"] then
				--v:SetNoDraw(false)
				--continue
			--end
			
			v:SetNoDraw(false)
		end
    end

end)
end]]