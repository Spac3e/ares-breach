-- [[ Global Locals ]]--
BREACH = BREACH or {
	Util = {},
	Meta = {},
	Config = {},
	Round = {GameStarted = GameStarted || false, RoundsTillRestart = RoundsTillRestart or 10},
	NukePos = Vector(-712.862427, 6677.729492, 2225.919189),
	BlackListedSCPPlayers = {}
}

BREACH.Music = BREACH.Music or {}
BREACH.Music.VolumeThinkRate = 0.2
BREACH.Music.IgnoreThinkRate = BREACH.Music.IgnoreThinkRate or false
BREACH.Music.Custom_Volumes = {
	["entrance_zone_2.ogg"] = 0.3,
	["entrance_zone_1.ogg"] = 0.3,

	["light_zone_2.ogg"] = 0.3,
	["light_zone_1.ogg"] = 0.8,

	["heavy_zone_5.ogg"] = 0.3,
	["heavy_zone_2.ogg"] = 0.8,
	["uiu_mission_complete.ogg"] = 1.4,		
}

BREACH.ZombieTextureMaterials = {
	"models/all_scp_models/shared/arms_new",
	"models/all_scp_models/class_d/arms",
	"models/all_scp_models/class_d/arms_b",
	"models/all_scp_models/mog/skin_full_arm_wht_col",
	"models/all_scp_models/class_d/fatheads/fat_head",
	"models/all_scp_models/class_d/fatheads/fat_torso",
	"models/all_scp_models/class_d/body_b",
	"models/all_scp_models/class_d/prisoner_lt_head_d",
	"models/all_scp_models/shared/f_hands/f_hands_white",
	"models/all_scp_models/shared/heads/female/head_1",
	"models/all_scp_models/cultists/vrancis_head",
	"models/all_scp_models/cultists/footmale",
	"models/all_scp_models/sci/shirt_boss",
	"models/all_scp_models/sci/dispatch/dispatch_head",
	"models/all_scp_models/sci/dispatch/dispatch_face",
	"models/all_scp_models/sci/dispatch/skirt",
	"models/all_scp_models/special_sci/special_4/head_sci_4",
	"models/all_scp_models/special_sci/special_4/face_sci_4",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_head",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_face",
	"models/all_scp_models/special_sci/arms",
	"models/all_scp_models/special_sci/tex_0160_0",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_face",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_head",
	"models/all_scp_models/special_sci/special_1/face_sci_1",
	"models/all_scp_models/special_sci/special_1/head_sci_1",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_face",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_head",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_face",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_head",
	"models/all_scp_models/special_sci/mutantskin_diff",
	"models/all_scp_models/special_sci/zed_hans_d",
	"models/all_scp_models/special_sci/spes_head"
}

function BREACH.Msg(message, color, ...)
    color = color or Color(255, 255, 255)
    local timestamp = os.date("[%H:%M:%S]", os.time())
    local prefix = "[Ares Breach]"
    local formattedMessage = string.format(message, ...)

    MsgC(Color(0, 122, 204), prefix, Color(200, 200, 200), " " .. timestamp .. " ", color, formattedMessage .. "\n")
end

function BREACH.Include(path, noprint)
    if not path then return end

    if SERVER then
        if path:find("cl_") then
            if not noprint then
                BREACH.Msg("Pooling CLIENT file: " .. path, Color(255, 128, 0))
            end
            AddCSLuaFile(path)
        elseif path:find("sv_") then
            if not noprint then
                BREACH.Msg("Loading SERVER file: " .. path, Color(0, 255, 255))
            end
            return include(path)
        else
            if not noprint then
                BREACH.Msg("Pooling and loading SHARED file: " .. path, Color(255, 255, 0))
            end
            AddCSLuaFile(path)
            return include(path)
        end
    else
        if not path:find("sv_") then
            if not noprint then
                local fileType = path:find("cl_") and "CLIENT" or "SHARED"
                local color = path:find("cl_") and Color(0, 255, 255) or Color(255, 255, 0)
                BREACH.Msg("Loading " .. fileType .. " file: " .. path, color)
            end
            return include(path)
        end
    end
end

function BREACH.IncludeDir(path, bRecursive, exclude)
    if not path:EndsWith("/") then
        path = path .. "/"
    end

    local dir = GM.FolderName .. "/gamemode/" .. path
    local files, folders = file.Find(dir .. "*", "LUA")

    if exclude and istable(exclude) then
        files = table.Filter(files, function(_, v) return not string.find(v, exclude) end)
        folders = table.Filter(folders, function(_, v) return not string.find(v, exclude) end)
    end

    local formatedpath = path:match("([^/]+)/?$") or "Unknown"
    BREACH.Msg(string.format("Loading folder: %s (%d files, %d subfolders)", formatedpath, #files, #folders), Color(255, 165, 0))

    for _, filename in ipairs(files) do
        BREACH.Include(path .. filename, true)
    end

    if bRecursive then
        for _, folder in ipairs(folders) do
            BREACH.IncludeDir(path .. folder, bRecursive, exclude)
        end
    end
end
