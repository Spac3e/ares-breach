hook.Add("Initialize", "Breach_Optimize", function()
 	if timer.Exists("CheckHookTimes") then
		timer.Remove("CheckHookTimes")
	end

	hook.Remove("PlayerTick", "TickWidgets")
    hook.Remove("Tick", "TickWidgets")
    hook.Remove("OnEntityCreated", "WidgetInit")

	if widgets then
        function widgets.PlayerTick() end
    end

	timer.Remove("HostnameThink")

	hook.Remove("Think", "CheckSchedules")
	hook.Remove("LoadGModSave", "LoadGModSave")

	if CLIENT then
		RunConsoleCommand("cl_smooth", "0")
		RunConsoleCommand("mat_queue_mode", "2")
		RunConsoleCommand("cl_threaded_bone_setup", "1")
		RunConsoleCommand("gmod_mcore_test", "1")
		RunConsoleCommand("r_threaded_client_shadow_manager", "1")
		RunConsoleCommand("r_threaded_renderables", "1")
		RunConsoleCommand("r_threaded_particles", "1")
		RunConsoleCommand("r_queued_ropes", "1")
		RunConsoleCommand("studio_queue_mode", "1")
		RunConsoleCommand("r_decals", "4096")
		RunConsoleCommand("cw_rt_scope_quality", "5")
		RunConsoleCommand("cw_kk_ins2_rig", "1")
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

		if GetConVar("mat_picmip"):GetInt() < 0 then
			RunConsoleCommand("mat_picmip", "0")
		end

		RunConsoleCommand("r_flashlightdepthres", "512")
	end
end)