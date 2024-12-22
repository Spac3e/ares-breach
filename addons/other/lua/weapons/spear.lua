--[[


addons/[begotten]_advmelee/lua/weapons/spear.lua

--]]

AddCSLuaFile()

SWEP.PrintName		= "Копьё"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.Base = "adv_melee_base"
SWEP.Category = "Advanced Melee"

SWEP.ViewModelFOV	= 90
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= Model("models/aoc_weapon/v_spear.mdl")
SWEP.WorldModel		= Model("models/aoc_weapon/w_spear.mdl")

SWEP.Spawnable		= true
SWEP.AdminOnly		= false

SWEP.UseHands = false

SWEP.SwingWindUp = 625 --ms
SWEP.SwingRelease = 475 --ms
SWEP.SwingRecovery = 800 --ms

SWEP.StabWindUp = 650 --ms
SWEP.StabRelease = 325 --ms
SWEP.StabRecovery = 700 --ms

SWEP.ParryCooldown = 700 --ms
SWEP.ParryWindow = 325 --ms

SWEP.Length = 180 --cm

SWEP.MissCost = 13
SWEP.FeintCost = 10
SWEP.MorphCost = 7
SWEP.StaminaDrain = 20
SWEP.ParryDrainNegation = 13

SWEP.SwingDamage = 10
SWEP.SwingDamageType = DMG_SLASH
SWEP.StabDamage = 70
SWEP.StabDamageType = DMG_SLASH

SWEP.HoldType = "knife" --just for anim base, should be the same as SWEP.MainHoldType
SWEP.MainHoldType = "knife" --we will fall back on this
SWEP.SwingHoldType = "melee2"
SWEP.StabHoldType = "knife"

SWEP.IdleAnimVM = "deflect" --for feint

SWEP.ParryAnim = "aoc_flamberge_block"
SWEP.ParryAnimWeight = 0.9
SWEP.ParryAnimSpeed = 0.7
SWEP.ParryAnimVM = {"block"}

SWEP.SwingAnim = "aoc_flamberge_slash_02"
SWEP.SwingAnimWeight = 1
SWEP.SwingAnimWindUpMultiplier = 6
SWEP.SwingAnimVM = {"swing1", "swing2"}

SWEP.AttackSounds = {
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-01.wav",
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-02.wav",
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-03.wav",
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-04.wav",
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-05.wav",
	"mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-06.wav",
    "mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-07.wav",
    "mordhau/weapons/wooshes/bladedsmall/woosh_bladedsmall-08.wav",
}

--we hit world
SWEP.HitSolidSounds = {
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_01.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_02.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_03.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_04.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_05.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_06.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_07.wav",
	"mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_08.wav",
    "mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_09.wav",
    "mordhau/weapons/block/combined/bladedsmall/sw_bladedsmall_block_10.wav",
}

SWEP.HitParry = {
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_01.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_02.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_03.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_04.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_05.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_06.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_07.wav",
	"mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_08.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_09.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_11.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_12.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_13.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_14.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_15.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_16.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_17.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_18.wav",
    "mordhau/weapons/block/combined/haftedlarge/sw_haftedlarge_19.wav",
}

--sounds from our weapon when we parry
SWEP.ParrySounds = {
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_01.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_02.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_03.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_04.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_05.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_06.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_07.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_08.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_09.wav",
	"mordhau/weapons/block/combined/woodlargeblock/sw_woodlargeblock_10.wav",
}

SWEP.StabWindUpAnim = "aoc_flamberge_stab.smd"
SWEP.StabAnim = "aoc_flamberge_stab.smd"
SWEP.StabAnimWeight = 1
SWEP.StabAnimWindUpMultiplier = 3
SWEP.StabAnimVM = {"stab"}

--sounds when we hit someone with swing
SWEP.GoreSwingSounds = {
	"mordhau/weapons/hits/bladedlarge/hit_bladedlarge_1.wav",
	"mordhau/weapons/hits/bladedlarge/hit_bladedlarge_2.wav",
	"mordhau/weapons/hits/bladedlarge/hit_bladedlarge_3.wav",
	"mordhau/weapons/hits/bladedlarge/hit_bladedlarge_4.wav",
}

--sounds when we hit someone with stab
SWEP.GoreStabSounds = {
	"mordhau/weapons/hits/piercemedium/hit_piercemedium-01.wav",
	"mordhau/weapons/hits/piercemedium/hit_piercemedium-02.wav",
	"mordhau/weapons/hits/piercemedium/hit_piercemedium-03.wav",
	"mordhau/weapons/hits/piercemedium/hit_piercemedium-04.wav",
}