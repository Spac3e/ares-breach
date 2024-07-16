--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/lang/french.lua

--]]

return {
	Name = "French",
	Flag = "flags16/fr.png",
	Phrases = function() return {

		open_menu                 = "Ouvrir Menu",
		menu_nopermission         = "Désolé, mais vous n'avez pas la permission d'accéder au menu GmodAdminSuite.",
		menu_unknown_module       = "Désolé, mais le module spécifié n'est pas installé ou n'existe pas.",
		menu_disabled_module      = "Désolé, mais ce module est désactivé.",
		menu_module_nopermission  = "Désolé, mais vous n'avez pas la permission d'accéder à ce module.",
		open_gas                  = "Ouvrir GmodAdminSuite",
		module_shortcut           = "Raccourci Module",
		module_shortcut_info      = [[You can quickly access this GmodAdminSuite module through console and chat commands.

		To access the module through your console, type: %s
		To access the module through chat, type: %s

		Additionally, you can bind a key on your keyboard to a specific module.
		To do this, in your console, type: %s

		Make sure to replace KEY with a key on your keyboard of your choice.
		%s]],
		close                     = "Fermer",
		wiki                      = "Wiki",
		licensee                  = "Licencié",
		support                   = "Support",
		module_shop               = "Boutique de Modules",
		welcome                   = "Bienvenue",
		operator                  = "Opérateur",
		script_page               = "Page du Script",
		wiki                      = "Wiki",
		no_modules_available      = "Aucuns modules disponnibles!",
		no_modules_available_info = [[Désolé, but there aren't any GmodAdminSuite modules available for you to use.
		You may have insufficient permissions to use any, or none are enabled.]],
		custom_ellipsis           = "Custom...",
		usergroup_ellipsis        = "Groupe d'Utilisateurs...",
		steamid_ellipsis          = "SteamID...",
		enter_steamid_ellipsis    = "Entrez SteamID...",
		by_distance               = "Par Distance",
		by_usergroup              = "Par Groupes d'Utilisateurs",
		by_team                   = "Par Equipe",
		by_name                   = "Par Nom",
		right_click_to_focus      = "Clic Droit pour faire le focus",
		unknown                   = "Inconnu",
		utilities                 = "Utilitaires",
		player_management         = "Gestion Joueurs",
		administration            = "Administration",
		s_second                  = "1 seconde",
		s_seconds                 = "%d secondes",
		s_minute                  = "1 minute",
		s_minutes                 = "%d minutes",
		s_hour                    = "1 heure",
		s_hours                   = "%d heures",
		second_ago                = "il y a 1 seconde",
		seconds_ago               = "il y a %d secondes",
		minute_ago                = "il y a 1 minute",
		minutes_ago               = "il y a %d minutes",
		hour_ago                  = "il y a 1 heure",
		hours_ago                 = "il y a %d heures",
		just_now                  = "A l'instant",
		click_to_focus            = "Clic pour faire le focus",
		add_steamid               = "SteamID Custom",
		copied                    = "Copié !",
		settings                  = "Paramètres",
		add_steamid_help          = [[Entrez un SteamID ou SteamID64. Exemples:
		SteamID: %s
		SteamID64: %s]],

		setting_default_module = "Module par Défaut",
		setting_default_module_tip = "Quel module doit être ouvert lorsque le menu principal GmodAdminSuite est ouvert ?",
		none = "Aucun",
		general = "Général",
		localization = "Localisation",
		setting_menu_voicechat = "Autoriser Chat Vocal\nlorsque les menu GAS sont ouverts",
		setting_menu_voicechat_tip = "Les menu GmodAdminSuite ne vous empêchent pas de communiquer en jeu lorsqu'ils sont ouverts. Si cette option est active, appuyez simplement sur votre touche désignée à cet effet pour parler.",
		use_gas_language = "Utiliser le langage GmodAdminSuite",
		default_format = "Format par Défaut",
		short_date_format = "Format Date Abrégée",
		long_date_format = "Format Date Entière",
		short_date_format_tip = "Date format used for shorter date formats\n\nThe default format automatically matches the date format of your region (North America, Europe, etc.)",
		long_date_format_tip = "Date format used for longer date formats",
		permissions = "Permissions",
		module_enable_switch_tip = "Changes to this will only apply after a server restart/map change",
		enabled = "Activé",
		modules = "Modules",
		permissions_help = [[GmodAdminSuite utilise une librairie de permission open-sources nommée OpenPermissions, développée par Billy pour GAS. Elle fournit une gestion optimisée des permissions pour les systèmes avancées fonctionnant sur des serveurs de tous types.
		
		OpenPermissions est l'addon depuis lequel vous contrôlerez quels groupes peuvent accéder à quels modules, et ce qu'ils peuvent faire avec ces modules.
		Il peut être ouvert ouvert n'importe quand en écrivant "!openpermissions" dans le chat, ou "openpermissions" dans la console en jeu.

		Pour obtenir de l'aide, ou des informations, cliquez sur l'onglet "Aide" dans le menu OpenPermissions.]],
		website = "Site Web",
		fun = "Fun",

		bvgui_copied               = "Copié !",
		bvgui_open_context_menu    = "Ouvrir Menu Contextuel",
		bvgui_open_steam_profile   = "Afficher Profil Steam",
		bvgui_right_click_to_focus = "Clic Droit pour faire le focus",
		bvgui_click_to_focus       = "Clic pour faire le focus",
		bvgui_unknown              = "Inconnu",
		bvgui_no_data              = "Aucune Données",
		bvgui_no_results_found     = "Aucun résultat trouvé",
		bvgui_done                 = "Terminé",
		bvgui_enter_text_ellipsis  = "Entrez texte...",
		bvgui_loading_ellipsis     = "Chargement...",
		bvgui_pin_tip              = "Appuyez sur ECHAP pour pouvoir de nouveau intéragir avec le menu",

} end }