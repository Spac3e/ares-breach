--[[


addons/[weapons]_phys_bullet/lua/hab/modules/physbullet/definitions.lua

--]]


local MODULE = hab.Module.PhysBullet

MODULE.MaterialEffects = {
	[EFFECT_DEFAULT] = {},
	[EFFECT_FLESH] = {},
	[EFFECT_DIRT] = {},
	[EFFECT_GRASS] = {},
	[EFFECT_CONCRETE] = {},
	[EFFECT_BRICK] = {},
	[EFFECT_WOOD] = {},
	[EFFECT_PLASTER] = {},
	[EFFECT_METAL] = {},
	[EFFECT_SAND] = {},
	[EFFECT_SNOW] = {},
	[EFFECT_GRAVEL] = {},
	[EFFECT_WATER] = {},
	[EFFECT_GLASS] = {},
	[EFFECT_TILE] = {},
	[EFFECT_CARPET] = {},
	[EFFECT_ROCK] = {},
	[EFFECT_ICE] = {},
	[EFFECT_PLASTIC] = {},
	[EFFECT_RUBBER] = {},
	[EFFECT_HAY] = {},
	[EFFECT_FOLIAGE] = {},
	[EFFECT_CARDBOARD] = {},
}
-- EFFECT Decals
MODULE.MaterialEffects[EFFECT_DEFAULT].dec		= "ExplosiveGunshot"
MODULE.MaterialEffects[EFFECT_FLESH].dec		= "Impact.BloodyFlesh"
MODULE.MaterialEffects[EFFECT_DIRT].dec			= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_GRASS].dec		= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_CONCRETE].dec		= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_BRICK].dec		= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_WOOD].dec			= "Impact.Wood"
MODULE.MaterialEffects[EFFECT_PLASTER].dec		= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_METAL].dec		= "Impact.Metal"
MODULE.MaterialEffects[EFFECT_SAND].dec			= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_SNOW].dec			= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_GRAVEL].dec		= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_WATER].dec		= "ExplosiveGunshot"
MODULE.MaterialEffects[EFFECT_GLASS].dec		= "Impact.Glass"
MODULE.MaterialEffects[EFFECT_TILE].dec			= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_CARPET].dec		= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_ROCK].dec			= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_ICE].dec			= "Impact.Glass"
MODULE.MaterialEffects[EFFECT_PLASTIC].dec		= "Impact.Concrete"
MODULE.MaterialEffects[EFFECT_RUBBER].dec		= "Impact.Sand"
MODULE.MaterialEffects[EFFECT_HAY].dec			= "Impact.Wood"
MODULE.MaterialEffects[EFFECT_FOLIAGE].dec		= "Impact.Wood"
MODULE.MaterialEffects[EFFECT_CARDBOARD].dec	= "Impact.Concrete"
--EFFECT Sounds
MODULE.MaterialEffects[EFFECT_DEFAULT].snd		= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_FLESH].snd		= "HAB.PhysBullet.Impact.Flesh"
MODULE.MaterialEffects[EFFECT_DIRT].snd			= "HAB.PhysBullet.Impact.Dirt"
MODULE.MaterialEffects[EFFECT_GRASS].snd		= "HAB.PhysBullet.Impact.Dirt"
MODULE.MaterialEffects[EFFECT_CONCRETE].snd		= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_BRICK].snd		= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_WOOD].snd			= "HAB.PhysBullet.Impact.Wood"
MODULE.MaterialEffects[EFFECT_PLASTER].snd		= "HAB.PhysBullet.Impact.Dirt"
MODULE.MaterialEffects[EFFECT_METAL].snd		= "HAB.PhysBullet.Impact.Metal"
MODULE.MaterialEffects[EFFECT_SAND].snd			= "HAB.PhysBullet.Impact.Sand"
MODULE.MaterialEffects[EFFECT_SNOW].snd			= "HAB.PhysBullet.Impact.Snow"
MODULE.MaterialEffects[EFFECT_GRAVEL].snd		= "HAB.PhysBullet.Impact.Dirt"
MODULE.MaterialEffects[EFFECT_WATER].snd		= "HAB.PhysBullet.Impact.Water"
MODULE.MaterialEffects[EFFECT_GLASS].snd		= "HAB.PhysBullet.Impact.Glass"
MODULE.MaterialEffects[EFFECT_TILE].snd			= "HAB.PhysBullet.Impact.Glass"
MODULE.MaterialEffects[EFFECT_CARPET].snd		= "HAB.PhysBullet.Impact.Dirt"
MODULE.MaterialEffects[EFFECT_ROCK].snd			= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_ICE].snd			= "HAB.PhysBullet.Impact.Snow"
MODULE.MaterialEffects[EFFECT_PLASTIC].snd		= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_RUBBER].snd		= "HAB.PhysBullet.Impact.Flesh"
MODULE.MaterialEffects[EFFECT_HAY].snd			= "HAB.PhysBullet.Impact.Concrete"
MODULE.MaterialEffects[EFFECT_FOLIAGE].snd		= "HAB.PhysBullet.Impact.Wood"
MODULE.MaterialEffects[EFFECT_CARDBOARD].snd	= "HAB.PhysBullet.Impact.Dirt"
--EFFECT Particles
--[[
MODULE.MaterialEffects[EFFECT_DEFAULT].pcf		= "doi_impact_dirt"
MODULE.MaterialEffects[EFFECT_FLESH].pcf		= "doi_impact_dirt"
MODULE.MaterialEffects[EFFECT_DIRT].pcf			= "doi_impact_dirt"
MODULE.MaterialEffects[EFFECT_GRASS].pcf		= "doi_impact_grass"
MODULE.MaterialEffects[EFFECT_CONCRETE].pcf		= "doi_impact_concrete"
MODULE.MaterialEffects[EFFECT_BRICK].pcf		= "doi_impact_brick"
MODULE.MaterialEffects[EFFECT_WOOD].pcf			= "doi_impact_wood"
MODULE.MaterialEffects[EFFECT_PLASTER].pcf		= "doi_impact_plaster"
MODULE.MaterialEffects[EFFECT_METAL].pcf		= "doi_impact_metal"
MODULE.MaterialEffects[EFFECT_SAND].pcf			= "doi_impact_sand"
MODULE.MaterialEffects[EFFECT_SNOW].pcf			= "doi_impact_snow"
MODULE.MaterialEffects[EFFECT_GRAVEL].pcf		= "doi_impact_gravel"
MODULE.MaterialEffects[EFFECT_WATER].pcf		= "doi_impact_water"
MODULE.MaterialEffects[EFFECT_GLASS].pcf		= "doi_impact_glass"
MODULE.MaterialEffects[EFFECT_TILE].pcf			= "doi_impact_tile"
MODULE.MaterialEffects[EFFECT_CARPET].pcf		= "doi_impact_carpet"
MODULE.MaterialEffects[EFFECT_ROCK].pcf			= "doi_impact_rock"
MODULE.MaterialEffects[EFFECT_ICE].pcf			= "doi_impact_glass"
MODULE.MaterialEffects[EFFECT_PLASTIC].pcf		= "doi_impact_plastic"
MODULE.MaterialEffects[EFFECT_RUBBER].pcf		= "doi_impact_rubber"
MODULE.MaterialEffects[EFFECT_HAY].pcf			= "doi_impact_wood"
MODULE.MaterialEffects[EFFECT_FOLIAGE].pcf		= "doi_impact_wood"
MODULE.MaterialEffects[EFFECT_CARDBOARD].pcf 	= "doi_impact_cardboard"
]]
MODULE.MaterialEffects[EFFECT_DEFAULT].pcf		= 0
MODULE.MaterialEffects[EFFECT_FLESH].pcf		= 1
MODULE.MaterialEffects[EFFECT_DIRT].pcf			= 2
MODULE.MaterialEffects[EFFECT_GRASS].pcf		= 3
MODULE.MaterialEffects[EFFECT_CONCRETE].pcf		= 4
MODULE.MaterialEffects[EFFECT_BRICK].pcf		= 5
MODULE.MaterialEffects[EFFECT_WOOD].pcf			= 6
MODULE.MaterialEffects[EFFECT_PLASTER].pcf		= 7
MODULE.MaterialEffects[EFFECT_METAL].pcf		= 8
MODULE.MaterialEffects[EFFECT_SAND].pcf			= 9
MODULE.MaterialEffects[EFFECT_SNOW].pcf			= 10
MODULE.MaterialEffects[EFFECT_GRAVEL].pcf		= 11
MODULE.MaterialEffects[EFFECT_WATER].pcf		= 12
MODULE.MaterialEffects[EFFECT_GLASS].pcf		= 13
MODULE.MaterialEffects[EFFECT_TILE].pcf			= 14
MODULE.MaterialEffects[EFFECT_CARPET].pcf		= 15
MODULE.MaterialEffects[EFFECT_ROCK].pcf			= 16
MODULE.MaterialEffects[EFFECT_ICE].pcf			= 17
MODULE.MaterialEffects[EFFECT_PLASTIC].pcf		= 18
MODULE.MaterialEffects[EFFECT_RUBBER].pcf		= 19
MODULE.MaterialEffects[EFFECT_HAY].pcf			= 20
MODULE.MaterialEffects[EFFECT_FOLIAGE].pcf		= 21
MODULE.MaterialEffects[EFFECT_CARDBOARD].pcf	= 22

MODULE.MaterialModifiers = { -- material behavior tables

--[[
	[MATERIAL]	=	{
								ric = {		G1,		G2,		G7,		GS,		GL		}, Ricochetability Multipliers (based on effect to rha)
								pen = {		G1,		G2,		G7,		GS,		GL		}, Penetration Multipliers (based on effect to rha)
								dam = {		G1,		G2,		G7,		GS,		GL		}, Damage Multipliers
								nrm = {		G1,		G2,		G7,		GS,		GL		}, Normalization Effects (based on effect to rha)
							},
]]
	[MAT_ALIENFLESH]	=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},
	[MAT_ANTLION]		=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},
	[MAT_BLOODYFLESH]	=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},
	[MAT_FLESH]			=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},
	[45]				=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},
	[88]				=	{
		ric = 1.1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1.5,	1.5,	1.5,	1.5,	1.5		},
		effect = EFFECT_FLESH,
	},

	[MAT_GLASS]			=	{
		ric = 1,
		pen = {		2,		2,		2,		2,		2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		2,		1,		1.5,	2,		2		},
		effect = EFFECT_GLASS,
	},

	[MAT_DIRT]			=	{
		ric = 1.64,
		pen = {		2.4,	3,		2.8,	1.92,	2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		2,		1,		1.35,	3,		2.8		},
		effect = EFFECT_DIRT,
	},
	[MAT_GRASS]			=	{
		ric = 1.6,
		pen = {		2.4,	3,		2.8,	1.92,	2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		2,		1,		1.35,	3,		2.8		},
		effect = EFFECT_GRASS,
	},

	[MAT_WOOD]			=	{
		ric = 1.7,
		pen = {		2.2,	3,		2.7,	2.5,	2.3		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		2,		1.5,	2,		2		},
		effect = EFFECT_WOOD,
	},
	[MAT_FOLIAGE]		=	{
		ric = 1.65,
		pen = {		3,		3.8,	3.5,	3.3,	3.1		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		2,		1.5,	2,		2		},
		effect = EFFECT_FOLIAGE,
	},

	[MAT_SAND]			=	{
		ric = 1.1,
		pen = {		0.8,	1,		0.9,	0.6,	0.5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		4,		1.5,	3,		4,		4		},
		effect = EFFECT_SAND,
	},
	[MAT_SNOW]			=	{
		ric = 1.1,
		pen = {		3.8,	4,		3.9,	4,		3.6		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		2,		1,		1.5,	1,		1.4		},
		effect = EFFECT_SNOW,
	},
	[MAT_SLOSH]			=	{
		ric = 1.55,
		pen = {		2.9,	3.5,	3.2,	1.8,	1.9		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		4,		1.5,	3,		4,		4		},
		effect = EFFECT_DIRT,
	},

	[MAT_PLASTIC]		=	{
		ric = 1.7,
		pen = {		2.2,	3,		2.7,	2.5,	2.3		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		2,		1,		1.5,	2,		2		},
		effect = EFFECT_PLASTIC,
	},
	[MAT_TILE]			=	{
		ric = 1,
		pen = {		2.5,	2.5,	2.5,	2.5,	2.5		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		1,		1,		1,		1		},
		effect = EFFECT_TILE,
	},
	[MAT_CONCRETE]		=	{
		ric = 1.5,
		pen = {		1.9,	1.5,	1.8,	1.4,	1.3		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		1,		1,		1,		1		},
		effect = EFFECT_CONCRETE,
	},

	[MAT_METAL]			=	{
		ric = 1,
		pen = {		2.3,	2.56,	2.4,	2,		2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		3,		1,		2,		1.8,	2		},
		effect = EFFECT_METAL,
	},
	[MAT_CLIP]			=	{
		ric = 1,
		pen = {		2.3,	2.56,	2.4,	2,		2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		3,		1,		2,		1.8,	2		},
		effect = EFFECT_METAL,
	},
	[MAT_COMPUTER]		=	{
		ric = 1,
		pen = {		2.3,	2.56,	2.4,	2,		2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		3,		1,		2,		1.8,	2		},
		effect = EFFECT_METAL,
	},
	[MAT_VENT]			=	{
		ric = 1,
		pen = {		2.3,	2.56,	2.4,	2,		2		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		3,		1,		2,		1.8,	2		},
		effect = EFFECT_METAL,
	},
	[MAT_GRATE]			=	{
		ric = 1.1,
		pen = {		8,		8,		8,		8,		8		},
		dam = {		1,		1,		1,		1,		1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		1,		1,		1,		1		},
		effect = EFFECT_METAL,
	},

	[MAT_WARPSHIELD]	=	{
		ric = 1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		0.85,	1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		2,		1.5,	2,		2		},
		effect = EFFECT_DEFAULT,
	},
	[MAT_DEFAULT]		=	{
		ric = 1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		0.85,	1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		2,		1.5,	2,		2		},
		effect = EFFECT_DEFAULT,
	},
	[MAT_EGGSHELL]		=	{
		ric = 1,
		pen = {		5.5,	6.8,	6,		6.4,	5		},
		dam = {		1,		1,		1,		0.85,	1		},
		ang = {		1,		1,		1,		1,		1		},
		nrm = {		1,		2,		1.5,	2,		2		},
		effect = EFFECT_DEFAULT,
	},

}

MODULE.SurfaceProperties = {}

MODULE.SurfaceProperties[SURF_DEFAULT] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_SOLIDMETAL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METAL_BOX] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METAL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METAL_BOUNCY] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_SLIPPERYMETAL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METALGRATE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METALVENT] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METALPANEL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_DIRT] = MODULE.MaterialModifiers[MAT_DIRT]

MODULE.SurfaceProperties[SURF_MUD] = MODULE.MaterialModifiers[MAT_SLOSH]

MODULE.SurfaceProperties[SURF_SLIPPERYSLIME] = {
	ric = 1.4,
	pen = {		2.9,	3.5,	3.2,	1.8,	1.9		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		4,		1.5,	3,		4,		4		},
	effect = EFFECT_DEFAULT,
}

MODULE.SurfaceProperties[SURF_GRASS] = MODULE.MaterialModifiers[MAT_GRASS]

MODULE.SurfaceProperties[SURF_TILE] = MODULE.MaterialModifiers[MAT_TILE]

MODULE.SurfaceProperties[SURF_WOOD] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_LOWDENSITY] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_BOX] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_CRATE] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_PLANK] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_SOLID] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_FURNITURE] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WOOD_PANEL] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_WATER] = {
	ric = 1.25,
	pen = {		1,		1,		1,		1,		1		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		1,		1,		1,		1		},
	effect = EFFECT_WATER,
}

MODULE.SurfaceProperties[SURF_SLIME] = MODULE.SurfaceProperties[SURF_SLIPPERYSLIME]

MODULE.SurfaceProperties[SURF_QUICKSAND] = MODULE.MaterialModifiers[MAT_SAND]

MODULE.SurfaceProperties[SURF_WADE] = MODULE.SurfaceProperties[SURF_WATER]

MODULE.SurfaceProperties[SURF_LADDER] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_WOODLADDER] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_GLASS] = MODULE.MaterialModifiers[MAT_GLASS]

MODULE.SurfaceProperties[SURF_COMPUTER] = MODULE.MaterialModifiers[MAT_GLASS]

MODULE.SurfaceProperties[SURF_CONCRETE] = MODULE.MaterialModifiers[MAT_CONCRETE]

MODULE.SurfaceProperties[SURF_ROCK] = {
	ric = 1.95,
	pen = {		2.1,	1.5,	1.8,	1.8,	1.65	},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		1,		1,		1,		1		},
	effect = EFFECT_ROCK,
}

MODULE.SurfaceProperties[SURF_STONE] = MODULE.SurfaceProperties[SURF_ROCK]

MODULE.SurfaceProperties[SURF_PORCELAIN] = MODULE.MaterialModifiers[MAT_TILE]

MODULE.SurfaceProperties[SURF_BOULDER] = MODULE.SurfaceProperties[SURF_ROCK]

MODULE.SurfaceProperties[SURF_GRAVEL] = {
	ric = 1.35,
	pen = {		2.4,	3,		2.8,	1.92,	2		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		2,		1,		1.35,	3,		2.8		},
	effect = EFFECT_GRAVEL,
}

MODULE.SurfaceProperties[SURF_BRICK] = {
	ric = 1.9,
	pen = {		2.6,	2,		2.3,	2.3,	2.2		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		1,		1,		1,		1		},
	effect = EFFECT_BRICK,
}

MODULE.SurfaceProperties[SURF_CONCRETE_BLOCK] = MODULE.SurfaceProperties[SURF_BRICK]

MODULE.SurfaceProperties[SURF_CHAINLINK] = MODULE.MaterialModifiers[MAT_GRATE]

MODULE.SurfaceProperties[SURF_CHAIN] = MODULE.MaterialModifiers[MAT_GRATE]

MODULE.SurfaceProperties[SURF_FLESH] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_BLOODYFLESH] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_ALIENFLESH] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_ARMORFLESH] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_WATERMELON] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_SNOW] = MODULE.MaterialModifiers[MAT_SNOW]

MODULE.SurfaceProperties[SURF_ICE] = {
	ric = 1,
	pen = {		3.8,	4,		3.9,	4,		3.6		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		2,		1,		1.5,	2,		2		},
	effect = EFFECT_ICE,
}

MODULE.SurfaceProperties[SURF_CARPET] = MODULE.MaterialModifiers[MAT_DIRT]

MODULE.SurfaceProperties[SURF_PLASTER] = {
	ric = 1.35,
	pen = {		3.2,	4,		3.7,	3.5,	3.3		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		2,		1.5,	2,		2		},
	effect = EFFECT_PLASTER,
}

MODULE.SurfaceProperties[SURF_CARDBOARD] = {
	ric = 1.1,
	pen = {		6,		6,		6,		6.5,	6		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		1,		1,		1,		1		},
	effect = EFFECT_CARDBOARD,
}

MODULE.SurfaceProperties[SURF_PLASTIC_BARREL] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_PLASTIC_BOX] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_PLASTIC] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_ITEM] = MODULE.SurfaceProperties[SURF_CARDBOARD]

MODULE.SurfaceProperties[SURF_FLOATINGSTANDABLE] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_SAND] = MODULE.MaterialModifiers[MAT_SAND]

MODULE.SurfaceProperties[SURF_RUBBER] = {
	ric = 1.1,
	pen = {		4,		4,		4,		4,		4		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		2,		1,		2,		2,		2		},
	effect = EFFECT_RUBBER,
}

MODULE.SurfaceProperties[SURF_RUBBERTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_JEEPTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_SLIDINGRUBBERTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_BRAKINGRUBBERTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_SLIDINGRUBBERTIRE_FRONT] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_SLIDINGRUBBERTIRE_REAR] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_GLASSBOTTLE] = MODULE.MaterialModifiers[MAT_GLASS]

MODULE.SurfaceProperties[SURF_POTTERY] = MODULE.MaterialModifiers[MAT_TILE]

MODULE.SurfaceProperties[SURF_GRENADE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_CANISTER] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METAL_BARREL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_FLOATING_METAL_BARREL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_PLASTIC_BARREL_BUOYANT] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_ROLLER] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_POPCAN] = {
	ric = 1,
	pen = {		4.3,	4.56,	4.4,	4,		4		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		3,		1,		2,		1.8,	2		},
	effect = EFFECT_METAL,
}

MODULE.SurfaceProperties[SURF_PAINTCAN] = MODULE.SurfaceProperties[SURF_POPCAN]

MODULE.SurfaceProperties[SURF_PAPER] = MODULE.SurfaceProperties[SURF_CARDBOARD]

MODULE.SurfaceProperties[SURF_PAPERCUP] = MODULE.SurfaceProperties[SURF_CARDBOARD]

MODULE.SurfaceProperties[SURF_CEILING_TILE] = MODULE.SurfaceProperties[SURF_PLASTER]

MODULE.SurfaceProperties[SURF_WEAPON] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_DEFAULT_SILENT] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_PLAYER] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_PLAYER_CONTROL_CLIP] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_NO_DECAL] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_FOLIAGE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_CAVERN_ROCK] = MODULE.SurfaceProperties[SURF_ROCK]

MODULE.SurfaceProperties[SURF_HUNTER] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_JALOPYTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_SLIDINGRUBBERTIRE_JALOPYFRONT] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_SLIDINGRUBBERTIRE_JALOPYREAR] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_JALOPY] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_GMOD_ICE] = MODULE.SurfaceProperties[SURF_ICE]

MODULE.SurfaceProperties[SURF_GMOD_BOUNCY] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_GMOD_SILENT] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_METALVEHICLE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_CROWBAR] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_ANTLIONSAND] = MODULE.MaterialModifiers[MAT_SAND]

MODULE.SurfaceProperties[SURF_METAL_SEAFLOORCAR] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_GUNSHIP] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_STRIDER] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_ANTLION] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_COMBINE_METAL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_COMBINE_GLASS] = MODULE.MaterialModifiers[MAT_GLASS]

MODULE.SurfaceProperties[SURF_ZOMBIEFLESH] = MODULE.MaterialModifiers[MAT_FLESH]

MODULE.SurfaceProperties[SURF_PHX_TIRE_NORMAL] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_GM_PS_EGG] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_PHX_EXPLOSIVEBALL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_PHX_FLAKSHELL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_PHX_WW2BOMB] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_GM_TORPEDO] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_GM_PS_WOODENTIRE] = MODULE.MaterialModifiers[MAT_WOOD]

MODULE.SurfaceProperties[SURF_GM_PS_METALTIRE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_GM_PS_SOCCERBALL] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_PHX_RUBBERTIRE] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_PHX_RUBBERTIRE2] = MODULE.SurfaceProperties[SURF_RUBBER]

MODULE.SurfaceProperties[SURF_BRASS_BELL_LARGE] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_BRASS_BELL_MEDIUM] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_BRASS_BELL_SMALL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_BRASS_BELL_SMALLEST] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_HAY] = {
	ric = 1.1,
	pen = {		7,		7,		7,		7,		7		},
	dam = {		1,		1,		1,		1,		1		},
	ang = {		1,		1,		1,		1,		1		},
	nrm = {		1,		1,		1,		1,		1		},
	effect = EFFECT_HAY,
}

MODULE.SurfaceProperties[SURF_METAL_BARRELLIGHT_HL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_METAL_BARREL_HL] = MODULE.MaterialModifiers[MAT_METAL]

MODULE.SurfaceProperties[SURF_PLASTIC_BARREL_VERYBUOYANT] = MODULE.MaterialModifiers[MAT_PLASTIC]

MODULE.SurfaceProperties[SURF_FRICTION_00] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_FRICTION_10] = MODULE.MaterialModifiers[MAT_DEFAULT]

MODULE.SurfaceProperties[SURF_FRICTION_25] = MODULE.MaterialModifiers[MAT_DEFAULT]
