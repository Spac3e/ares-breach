--[[


addons/[weapons]_phys_bullet/lua/hab/modules/physbullet/ammotypes.lua

--]]


local MODULE = hab.Module.PhysBullet

MODULE.AmmoTypes = {}
local AmmoTypes = MODULE.AmmoTypes

game.AddAmmoType = function ( tbl )

	if ( !tbl.name ) then return end

	table.insert( AmmoTypes, tbl )
	MODULE.AmmoTypes[tbl.name] = tbl

end

game.BuildAmmoTypes = function( )

	table.SortByMember( AmmoTypes, "name", true )

	return AmmoTypes;

end

MODULE.AddAmmoType = function( AmmoData )

	local data = {

		name = AmmoData.name,
		tracer = AmmoData.tracer or TRACER_NONE,

		dmgtype = AmmoData.dmgtype or DMG_BULLET,
		plydmg = AmmoData.plydmg,
		npcdmg = AmmoData.plydmg,

		force = AmmoData.force or 5,
		minsplash = 0,
		maxsplash = 0,

		maxcarry = AmmoData.maxcarry,
		flags = 0, -- backwards compatability

		Velocity = AmmoData.Velocity or 700,
		Color = AmmoData.Color or HAB_COLOR_RED ,
		EffectSize = math.floor( AmmoData.EffectSize or 1, 16 ),
		HullSize = AmmoData.HullSize or 0,
		Penetration = AmmoData.Penetration or hab.cval.PhysBullet.DefaultPenetrationMult,

		BlastDamage = AmmoData.BlastDamage or false,
		BlastDamageType = AmmoData.BlastDamageType or ( DMG_BLAST + DMG_AIRBOAT ),
		BlastDamageRadius = AmmoData.BlastDamageRadius or 0,

		BalisticsType = AmmoData.BalisticsType or HAB_BULLET_MODEL_G1,
		Fused = AmmoData.Fused or false,
		Proximity = AmmoData.Proximity or false,
		Radius = AmmoData.Radius or hab.cval.PhysBullet.DefaultCaliber,
		TimeToLive = AmmoData.TimeToLive or 10,
		TracerTimeToLive = AmmoData.TracerTimeToLive or 8,

		Caliber = AmmoData.Caliber or hab.cval.PhysBullet.DefaultCaliber,
		Mass = AmmoData.Mass or 8,

		Number = AmmoData.Number or 1,

		BulletType = AmmoData.BulletType or HAB_BULLET_AP

	}

	game.AddAmmoType( data )

end

local Types = {}
local DefaultTypes = {}

DefaultTypes["Default"] = {

	name = "Default",

	plydmg = 25, -- VEL/100

	force = 6.76, -- ENERGY j/100
	maxcarry = 420,

	Velocity = 426, -- VEL m/s
	Color = HAB_COLOR_WHITE,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 9,
	Mass = 7.45, -- MASS g

}

DefaultTypes["Pistol"] = {

	name = "Pistol",

	plydmg = 21, -- VEL/100

	force = 6.76, -- ENERGY j/100
	maxcarry = 420,

	Velocity = 426, -- VEL m/s
	Color = HAB_COLOR_SPRING,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 9,
	Mass = 7.45, -- MASS g

}

DefaultTypes["AR2"] = {

	name = "AR2",

	dmgtype = DMG_AIRBOAT,
	plydmg = 19, -- VEL/100

	force = 40.96, -- ENERGY/100
	maxcarry = 420,

	Velocity = 760, -- VEL m/s
	Color = HAB_COLOR_GREEN,
	Penetration = 15, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 5.56,
	Mass = 12.8, -- MASS g

	BlastDamage = 14,
	BlastDamageRadius = 0.2,

	BulletType = HAB_BULLET_APHE,

}

DefaultTypes["SMG1"] = {

	name = "SMG1",

	plydmg = 15, -- VEL/100

	force = 35.74, -- ENERGY/100
	maxcarry = 420,

	Velocity = 783, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 12, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 7.62,
	Mass = 12, -- MASS g

}

DefaultTypes["357"] = {

	name = "357",

	plydmg = 72, -- VEL/100

	force = 10.62, -- ENERGY/100
	maxcarry = 420,

	Velocity = 520, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 16, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 9,
	Mass = 17, -- MASS g

}

DefaultTypes["Buckshot"] = {

	name = "Buckshot",

	plydmg = 12, -- VEL/100

	force = 20, -- ENERGY/100
	maxcarry = 420,

	Velocity = 400, -- VEL m/s
	Color = HAB_COLOR_BLACK,
	Penetration = 8, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_GS,

	Caliber = 5,
	Mass = 5, -- MASS g

}

DefaultTypes["AirboatGun"] = {

	name = "AirboatGun",

	dmgtype = DMG_AIRBOAT,
	plydmg = 18, -- VEL/100

	force = 201.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 730, -- VEL m/s
	Color = HAB_COLOR_RED,
	Penetration = 26, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_GS,

	Caliber = 7.62,
	Mass = 100, -- MASS g

	BlastDamage = 13,
	BlastDamageRadius = 0.2,

	BulletType = HAB_BULLET_APHE,

	Fused = true,
	TimeToLive = 0.16,

}

DefaultTypes["GaussEnergy"] = {

	name = "GaussEnergy",

	dmgtype = DMG_AIRBOAT,
	plydmg = 25, -- VEL/100

	force = 200, -- ENERGY/100
	maxcarry = 420,

	Velocity = 128, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 50, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_GS,

	Caliber = 5,
	Mass = 0, -- MASS g

	BlastDamage = 16,
	BlastDamageRadius = 1,

	BulletType = HAB_BULLET_HE,

}

DefaultTypes["StriderMinigun"] = {

	name = "StriderMinigun",

	plydmg = 44, -- VEL/100

	force = 501.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 882, -- VEL m/s
	Color = HAB_COLOR_ORANGE,
	Penetration = 80, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G2,

	Caliber = 15,
	Mass = 52, -- MASS g

	BlastDamage = 20,
	BlastDamageRadius = 1,

	BulletType = HAB_BULLET_APHE,

}

DefaultTypes["StriderMinigunDirect"] = {

	name = "StriderMinigunDirect",

	plydmg = 22, -- VEL/100

	force = 501.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 882, -- VEL m/s
	Color = HAB_COLOR_ORANGE,
	Penetration = 80, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G2,

	Caliber = 15,
	Mass = 52, -- MASS g

	BlastDamage = 10,
	BlastDamageRadius = 0.5,

	BulletType = HAB_BULLET_APHE,

}

DefaultTypes["HelicopterGun"] = {

	name = "HelicopterGun",

	plydmg = 10, -- VEL/100

	force = 501.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 882, -- VEL m/s
	Color = HAB_COLOR_AZURE,
	Penetration = 32, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G2,

	Caliber = 5.56,
	Mass = 52, -- MASS g

	BlastDamage = 7,
	BlastDamageRadius = 0.3,

	BulletType = HAB_BULLET_APHE,

}

DefaultTypes["CombineCannon"] = {

	name = "CombineCannon",

	plydmg = 23, -- VEL/100

	force = 501.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 882, -- VEL m/s
	Color = HAB_COLOR_AZURE,
	Penetration = 200, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G2,

	Caliber = 20,
	Mass = 52, -- MASS g

	BlastDamage = 10,
	BlastDamageRadius = 1,

	BulletType = HAB_BULLET_APHE,

}

Types["hab_Pzgr_39_43"] = {

	name = "hab_Pzgr_39_43",

	plydmg = 200, -- VEL/100

	force = 104, -- ENERGY/100
	maxcarry = 80,

	Velocity = 1000, -- VEL m/s
	Color = HAB_COLOR_WHITE,
	Penetration = 235, -- Penetration mm (floor caliber*2)

	BlastDamage = 100,
	BlastDamageRadius = 1.088,

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 88,
	Mass = 10.4, -- MASS g

	BulletType = HAB_BULLET_APHE,

}

Types["hab_SPzgr_L4_5"] = {

	name = "hab_SPzgr_L4_5",

	plydmg = 200, -- VEL/100

	force = 104, -- ENERGY/100
	maxcarry = 80,

	Velocity = 820, -- VEL m/s
	Color = HAB_COLOR_WHITE,
	Penetration = 0.5, -- Penetration mm (floor caliber*2)

	BlastDamage = 200,
	BlastDamageRadius = 9.35,

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 88,
	Mass = 11, -- MASS g

	BulletType = HAB_BULLET_HE,

}

Types["hab_792x57"] = {

	name = "hab_792x57",

	plydmg = 76, -- VEL/100

	force = 40.96, -- ENERGY/100
	maxcarry = 420,

	Velocity = 760, -- VEL m/s
	Color = HAB_COLOR_GREEN,
	Penetration = 14, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 7.92,
	Mass = 12.8, -- MASS g

}

Types["hab_9x19"] = {

	name = "hab_9x19",

	plydmg = 42, -- VEL/100

	force = 6.76, -- ENERGY j/100
	maxcarry = 420,

	Velocity = 426, -- VEL m/s
	Color = HAB_COLOR_SPRING,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 9,
	Mass = 7.45, -- MASS g

}

Types["hab_792x33"] = {

	name = "hab_792x33",

	plydmg = 68, -- VEL/100

	force = 19.09, -- ENERGY/100
	maxcarry = 420,

	Velocity = 685, -- VEL m/s
	Color = HAB_COLOR_CHARTREUSE,
	Penetration = 12, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 7.92,
	Mass = 8.1, -- MASS g

}

Types["hab_763x25"] = {

	name = "hab_763x25",

	plydmg = 44, -- VEL/100

	force = 5.45, -- ENERGY/100
	maxcarry = 420,

	Velocity = 441, -- VEL m/s
	Color = HAB_COLOR_SPRING,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 7.63,
	Mass = 5.6, -- MASS g

}

Types["hab_765x21"] = {

	name = "hab_765x21",

	plydmg = 37, -- VEL/100

	force = 4.12, -- ENERGY/100
	maxcarry = 420,

	Velocity = 370, -- VEL m/s
	Color = HAB_COLOR_SPRING,
	Penetration = 8, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 7.65,
	Mass = 6.03, -- MASS g

}

Types["hab_762x63"] = {

	name = "hab_762x63",

	plydmg = 76, -- VEL/100

	force = 40.42, -- ENERGY/100
	maxcarry = 420,

	Velocity = 760, -- VEL m/s
	Color = HAB_COLOR_RED,
	Penetration = 14, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 7.62,
	Mass = 14, -- MASS g

}

Types["hab_762x33"] = {

	name = "hab_762x33",

	plydmg = 60, -- VEL/100

	force = 13.11, -- ENERGY/100
	maxcarry = 420,

	Velocity = 606, -- VEL m/s
	Color = HAB_COLOR_RED,
	Penetration = 14, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 7.62,
	Mass = 7, -- MASS g

}

Types["hab_1143x23"] = {

	name = "hab_1143x23",

	plydmg = 34, -- VEL/100

	force = 5.06, -- ENERGY/100
	maxcarry = 420,

	Velocity = 255, -- VEL m/s
	Color = HAB_COLOR_RED,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 11.43,
	Mass = 15, -- MASS g

}

Types["hab_125x99"] = {

	name = "hab_125x99",

	plydmg = 88, -- VEL/100

	force = 201.95, -- ENERGY/100
	maxcarry = 420,

	Velocity = 882, -- VEL m/s
	Color = HAB_COLOR_RED,
	Penetration = 26, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 12.5,
	Mass = 52, -- MASS g

}

Types["hab_77x56"] = {

	name = "hab_77x56",

	plydmg = 78, -- VEL/100

	force = 35.74, -- ENERGY/100
	maxcarry = 420,

	Velocity = 783, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 12, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G7,

	Caliber = 7.7,
	Mass = 12, -- MASS g

}

Types["hab_1155×193"] = {

	name = "hab_1155×193",

	plydmg = 37, -- VEL/100

	force = 28.7, -- ENERGY/100
	maxcarry = 420,

	Velocity = 231, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 11.55,
	Mass = 17.2, -- MASS g

}

Types["hab_765x17"] = {

	name = "hab_765x17",

	plydmg = 31, -- VEL/100

	force = 24, -- ENERGY/100
	maxcarry = 420,

	Velocity = 318, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 10, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_G1,

	Caliber = 7.65,
	Mass = 5, -- MASS g

}

Types["hab_12g"] = {

	name = "hab_12g",

	plydmg = 32, -- VEL/100

	force = 40, -- ENERGY/100
	maxcarry = 420,

	Velocity = 400, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 8, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_GS,

	Caliber = 1,
	Mass = 12, -- MASS g

}

Types["hab_20g"] = {

	name = "hab_20g",

	plydmg = 20, -- VEL/100

	force = 24, -- ENERGY/100
	maxcarry = 420,

	Velocity = 350, -- VEL m/s
	Color = HAB_COLOR_YELLOW,
	Penetration = 6, -- Penetration mm (floor caliber*2)

	BalisticsType = HAB_BULLET_MODEL_GS,

	Caliber = 1,
	Mass = 20, -- MASS g

}

hab.hook( "PhysBulletOnAddAmmoTypes", "HAB_Initialize_PhysBullet_Stock_AmmoTypes", function( )

	MODULE.AddAmmoType( {

		name = "generic_hitscan",
		tracer = TRACER_LINE_AND_WHIZ,

	} )

	for k, v in pairs( DefaultTypes ) do -- recursivley add default types
		v.tracer = TRACER_LINE_AND_WHIZ
		MODULE.AddAmmoType( v )

	end

	for k, v in pairs( Types ) do -- recursivley add tracer and non tracer versions of types

		MODULE.AddAmmoType( v )

		v.name = v.name .. "_t"
		v.tracer = TRACER_LINE_AND_WHIZ
		MODULE.AddAmmoType( v )

	end

end )

