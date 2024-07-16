--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/fpsbooster/lang/english.lua

--]]

return {
	Name = "English",
	Flag = "flags16/gb.png",
	Phrases = function() return {

		module_name = "FPS Booster",

		--####################### UI PHRASES #######################--

		fps_booster          = "FPS Booster",
		never_show_again     = "Never Show Again",
		never_show_again_tip = "You'll lose the benefits of this menu! Type \"gmodadminsuite fpsbooster\" in your console to open this menu in future.",

		--####################### SETTING PHRASES #######################--

		show_fps                 = "Show FPS",
		multicore_rendering      = "Enable Multicore Rendering",
		multicore_rendering_help = "This is an experimental feature of GMod which boosts FPS by rendering frames using more than a single CPU core.",
		hardware_acceleration    = "Enable Hardware Acceleration",
		shadows                  = "Disable Shadows",
		disable_skybox           = "Disable Skybox",
		sprays                   = "Disable Player Sprays",
		gibs                     = "Disable Gibs",
		gibs_help                = "\"Gibs\" are particles and objects that can fly off of corpses and ragdolls.",

} end }