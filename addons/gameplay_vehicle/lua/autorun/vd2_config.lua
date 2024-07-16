VD2 = VD2 or {}

CreateConVar("vd2_dt", 0, FCVAR_ARCHIVE)
CreateConVar("vd2_explosionsonly", 0, FCVAR_ARCHIVE)
CreateConVar("vd2_resurrect", 1, FCVAR_ARCHIVE)
CreateConVar("vd2_crash", 1, FCVAR_ARCHIVE)
CreateConVar("vd2_basehp", 1000, FCVAR_ARCHIVE)
CreateConVar("vd2_dietime", 60, FCVAR_ARCHIVE)
CreateConVar("vd2_neverdie", 0, FCVAR_ARCHIVE)
CreateConVar("vd2_mintime", 2, FCVAR_ARCHIVE)
CreateConVar("vd2_maxtime", 15, FCVAR_ARCHIVE)
CreateConVar("vd2_passenger", 1, FCVAR_ARCHIVE)
CreateConVar("vd2_nodamagesounds", 1, FCVAR_ARCHIVE)
CreateConVar("vd2_nokillmat", 0, FCVAR_ARCHIVE)
CreateConVar("vd2_nosabotage", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED)
CreateConVar("vd2_killmat", "models/props_pipes/GutterMetal01a", FCVAR_ARCHIVE)

CreateClientConVar("vd2_hud", 1)
CreateClientConVar("vd2_hud_align_ver", 1)
CreateClientConVar("vd2_hud_align_hor", 0)
CreateClientConVar("vd2_altkeys", 0)
CreateClientConVar("vd2_althud", 0)

VD2.StartSmoke = 0.25
VD2.StartFlame = 0
VD2.ExplosionMagnitude = 100
VD2.BlastDamageMult = 2
VD2.QuadraticDamage = false
VD2.SmokeParticleEffect = "smoke_burning_engine_01"
VD2.FlameParticleEffect = "env_fire_small"
VD2.DeadMaterial = "models/props_pipes/GutterMetal01a"
VD2.DeadColor = Color( 72, 72, 72, 255 )
VD2.FadeTime = 5
VD2.CrashMult = 0.2

VD2.BlockDamageSounds = {
    "physics/metal/metal_box_impact_bullet1.wav",
    "physics/metal/metal_box_impact_bullet2.wav",
    "physics/metal/metal_box_impact_bullet3.wav",
}
VD2.TakeDamageSounds = {
    "physics/metal/metal_computer_impact_bullet1.wav",
    "physics/metal/metal_computer_impact_bullet2.wav",
    "physics/metal/metal_computer_impact_bullet3.wav"
}
VD2.ExplodeSounds = {
    "ambient/explosions/explode_3.wav"
}

function VD2_Options_Client( CPanel )

    CPanel:AddControl("ComboBox", {
        MenuButton = 1,
        Folder = "VD2_Client",
        CVars = {
            "vd2_hud",
            "vd2_hud_align_ver",
            "vd2_hud_align_hor",
            "vd2_althud",
            "vd2_altkeys"
        }
    })

    CPanel:AddControl("Checkbox", {Label = "Enable HUD", Command = "vd2_hud" })
    CPanel:AddControl("Slider", {Label = "HUD Alignment - Vertical", Command = "vd2_hud_align_ver", Min = -1, Max = 1, Type = "int"})
    CPanel:AddControl("Slider", {Label = "HUD Alignment - Horizontal", Command = "vd2_hud_align_hor", Min = -1, Max = 1, Type = "int"})
    CPanel:AddControl("Checkbox", {Label = "Alt HUD", Command = "vd2_althud" })

    CPanel:AddControl("Header", {Description = "(slot1): Lock/Unlock Vehicle\n(slot2): Next Seat"})
end

function VD2_Options_Server( CPanel )

    CPanel:AddControl("ComboBox", {
        MenuButton = 1,
        Folder = "VD2_Server",
        CVars = {
            "vd2_basehp",
            "vd2_dt",
            "vd2_crash",
            "vd2_nokillmat",
            "vd2_explosionsonly",
            "vd2_nodamagesounds",
            "vd2_resurrect",
            "vd2_neverdie",
            "vd2_mintime",
            "vd2_maxtime",
            "vd2_passenger"
        }
    })

    CPanel:AddControl("Slider", {Label = "Base HP", Command = "vd2_basehp", Min = 100, Max = 10000})
    CPanel:AddControl("Slider", {Label = "Damage Threshold", Command = "vd2_dt", Min = 0, Max = 1000})
    CPanel:AddControl("Checkbox", {Label = "Crash Damage", Command = "vd2_crash"})
    CPanel:AddControl("Checkbox", {Label = "Explosions Only", Command = "vd2_explosionsonly"})
    CPanel:AddControl("Checkbox", {Label = "No Damage Sounds", Command = "vd2_nodamagesounds"})
    CPanel:AddControl("Checkbox", {Label = "No Kill Material", Command = "vd2_nokillmat"})

    CPanel:AddControl("Header", {Description = ""})

    CPanel:AddControl("Checkbox", {Label = "Resurrection", Command = "vd2_resurrect"})
    CPanel:AddControl("Checkbox", {Label = "Wrecks Never Despawn", Command = "vd2_neverdie"})
    CPanel:AddControl("Slider", {Label = "Wreck Despawn Time (Sec)", Command = "vd2_dietime", Min = 0, Max = 3600})

    CPanel:AddControl("Header", {Description = ""})

    CPanel:AddControl("Slider", {Label = "Neardeath Time Min", Command = "vd2_mintime", Min = 0, Max = 120})
    CPanel:AddControl("Slider", {Label = "Neardeath Time Max", Command = "vd2_maxtime", Min = 0, Max = 120})

    CPanel:AddControl("Header", {Description = ""})

    CPanel:AddControl("Checkbox", {Label = "Passenger System", Command = "vd2_passenger"})

    CPanel:AddControl("Header", {Description = ""})

    CPanel:AddControl("Checkbox", {Label = "Disable Sabotage", Command = "vd2_nosabotage"})

end

hook.Add( "PopulateToolMenu", "VD2_Options", function()
    spawnmenu.AddToolMenuOption( "Options", "VD2", "VD2_Options_Client", "Client", "", "", VD2_Options_Client)
    spawnmenu.AddToolMenuOption( "Options", "VD2", "VD2_Options_Server", "Server", "", "", VD2_Options_Server)
end )
