--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/fpsbooster/lang/french.lua

--]]

return {
	Name = "French",
	Flag = "flags16/fr.png",
	Phrases = function() return {

		module_name = "FPS Booster",

		--####################### UI PHRASES #######################--

		fps_booster          = "Booster de FPS",
		never_show_again     = "Ne plus afficher",
		never_show_again_tip = "Vous perdrez les avantages de ce menu ! Tapez \"gmodadminsuite fpsbooster\" dans votre console pour ouvrir ce menu dans le futur.",

		--####################### SETTING PHRASES #######################--

		show_fps                 = "Afficher FPS",
		multicore_rendering      = "Afficher le rendu Multi-Coeur",
		multicore_rendering_help = "C'est une fonctionnalité expérimentale de GMod qui permet d'augmenter les FPS en faisant un rendu des images sur plusieurs coeurs de votre processeur.",
		hardware_acceleration    = "Activer l'Accélération Matérielle",
		shadows                  = "Désactiver les Ombres",
		disable_skybox           = "Désactiver Skybox",
		sprays                   = "Désactiver les Sprays des Joueurs",
		gibs                     = "Désactiver Gibs",
		gibs_help                = "\"Gibs\" Sont des particules qui volent hors des cadavres et des ragdolls.",

} end }