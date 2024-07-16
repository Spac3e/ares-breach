local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
BREACH.ParticlesPrecached = BREACH.ParticlesPrecached or false

if BREACH.ParticlesPrecached then
  return
end

BREACH.ParticlesPrecached = true

--[[Particles]]--
game.AddParticles( "particles/paect_fx.pcf" );
game.AddParticles( "particles/fire_01l4d.pcf" );
game.AddParticles( "particles/fire_infected_fx.pcf" )
game.AddParticles( "particles/vman_nuke.pcf" );
game.AddParticles( "particles/rev_meteor_storm.pcf");
game.AddParticles( "particles/rev_environment.pcf");
game.AddParticles( "particles/smoker_fx.pcf" );
game.AddParticles( "particles/weapon_fx.pcf" );
game.AddParticles( "particles/rev_portals.pcf" )
game.AddParticles( "particles/environment_fx.pcf")
game.AddParticles( "particles/blood_impact.pcf" )
game.AddParticles( "particles/blood_impact_1.pcf" )
game.AddParticles( "particles/neuro_gore.pcf")
game.AddParticles( "particles/fire_fx.pcf" )
game.AddParticles( "particles/gen_dest_fx.pcf" )
game.AddParticles( "particles/power_ups.pcf" )
game.AddParticles( "particles/white_burning_fx.pcf" )
game.AddParticles( "particles/deathangle.pcf" )
game.AddParticles( "particles/deathangle_attack.pcf" )
game.AddParticles( "particles/ayykyu_muzzleflashes.pcf" )
game.AddParticles( "particles/tfa_ballistics.pcf" )
game.AddParticles( "particles/blue_weapon_fx.pcf" )
game.AddParticles( "particles/mephistopheles.pcf" )
game.AddParticles( "particles/raygun.pcf" )
game.AddParticles( "particles/boomer_fx.pcf" )

PrecacheParticleSystem( "fire_big_01" )

PrecacheParticleSystem( "blood_advisor_puncture_withdraw" )
PrecacheParticleSystem( "dustwave_tracer" );
PrecacheParticleSystem( "vman_nuke" );
PrecacheParticleSystem( "engSmokeB_rev" );
PrecacheParticleSystem( "fire_burning_survivor" )
--PrecacheParticleSystem( "burning_fx" );
PrecacheParticleSystem("rgun1_impact");
PrecacheParticleSystem( "smoker_smokecloud" );
PrecacheParticleSystem( "fog_volume_1024_512" )
PrecacheParticleSystem( "weapon_muzzle_flash_smg" )
PrecacheParticleSystem( "aircraft_landing_light_dst" )
PrecacheParticleSystem( "groundfog_street_b")
PrecacheParticleSystem( "weapon_muzzle_flash_shotgun" )
PrecacheParticleSystem( "weapon_muzzle_flash_smg" )
PrecacheParticleSystem( "gas_explosion_ground_wave" )
PrecacheParticleSystem( "missile_hit_seFluidExplosio" )
PrecacheParticleSystem( "portal_magmafalls" )
PrecacheParticleSystem( "tankwall_concrete" )
PrecacheParticleSystem( "steam_manhole" )
PrecacheParticleSystem( "skyscraper_fog_r" )

PrecacheParticleSystem( "white_magnetor" )

PrecacheParticleSystem( "smoke_barrel" )
PrecacheParticleSystem( "pillardust" )
PrecacheParticleSystem( "gas_explosion_main" )

-- [[ Cleymor Effects ]] --

  PrecacheParticleSystem( "gas_explosion_fireball" )
  PrecacheParticleSystem( "gas_explosion_firesmoke" )

----

-- [[ GOC ]] --

  PrecacheParticleSystem( "mr_portal_1a_ff" )
  PrecacheParticleSystem( "mr_portal_1a" )
  PrecacheParticleSystem( "mr_portal_1a_fg" )

----
-- [[ Scarlet King Effects ]] --

  PrecacheParticleSystem( "portal_ring1" )
  PrecacheParticleSystem( "mr_red_mist_big" )
  PrecacheParticleSystem( "mr_hydrogen_aura" )
  PrecacheParticleSystem( "core_finish" )
  PrecacheParticleSystem( "slave_finish" )

----

-- [[ SCP-542 ]] --

  PrecacheParticleSystem( "Blood_Drain2" ) -- Hands.pos
  PrecacheParticleSystem( "infect2" ) -- player death
  PrecacheParticleSystem( "core_dirl1" )
  PrecacheParticleSystem( "death_evil6" ) -- bottom

----
 
-- [[ DZ ]] --

  PrecacheParticleSystem( "portal1_green" )
  PrecacheParticleSystem( "portal4_green" )
  PrecacheParticleSystem( "mr_portal_2a" )
  PrecacheParticleSystem( "mr_portal_2a_fg" )

----

--[[Gore]]--

  PrecacheParticleSystem( "tank_gore_intestine_b" )
  PrecacheParticleSystem( "tank_gore_c" )
  PrecacheParticleSystem( "tank_gore_splatter" )

----

--[[Nuke]]--

  PrecacheParticleSystem( "smoke_traintunnel" )

----

PrecacheParticleSystem( "smoke_gib_01"  )
PrecacheParticleSystem( "fire_small_03" )
PrecacheParticleSystem( "fire_small_01" )

--[[ Special-Heal ]]--

  PrecacheParticleSystem( "mr_effect_03_overflow" )
  PrecacheParticleSystem( "mr_effect_04_ember" )

----

--[[ Special-Accelerator ]]--

  PrecacheParticleSystem( "mr_oxygen" )

----

--[[ Special-DecreaseSCPSpeed ]]--

  PrecacheParticleSystem( "mr_g_fg_activate" )
  PrecacheParticleSystem( "mr_a_fx_1" )

----

--[[ Special Mine ]]--

  PrecacheParticleSystem( "smoker_smokecloud" )

----

--[[ Shocker Effects ]]--

  --PrecacheParticleSystem( "electrical_arc_01_cp0" )
  --PrecacheParticleSystem( "st_elmos_fire_cp0" )

----

--[[ Flashlight ]]--

  PrecacheParticleSystem( "aircraft_landing_light02" )

----

-- [[ SCP-457 ]] --

  PrecacheParticleSystem( "gas_explosion_ground_fire" )

----

--[[ SCP-542 ]]--

  PrecacheParticleSystem( "death_evil4" )
  PrecacheParticleSystem( "slave_alart" )
  PrecacheParticleSystem( "slave_finish" )

----

--[[ SCP-106 ]]--

  PrecacheParticleSystem( "death_evil3" ) -- Player body attachment
  PrecacheParticleSystem( "death_telc" ) -- Player body attachment ( end )
  PrecacheParticleSystem( "death_blood_slave2" ) -- Player bonemerge attachment
  PrecacheParticleSystem( "burning_character_glow_b_white" ) -- White glow on exit_ent

----

-- [[ "Muzzleflashes" ]] --

  PrecacheParticleSystem( "muzzleflash_shotgun" )
  PrecacheParticleSystem( "muzzleflash_shotgun_npc" )
  PrecacheParticleSystem( "muzzleflash_smg_npc" )
  PrecacheParticleSystem( "muzzleflash_suppressed" )
  PrecacheParticleSystem( "muzzleflash_sniper_npc" )
  PrecacheParticleSystem( "muzzleflash_pistol_npc" )
  PrecacheParticleSystem( "muzzleflash_pistol_red" )
  PrecacheParticleSystem( "muzzleflash_6" )
  PrecacheParticleSystem( "muzzleflash_vollmer" )
  PrecacheParticleSystem( "blue_weapon_muzzle_flash" )

---------

-- [[ SH Spawn ]] --

  PrecacheParticleSystem( "Kulkukan_projectile" )
  PrecacheParticleSystem( "Kul_child" )

---------

-- [[ SCP-811 Effects ]] --

  PrecacheParticleSystem( "boomer_vomit" )
  PrecacheParticleSystem( "boomer_vomit_survivor_b" )
  PrecacheParticleSystem( "boomer_vomit_screeneffect" )
  PrecacheParticleSystem( "boomer_leg_smoke" )

  PrecacheParticleSystem( "Poison_Ball" )

  PrecacheParticleSystem( "scp_811_blast" ) -- scp_811_blast

  PrecacheParticleSystem( "Priestess_Ball" )
  PrecacheParticleSystem( "priestess_explosion" )

  PrecacheParticleSystem( "death_comeout" )
  PrecacheParticleSystem( "kul_landing_updownSmoke" )


---------

-- [[ Radioactive effect ]] - -

  PrecacheParticleSystem( "rgun1_impact_pap_child" )

---------

PrecacheParticleSystem( "weapon_muzzle_flash_assaultrifle")
PrecacheParticleSystem( "aircraft_destroy_engineSmoke1" )
PrecacheParticleSystem( "aircraft_destroy_engine_fireball" )
PrecacheParticleSystem( "blood_advisor_pierce_spray" )
--PrecacheParticleSystem( "blood_impact_red_brutal" )
PrecacheParticleSystem( "gen_hit_up" )
--PrecacheParticleSystem( "building_destroyed_01" )
PrecacheParticleSystem( "gen_dest_fireball" )
PrecacheParticleSystem( "fluidExplosion_frames" )
PrecacheParticleSystem( "aircraft_destroy_fireballR1" )
