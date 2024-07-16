--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/logging/lang/french.lua

--]]

return {
	Name = "French",
	Flag = "flags16/fr.png",
	Phrases = function() return {

		module_name = "Billy's Logs",

		--####################### UI PHRASES #######################--

		no_data                     = "Aucune donnée",
		add_to_evidence_box         = "Ajouter à la boite à preuves",
		livelogs_show_logs_for      = "Afficher les Logs pour",
		background_color            = "Couleur d'Arrière Plan",
		health_abbrieviated         = "%d PV",
		livelogs                    = "Logs en Direct",
		exit_deep_storage           = "Quitter le Stockage Interne",
		log_formatting              = "Formattage des Logs",
		strings                     = "Variables",
		when                        = "Quand",
		copy_log                    = "Copier Log",
		evidence_box                = "Boite à Preuves",
		livelogs_position_x         = "Position X (pixels)",
		width                       = "Largeur",
		color                       = "Couleur",
		help                        = "Aide",
		live_log_antispam           = "< journal en direct supprimé pour antispam >",
		settings                    = "Paramètres",
		loading_ellipsis            = "Chargement...",
		livelogs_enabled            = "Activer les logs en temps réel",
		armor_abbrieviated          = "%d ARM",
		deep_storage                = "Stockage Interne",
		all_logs                    = "Tous les logs",
		logs                        = "Logs",
		padding                     = "Bordure (pixels)",
		livelogs_position_y         = "Position Y (pixels)",
		livelogs_rows_help          = "Quel est le nombre maximal de logs devant être affichés ?",
		livelogs_rows               = "Rangées (Nombre de Logs)",
		livelogs_color_help         = "Les logs doivent-ils être affichés en couleur ?",
		export_to_clipboard         = "Exporter vers le Presse-Papier",
		players                     = "Joueurs",
		script_page                 = "Page de Script",
		wiki                        = "Wiki",
		module                      = "Module",
		modules                     = "Modules",
		localization                = "Localisation",
		view_deep_storage           = "Afficher Stockage Interne",
		copied                      = "Copié !",
		operator                    = "Opérateur",
		log                         = "Log",
		reset_to_defaults           = "Réinitialiser",
		livelogs_show_logs_for_help = "Combien de secondes les logs doivent-ils être affichés ?\nMettez 0 pour toujours.",
		advanced_search             = "Recherche Avancée",
		quick_search                = "Recherche Rapide",
		quick_search_ellipsis       = "Recherche Rapide...",
		entities                    = "Entitées",
		tutorial                    = "Tutoriel",
		clear_filters               = "Nettoyer Filtre",
		no_results_found            = "Aucun résultat trouvé",
		add_player                  = "+ Ajouter Joueur",
		add_module                  = "+ Ajouter Module",
		add_entity                  = "+ Ajouter Entitée",
		add_string                  = "+ Ajouter Variable",
		modules_search_tooltip      = "Quel(s) module(s) souhaitez-vous inclure ? (laissez blanc pour aucun module)",
		players_search_tooltip      = "Quel(s) joueur(s) cherchez-vous ? (laissez blanc pour n'importe quel joueur)",
		entities_search_tooltip     = "Quelle entitée(s) cherchez-vous ? (SWEPs, SENTs, véhicule, props, classes, etc.)",
		strings_search_tooltip      = "Recherchez-vous un texte spécifique ?",
		class_name_ellipsis         = "Nom de la classe...",
		add_string_popup_title      = "Ajouter Variable",
		add_string_popup_text       = "Entrez le texte que vous essayez de trouver.",
		text_ellipsis               = "Texte...",
		click_to_focus              = "Cliquez pour obtenir le focus",
		right_click_to_focus        = "Clic droit pour obtenir le focus",
		highlight_color             = "Couleur de surlignage",
		weapon_color                = "Couleur d'Armes",
		money_color                 = "Couleur d'Argent",
		vehicle_color               = "Couleur de Véhicules",
		entity_color                = "Couleur d'Entitées",
		health_color                = "Couleur de Santé",
		armor_color                 = "Couleur d'Armure",
		usergroup_color             = "Couleur de Grade",
		unavailable_color           = "Couleur Indisponible/Inconnue",
		learn_more                  = "En savoir plus",
		player_combats              = "Combats de joueurs",
		took_damage                 = "[a pris %d dgts]",
		jump_to_pvp_event           = "Sauter à l'évènement PvP",
		remove                      = "Retirer",
		greedy                      = "Gourmande",
		greedy_tip                  = "Si votre recherche est conséquente, le système tentera de faire correspondre le plus de logs possible. Si elle n'est pas conséquente, il tentera de faire correspondre le moins de logs possible.",
		log_colouring               = "Coloration des Logs",
		done_exclamation            = "Terminé !",
		module_settings             = "Paramètres des Modules",
		storage_settings            = "Paramètres du Stockage",
		third_party_addons          = "Addons Tiers",
		pvp_settings                = "Système de Log PvP",
		live_logs_settings          = "Paramètres de Logs en Direct",
		logging_settings            = "Paramètres de Logs",
		settings                    = "Paramètres",
		enabled_modules             = "Modules Activés",
		permissions                 = "Permissions",
		gamemode_modules            = "Modules de Mode de Jeu",
		saved_exclamation           = "Sauvegardé !",
		save_settings               = "Sauvegarder Paramètres",
		weapon_class                = "Classe d'Arme",
		enter_weapon_class          = "Entrez la classe de l'arme.\nVous ne la connaissez-pas ? Ouvrez votre menu de spawn, cliquez-droit sur une arme et séléctionnez \"Copy to clipboard\"",
		save                        = "Sauvegarder",
		add_new                     = "+ Ajouter Nouveau",
		enabled                     = "Activé",
		website                     = "Site Web",
		name                        = "Nom",
		usergroups                  = "Groupes d'Utilisateurs",
		everyone                    = "Tout le Monde",
		all_modules                 = "Tout les modules",
		all_teams                   = "Toutes les équipes",
		add_usergroup               = "Ajouter Groupe d'Utilisateurs",
		cl_sv_tooltip               = [[cl réprésente le temps nécéssaire à votre ordinateur pour demander les logs, les recevoir, les lire et les afficher
		
		sv réprésente le temps nécéssaire au serveur pour récupérer les logs depuis la mémoire/la base de données, les lires et vous les envoyer

		Les serveurs utilisant MySQL auront une valeur sv supérieur en fonction de la latence entre le serveur MySQL et Garry's Mod]],
		deep_storage_help           = [[Le Stockage Interne est une fonctionnalité de bLogs qui améliore les performances en stockant les logs des sessions serveurs précédentes séparément de la session actuelle.

		Après avoir cliqué sur "Afficher Stockage Interne", vous verrez seulement les logs des sessions serveurs précédentes.
		Vous pouvez voir les logs de la session actuelle en cliquant sur le bouton ci-dessus de nouveau, ou en réouvrant le menu.

		NOTE: Les logs de dégats ne sont pas inclus dans le stockage interne et sont supprimés à chaque redémarrage du serveur pour économiser de l'espace disque]],

		class_type_other = "Autres",
		class_type_player = "Joueur",
		class_type_team = "Equipe",
		class_type_weapon = "Arme",
		class_type_vehicle = "Véhicule",
		class_type_usergroup = "Groupe d'Utilisateur",
		class_type_prop = "Prop",
		class_type_ragdoll = "Ragdoll",
		class_type_country = "Pays",
		class_type_ammo = "Munition",
		class_type_role = "Rôle",
		class_selector = "Sélecteur de classe",
		custom_class = "Classe Personnalisée",
		class_type = "Type de Classe",
		value = "Valeur",
		search = "Rechercher",
		check_all = "Tout Cocher",
		uncheck_all = "Tout Décocher",
		general = "Général",
		class_search_title = "Recherche de classe",
		class_search_text = "Entrez le nom ou une partie du nom de la classe que vous cherchez (insensibles aux majuscules/minuscules)",
		view_logs = "Voir Logs",
		open_menu = "Ouvrir Menu",
		licensed_to = "License accordée à %s",

		--####################### SETTINGS #######################--

		Player_RecordTeam = "Afficher l'équipe du joueur dans les logs",
		Player_RecordUsergroup = "Afficher le grade du joueur dans les logs",
		Player_RecordHealth = "Afficher la santé du joueur dans les logs",
		Player_RecordArmor = "Afficher l'armure du joueur dans les logs",
		Player_RecordWeapon = "Afficher l'arme du joueur dans les logs",
		Player_RecordWeapon_DoNotRecord = "Filtre d'arme du joueur",
		Player_RecordWeapon_DoNotRecord_help = "Si vous souhaitez afficher les armes des joueurs dans les logs, utilisez cette option pour filtrer les armes non-désirées (comme le physgun, toolgun, etc.)",

		OverrideMoneyFormat = "Outrepasser le formatage de l'argent par défaut",
		OverrideMoneyFormat_help = "Lorsque désactivé, le formattage de l'argent du mode de jeu sera utilisé.\nLorsque activé, vous pouvez utiliser l'option ci-dessous pour créer votre propre formattage de l'argent.",
		MoneyFormat = "Formattage de l'Argent",
		MoneyFormat_help = "Entrez la façon dont vous souhaitez que l'argent apparaisse et insérez \"%s\" (sans guillemts) à l'endroit ou vous souhaitez voir l'argent affiché.",

		MaxSessionLogs = "Logs de session max",
		MaxSessionLogs_help = "Combien de logs de la session actuelle peuvent être affichées avant de déplacer toutes les logs dans le stockage interne ? (économies de performances)\nDéfinissez sur 0 pour infini ((Déconseillée)).",

		DeepStorageTooOld = "Age max des logs du stockage interne",
		DeepStorageTooOld_help = "Combien de jours souhaitez-vous conserver les logs dans le stockage interne avant de les supprimer? (économise l'espace disque)\nDéfinissez sur 0 pour ne jamais supprimer les logs dans le stockage interne (Déconseillée).",

		LiveLogsEnabled = "Logs en Direct Activées",
		LiveLogsEnabled_help = "Les logs en direct peuvent nuire aux performances sur les gros serveurs; vous pouvez complètement désactiver cette fonctionnalité ici.",
		LiveLogsIn10Seconds = "Logs en Direct max en 10 secondes",
		LiveLogsIn10Seconds_help = "Combien de logs en direct peuvent être envoyées avant que les logs supplémentaires ne soient supprimées par l'antispam ?",
		NotifyLiveLogsAntispam = "Notifier Antispam",
		NotifyLiveLogsAntispam_help = "Les utilisateurs doivent-ils être notifiés qu'un log en direct à été supprimée par l'antispam ?",

		TimeBetweenPvPEvents = "Temps entre les évènements PvP",
		TimeBetweenPvPEvents_help = "Quant un joueur commence à se battre, il crée un \"Evènement PvP\", quand aucun combat supplémentaire n'a eu lieu dans un certain nombre de secondes, l'évènement PvP est défini comme terminé et est envoyé aux logs. Combien de secondes bLogs doit attendre avant de faire cela ?",
		NonPvPWeapons = "Filtre des Armes PvP",
		NonPvPWeapons_help = "Quelles armes ne doivent pas être considérées comme des armes PvP ?",

		server_restart_required = "NOTE: Les modification effectuées ici ne prendront effets qu'après un redémarrage du serveur.",

		gamemode_modules_tip = [[bLogs supporte un grand nombre de modes de jeu.
		Cependant, il peut arriver que bLogs ait des problèmes à détecter le mode de jeu utilisé sur votre serveur.
		Sur cet écran, vous pouvez forcer bLogs à détecter un certain mode de jeu.

		Décoché = Comportement par défaut
		Coché = Activation Forcée
		Coché avec une croix = Désactivé

		Veuillez noter que certains modes de jeu sont des dérivation du Sandbox, cela signifie qu'ils utilisent certaines fonctionnalitées du Sandbox.
		Pour les modes de jeu comme DarkRP qui dérivent du Sandbox, il est recommandé de laisser Sandbox comme mode jeu par défaut.]],

		third_party_addons_tip = [[[bLogs supporte un grand nombre d'addons tiers'.
		Cependant, il peut arriver que bLogs ait des problèmes à détecter certains addons tiers installés.
		Sur cet écran, vous pouvez forcer bLogs à détecter certains addons tiers.

		Décoché = Comportement par défaut
		Coché = Activation Forcée
		Coché avec une croix = Désactivé]],

		edit_discord_webhooks = "Modifier les Webhooks Discord",
		webhook_name = "Nom du Webhook",
		webhook_name_tip = "Entrez le nom de votre webhook.\nIl ne sagit que d'un identifiant pour le webhook, vous entrerez l'URL dans la prochaine page.",
		webhook = "Webhook",
		webhook_url = "URL Webhook",
		webhook_url_tip = "Copier l'URL webhook de votre serveur discord et collez-la ici.",
		copy_webhook = "Copier Webhook",

		can_access_module = "Peu accéder au Module",
		can_access_all_modules = "Peu accéder à tous les modules",
		all_usergroups = "Tous les Grades",
		all_jobs_in_category = "Tous les métiers dans la catégorie",
		all_teams_in_category = "Toutes les équipes dans la catégorie",
		teams = "Equipes",
		permissions_tip = "Décoché = Hérité de \"%s\"\nCoché = Autorisé à utiliser le module\nCoché avec une croix = Interdit d'utiliser le module",
		all_modules_tip = "Les permissions sont héritées de cette section sauf en cas de substitution.",

		wipes_and_resets = "Nettoyage & Réinitialisations", -- wipes as in data wipes
		disable_buttons = "Désactiver les Boutons",
		enable_buttons = "Activer les Boutons",
		wipe_deepstorage = "Nettoyer le Stockage Interne",
		wipe_session = "Nettoyer les logs de Session",
		wipe_all_logs = "Nettoyer toutes les logs",
		reset_config = "Réinitialiser configuration",

		--####################### LOG PHRASES #######################--
		Logs = {
			round_start     = "DEBUT DE MANCHE",
			round_preparing = "PREPARATION DE MANCHE",
			round_end       = "FIN DE MANCHE",

			connected                                     = "{1} se connecte",
			connected_from_country                        = "{1} se connecte depuis {2}",
			finished_connecting                           = "{1} a fini de se connecter",
			respawned                                     = "{1} réapparu",
			disconnected                                  = "{1} déconnecté ({2})",
			picked_up_weapon                              = "{1} a ramassé une arme {2}",
			picked_up_item                                = "{1} a ramassé un item {2}",
			prop_killed_self                              = "{1} s'est suicidé avec son prop {2}",
			prop_killed_other                             = "{1} a été tué par un prop posé par {2} ({3})",
			prop_killed_world                             = "{1} a été tué par un prop de map {2}",
			prop_damaged_self                             = "{1} s'est infligé {2} de dégats avec son prop {3}",
			prop_damaged_other                            = "{1} a reçu des dégats d'un prop créer par {2} pour {3} dégats ({4})",
			prop_damaged_world                            = "{1} a reçu des dégats par un prop de map {2} pour {3} dégats",
			toolgun_used_their_ent                        = "{1} a utilisé l'outils {2} sur {3}",
			toolgun_used_other_ent                        = "{1} a utilisé l'outils {2} sur {3} créer par {4}",
			toolgun_used_world_ent                        = "{1} a utilisé l'outils {2} sur {3}",
			spawned_effect                                = "{1} a fait apparaitre un effet {2}",
			spawned_npc                                   = "{1} a fait apparaitre un NPC {2}",
			spawned_prop                                  = "{1} a fait apparaitre un prop {2}",
			spawned_ragdoll                               = "{1} a fait apparaitre un ragdoll {2}",
			spawned_sent                                  = "{1} a fait apparaitre un SENT {2}",
			spawned_swep                                  = "{1} a fait apparaitre un SWEP {2}",
			spawned_vehicle                               = "{1} a fait apparaitre un véhicule {2}",

			murder_loot                                   = "{1} a ramassé du butin",

			cinema_video_queued                           = "{1} fait la queue {2} au théâtre {3}",

			ttt_win_traitor                               = "Les Traites ont gagné !",
			ttt_win_innocent                              = "Les Innocents ont gagné !",
			ttt_win_timelimit                             = "Innocents ont gagné - Limite de temps atteinte !",
			ttt_bought                                    = "{1} a acheté {2}",
			ttt_karma                                     = "{1} a été ÉJECTÉ pour faible karma",
			ttt_foundbody                                 = "{1} a trouvé le corps de {2}",
			ttt_founddna                                  = "{1} a trouvé l'ADN de {2} sur son {3}",
			ttt_founddna_corpse                           = "{1} a trouvé l'ADN de {2} sur son cadavre",

			darkrp_agenda_updated                         = "{1} a mis à jour l'agenda {2} pour: {3}",
			darkrp_agenda_removed                         = "{1} a supprimé le {2}",
			darkrp_arrest                                 = "{1} a arrêté {2}",
			darkrp_unarrest                               = "{1} a relaché {2}",
			darkrp_batteringram_owned_success             = "{1} a enfoncé le {2} de {3}",
			darkrp_batteringram_owned_door_success        = "{1} a enfoncé la porte de {2}",
			darkrp_batteringram_success                   = "{1} a enfoncé une {2} sans propriétaire",
			darkrp_batteringram_door_success              = "{1} a enfoncé une porte sans propriétaire",
			darkrp_batteringram_owned_failed              = "{1} n'a pas réussi à enfoncer le {2} de {3}",
			darkrp_batteringram_owned_door_failed         = "{1} n'a pas réussi à enfoncer la porte de {2}",
			darkrp_batteringram_failed                    = "{1} n'a pas réussi à enfoncer la {2} sans propriétaire",
			darkrp_batteringram_door_failed               = "{1} n'a pas réussi à enfoncer une porte sans propriétaire",
			darkrp_cheque_dropped                         = "{1} a posé un chèque de {2} pour {3}",
			darkrp_cheque_picked_up                       = "{1} a empoché un chèque de {2} fait par {3}",
			darkrp_cheque_tore_up                         = "{1} a dériché un chèque de {2} destiné à {3}",
			darkrp_demoted                                = "{1} a rétrogradé {2} pour {3}",
			darkrp_demoted_afk                            = "{1} a été rétrogradé pour avoir été AFK",
			darkrp_door_sold                              = "{1} a vendu une porte",
			darkrp_door_bought                            = "{1} a acheté une porte",
			darkrp_money_dropped                          = "{1} a posé {2}",
			darkrp_money_picked_up                        = "{1} a ramassé {2}",
			darkrp_money_picked_up_owned                  = "{1} a ramassé {2} posé par {3}",
			darkrp_job_changed                            = "{1} a changé de {2} pour {3}",
			darkrp_law_added                              = "{1} a ajouté la loi: {2}",
			darkrp_law_removed                            = "{1} a supprimé la loi: {2}",
			darkrp_purchase                               = "{1} a acheté {2} pour {3}",
			darkrp_purchase_ammo                          = "{1} a acheté {2} munitionjs pour {3}",
			darkrp_purchase_shipment                      = "{1} a acheté une caisse de x{2} {3} pour {4}",
			darkrp_purchase_food                          = "{1} a acheté {2} pour {3}",
			darkrp_weapons_checked                        = "{1} a vérifié l'arme de {2}",
			darkrp_weapons_confiscated                    = "{1} a confisqué les armes de {2}",
			darkrp_weapons_returned                       = "{1} a rendu les armes confisquées de {2}",
			darkrp_filed_warant                           = "{1} a déposé un mandat sur {2} pour: {3}",
			darkrp_warrant_cancelled                      = "{1} a annulé un mandat sur {2}",
			darkrp_set_wanted                             = "{1} recherche {2} pour {3}",
			darkrp_cancelled_wanted                       = "{1} a annulé l'avis de recherche de {2}",
			darkrp_starved                                = "{1} est mort affamé",
			darkrp_pocket_added                           = "{1} a mit {2} dans son sac",
			darkrp_pocket_dropped                         = "{1} a posé {2} depuis son sac",
			darkrp_rpname_change                          = "{1} a changé de nom rp de {2} pour {3}",
			darkrp_started_lockpick_owned_entity          = "{1} a commencé à crocheter {2} possédé par {3}",
			darkrp_started_lockpick_unowned_entity        = "{1} a commencé à crocheter une {2} sans propriétaire",
			darkrp_started_lockpick_owned_door            = "{1} a commencé à crocheter une porte appartenant à {2}",
			darkrp_started_lockpick_unowned_door          = "{1} a commencé à crocheter une porte sans propriétaire",
			darkrp_started_lockpick_own_entity            = "{1} a commencé à crocheter son {2}",
			darkrp_started_lockpick_own_door              = "{1} a commencé à crocheter l'une de ses portes",
			darkrp_successfully_lockpicked_owned_entity   = "{1} a crocheté {2} possédé par {3}",
			darkrp_successfully_lockpicked_unowned_entity = "{1} a crocheté une {2} sans propriétaire",
			darkrp_successfully_lockpicked_owned_door     = "{1} a crocheté une porte appartenant à {2}",
			darkrp_successfully_lockpicked_unowned_door   = "{1} a crocheté une porte sans propriétaire",
			darkrp_successfully_lockpicked_own_entity     = "{1} a crocheté sa {2}",
			darkrp_successfully_lockpicked_own_door       = "{1} a crocheté l'une de ses portes",
			darkrp_failed_lockpick_owned_entity           = "{1} n'a pas réussi à crocheter une {2} possédé par {3}",
			darkrp_failed_lockpick_unowned_entity         = "{1} n'a pas réussi à crocheter une {2} sans propriétaire",
			darkrp_failed_lockpick_owned_door             = "{1} n'a pas réussi à crocheter une porte possédé par {2}",
			darkrp_failed_lockpick_unowned_door           = "{1} n'a pas réussi à crocheter une porte sans propriétaire",
			darkrp_failed_lockpick_own_entity             = "{1} n'a pas réussi à crocheter sa {2}",
			darkrp_failed_lockpick_own_door               = "{1} n'a pas réussi à crocheter l'une de ses portes",
			darkrp_changed_job                            = "{1} a changé de métier de {2} pour {3}",
			darkrp_added_law                              = "{1} a ajouté la loi: {2}",
			darkrp_removed_law                            = "{1} a supprimé la loi: {2}",
			darkrp_hit_accepted                           = "{1} a accepté un contrat sur {2} donné par {3}",
			darkrp_hit_completed                          = "{1} a completé un contrat sur {2} ayant été donné par {3}",
			darkrp_hit_failed                             = "{1} a échoué sur un contrat contre {2} ayant été donné par {3}",
			darkrp_hit_requested                          = "{1} a donné un contrat sur {2} pendant {3} pour {4}",
			darkrp_sold_door                              = "{1} a vendu une porte",
			darkrp_bought_door                            = "{1} a acheté une porte",
			darkrp_dropped_money                          = "{1} a posé {2}",
			darkrp_picked_up_money                        = "{1} a ramassé {2}",
			darkrp_picked_up_money_dropped_by             = "{1} a ramssé {2} ayant été posé(e) par {3}",
			darkrp_afk_demoted                            = "{1} a été rétrogradé pour avoir été AFK",

			pvp_instigator_killed_noweapon                = "{1} {2} a fini un combat et à TUÉ {3} {4} après {5}", -- after X seconds/minutes/hours
			pvp_instigator_killed_weapon                  = "{1} {2} a fini un combat en utilisant {3} et à TUÉ {4} {5} après {6}",
			pvp_instigator_killed_weapons                 = "{1} {2} a fini un combat en utilisant plusieurs armes et à TUÉ {3} {4} après {5}",
			pvp_victim_killed_noweapon                    = "{1} {2} a fini un combat et à ÉTÉ TUÉ PAR {3} {4} après {5}",
			pvp_victim_killed_weapon                      = "{1} {2} a fini un combat en utilisant {3} et A ÉTÉ TUÉ PAR {4} {5} après {6}",
			pvp_victim_killed_weapons                     = "{1} {2} a fini un combat en utilisant plusieurs armes et A ÉTÉ TUÉ PAR {3} {4} après {5}",
			pvp_combat_noweapon                           = "{1} {2} finished combat with {3} {4} après {5}",
			pvp_combat_weapon                             = "{1} {2} a fini un combat en utilisant {3} avec {4} {5} après {6}",
			pvp_combat_weapons                            = "{1} {2} a fini un combat en utilisant plusieurs armes avec {3} {4} après {5}",
			pvp_log_noweapon                              = "{1} a touché {2} infligeant {3} dégats",
			pvp_log_weapon                                = "{1} a touché {2} infligeant {3} dégats avec un(e) {4}",
			pvp_killed                                    = "{1} a tué {2}",
			pvp_vehicle_owned_killed                      = "{1} a été touché et tué par un(e) {2} sans conducteur et appartenant à {3}",
			pvp_vehicle_owned_damaged                     = "{1} a été touché, recevant {2} dégats par {3} sans conducteur, et appartenant à {4}",
			pvp_vehicle_killed                            = "{1} a été touché et tué par un(e) {2} sans conducteur et sans propriétaire",
			pvp_vehicle_damaged                           = "{1} a été touché, recevant {2} dégats par {3} sans conducteur et sans propriétaire",
			pvp_killed_self                               = "{1} s'est suicidé",
			pvp_damaged_self                              = "{1} s'est infligé {2} dégats",

			changed_team                                  = "{1} a changé d'équipe de {2} pour {3}",
			command_used                                  = "{1}: {2}",
			warned_reason                                 = "{1} a été averti par {2} pour {3}",
			warned_noreason                               = "{1} a été averti par {2}",
			warned_kicked                                 = "{1} a été ÉJECTÉ pour avoir dépassé le seuil maximal d'avertissements",
			warned_banned                                 = "{1} a été BANNI pour avoir dépassé le seuil maximal d'avertissements",
			handcuffed                                    = "{1} a menotté {2}",
			handcuffs_broken_by                           = "{1} a libéré {2} de ses menottes",
			handcuffs_broken                              = "{1} s'est libéré de ses menottes",
			npc_health_bought                             = "{1} a acheté de la santé à un PNJ pour {2}",
			npc_armor_bought                              = "{1} a acheté de l'armure à un PNJ pour {2}",
			pac_outfit                                    = "{1} a changé pour une tenue PAC {2}",
			party_chat                                    = "{1} ({2}): {3}",
			party_created                                 = "{1} a créer une partie {2}",
			party_join                                    = "{1} a rejoint une partie {2}",
			party_join_request                            = "{1} a demandé à rejoindre une partie {2}",
			party_invite                                  = "{1} a invité {2} sur la partie {3}",
			party_leave                                   = "{1} a quitté la partie {2}",
			party_kick                                    = "{1} a ejecté {2} de la partie {3}",
			party_disbanded                               = "{1} a supprimé la partie {2}",
			party_abandoned                               = "{1} a quitté le serveur et a abandonné sa partie {2}",
			spraymesh                                     = "{1} a utilisé son spray {2}",
			starwarsvehicle_damage_owned_weapon           = "{1} a infligé des dégats sur Star Wars vehicle {2} possédé par {3} pour {4} dégats avec {5}",
			starwarsvehicle_damage_owned                  = "{1} a infligé des dégats sur Star Wars vehicle {2} possédé par {3} pour {4} dégats",
			starwarsvehicle_damage_weapon                 = "{1} a infligé des dégats sur Star Wars vehicle {2} pour {3} dégats avec {4}",
			starwarsvehicle_damage                        = "{1} a infligé des dégats sur Star Wars vehicle {2} pour {3} dégats",
			wac_damage_owned_weapon                       = "{1} a infligé des dégats sur WAC aircraft {2} possédé par {3} pour {4} dégats avec {5}",
			wac_damage_owned                              = "{1} a infligé des dégats sur WAC aircraft {2} possédé par {3} pour {4} dégats",
			wac_damage_weapon                             = "{1} a infligé des dégats sur WAC aircraft {2} pour {3} dégats avec {4}",
			wac_damage                                    = "{1} a infligé des dégats sur WAC aircraft {2} pour {3} dégats",
			wyozi_cinema_queued                           = "{1} a demandé la vidéo {2} ➞ {3} au cinéma {4}",
			wyozi_dj_queued                               = "{1} a ajouté en file d'attente {2} ➞ {3} sur le canal {4}",
			wyozi_dj_channel_rename                       = "{1} a renommé le canal en {2}",
		}

} end }