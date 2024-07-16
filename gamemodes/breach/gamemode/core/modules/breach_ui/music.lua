-- code was kindfully provided by the most notorious lua programmer in the world spac3. I Admit that.

BR_MUSIC_AMBIENT_LZ = 1
BR_MUSIC_AMBIENT_HZ = 2
BR_MUSIC_AMBIENT_OFFICE = 3
BR_MUSIC_AMBIENT_OUTSIDE = 4

BR_MUSIC_FBI_AGENTS_START = 5
BR_MUSIC_FBI_AGENTS_ESCAPE = 6

BR_MUSIC_FBI_AGENTS_LOOP = 16

BR_MUSIC_SPAWN_FBI_AGENTS = 7
BR_MUSIC_SPAWN_FBI = 31
BR_MUSIC_SPAWN_CHAOS = 8
BR_MUSIC_SPAWN_MOG = 9
BR_MUSIC_SPAWN_DZ = 18
BR_MUSIC_SPAWN_OBR = 19
BR_MUSIC_SPAWN_GOC = 20
BR_MUSIC_SPAWN_CULT = 21
BR_MUSIC_SPAWN_NTF = 22
BR_MUSIC_SPAWN_SECURITY = 10
BR_MUSIC_SPAWN_GRU = 34
BR_MUSIC_SPAWN_DEFAULT = 23

BR_MUSIC_TEST = 11

BR_MUSIC_ACTION_LZ = 12
BR_MUSIC_ACTION_HZ = 13
BR_MUSIC_ACTION_OFFICE = 14
BR_MUSIC_ACTION_OUTSIDE = 15

BR_MUSIC_DEATH = 17

BR_MUSIC_OUTRO_GOC_WIN = 24
BR_MUSIC_UIU_WIN = 25
BR_MUSIC_UIU_LOOSE = 26
BR_MUSIC_ESCAPED = 27
BR_MUSIC_COUNTDOWN = 28
BR_MUSIC_GOC_NUKE = 29

BR_MUSIC_DIMENSION_SCP106 = 30

BR_MUSIC_EVACUATION = 33

BR_MUSIC_LIGHTZONE_DECONT = 32

BR_MUSIC_DAK_RITUAL = 35
BR_MUSIC_SPAWN_AMBIENT = 36

local escapesmusic = 6

if SERVER then return end

local volume_misc = "misc"
local volume_spawn = "spawn"
local volume_ambience = "ambience"
local volume_panic = "panic"

local music_path = "sound/no_music/"

local function getpath(m)
	return music_path..m
end

local tab = {}

local function RegisterMusic(id, soundname, playwhenend, volume_type, loop, endat, fade, ispercentendat)

	tab[id] = {}
	tab[id].volumetype = volume_type
	tab[id].soundname = soundname
	tab[id].loop = loop == true

	tab[id].playwhenend = playwhenend

	if endat then
		tab[id].EndAt = endat
		tab[id].IsPercentEndAt = ispercentendat
	end

	if fade then
		tab[id].fade = fade
	end

	tab[id].id = id

end

RegisterMusic(BR_MUSIC_OUTRO_GOC_WIN, getpath("misc/goc_won.ogg"), _, volume_misc) 
RegisterMusic(BR_MUSIC_UIU_WIN, getpath("misc/uiu_mission_complete.ogg"), _, volume_misc) 
RegisterMusic(BR_MUSIC_UIU_LOOSE, getpath("misc/uiu_mission_failed.ogg"), _, volume_misc) 
RegisterMusic(BR_MUSIC_ESCAPED, getpath("misc/pl_escaped.ogg"), _, volume_misc) 
RegisterMusic(BR_MUSIC_COUNTDOWN, getpath("preparing_game.ogg"), _, volume_misc)
RegisterMusic(BR_MUSIC_LIGHTZONE_DECONT, getpath("lz/lightzone_decont_1.ogg"), _, volume_misc, false, 70, 0.1)

local function registerambience(path, ambience_id, action_id)
	local tab = {}
	
	local files = file.Find(path.."*", "GAME")

	local Action = {}
	local default = {}

	for i, v in pairs(files) do
		if v:find("decont") then continue end
		if v:find("action") then
			table.insert(Action, path..v)
		else
			table.insert(default, path..v)
		end
	end

	RegisterMusic(ambience_id,
		default,
		_,
		volume_ambience,
		false,
		0.9,
		0.1,
		true
	)

	RegisterMusic(action_id,
		Action,
		_,
		volume_panic,
		false,
		15,
		0.2
	)

end

registerambience("sound/no_music/hz/", BR_MUSIC_AMBIENT_HZ, BR_MUSIC_ACTION_HZ)
registerambience("sound/no_music/ez/", BR_MUSIC_AMBIENT_OFFICE, BR_MUSIC_ACTION_OFFICE)
registerambience("sound/no_music/lz/", BR_MUSIC_AMBIENT_LZ, BR_MUSIC_ACTION_LZ)
registerambience("sound/no_music/outside/", BR_MUSIC_AMBIENT_OUTSIDE, BR_MUSIC_ACTION_OUTSIDE)

RegisterMusic(BR_MUSIC_TEST, getpath("misc/fbi/fbi_escape_loop.ogg"), _, volume_misc, true, 10, 0.1)
RegisterMusic(BR_MUSIC_FBI_AGENTS_START, getpath("misc/fbi/fbi_action_start.ogg"), BR_MUSIC_FBI_AGENTS_LOOP, volume_misc, false)
RegisterMusic(BR_MUSIC_FBI_AGENTS_LOOP, getpath("misc/fbi/fbi_action_loop.ogg"), _, volume_misc, true)
RegisterMusic(BR_MUSIC_FBI_AGENTS_ESCAPE, getpath("misc/fbi/fbi_escape_loop.ogg"), BR_MUSIC_FBI_AGENTS_LOOP, volume_misc, false)

--[[SPAWNS]]--
RegisterMusic(BR_MUSIC_SPAWN_CHAOS, getpath("factions_spawn/chaos_theme.ogg"), _, volume_spawn, false, 15, 0.1)
RegisterMusic(BR_MUSIC_SPAWN_FBI, getpath("factions_spawn/fbi_spawn.wav"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_GRU, getpath("factions_spawn/gru_theme.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_MOG, getpath("factions_spawn/mtf_intro.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_DZ, getpath("factions_spawn/sh_intro.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_NTF, getpath("factions_spawn/ntf_intro.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_CULT, getpath("factions_spawn/cult_theme.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_GOC, getpath("factions_spawn/goc_intro.ogg"), _, volume_spawn)
RegisterMusic(BR_MUSIC_SPAWN_OBR, getpath("factions_spawn/obr_intro.ogg"), _, volume_spawn, false, 15, 0.1)

local ambient = {}
local evacmusic = {}
local spawnambient = {}
local dimension = {}

for i = 1, 3 do dimension[#dimension + 1] = getpath("dimension/dimension_"..i..".ogg") end
for i = 1, 3 do ambient[#ambient + 1] = getpath("spawn_ambient/start_ambience"..i..".ogg") end
for i = 1, 6 do evacmusic[#evacmusic + 1] = "sound/no_music/evacuation/evacuation_"..i..".ogg" end
for i = 1, 10 do spawnambient[#spawnambient + 1] = "sound/no_music/start_round_ambient/start_ambience"..i..".ogg" end

RegisterMusic(BR_MUSIC_SPAWN_DEFAULT, ambient, _, volume_spawn)
RegisterMusic(BR_MUSIC_EVACUATION, evacmusic, _, volume_misc)
RegisterMusic(BR_MUSIC_SPAWN_AMBIENT, spawnambient, _, volume_misc)
RegisterMusic(BR_MUSIC_GOC_NUKE, getpath("nukes/goc_nuke.ogg"), _, volume_misc, false, 130, 0.2)

--[[MISC]]--
RegisterMusic(BR_MUSIC_DEATH, {getpath("misc/death/death_1.ogg"), getpath("misc/death/death_2.ogg")}, _, volume_misc)
RegisterMusic(BR_MUSIC_DAK_RITUAL, "sound/no_music/dak_ritual_start.ogg", _, volume_misc)
RegisterMusic(BR_MUSIC_DIMENSION_SCP106, dimension, _, volume_misc)

return tab