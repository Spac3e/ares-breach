--[[


addons/[weapons]_phys_bullet/lua/hab/modules/physbullet/sounds.lua

--]]


-------------------------------------------------------
--###################################################-- Explode
-------------------------------------------------------

sound.Add( -- explode small
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Small",
	level = 90,
	sound = {
		"bullet/explode/small_1.wav",
		"bullet/explode/small_2.wav",
		"bullet/explode/small_3.wav"
		},
	volume = 0.85,
	pitch = { 98, 102 },
} )


sound.Add( -- explode medium
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Medium",
	level = 100,
	sound = {
		"bullet/explode/medium_1.wav",
		"bullet/explode/medium_2.wav",
		"bullet/explode/medium_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode medium near
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Medium.Near",
	level = 110,
	sound = {
		"bullet/explode/medium_near_1.wav",
		"bullet/explode/medium_near_2.wav",
		"bullet/explode/medium_near_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode medium far
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Medium.Far",
	level = 120,
	sound = {
		"bullet/explode/medium_far_1.wav",
		"bullet/explode/medium_far_2.wav",
		"bullet/explode/medium_far_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )


sound.Add( -- explode large
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large",
	level = 120,
	sound = {
		"bullet/explode/large_1.wav",
		"bullet/explode/large_2.wav",
		"bullet/explode/large_3.wav",
		"bullet/explode/large_4.wav",
		"bullet/explode/large_5.wav",
		"bullet/explode/large_6.wav",
		"bullet/explode/large_7.wav",
		"bullet/explode/large_8.wav",
		"bullet/explode/large_9.wav",
		"bullet/explode/large_10.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large far
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Far",
	level = 110,
	sound = {
		"bullet/explode/large_far_1.wav",
		"bullet/explode/large_far_2.wav",
		"bullet/explode/large_far_3.wav",
		"bullet/explode/large_far_4.wav",
		"bullet/explode/large_far_5.wav",
		"bullet/explode/large_far_6.wav",
		"bullet/explode/large_far_7.wav",
		"bullet/explode/large_far_8.wav",
		"bullet/explode/large_far_9.wav",
		"bullet/explode/large_far_10.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer concrete
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Concrete",
	level = 125,
	sound = {
		"bullet/explode/large_layer_concrete_1.wav",
		"bullet/explode/large_layer_concrete_2.wav",
		"bullet/explode/large_layer_concrete_3.wav",
		"bullet/explode/large_layer_concrete_4.wav",
		"bullet/explode/large_layer_concrete_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer dirt
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Dirt",
	level = 125,
	sound = {
		"bullet/explode/large_layer_dirt_1.wav",
		"bullet/explode/large_layer_dirt_2.wav",
		"bullet/explode/large_layer_dirt_3.wav",
		"bullet/explode/large_layer_dirt_4.wav",
		"bullet/explode/large_layer_dirt_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer metal
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Metal",
	level = 125,
	sound = {
		"bullet/explode/large_layer_metal_1.wav",
		"bullet/explode/large_layer_metal_2.wav",
		"bullet/explode/large_layer_metal_3.wav",
		"bullet/explode/large_layer_metal_4.wav",
		"bullet/explode/large_layer_metal_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer water
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Water",
	level = 125,
	sound = {
		"bullet/explode/large_layer_water_1.wav",
		"bullet/explode/large_layer_water_2.wav",
		"bullet/explode/large_layer_water_3.wav",
		"bullet/explode/large_layer_water_4.wav",
		"bullet/explode/large_layer_water_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer wood
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Wood",
	level = 125,
	sound = {
		"bullet/explode/large_layer_wood_1.wav",
		"bullet/explode/large_layer_wood_2.wav",
		"bullet/explode/large_layer_wood_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode large layer bass
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Large.Layer.Bass",
	level = 125,
	sound = {
		"bullet/explode/layer_bass_1.wav",
		"bullet/explode/layer_bass_2.wav",
		"bullet/explode/layer_bass_3.wav",
		"bullet/explode/layer_bass_4.wav",
		"bullet/explode/layer_bass_5.wav",
		"bullet/explode/layer_bass_6.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )


sound.Add( -- explode airburst
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Airburst",
	level = 130,
	sound = {
		"bullet/explode/airburst_1.wav",
		"bullet/explode/airburst_2.wav",
		"bullet/explode/airburst_3.wav",
		"bullet/explode/airburst_4.wav"
		},
	volume = 0.8,
	pitch = { 98, 102 },
} )


sound.Add( -- explode flak
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Flak",
	level = 130,
	sound = {
		"bullet/explode/flak_1.wav",
		"bullet/explode/flak_2.wav",
		"bullet/explode/flak_3.wav",
		"bullet/explode/flak_4.wav",
		"bullet/explode/flak_5.wav",
		"bullet/explode/flak_6.wav",
		"bullet/explode/flak_7.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode flak far
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Flak.Far",
	level = 155,
	sound = {
		"bullet/explode/flak_far_1.wav",
		"bullet/explode/flak_far_2.wav",
		"bullet/explode/flak_far_3.wav",
		"bullet/explode/flak_far_4.wav",
		"bullet/explode/flak_far_5.wav",
		"bullet/explode/flak_far_6.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- explode flak layer debris
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Explode.Flak.Layer.Debris",
	level = 90,
	sound = {
		"bullet/explode/flak_layer_debris_1.wav",
		"bullet/explode/flak_layer_debris_2.wav",
		"bullet/explode/flak_layer_debris_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Impacts
-------------------------------------------------------

sound.Add( -- impact large
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large",
	level = 75,
	sound = {
		"^bullet/explode/large_1.wav",
		"^bullet/explode/large_2.wav",
		"^bullet/explode/large_3.wav",
		"^bullet/explode/large_4.wav",
		"^bullet/explode/large_5.wav",
		"^bullet/explode/large_6.wav",
		"^bullet/explode/large_7.wav",
		"^bullet/explode/large_8.wav",
		"^bullet/explode/large_9.wav",
		"^bullet/explode/large_10.wav"
		},
	volume = 0.8,
	pitch = { 98, 102 },
} )

sound.Add( -- impact big
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Big",
	level = 75,
	sound = {
		"^bullet/impact/big_1.wav",
		"^bullet/impact/big_2.wav",
		"^bullet/impact/big_3.wav",
		"^bullet/impact/big_4.wav",
		"^bullet/impact/big_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact debris
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Debris",
	level = 75,
	sound = {
		"^bullet/impact/debris_1.wav",
		"^bullet/impact/debris_2.wav",
		"^bullet/impact/debris_3.wav",
		"^bullet/impact/debris_4.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact concrete
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Concrete",
	level = 75,
	sound = {
		"^bullet/impact/concrete_1.wav",
		"^bullet/impact/concrete_2.wav",
		"^bullet/impact/concrete_3.wav",
		"^bullet/impact/concrete_4.wav",
		"^bullet/impact/concrete_5.wav",
		"^bullet/impact/concrete_6.wav",
		"^bullet/impact/concrete_7.wav",
		"^bullet/impact/concrete_8.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact dirt
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Dirt",
	level = 75,
	sound = {
		"^bullet/impact/dirt_1.wav",
		"^bullet/impact/dirt_2.wav",
		"^bullet/impact/dirt_3.wav",
		"^bullet/impact/dirt_4.wav",
		"^bullet/impact/dirt_5.wav",
		"^bullet/impact/dirt_6.wav",
		"^bullet/impact/dirt_7.wav",
		"^bullet/impact/dirt_8.wav",
		"^bullet/impact/dirt_9.wav",
		"^bullet/impact/dirt_10.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact glass
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Glass",
	level = 75,
	sound = {
		"^bullet/impact/glass_1.wav",
		"^bullet/impact/glass_2.wav",
		"^bullet/impact/glass_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact metal
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Metal",
	level = 75,
	sound = {
		"^bullet/impact/metal_1.wav",
		"^bullet/impact/metal_2.wav",
		"^bullet/impact/metal_3.wav",
		"^bullet/impact/metal_4.wav",
		"^bullet/impact/metal_5.wav",
		"^bullet/impact/metal_6.wav",
		"^bullet/impact/metal_7.wav",
		"^bullet/impact/metal_8.wav",
		"^bullet/impact/metal_9.wav",
		"^bullet/impact/metal_10.wav",
		"^bullet/impact/metal_11.wav",
		"^bullet/impact/metal_12.wav",
		"^bullet/impact/metal_13.wav",
		"^bullet/impact/metal_14.wav",
		"^bullet/impact/metal_15.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact sand
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Sand",
	level = 75,
	sound = {
		"^bullet/impact/sand_1.wav",
		"^bullet/impact/sand_2.wav",
		"^bullet/impact/sand_3.wav",
		"^bullet/impact/sand_4.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact snow
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Snow",
	level = 75,
	sound = {
		"^bullet/impact/snow_1.wav",
		"^bullet/impact/snow_2.wav",
		"^bullet/impact/snow_3.wav",
		"^bullet/impact/snow_4.wav",
		"^bullet/impact/snow_5.wav",
		"^bullet/impact/snow_6.wav",
		"^bullet/impact/snow_7.wav",
		"^bullet/impact/snow_8.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact water
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Water",
	level = 75,
	sound = {
		"^bullet/impact/water_1.wav",
		"^bullet/impact/water_2.wav",
		"^bullet/impact/water_3.wav",
		"^bullet/impact/water_4.wav",
		"^bullet/impact/water_5.wav",
		"^bullet/impact/water_6.wav",
		"^bullet/impact/water_7.wav",
		"^bullet/impact/water_8.wav",
		"^bullet/impact/water_9.wav",
		"^bullet/impact/water_10.wav",
		"^bullet/impact/water_11.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact wood
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Wood",
	level = 75,
	sound = {
		"^bullet/impact/wood_1.wav",
		"^bullet/impact/wood_2.wav",
		"^bullet/impact/wood_3.wav",
		"^bullet/impact/wood_4.wav",
		"^bullet/impact/wood_5.wav",
		"^bullet/impact/wood_6.wav",
		"^bullet/impact/wood_7.wav",
		"^bullet/impact/wood_8.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Impacts Tank Large
-------------------------------------------------------

sound.Add( -- impact large block
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.Block",
	level = 110,
	sound = {
		"bullet/impact/large/block_1.wav",
		"bullet/impact/large/block_2.wav",
		"bullet/impact/large/block_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact large ap
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.AP",
	level = 110,
	sound = {
		"bullet/impact/vehicle/large/ap_1.wav",
		"bullet/impact/vehicle/large/ap_2.wav",
		"bullet/impact/vehicle/large/ap_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact large aphe
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.APHE",
	level = 110,
	sound = {
		"bullet/impact/vehicle/large/aphe_1.wav",
		"bullet/impact/vehicle/large/aphe_2.wav",
		"bullet/impact/vehicle/large/aphe_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact large he
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.HE",
	level = 110,
	sound = {
		"bullet/impact/vehicle/large/he_1.wav",
		"bullet/impact/vehicle/large/he_2.wav",
		"bullet/impact/vehicle/large/he_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact large heat
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.HEAT",
	level = 110,
	sound = {
		"bullet/impact/vehicle/large/heat_1.wav",
		"bullet/impact/vehicle/large/heat_2.wav",
		"bullet/impact/vehicle/large/heat_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact large water
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Large.Water",
	level = 100,
	sound = {
		"bullet/impact/vehicle/large/water_1.wav",
		"bullet/impact/vehicle/large/water_2.wav",
		"bullet/impact/vehicle/large/water_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Impacts Tank Medium
-------------------------------------------------------

sound.Add( -- impact medium block
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Medium.Block",
	level = 105,
	sound = {
		"bullet/impact/medium/block_1.wav",
		"bullet/impact/medium/block_2.wav",
		"bullet/impact/medium/block_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact medium ap
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Medium.AP",
	level = 105,
	sound = {
		"bullet/impact/medium/ap_1.wav",
		"bullet/impact/medium/ap_2.wav",
		"bullet/impact/medium/ap_3.wav",
		"bullet/impact/medium/ap_4.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact medium aphe
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Medium.APHE",
	level = 105,
	sound = {
		"bullet/impact/medium/aphe_1.wav",
		"bullet/impact/medium/aphe_2.wav",
		"bullet/impact/medium/aphe_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact medium he
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Medium.HE",
	level = 105,
	sound = {
		"bullet/impact/medium/he_1.wav",
		"bullet/impact/medium/he_2.wav",
		"bullet/impact/medium/he_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact medium heat
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Medium.HEAT",
	level = 105,
	sound = {
		"bullet/impact/medium/heat_1.wav",
		"bullet/impact/medium/heat_2.wav",
		"bullet/impact/medium/heat_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Impacts Tank Small
-------------------------------------------------------

sound.Add( -- impact small block
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Small.Block",
	level = 105,
	sound = {
		"bullet/impact/small/block_1.wav",
		"bullet/impact/small/block_2.wav",
		"bullet/impact/small/block_3.wav",
		"bullet/impact/small/block_4.wav",
		"bullet/impact/small/block_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact small ap
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Small.AP",
	level = 105,
	sound = {
		"bullet/impact/small/ap_1.wav",
		"bullet/impact/small/ap_2.wav",
		"bullet/impact/small/ap_3.wav",
		"bullet/impact/small/ap_4.wav",
		"bullet/impact/small/ap_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact small aphe
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Small.APHE",
	level = 105,
	sound = {
		"bullet/impact/small/aphe_1.wav",
		"bullet/impact/small/aphe_2.wav",
		"bullet/impact/small/aphe_3.wav",
		"bullet/impact/small/aphe_4.wav",
		"bullet/impact/small/aphe_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact small he
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Small.HE",
	level = 105,
	sound = {
		"bullet/impact/small/he_1.wav",
		"bullet/impact/small/he_2.wav",
		"bullet/impact/small/he_3.wav",
		"bullet/impact/small/he_4.wav",
		"bullet/impact/small/he_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- impact small heat
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Small.HEAT",
	level = 105,
	sound = {
		"bullet/impact/small/heat_1.wav",
		"bullet/impact/small/heat_2.wav",
		"bullet/impact/small/heat_3.wav",
		"bullet/impact/small/heat_4.wav",
		"bullet/impact/small/heat_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Impacts Entities
-------------------------------------------------------

sound.Add( -- impact player
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Player",
	level = 70,
	sound = {
		"bullet/impact/player/impact_01.wav",
		"bullet/impact/player/impact_02.wav",
		"bullet/impact/player/impact_03.wav",
		"bullet/impact/player/impact_04.wav",
		"bullet/impact/player/impact_05.wav",
		"bullet/impact/player/impact_06.wav",
		"bullet/impact/player/impact_07.wav",
		"bullet/impact/player/impact_08.wav",
		"bullet/impact/player/impact_09.wav",
		"bullet/impact/player/impact_10.wav",
		"bullet/impact/player/impact_11.wav",
		"bullet/impact/player/impact_12.wav",
		"bullet/impact/player/impact_13.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})

sound.Add( -- impact playerlocal
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.PlayerLocal",
	level = 70,
	sound = {
		"bullet/impact/player/local/impact_01.wav",
		"bullet/impact/player/local/impact_02.wav",
		"bullet/impact/player/local/impact_03.wav",
		"bullet/impact/player/local/impact_04.wav",
		"bullet/impact/player/local/impact_05.wav",
		"bullet/impact/player/local/impact_06.wav",
		"bullet/impact/player/local/impact_07.wav",
		"bullet/impact/player/local/impact_08.wav",
		"bullet/impact/player/local/impact_09.wav",
		"bullet/impact/player/local/impact_10.wav",
		"bullet/impact/player/local/impact_11.wav",
		"bullet/impact/player/local/impact_12.wav",
		"bullet/impact/player/local/impact_13.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})


sound.Add( -- headshot player
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Headshot.Player",
	level = 70,
	sound = {
		"bullet/impact/player/headshot/headshot_01.wav",
		"bullet/impact/player/headshot/headshot_02.wav",
		"bullet/impact/player/headshot/headshot_03.wav",
		"bullet/impact/player/headshot/headshot_04.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})

sound.Add( -- headshot playerlocal
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Headshot.PlayerLocal",
	level = 70,
	sound = {
		"bullet/impact/player/headshot/local/headshot_01.wav",
		"bullet/impact/player/headshot/local/headshot_02.wav",
		"bullet/impact/player/headshot/local/headshot_03.wav",
		"bullet/impact/player/headshot/local/headshot_04.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})


sound.Add( -- helmetshot player
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Helmetshot.Player",
	level = 70,
	sound = {
		"bullet/impact/player/headshot/helmetshot_01.wav",
		"bullet/impact/player/headshot/helmetshot_02.wav",
		"bullet/impact/player/headshot/helmetshot_03.wav",
		"bullet/impact/player/headshot/helmetshot_04.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})

sound.Add( -- helmetshot playerlocal
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Helmetshot.PlayerLocal",
	level = 70,
	sound = {
		"bullet/impact/player/headshot/local/helmetshot_01.wav",
		"bullet/impact/player/headshot/local/helmetshot_02.wav",
		"bullet/impact/player/headshot/local/helmetshot_03.wav",
		"bullet/impact/player/headshot/local/helmetshot_04.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
})


sound.Add( -- impact aircraft
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Impact.Aircraft",
	level = 110,
	sound = {
		"bullet/impact/vehicle/air_impact_1.wav",
		"bullet/impact/vehicle/air_impact_2.wav",
		"bullet/impact/vehicle/air_impact_3.wav",
		"bullet/impact/vehicle/air_impact_4.wav",
		"bullet/impact/vehicle/air_impact_5.wav",
		"bullet/impact/vehicle/air_impact_6.wav",
		"bullet/impact/vehicle/air_impact_7.wav",
		"bullet/impact/vehicle/air_impact_8.wav",
		"bullet/impact/vehicle/air_impact_9.wav",
		"bullet/impact/vehicle/air_impact_10.wav"
		},
	volume = 0.9,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- NearMiss
-------------------------------------------------------

sound.Add( -- nearnearmiss small
{
	channel = CHAN_AUTO,
	name = "HAB.Sounds.PhysBullet.NearCrack",
	level = 140,
	sound = {
		"^bullet/nearmiss/small_01.wav",
		"^bullet/nearmiss/small_02.wav",
		"^bullet/nearmiss/small_03.wav",
		"^bullet/nearmiss/small_04.wav",
		"^bullet/nearmiss/small_05.wav",
		"^bullet/nearmiss/small_06.wav",
		"^bullet/nearmiss/small_07.wav",
		"^bullet/nearmiss/small_08.wav",
		"^bullet/nearmiss/small_09.wav",
		"^bullet/nearmiss/small_10.wav",
		"^bullet/nearmiss/small_11.wav",
		"^bullet/nearmiss/small_12.wav",
		"^bullet/nearmiss/small_13.wav",
		"^bullet/nearmiss/small_14.wav",
		"^bullet/nearmiss/small_15.wav",
		"^bullet/nearmiss/small_16.wav",
		"^bullet/nearmiss/small_17.wav",
		"^bullet/nearmiss/small_18.wav",
		"^bullet/nearmiss/small_19.wav",
		"^bullet/nearmiss/small_20.wav",
		"^bullet/nearmiss/small_21.wav",
		"^bullet/nearmiss/small_22.wav",
		"^bullet/nearmiss/small_23.wav",
		"^bullet/nearmiss/small_24.wav",
		"^bullet/nearmiss/small_25.wav",
		"^bullet/nearmiss/small_26.wav",
		"^bullet/nearmiss/small_27.wav",
		},
	volume = 1.0,
	pitch = { 95, 105 },
} )

sound.Add( -- nearmiss large
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.NearMiss.Large",
	level = 140,
	sound = {
		"^bullet/nearmiss/large_1.wav",
		"^bullet/nearmiss/large_2.wav",
		"^bullet/nearmiss/large_3.wav",
		"^bullet/nearmiss/large_4.wav",
		"^bullet/nearmiss/large_5.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- crack
{
	channel = CHAN_AUTO,
	name = "HAB.Sounds.PhysBullet.FarCrack",
	level = 110,
	sound = {
		"bullet/crack/crack_01.wav",
		"bullet/crack/crack_02.wav",
		"bullet/crack/crack_03.wav",
		"bullet/crack/crack_04.wav",
		"bullet/crack/crack_05.wav",
		"bullet/crack/crack_06.wav",
		"bullet/crack/crack_07.wav",
		"bullet/crack/crack_08.wav",
		"bullet/crack/crack_09.wav",
		"bullet/crack/crack_10.wav",
		"bullet/crack/crack_11.wav",
		"bullet/crack/crack_12.wav"
		},
	volume = 0.8,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Ricochet/Bounce
-------------------------------------------------------

sound.Add( -- far ricochet
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Far.Ricochet",
	level = 80,
	sound = {
		"^bullet/ricochet/far_1.wav",
		"^bullet/ricochet/far_2.wav",
		"^bullet/ricochet/far_3.wav",
		"^bullet/ricochet/far_4.wav"
		},
	volume = 1,
	pitch = { 98, 102 },
} )

sound.Add( -- small ricochet
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Small.Ricochet",
	level = 80,
	sound = {
		"^bullet/ricochet/small/ricochet_1.wav",
		"^bullet/ricochet/small/ricochet_2.wav",
		"^bullet/ricochet/small/ricochet_3.wav",
		"^bullet/ricochet/small/ricochet_4.wav",
		"^bullet/ricochet/small/ricochet_5.wav",
		"^bullet/ricochet/small/ricochet_6.wav",
		"^bullet/ricochet/small/ricochet_7.wav",
		"^bullet/ricochet/small/ricochet_8.wav",
		"^bullet/ricochet/small/ricochet_9.wav",
		"^bullet/ricochet/small/ricochet_10.wav",
		"^bullet/ricochet/small/ricochet_11.wav",
		"^bullet/ricochet/small/ricochet_12.wav"
		},
	volume = 0.9,
	pitch = { 98, 102 },
} )

sound.Add( -- medium ricochet
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Medium.Ricochet",
	level = 80,
	sound = {
		"^bullet/ricochet/small/ricochet_1.wav",
		"^bullet/ricochet/small/ricochet_2.wav",
		"^bullet/ricochet/small/ricochet_3.wav",
		"^bullet/ricochet/small/ricochet_4.wav"
		},
	volume = 0.9,
	pitch = { 98, 102 },
} )

sound.Add( -- large ricochet
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Large.Ricochet",
	level = 80,
	sound = {
		"^bullet/ricochet/large/ricochet_1.wav",
		"^bullet/ricochet/large/ricochet_2.wav",
		"^bullet/ricochet/large/ricochet_3.wav",
		"^bullet/ricochet/large/ricochet_4.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- large ricochet inside
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Large.Ricochet.Inside",
	level = 80,
	sound = {
		"^bullet/ricochet/large/ricochet_5.wav",
		"^bullet/ricochet/large/ricochet_6.wav",
		"^bullet/ricochet/large/ricochet_7.wav",
		"^bullet/ricochet/large/ricochet_8.wav"
		},
	volume = 0.8,
	pitch = { 98, 102 },
} )

-------------------------------------------------------
--###################################################-- Penetrate
-------------------------------------------------------

sound.Add( -- large penetrate
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Large.Penetrate",
	level = 110,
	sound = {
		"bullet/penetrate/large_1.wav",
		"bullet/penetrate/large_2.wav",
		"bullet/penetrate/large_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- medium penetrate
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Medium.Penetrate",
	level = 105,
	sound = {
		"bullet/penetrate/medium_1.wav",
		"bullet/penetrate/medium_2.wav",
		"bullet/penetrate/medium_3.wav",
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )

sound.Add( -- small penetrate
{
	channel = CHAN_AUTO,
	name = "HAB.PhysBullet.Small.Penetrate",
	level = 100,
	sound = {
		"bullet/penetrate/small_1.wav",
		"bullet/penetrate/small_2.wav",
		"bullet/penetrate/small_3.wav"
		},
	volume = 1.0,
	pitch = { 98, 102 },
} )
