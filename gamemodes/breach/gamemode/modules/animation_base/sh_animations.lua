local Breach = BREACH
local string = string
local math = math
local util = util

BREACH.AnimationTable = {}
BREACH.AnimationTable.AltWalk = {
    ["ar2_altwalk"] = "walkAIMALL1",
    ["revolver_altwalk"] = "walk_revolver",
    ["normal_altwalk"] = "walk_all_Moderate",
    ["smg_altwalk"] = "walkAIMALL1",
}

BREACH.AnimationTable.Soldiers = {
    ["sit"] = "drive_jeep",
    ["idle_shield"] = {"0_shield_idle", "0_shield_idle", "0_shield_idle",},
    ["walk_shield"] = {"0_shield_walk", "0_shield_walk", "0_shield_walk",},
    ["run_shield"] = {"0_shield_run", "0_shield_run", "0_shield_run",},
    ["shield_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["idle_ar2"] = {
        "DOD_StandIdle_PSCHRECK", -------------------------
        "AHL_StandAim_AR",
        "DOD_StandAim_MP40"
    },
    ["walk_ar2"] = {"2alkEasy_all", "2alk_aiming_all", "DOD_w_WalkAim_MP40"},
    ["run_ar2"] = {"2unALL", "2unALL"},
    ["crouch_ar2"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_CrouchAim_AR", "DOD_CrouchIdle_RIFLE"},
    ["reload_ar2"] = "DOD_Reload_MP40",
    ["crouch_reload_ar2"] = "DOD_ReloadCrouch_MP40",
    ["attack_ar2"] = "AHL_Attack_AR",
    ["jump_ar2"] = "AHL_jump_AR",
    ["idle_shotgun"] = {
        "DOD_StandIdle_PSCHRECK", -------------------------
        "AHL_StandAim_SHOTGUN",
        "AHL_StandAim_ZOOMED"
    },
    ["walk_shotgun"] = {"2alkEasy_all", "2alk_aiming_all_SG", "AHL_w_WalkAim_ZOOMED"},
    ["run_shotgun"] = {"2unALL", "2unALL"},
    ["crouch_shotgun"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_CrouchAim_AR", "DOD_CrouchIdle_RIFLE"},
    ["reload_shotgun"] = "DOD_Reload_MP40",
    ["crouch_reload_shotgun"] = "DOD_ReloadCrouch_MP40",
    ["jump_shotgun"] = "AHL_jump_AR",
    ["attack_shotgun"] = "AHL_Attack_SHOTGUN",
    ["knife_idle"] = {
        "AHL_StandAim_KNIFE" ------------------------------
    },
    ["knife_run"] = {"AHL_r_RunAim_KNIFE"},
    ["knife_walk"] = {"AHL_w_WalkAim_KNIFE"},
    ["knife_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["reload_knife"] = "AHL_Reload_PISTOL",
    ["attack_knife"] = {"AHL_Attack_KNIFE", "AHL_Attack_KNIFE2", "AHL_Attack_KNIFE3"},
    ["jump_knife"] = "AHL_jump_KNIFE",
    ["pass_idle"] = {"idle_pistol"},
    ["pass_run"] = {"DOD_r_RunIdle_SPADE"},
    ["pass_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["pass_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_pass"] = "2ump_holding_jump",
    ["axe_idle"] = {
        "shaky_idle_axe" ---------------
    },
    ["axe_run"] = {"shaky_run_axe"},
    ["axe_walk"] = {"shaky_walk_axe"},
    ["axe_crouch"] = {"shaky_crouchwalk_axe", "shaky_crouchidle_axe"},
    ["attack_axe"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_axe"] = "l4d_Jump_Frying_Pan_01",
    ["melee2_idle"] = {
        "aoc_flamberge_idle" ---------------
    },
    ["melee2_run"] = {"run_flamberge"},
    ["melee2_walk"] = {"run_flamberge"},
    ["melee2_crouch"] = {"cwalk_flamberge", "cidle_flamberge"},
    ["attack_melee2"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_melee2"] = "jump_flamberge",
    ["gren_idle"] = {
        "AHL_StandAim_GREN_FRAG", ---------------
        "AHL_StandAim_GREN_FRAG1",
    },
    ["gren_run"] = {"AHL_r_RunAim_GREN_FRAG", "AHL_r_RunAim_GREN_FRAG1",},
    ["gren_walk"] = {"AHL_w_WalkAim_GREN_FRAG", "AHL_w_WalkAim_GREN_FRAG1",},
    ["gren_crouch"] = {"AHL_cw_CrouchWalkAim_GREN_FRAG", "AHL_CrouchAim_GREN_FRAG", "AHL_cw_CrouchWalkAim_GREN_FRAG1", "AHL_CrouchAim_GREN_FRAG1",},
    ["attack_gren"] = "AHL_Attack_GREN_FRAG",
    ["jump_gren"] = "2ump_holding_jump",
    ["crowbar_idle"] = {
        "shaky_idle_melee" ---------------
    },
    ["crowbar_run"] = {"shaky_run_melee"},
    ["crowbar_walk"] = {"shaky_walk_melee"},
    ["crowbar_crouch"] = {"shaky_crouchwalk_melee", "shaky_crouchidle_melee"},
    ["attack_crowbar"] = "l4d_guitar_primary_attack02_LAYER",
    ["jump_crowbar"] = "l4d_Jump_Frying_Pan_01",
    ["jump"] = "AHL_Jump", ---------------
    ["revolver_idle"] = {
        "DOD_StandIdle_PISTOL", ------------------------- -- Safe-mode
        "DOD_StandAim_PISTOL", -- Fire-mode
        "DOD_StandAim_PISTOL" -- Aim-mode
    },
    ["revolver_run"] = {"run_all_01", "AHL_r_RunAim_PISTOL"},
    ["revolver_walk"] = {"DOD_w_WalkIdle_PISTOL", "DOD_w_WalkAim_PISTOL", "DOD_w_WalkAim_PISTOL"},
    ["revolver_crouch"] = {"DOD_cw_CrouchWalkAim_PISTOL", "DOD_c_CrouchWalkIdle_PISTOL", "DOD_CrouchAim_PISTOL", "DOD_CrouchIdle_PISTOL"},
    ["reload_revolver"] = "AHL_Reload_PISTOL",
    ["crouch_reload_revolver"] = "AHL_ReloadCrouch_PISTOL",
    ["attack_revolver"] = "DOD_Attack_PISTOL",
    ["jump_revolver"] = "AHL_jump_PISTOL",
    ["stand_idle"] = "2dle_Unarmed", -------------------------
    ["stand_idlesafemodeoff"] = "2dle_Unarmed",
    ["stand_idleraised"] = "2dle_Unarmed",
    ["stand_run"] = "run_all_01",
    ["stand_runsafemode"] = "run_all_01",
    ["stand_runsafemodeoff"] = "run_all_01",
    ["stand_walk"] = "walk_all",
    ["stand_walkraised"] = "walk_all",
    ["stand_walksafemodeoff"] = "walk_all",
    ["crouch_crouch"] = "DOD_c_CrouchWalkIdle_GREN_STICK",
    ["crouch_crouchsafemodeon"] = "crouchIdle_panicked4",
    ["crouch_crouchsafemodeoff"] = "crouchIdle_panicked4",
    ["smg_idle"] = {
        "DOD_StandIdle_PSCHRECK", -------------------------
        "AHL_StandAim_AR",
        "DOD_StandZoom_BOLT"
    },
    ["smg_walk"] = {"2alkEasy_all", "2alk_aiming_all", "DOD_w_WalkAim_MP40"},
    ["smg_run"] = {"2unALL", "2unALL"},
    ["smg_crouch"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "DOD_CrouchAim_BOLT", "DOD_CrouchIdle_BAZOOKA"},
    ["reload_smg"] = "DOD_Reload_BAR",
    ["crouch_reload_smg"] = "DOD_ReloadCrouch_BAR",
    ["attack_smg"] = "DOD_Attack_MG",
    ["jump_smg"] = "AHL_Jump",
    ["idle_gauss"] = {
        "idle_gravgun", ----------------------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_gauss"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_gauss"] = {"run_physgun", "run_physgun"},
    ["crouch_gauss"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_gauss"] = "DOD_Reload_MP40",
    ["crouch_reload_gauss"] = "DOD_ReloadCrouch_MP40",
    ["attack_gauss"] = "2esture_shoot_ar2",
    ["jump_gauss"] = "AHL_jump_AR",
    ["idle_physgun"] = {
        "idle_gravgun", ----------------------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_physgun"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_physgun"] = {"run_physgun", "run_physgun"},
    ["crouch_physgun"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_physgun"] = "DOD_Reload_MP40",
    ["crouch_reload_physgun"] = "DOD_ReloadCrouch_MP40",
    ["attack_physgun"] = "2esture_shoot_ar2",
    ["jump_physgun"] = "AHL_jump_AR",
    ["idle_camera"] = {
        "idle_camera", ---------------
        "idle_camera",
        "idle_camera"
    },
    ["walk_camera"] = {"walk_camera", "walk_camera", "walk_camera"},
    ["run_camera"] = {"run_camera", "run_camera"},
    ["crouch_camera"] = {"crouch_camera", "crouch_camera", "crouch_camera", "crouch_camera"},
    ["reload_camera"] = "DOD_Reload_MP40",
    ["crouch_reload_camera"] = "DOD_ReloadCrouch_MP40",
    ["attack_camera"] = "2esture_shoot_ar2",
    ["jump_camera"] = "AHL_jump_AR",
    ["slam_idle"] = {
        "idle_slam" ---------------
    },
    ["slam_run"] = {"DOD_s_SprintAim_KNIFE"},
    ["slam_walk"] = {"walk_slam"},
    ["slam_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_KNIFE"},
    ["jump_slam"] = "2ump_holding_jump",
    ["keycard_idle"] = {
        "idle_all_01", -------------------------
        "idle_all_01",
        "idle_all_01"
    },
    ["keycard_run"] = {"DOD_r_RunIdle_SPADE"},
    ["keycard_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["keycard_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_keycard"] = "2ump_holding_jump",
    ["items_idle"] = {
        "idle_slam" -------------------------
    },
    ["items_run"] = {"run_slam"},
    ["items_walk"] = {"walk_slam"},
    ["items_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_SPADE"},
    ["jump_items"] = "2ump_holding_jump",
    ["idle_rpg"] = {
        "DOD_StandIdle_PSCHRECK", ----------------------------------
        "DOD_StandZoom_PSCHRECK",
        "DOD_StandZoom_PSCHRECK"
    },
    ["walk_rpg"] = {"DOD_w_WalkIdle_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK"},
    ["run_rpg"] = {"run_holding_RPG_all", "run_holding_RPG_all", "run_holding_RPG_all"},
    ["crouch_rpg"] = {"DOD_cw_CrouchWalkZoom_PSCHRECK", "DOD_c_CrouchWalkIdle_PSCHRECK", "DOD_CrouchZoom_PSCHRECK", "DOD_CrouchIdle_PSCHRECK"},
    ["reload_rpg"] = "DOD_Reload_PSCHRECK",
    ["attack_rpg"] = "DOD_Attack_PSCHRECK",
    ["jump_rpg"] = "DOD_Jump",
    ["heal_idle"] = {
        "AHL_StandAim_BANDAGES" ----------------------------------
    },
    ["heal_run"] = {"AHL_r_RunAim_BANDAGES"},
    ["heal_walk"] = {"AHL_w_WalkAim_BANDAGES"},
    ["heal_crouch"] = {"AHL_cw_CrouchWalkAim_BANDAGES", "AHL_CrouchAim_BANDAGES"},
    ["jump_heal"] = "AHL_jump_BANDAGES",
    ["idle_normal"] = {
        "idle_all_01" ----------------------------------
    },
    ["walk_normal"] = {"walk_all", "walk_all", "walk_all"},
    ["run_normal"] = {"run_all_01", "run_all_02"},
    ["crouch_normal"] = {"DOD_c_CrouchWalkIdle_PISTOL", "DOD_CrouchIdle_SPADE"},
    ["jump_normal"] = "2ump_holding_jump",
    ["idle_zombie"] = {
        {
            animation = "breach_zombie_idle_raw",
            gesture = "breach_zombie_idle3"
        }
    },
    ["run_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_run2"
        }
    },
    ["walk_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_walk2"
        }
    },
    ["crouch_zombie"] = {"breach_zombie_cwalk_03", "breach_zombie_cidle"},
    ["attack_zombie"] = {"breach_zombie_attack_1", "breach_zombie_attack_2"},
    ["jump_zombie"] = "2ump_holding_jump",
    ["idle_ww2tdm"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_ww2tdm"] = {"run_holding_ar2_all", "run_holding_ar2_all"},
    ["walk_ww2tdm"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_ww2tdm"] = {"Crouch_walk_aiming_all", "Crouch_Idle_RPG", "crouch_aim_smg1", "Crouch_Idle_RPG"},
    ["reload_ww2tdm"] = "DOD_Reload_M1CARBINE",
    ["attack_ww2tdm"] = "AHL_Attack_AR",
    ["jump_ww2tdm"] = "2ump_holding_jump",
}

BREACH.AnimationTable.SCPS = {
    ["scp062fr_idle"] = {
        "idle_melee" ---------------------------------------------------
    },
    ["scp062fr_crouch_idle"] = {"idle_melee"},
    ["scp062fr_walk"] = {"walk_melee"},
    ["scp062fr_crouch_walk"] = {"crouch_walk_upper_knife"},
    ["scp062fr_run"] = {"run_melee2"},
    ["scp062fr_attack"] = {"attack_0", "attack_1", "attack_2",},
    ["scp062fr_secondary_attack"] = {"attack_0", "attack_1", "attack_2",},
    ["scp062fr_crouch_attack"] = {"attack_0", "attack_1", "attack_2",},
    ["scp062fr_crouch_secondary_attack"] = {"attack_0", "attack_1", "attack_2",},
    ["scp062fr_jump"] = {"jump_melee2"},
    ["idle_katana"] = {"wos_judge_b_idle"},
    ["katana_crouch_idle"] = {"h_block"},
    ["walk_katana"] = {"s_run"},
    ["crouch_katana"] = {"s_run"},
    ["katana_run"] = {"s_run"},
    ["katana_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_jump"] = {"h_jump"},
    ["scp638_idle"] = {
        "idle_standing" -------------------------------------------------
    },
    ["scp638_crouch_idle"] = {"crouch_idle_upper_knife"},
    ["scp638_walk"] = {"walk_upper_knife"},
    ["scp638_crouch_walk"] = {"crouch_walk_upper_knife"},
    ["scp638_run"] = {"run_upper_knife"},
    ["scp638_attack"] = {"Flinch_02", "Flinch_02"},
    ["scp638_secondary_attack"] = {"Flinch_02", "Flinch_02"},
    ["scp638_crouch_attack"] = {"Flinch_02", "Flinch_02"},
    ["scp638_crouch_secondary_attack"] = {"Flinch_02", "Flinch_02"},
    ["scp638_jump"] = {"jump"},
    ["scp1015ru_idle"] = {
        "idle_all_02" -------------------------------------------------
    },
    ["scp1015ru_crouch"] = {"DOD_CrouchIdle_SPADE"},
    ["scp1015ru_walk"] = {"walk_all"},
    ["scp1015ru_crouch_walk"] = {"AHL_cw_CrouchWalkAim_KNIFE"},
    ["scp1015ru_run"] = {"run_all"},
    ["scp1015ru_attack"] = {"0_SCP_542_attack_ges", "0_SCP_542_attack_ges"},
    ["scp1015ru_secondary_attack"] = {
        "0_106_attack_gesture_new", --0_106_attack_gesture_new не забудь
        "0_106_attack_gesture_new"
    },
    ["scp1015ru_crouch_attack"] = {"0_SCP_542_attack_ges", "0_SCP_542_attack_ges"},
    ["scp1015ru_crouch_secondary_attack"] = {"0_106_attack_gesture_new", "0_106_attack_gesture_new"},
    ["scp1015ru_jump"] = {"2ump_holding_glide"},
    ["crossbow_idle"] = {
        "scp_2012_Crossbow_idle_2" -------------------------------------------------
    },
    ["crossbow_run"] = {"scp_2012_Crossbow_run"},
    ["crossbow_walk"] = {"scp_2012_Crossbow_walk"},
    ["crossbow_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["crossbow_attack"] = {"scp_2012_Crossbow_shoot"},
    ["crossbow_jump"] = "2ump_holding_jump",
    ["scp811_idle"] = {
        "811_Walk_01" ---------------------------------------------------
    },
    ["scp811_run"] = {"811_Walk_01"},
    ["scp811_walk"] = {"811_Walk_01"},
    ["scp811_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["scp811_attack"] = {"811_Melee_01_layer", "811_Melee_02_layer"},
    ["scp811_jump"] = "2ump_holding_jump",
    ["scp860_idle"] = {
        "idle_knife" ---------------------------------------------------
    },
    ["scp860_run"] = {"run_knife"},
    ["scp860_walk"] = {"walk_knife"},
    ["scp860_crouch"] = {"idle_knife", "walk_knife"},
    ["scp860_attack"] = {"idle_knife", "idle_knife"},
    ["scp860_jump"] = "run_knife",
    ["melee2_idle"] = {
        "idle_melee2" ---------------------------------------------------
    },
    ["melee2_run"] = {"run_melee2"},
    ["melee2_walk"] = {"walk_melee2"},
    ["melee2_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["melee2_attack"] = {"att_4", "att_3"},
    ["melee2_jump"] = "2ump_holding_jump",
    ["idle_mp40"] = {
        "MPF_smg1angryidle1", ---------------------------------------------------
        "MPF_smg1angryidle1",
        "MPF_smg1angryidle1"
    },
    ["walk_mp40"] = {"MPF_walk_aiming_SMG1_all", "MPF_walk_aiming_SMG1_all", "MPF_walk_aiming_SMG1_all"},
    ["run_mp40"] = {"MPF_run_aiming_smg1_all", "MPF_run_aiming_smg1_all"},
    ["crouch_mp40"] = {"DOD_cw_CrouchWalkAim_MP40", "DOD_cw_CrouchWalkAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40"},
    ["reload_mp40"] = "DOD_Reload_MP40",
    ["crouch_reload_mp40"] = "DOD_ReloadCrouch_MP40",
    ["attack_mp40"] = "DOD_Attack_MP40",
    ["jump_mp40"] = "AHL_jump_AR",
    ["tonfa_idle"] = {
        "0_973_idle" ---------------------------------------------------
    },
    ["tonfa_run"] = {"0_973_walk_melee_calm"},
    ["tonfa_walk"] = {"0_973_walk_melee_calm"},
    ["tonfa_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["tonfa_attack"] = {"0_973_attack_swing"},
    ["scp2012_idle"] = {
        "scp_2012_2h_idle_2" ----------------------------------------------------
    },
    ["scp2012_run"] = {"scp_2012_2h_run"},
    ["scp2012_walk"] = {"scp_2012_2h_walk"},
    ["scp2012_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["scp2012_attack"] = {"scp_2012_2h_slash_01", "scp_2012_2h_slash_02"},
    ["scp2012_jump"] = "2ump_holding_jump",
    ["tonfarage_idle"] = {
        "0_973_idle" ---------------------------------------------------
    },
    ["tonfarage_run"] = {"0_973_run"},
    ["tonfarage_walk"] = {"0_973_walk_melee_angry"},
    ["tonfarage_crouch"] = {"idle_melee2", "cwalk_melee2"},
    ["tonfarage_attack"] = "0_973_attack_swing",
    ["tonfarage_jump"] = "2ump_holding_jump",
    ["revolver_idle"] = {
        "DOD_StandIdle_PISTOL", ---------------------------------------------- ------------------------- -- Safe-mode
        "DOD_StandAim_PISTOL", -- Fire-mode
        "DOD_StandAim_PISTOL" -- Aim-mode
    },
    ["revolver_run"] = {"run_all_01", "AHL_r_RunAim_PISTOL"},
    ["revolver_walk"] = {"DOD_w_WalkIdle_PISTOL", "DOD_w_WalkAim_PISTOL", "DOD_w_WalkAim_PISTOL"},
    ["revolver_crouch"] = {"DOD_cw_CrouchWalkAim_PISTOL", "DOD_c_CrouchWalkIdle_PISTOL", "DOD_CrouchAim_PISTOL", "DOD_CrouchIdle_PISTOL"},
    ["reload_revolver"] = "AHL_Reload_PISTOL",
    ["crouch_reload_revolver"] = "AHL_ReloadCrouch_PISTOL",
    ["attack_revolver"] = "DOD_Attack_PISTOL",
    ["jump_revolver"] = "AHL_jump_PISTOL",
    ["shotgun_idle"] = {
        "DOD_StandZoom_RIFLE", ---------------------------------------------------
        "DOD_StandZoom_RIFLE",
        "DOD_StandZoom_RIFLE"
    },
    ["shotgun_run"] = {"DOD_r_RunAim_RIFLE", "DOD_r_RunAim_RIFLE"},
    ["shotgun_walk"] = {"DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE",},
    ["shotgun_crouch"] = {"DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE"},
    ["attack_shotgun"] = "AHL_Attack_SHOTGUN",
    ["scp049_idle"] = {
        "0_049_idle" ---------------------------------------------------
    },
    ["scp049_run"] = {"0_049_walk"},
    ["scp049_walk"] = {"0_049_walk"},
    ["scp049_crouch"] = {"Crouch_walk_all", "crouchIdle_panicked4"},
    ["idle_testhold"] = {
        "idle_all_01", ---------------------------------------------------
        "idle_all_01"
    },
    ["run_testhold"] = {"run_all", "run_all"},
    ["walk_testhold"] = {"walk_all", "walk_all"},
    ["crouch_testhold"] = {"Crouch_walk_all", "crouchIdle_panicked4"},
    ["jump_testhold"] = "2ump_holding_jump",
    ["attack_testhold"] = {"0_SCP_542_attack_ges", "0_SCP_542_attack2_ges"},
    ["idle_sword"] = {
        "aoc_shortswordshield_idle", ---------------
        "aoc_shortswordshield_idle"
    },
    ["scp682_idle"] = {
        "0_Stand_0", ---------------------------------------------------
        "0_Stand_0"
    },
    ["scp682_run"] = {"Run", "Run"},
    ["scp682_walk"] = {"Walk", "Walk"},
    ["jump_scp682"] = "0_JumpStart_56",
    ["attack_scp682"] = {"0_AttackUnarmed_14_gesture", "0_AttackUnarmed_15_gesture"},
    ["idle_bogdan"] = {
        "idle_knife" ---------------------------------------------------
    },
    ["run_bogdan"] = {"run_knife"},
    ["walk_bogdan"] = {"walk_knife"},
    ["crouch_bogdan"] = {"cwalk_knife", "idle_knife"},
    ["attack_bogdan"] = "att_3",
    ["idle_rage"] = {
        "idle_MELEE" ---------------------------------------------------
    },
    ["run_rage"] = {"run_MELEE"},
    ["walk_rage"] = {"walk_MELEE"},
    ["crouch_rage"] = {"idle_Crouch_MELEE", "idle_Crouch_MELEE"},
    ["scp457_idle"] = {
        "457_idle" ---------------------------------------------------
    },
    ["scp457_walk"] = {"457_walk"},
    ["scp457_run"] = {"457_walk"},
    ["scp457_crouch"] = {"457_walk", "457_idle2"},
    ["rifle_idle"] = {
        "DOD_StandZoom_RIFLE", ---------------------------------------------------
        "DOD_StandZoom_RIFLE",
        "DOD_StandZoom_RIFLE"
    },
    ["rifle_run"] = {"DOD_r_RunAim_RIFLE", "DOD_r_RunAim_RIFLE"},
    ["rifle_walk"] = {"DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE",},
    ["rifle_crouch"] = {"DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE"},
    ["attack_rifle"] = "DOD_Attack_RIFLE",
    ["jump_rifle"] = "AHL_Jump",
    ["ar2_idle"] = {
        "DOD_StandZoom_RIFLE", ---------------------------------------------------
        "DOD_StandZoom_RIFLE",
        "DOD_StandZoom_RIFLE"
    },
    ["ar2_run"] = {"DOD_r_RunAim_RIFLE", "DOD_r_RunAim_RIFLE"},
    ["ar2_walk"] = {"DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE", "DOD_w_WalkAim_RIFLE",},
    ["ar2_crouch"] = {"DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE"},
    ["attack_ar2"] = "AHL_Attack_SNIPER",
    ["jump_ar2"] = "AHL_Jump",
    ["knife_idle"] = {
        "AHL_StandAim_KNIFE" ----------------------
    },
    ["knife_run"] = {"AHL_r_RunAim_KNIFE"},
    ["knife_walk"] = {"AHL_w_WalkAim_KNIFE"},
    ["knife_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["reload_knife"] = "AHL_Reload_PISTOL",
    ["attack_knife"] = {"AHL_Attack_KNIFE", "AHL_Attack_KNIFE2", "AHL_Attack_KNIFE3"},
    ["jump_knife"] = "AHL_jump_KNIFE",
    ["scp912_idle"] = {
        "2ombatIdle1_SMG1", ---------------------------------------------------
        "2ombatIdle1_SMG1",
        "2ombatIdle1_SMG1"
    },
    ["scp912_run"] = {"2unAIMALL1", "2unAIMALL1"},
    ["scp912_walk"] = {"2alk_aiming_all", "2alk_aiming_all", "2alk_aiming_all",},
    ["scp912_crouch"] = {"DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE", "DOD_cw_CrouchWalkAim_RIFLE"},
    ["reload_scp912"] = "DOD_Reload_MP40",
    ["attack_scp912"] = "AHL_Attack_AR",
    ["jump_scp912"] = "AHL_Jump",
    ["idle_normal"] = {
        "idle_all_01" ---------------------------------------------------
    },
    ["walk_normal"] = {"walk_all_Moderate"},
    ["run_normal"] = {"walk_all"},
    ["crouch_normal"] = {"Crouch_walk_all", "crouchIdle_panicked4"},
    ["idle_scp106"] = {
        "0_106_Idle_new" ---------------------------------------------------
    },
    ["walk_scp106"] = {"0_106_new_walk"},
    ["run_scp106"] = {"0_106_new_walk"},
    ["attack_scp106"] = "0_106_attack_gesture_new",
    ["crouch_scp106"] = {"Crouch_walk_all", "crouchIdle_panicked4"}
}

BREACH.AnimationTable.Guards = {
    ["idle_shield"] = {"0_shield_idle", "0_shield_idle", "0_shield_idle",},
    ["walk_shield"] = {"0_shield_walk", "0_shield_walk", "0_shield_walk",},
    ["run_shield"] = {"0_shield_run", "0_shield_run", "0_shield_run",},
    ["shield_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["fist_idle"] = "AHL_StandAim_KUNGFU",
    ["fist_walk"] = "AHL_w_WalkAim_KUNGFU",
    ["fist_run"] = "AHL_r_RunAim_KUNGFU",
    ["attack_fist"] = {"AHL_Attack_KUNGFU", "AHL_Attack_KUNGFU2", "AHL_Attack_KUNGFU3", "AHL_Attack_KUNGFU4", "AHL_Attack_KUNGFU5", "AHL_Attack_KUNGFU6"},
    ["crouch_fist"] = {"AHL_cw_CrouchWalkAim_KUNGFU", "AHL_CrouchAim_KUNGFU",},
    ["idle_zombie"] = {
        {
            animation = "breach_zombie_idle_raw",
            gesture = "breach_zombie_idle3"
        }
    },
    ["run_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_run2"
        }
    },
    ["walk_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_walk2"
        }
    },
    ["crouch_zombie"] = {"breach_zombie_cwalk_03", "breach_zombie_cidle"},
    ["attack_zombie"] = {"breach_zombie_attack_1", "breach_zombie_attack_2"},
    ["jump_zombie"] = "2ump_holding_jump",
    ["idle_ww2tdm"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_ww2tdm"] = {"run_holding_ar2_all", "run_holding_ar2_all"},
    ["walk_ww2tdm"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_ww2tdm"] = {"Crouch_walk_aiming_all", "Crouch_Idle_RPG", "crouch_aim_smg1", "Crouch_Idle_RPG"},
    ["reload_ww2tdm"] = "DOD_Reload_M1CARBINE",
    ["attack_ww2tdm"] = "AHL_Attack_AR",
    ["jump_ww2tdm"] = "2ump_holding_jump",
    ["gren_idle"] = {
        "AHL_StandAim_GREN_FRAG", ---------------
        "AHL_StandAim_GREN_FRAG1",
    },
    ["gren_run"] = {"AHL_r_RunAim_GREN_FRAG", "AHL_r_RunAim_GREN_FRAG1",},
    ["gren_walk"] = {"AHL_w_WalkAim_GREN_FRAG", "AHL_w_WalkAim_GREN_FRAG1",},
    ["gren_crouch"] = {"AHL_cw_CrouchWalkAim_GREN_FRAG", "AHL_CrouchAim_GREN_FRAG", "AHL_cw_CrouchWalkAim_GREN_FRAG1", "AHL_CrouchAim_GREN_FRAG1",},
    ["attack_gren"] = "AHL_Attack_GREN_FRAG",
    ["jump_gren"] = "2ump_holding_jump",
    ["idle_smg"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "idle_ar2_aim",
        "Idle_SMG1_Aim_Alert"
    },
    ["run_smg"] = {"run_SMG1_Relaxed_all", "run_holding_ar2_all"},
    ["walk_smg"] = {"walkHOLDALL1_ar2", "walkAlertAim_AR2_ALL1", "DOD_w_WalkAim_RIFLE"},
    ["crouch_smg"] = {"DOD_cw_CrouchWalkAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40"},
    ["reload_smg"] = "DOD_Reload_M1CARBINE",
    ["attack_smg"] = "DOD_Attack_MP44",
    ["jump_smg"] = "AHL_Jump",
    ["idle_rpg"] = {"DOD_StandIdle_PSCHRECK", "DOD_StandZoom_PSCHRECK", "DOD_StandZoom_PSCHRECK"},
    ["walk_rpg"] = {"DOD_w_WalkIdle_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK"},
    ["run_rpg"] = {"run_holding_RPG_all", "run_holding_RPG_all", "run_holding_RPG_all"},
    ["crouch_rpg"] = {"DOD_cw_CrouchWalkZoom_PSCHRECK", "DOD_c_CrouchWalkIdle_PSCHRECK", "DOD_CrouchZoom_PSCHRECK", "DOD_CrouchIdle_PSCHRECK"},
    ["reload_rpg"] = "DOD_Reload_PSCHRECK",
    ["attack_rpg"] = "DOD_Attack_PSCHRECK",
    ["jump_rpg"] = "DOD_Jump",
    ["idle_ar2"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_ar2"] = {"run_SMG1_Relaxed_all", "run_SMG1_Relaxed_all"},
    ["walk_ar2"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_ar2"] = {"DOD_cw_CrouchWalkAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40"},
    ["reload_ar2"] = "DOD_Reload_M1CARBINE",
    ["crouch_reload_ar2"] = "DOD_ReloadCrouch_M1CARBINE",
    ["attack_ar2"] = "DOD_Attack_MP44",
    ["jump_ar2"] = "2ump_holding_jump",
    ["idle_gauss"] = {
        "idle_gravgun", ---------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_gauss"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_gauss"] = {"run_physgun", "run_physgun"},
    ["crouch_gauss"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_gauss"] = "DOD_Reload_MP40",
    ["crouch_reload_gauss"] = "DOD_ReloadCrouch_MP40",
    ["attack_gauss"] = "2esture_shoot_ar2",
    ["jump_gauss"] = "AHL_jump_AR",
    ["idle_physgun"] = {
        "idle_gravgun", ----------------------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_physgun"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_physgun"] = {"run_physgun", "run_physgun"},
    ["crouch_physgun"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_physgun"] = "DOD_Reload_MP40",
    ["crouch_reload_physgun"] = "DOD_ReloadCrouch_MP40",
    ["attack_physgun"] = "2esture_shoot_ar2",
    ["jump_physgun"] = "AHL_jump_AR",
    ["idle_camera"] = {
        "idle_camera", ---------------
        "idle_camera",
        "idle_camera"
    },
    ["walk_camera"] = {"walk_camera", "walk_camera", "walk_camera"},
    ["run_camera"] = {"run_camera", "run_camera"},
    ["crouch_camera"] = {"crouch_camera", "crouch_camera", "crouch_camera", "crouch_camera"},
    ["reload_camera"] = "DOD_Reload_MP40",
    ["crouch_reload_camera"] = "DOD_ReloadCrouch_MP40",
    ["attack_camera"] = "2esture_shoot_ar2",
    ["jump_camera"] = "AHL_jump_AR",
    ["shotgun_idle"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["shotgun_run"] = {"run_SMG1_Relaxed_all", "run_holding_ar2_all"},
    ["shotgun_walk"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["shotgun_crouch"] = {"DOD_cw_CrouchWalkAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40"},
    ["reload_shotgun"] = "DOD_Reload_M1CARBINE",
    ["crouch_reload_shotgun"] = "DOD_ReloadCrouch_M1CARBINE",
    ["attack_shotgun"] = "DOD_Attack_MP44",
    ["jump_shotgun"] = "2ump_holding_jump",
    ["axe_idle"] = {
        "shaky_idle_axe" ---------------
    },
    ["axe_run"] = {"shaky_run_axe"},
    ["axe_walk"] = {"shaky_walk_axe"},
    ["axe_crouch"] = {"shaky_crouchwalk_axe", "shaky_crouchidle_axe"},
    ["attack_axe"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_axe"] = "l4d_Jump_Frying_Pan_01",
    ["melee2_idle"] = {
        "aoc_flamberge_idle" ---------------
    },
    ["melee2_run"] = {"run_flamberge"},
    ["melee2_walk"] = {"run_flamberge"},
    ["melee2_crouch"] = {"cwalk_flamberge", "cidle_flamberge"},
    ["attack_melee2"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_melee2"] = "jump_flamberge",
    ["crowbar_idle"] = {
        "shaky_idle_melee" ---------------
    },
    ["crowbar_run"] = {"shaky_run_melee"},
    ["crowbar_walk"] = {"shaky_walk_melee"},
    ["crowbar_crouch"] = {"shaky_crouchwalk_melee", "shaky_crouchidle_melee"},
    ["attack_crowbar"] = "l4d_guitar_primary_attack02_LAYER",
    ["jump_crowbar"] = "l4d_Jump_Frying_Pan_01",
    ["items_idle"] = {
        "idle_slam" ---------------
    },
    ["items_run"] = {"run_slam"},
    ["items_walk"] = {"walk_slam"},
    ["items_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_SPADE"},
    ["jump_items"] = "2ump_holding_jump",
    ["heal_idle"] = {
        "AHL_StandAim_BANDAGES" ---------------
    },
    ["heal_run"] = {"AHL_r_RunAim_BANDAGES"},
    ["heal_walk"] = {"AHL_w_WalkAim_BANDAGES"},
    ["heal_crouch"] = {"AHL_cw_CrouchWalkAim_BANDAGES", "AHL_CrouchAim_BANDAGES"},
    ["jump_heal"] = "AHL_jump_BANDAGES",
    ["revolver_idle"] = {
        "DOD_StandIdle_PISTOL", --------------
        "DOD_StandAim_PISTOL",
        "DOD_StandAim_PISTOL"
    },
    ["revolver_run"] = {"run_all_01", "AHL_r_RunAim_PISTOL"},
    ["revolver_walk"] = {"DOD_w_WalkIdle_PISTOL", "DOD_w_WalkAim_PISTOL", "DOD_w_WalkAim_PISTOL"},
    ["revolver_crouch"] = {"AHL_cw_CrouchWalkAim_PISTOL", "DOD_c_CrouchWalkIdle_PISTOL", "AHL_CrouchAim_PISTOL", "AHL_CrouchAim_PISTOL"},
    ["reload_revolver"] = "AHL_Reload_PISTOL",
    ["crouch_reload_revolver"] = "AHL_ReloadCrouch_PISTOL",
    ["attack_revolver "] = "AHL_Attack_PISTOL",
    ["jump_revolver"] = "2ump_holding_jump",
    ["idle_katana"] = {"wos_judge_b_idle"},
    ["katana_crouch_idle"] = {"h_block"},
    ["walk_katana"] = {"s_run"},
    ["crouch_katana"] = {"s_run"},
    ["katana_run"] = {"s_run"},
    ["katana_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_jump"] = {"h_jump"},
    ["keycard_idle"] = {
        "idle_all_01", --------------
        "idle_all_01",
        "idle_all_01"
    },
    ["keycard_run"] = {"DOD_r_RunIdle_SPADE"},
    ["keycard_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["keycard_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_keycard"] = "2ump_holding_jump",
    ["pass_idle"] = {
        "idle_pistol" --------------
    },
    ["pass_run"] = {"DOD_r_RunIdle_SPADE"},
    ["pass_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["pass_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_pass"] = "2ump_holding_jump",
    ["knife_idle"] = {
        "AHL_StandAim_KNIFE" --------------
    },
    ["knife_run"] = {"AHL_r_RunAim_KNIFE"},
    ["knife_walk"] = {"AHL_w_WalkAim_KNIFE"},
    ["knife_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["reload_knife"] = "AHL_Reload_PISTOL",
    ["attack_knife"] = {"AHL_Attack_KNIFE", "AHL_Attack_KNIFE2", "AHL_Attack_KNIFE3"},
    ["jump_knife"] = "AHL_jump_KNIFE",
    ["slam_idle"] = {
        "idle_slam", --------------
        "idle_slam",
        "idle_slam",
    },
    ["slam_run"] = {"DOD_s_SprintAim_KNIFE", "DOD_s_SprintAim_KNIFE", "DOD_s_SprintAim_KNIFE",},
    ["slam_walk"] = {"walk_slam", "walk_slam", "walk_slam",},
    ["slam_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_KNIFE", "DOD_CrouchIdle_KNIFE", "DOD_CrouchIdle_KNIFE",},
    ["attack_slam"] = "range_slam",
    ["jump_slam"] = "2ump_holding_jump",
    ["idle_katana"] = {"wos_judge_b_idle"},
    ["katana_crouch_idle"] = {"h_block"},
    ["walk_katana"] = {"s_run"},
    ["crouch_katana"] = {"s_run"},
    ["katana_run"] = {"s_run"},
    ["katana_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_crouch_secondary_attack"] = {"l4d_katana_swing_w2e_layer", "l4d_katana_swing_w2e_layer"},
    ["katana_jump"] = {"h_jump"},
    ["normal_idle"] = {
        "idle_all_01" -------------------------
    },
    ["normal_walk"] = {"walk_all", "walk_all", "walk_all"},
    ["normal_run"] = {"run_all_01", "run_all_02"},
    ["normal_crouch"] = {"DOD_c_CrouchWalkIdle_PISTOL", "DOD_CrouchIdle_SPADE"},
    ["jump_normal"] = "2ump_holding_jump",
    ["stand_run"] = "run_all_01", --[Crowbar, etc animations]-- ---------------
    ["stand_runsafemode"] = "run_all_01",
    ["stand_runsafemodeoff"] = "run_all_01",
    ["stand_walk"] = "walk_all",
    ["stand_walkraised"] = "walk_all",
    ["stand_walksafemodeoff"] = "walk_all",
    ["crouch_crouch"] = "cwalk_all",
    ["crouch_crouchsafemodeon"] = "cwalk_all",
    ["crouch_crouchsafemodeoff"] = "cwalk_all",
    ["crouch"] = ACT_WALK_CROUCH,
    ["jump_jump"] = ACT_JUMP,
    ["sit"] = "drive_jeep"
}

BREACH.AnimationTable.maleHuman = {
    ["idle_shield"] = {"0_shield_idle", "0_shield_idle", "0_shield_idle",},
    ["walk_shield"] = {"0_shield_walk", "0_shield_walk", "0_shield_walk",},
    ["run_shield"] = {"0_shield_run", "0_shield_run", "0_shield_run",},
    ["shield_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["idle_zombie"] = {
        {
            animation = "breach_zombie_idle_raw", ---------------
            gesture = "breach_zombie_idle3"
        }
    },
    ["run_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_run2"
        }
    },
    ["walk_zombie"] = {
        {
            animation = "breach_zombie_run",
            gesture = "breach_zombie_walk2"
        }
    },
    ["crouch_zombie"] = {"breach_zombie_cwalk_03", "breach_zombie_cidle"},
    ["attack_zombie"] = {"breach_zombie_attack_1", "breach_zombie_attack_2"},
    ["jump_zombie"] = "2ump_holding_jump",
    ["idle_katana"] = {
        "h_idle", --------------
        "h_idle"
    },
    ["walk_katana"] = {"h_run", "h_run"},
    ["run_katana"] = {"ryoku_h_run", "ryoku_h_run"},
    ["gren_idle"] = {
        "AHL_StandAim_GREN_FRAG", ---------------
        "AHL_StandAim_GREN_FRAG1",
    },
    ["gren_run"] = {"AHL_r_RunAim_GREN_FRAG", "AHL_r_RunAim_GREN_FRAG1",},
    ["gren_walk"] = {"AHL_w_WalkAim_GREN_FRAG", "AHL_w_WalkAim_GREN_FRAG1",},
    ["gren_crouch"] = {"AHL_cw_CrouchWalkAim_GREN_FRAG", "AHL_CrouchAim_GREN_FRAG", "AHL_cw_CrouchWalkAim_GREN_FRAG1", "AHL_CrouchAim_GREN_FRAG1",},
    ["attack_gren"] = "AHL_Attack_GREN_FRAG",
    ["jump_gren"] = "2ump_holding_jump",
    ["idle_smg"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "idle_ar2_aim",
        "Idle_SMG1_Aim_Alert"
    },
    ["run_smg"] = {"run_SMG1_Relaxed_all", "run_holding_ar2_all"},
    ["walk_smg"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_smg"] = {"DOD_cw_CrouchWalkAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40", "DOD_CrouchAim_MP40"},
    ["reload_smg"] = "DOD_Reload_M1CARBINE",
    ["attack_smg"] = "DOD_Attack_MP44",
    ["jump_smg"] = "AHL_Jump",
    ["idle_rpg"] = {"DOD_StandIdle_PSCHRECK", "DOD_StandZoom_PSCHRECK", "DOD_StandZoom_PSCHRECK"},
    ["walk_rpg"] = {"DOD_w_WalkIdle_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK", "DOD_w_WalkZoom_PSCHRECK"},
    ["run_rpg"] = {"run_holding_RPG_all", "run_holding_RPG_all", "run_holding_RPG_all"},
    ["crouch_rpg"] = {"DOD_cw_CrouchWalkZoom_PSCHRECK", "DOD_c_CrouchWalkIdle_PSCHRECK", "DOD_CrouchZoom_PSCHRECK", "DOD_CrouchIdle_PSCHRECK"},
    ["reload_rpg"] = "DOD_Reload_PSCHRECK",
    ["attack_rpg"] = "DOD_Attack_PSCHRECK",
    ["jump_rpg"] = "DOD_Jump",
    ["idle_ar2"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_ar2"] = {"run_SMG1_Relaxed_all", "run_RPG_Relaxed_all"},
    ["walk_ar2"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_ar2"] = {"Crouch_walk_aiming_all", "Crouch_Idle_RPG", "crouch_aim_smg1", "Crouch_Idle_RPG"},
    ["reload_ar2"] = "DOD_Reload_M1CARBINE",
    ["attack_ar2"] = "DOD_Attack_MP44",
    ["jump_ar2"] = "2ump_holding_jump",
    ["idle_ww2tdm"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_ww2tdm"] = {"run_holding_ar2_all", "run_holding_ar2_all"},
    ["walk_ww2tdm"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_ww2tdm"] = {"Crouch_walk_aiming_all", "Crouch_Idle_RPG", "crouch_aim_smg1", "Crouch_Idle_RPG"},
    ["reload_ww2tdm"] = "DOD_Reload_M1CARBINE",
    ["attack_ww2tdm"] = "AHL_Attack_AR",
    ["jump_ww2tdm"] = "2ump_holding_jump",
    ["idle_gauss"] = {
        "idle_gravgun", ---------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_gauss"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_gauss"] = {"run_physgun", "run_physgun"},
    ["crouch_gauss"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_gauss"] = "DOD_Reload_MP40",
    ["crouch_reload_gauss"] = "DOD_ReloadCrouch_MP40",
    ["attack_gauss"] = "2esture_shoot_ar2",
    ["jump_gauss"] = "AHL_jump_AR",
    ["idle_physgun"] = {
        "idle_gravgun", ----------------------------
        "idle_gravgun",
        "idle_gravgun"
    },
    ["walk_physgun"] = {"walk_physgun", "walk_physgun", "walk_physgun"},
    ["run_physgun"] = {"run_physgun", "run_physgun"},
    ["crouch_physgun"] = {"AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE", "AHL_cw_CrouchWalkAim_AR", "DOD_c_CrouchWalkIdle_RIFLE"},
    ["reload_physgun"] = "DOD_Reload_MP40",
    ["crouch_reload_physgun"] = "DOD_ReloadCrouch_MP40",
    ["attack_physgun"] = "2esture_shoot_ar2",
    ["jump_physgun"] = "AHL_jump_AR",
    ["idle_camera"] = {
        "idle_camera", ---------------
        "idle_camera",
        "idle_camera"
    },
    ["walk_camera"] = {"walk_camera", "walk_camera", "walk_camera"},
    ["run_camera"] = {"run_camera", "run_camera"},
    ["crouch_camera"] = {"cwalk_camera", "cwalk_camera", "cwalk_camera", "cwalk_camera"},
    ["reload_camera"] = "DOD_Reload_MP40",
    ["crouch_reload_camera"] = "DOD_ReloadCrouch_MP40",
    ["attack_camera"] = "2esture_shoot_ar2",
    ["jump_camera"] = "AHL_jump_AR",
    ["shotgun_idle"] = {
        "Idle_Relaxed_SMG1_2", ---------------
        "Idle_SMG1_Aim",
        "idle_ar2_aim"
    },
    ["run_shotgun"] = {"run_SMG1_Relaxed_all", "run_RPG_Relaxed_all"},
    ["walk_shotgun"] = {"2alkEasy_all", "walkAIMALL1_ar2", "walkAIMALL1"},
    ["crouch_shotgun"] = {"Crouch_walk_aiming_all", "Crouch_Idle_RPG", "crouch_aim_smg1", "Crouch_Idle_RPG"},
    ["reload_shotgun"] = "DOD_Reload_M1CARBINE",
    ["crouch_reload_shotgun"] = "DOD_ReloadCrouch_M1CARBINE",
    ["attack_shotgun"] = "DOD_Attack_MP44",
    ["jump_shotgun"] = "2ump_holding_jump",
    ["axe_idle"] = {
        "shaky_idle_axe" ---------------
    },
    ["axe_run"] = {"shaky_run_axe"},
    ["axe_walk"] = {"shaky_walk_axe"},
    ["axe_crouch"] = {"shaky_crouchwalk_axe", "shaky_crouchidle_axe"},
    ["attack_axe"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_axe"] = "l4d_Jump_Frying_Pan_01",
    ["melee2_idle"] = {
        "aoc_flamberge_idle" ---------------
    },
    ["melee2_run"] = {"run_flamberge"},
    ["melee2_walk"] = {"run_flamberge"},
    ["melee2_crouch"] = {"cwalk_flamberge", "cidle_flamberge"},
    ["attack_melee2"] = {"l4d_axe_swing_strong_layer1", "l4d_axe_swing_layer_2"},
    ["jump_melee2"] = "jump_flamberge",
    ["crowbar_idle"] = {
        "shaky_idle_melee" ---------------
    },
    ["crowbar_run"] = {"shaky_run_melee"},
    ["crowbar_walk"] = {"shaky_walk_melee"},
    ["crowbar_crouch"] = {"shaky_crouchwalk_melee", "shaky_crouchidle_melee"},
    ["attack_crowbar"] = "l4d_guitar_primary_attack02_LAYER",
    ["jump_crowbar"] = "l4d_Jump_Frying_Pan_01",
    ["items_idle"] = {
        "idle_slam" ---------------
    },
    ["items_run"] = {"run_slam"},
    ["items_walk"] = {"walk_slam"},
    ["items_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_SPADE"},
    ["jump_items"] = "2ump_holding_jump",
    ["heal_idle"] = {
        "AHL_StandAim_BANDAGES" ---------------
    },
    ["heal_run"] = {"AHL_r_RunAim_BANDAGES"},
    ["heal_walk"] = {"AHL_w_WalkAim_BANDAGES"},
    ["heal_crouch"] = {"AHL_cw_CrouchWalkAim_BANDAGES", "AHL_CrouchAim_BANDAGES"},
    ["jump_heal"] = "AHL_jump_BANDAGES",
    ["revolver_idle"] = {
        "DOD_StandIdle_PISTOL", --------------
        "DOD_StandAim_PISTOL",
        "DOD_StandAim_PISTOL"
    },
    ["revolver_run"] = {"run_all_01", "AHL_r_RunAim_PISTOL"},
    ["revolver_walk"] = {"DOD_w_WalkIdle_PISTOL", "DOD_w_WalkAim_PISTOL", "DOD_w_WalkAim_PISTOL"},
    ["revolver_crouch"] = {"AHL_cw_CrouchWalkAim_PISTOL", "DOD_c_CrouchWalkIdle_PISTOL", "AHL_CrouchAim_PISTOL", "AHL_CrouchAim_PISTOL"},
    ["reload_revolver"] = "AHL_Reload_PISTOL",
    ["attack_revolver"] = "AHL_Attack_PISTOL",
    ["jump_revolver"] = "2ump_holding_jump",
    ["keycard_idle"] = {
        "idle_all_01", --------------
        "idle_all_01",
        "idle_all_01"
    },
    ["keycard_run"] = {"DOD_r_RunIdle_SPADE"},
    ["keycard_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["keycard_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_keycard"] = "2ump_holding_jump",
    ["pass_idle"] = {
        "idle_pistol" --------------
    },
    ["pass_run"] = {"DOD_r_RunIdle_SPADE"},
    ["pass_walk"] = {"DOD_w_WalkIdle_SPADE"},
    ["pass_crouch"] = {"DOD_c_CrouchWalkIdle_SPADE", "DOD_c_CrouchWalkIdle_SPADE"},
    ["jump_pass"] = "2ump_holding_jump",
    ["knife_idle"] = {
        "AHL_StandAim_KNIFE" --------------
    },
    ["knife_run"] = {"AHL_r_RunAim_KNIFE"},
    ["knife_walk"] = {"AHL_w_WalkAim_KNIFE"},
    ["knife_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "AHL_CrouchAim_KNIFE"},
    ["reload_knife"] = "AHL_Reload_PISTOL",
    ["attack_knife"] = {"AHL_Attack_KNIFE", "AHL_Attack_KNIFE2", "AHL_Attack_KNIFE3"},
    ["jump_knife"] = "AHL_jump_KNIFE",
    ["slam_idle"] = {
        "idle_slam", --------------
        "idle_slam",
        "idle_slam",
    },
    ["slam_run"] = {"DOD_s_SprintAim_KNIFE", "DOD_s_SprintAim_KNIFE", "DOD_s_SprintAim_KNIFE",},
    ["slam_walk"] = {"walk_slam", "walk_slam", "walk_slam",},
    ["slam_crouch"] = {"AHL_cw_CrouchWalkAim_KNIFE", "DOD_CrouchIdle_KNIFE", "DOD_CrouchIdle_KNIFE", "DOD_CrouchIdle_KNIFE",},
    ["attack_slam"] = "range_slam",
    ["jump_slam"] = "2ump_holding_jump",
    ["normal_idle"] = {
        "idle_all_01" -------------------------
    },
    ["normal_walk"] = {"walk_all", "walk_all", "walk_all"},
    ["normal_run"] = {"run_all_01", "run_all_02"},
    ["normal_crouch"] = {"DOD_c_CrouchWalkIdle_PISTOL", "DOD_CrouchIdle_SPADE"},
    ["jump_normal"] = "2ump_holding_jump",
    ["stand_run"] = "run_all_01", ---------------
    ["stand_runsafemode"] = "run_all_01",
    ["stand_runsafemodeoff"] = "run_all_01",
    ["stand_walk"] = "walk_all",
    ["stand_walkraised"] = "walk_all",
    ["stand_walksafemodeoff"] = "walk_all",
    ["crouch_crouch"] = "cwalk_all",
    ["crouch_crouchsafemodeon"] = "cwalk_all",
    ["crouch_crouchsafemodeoff"] = "cwalk_all",
    ["crouch"] = ACT_WALK_CROUCH,
    ["jump_jump"] = ACT_JUMP,
    ["falling"] = ACT_ZOMBIE_LEAPING,
    ["sit"] = "drive_jeep"
}

function Breach.AnimationTable:GetForModel(model, key, player)
    if not model then
        debug.Trace()
        return false
    end

    if player and player:IsValid() then
        model = player:GetModel()
    else
        return
    end

    local lowerModel = string.lower(model)
    local animTable = self:GetTable(player, lowerModel)
    local finalAnimation = animTable[key]
    return finalAnimation
end

function Breach.AnimationTable:GetWeaponHoldType(player, weapon, cw_weapon)
    if not (weapon and weapon:IsValid()) then return end
    local class = string.lower(weapon:GetClass())
    local weaponTable = weapons.GetStored(class)
    local holdType
    if not weaponTable then
        holdType = player:GetActiveWeapon():GetHoldType()
    else
        if cw_weapon then
            holdType = weaponTable.NormalHoldType
        else
            holdType = weaponTable.HoldType
            if not holdType then
                weaponTable = weapons.GetStored(weaponTable.Base)
                holdType = weaponTable.HoldType
            end
        end
    end

    if player:GTeam() == TEAM_SCP and player:GetActiveWeapon() ~= NULL then holdType = player:GetActiveWeapon():GetHoldType() end
    if not isstring(holdType) then holdType = "normal" end
    return string.lower(holdType)
end

local soldier_teams = {
    [TEAM_QRT] = true,
    [TEAM_NTF] = true,
    [TEAM_GOC] = true,
    [TEAM_USA] = true,
    [TEAM_CHAOS] = true,
    [TEAM_OSN] = true,
    [TEAM_DZ] = true,
    [TEAM_COTSK] = true,
    [TEAM_NAZI] = true,
    [TEAM_GRU] = true,
}

local guard_teams = {
    [TEAM_GUARD] = true,
    [TEAM_SECURITY] = true
}

local guard_models = {
    ["models/cultist/humans/mog/mog.mdl"] = true,
    ["models/cultist/humans/security/security.mdl"] = true,
    ["models/cultist/humans/mog/mog_hazmat.mdl"] = true,
}

local soldier_models = {
    ["models/cultist/humans/fbi/fbi.mdl"] = true,
    ["models/cultist/humans/ntf/ntf.mdl"] = true,
    ["models/cultist/humans/russian/russians.mdl"] = true,
    ["models/cultist/humans/chaos/chaos.mdl"] = true,
    ["models/cultist/humans/obr/obr.mdl"] = true,
    ["models/cultist/humans/obr/obr_new.mdl"] = true,
    ["models/cultist/humans/osn/osn.mdl"] = true,
}

local banned_roles = {
    ["CI Spy"] = true,
    ["GOC Spy"] = true,
    ["SH Spy"] = true,
    ["UIU Spy"] = true,
    ["Dispatcher"] = true,
}

function Breach.AnimationTable:GetTable(player, model)
    if (soldier_teams[player:GTeam()] and not banned_roles[player:GetRoleName()]) or (player:GetRoleName() == role.ClassD_Hitman and soldier_models[model]) then
        return BREACH.Animations.SoldiersAnimations, "1"
    elseif (guard_teams[player:GTeam()] and not banned_roles[player:GetRoleName()]) or guard_models[model] then
        return BREACH.Animations.GuardAnimations, "2"
    else
        return BREACH.Animations.HumansAnimations, "3"
    end
end

function AnimationTableGetTable(player, model)
    if (soldier_teams[player:GTeam()] and not banned_roles[player:GetRoleName()]) or (player:GetRoleName() == role.ClassD_Hitman and soldier_models[model]) then
        return BREACH.Animations.SoldiersAnimations, "1"
    elseif (guard_teams[player:GTeam()] and not banned_roles[player:GetRoleName()]) or guard_models[model] then
        return BREACH.Animations.GuardAnimations, "2"
    else
        return BREACH.Animations.HumansAnimations, "3"
    end
end

function GetSequenceList(ply)
    if ply and ply:IsValid() then
        local tbl = ply:GetSequenceList()
        local tab = util.TableToJSON(tbl, true)
        if SERVER then
            file.Write("ServerAnimationsVersion" .. math.Round(CurTime()) .. ".txt", tab)
        else
            file.Write("ClientAnimationsVersion" .. math.Round(CurTime()) .. ".txt", tab)
        end
    end
end
--concommand.Add("GetID", GetSequenceList)