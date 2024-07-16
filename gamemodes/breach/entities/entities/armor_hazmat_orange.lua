AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_orange"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_3.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 5
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 0
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .9,
	[ DMG_BLAST ] = .4,
	[ DMG_PLASMA ] = .8,
	[ DMG_SHOCK ] = .95,
	[ DMG_ACID ] = .95,
	[ DMG_POISON ] = .8

}
