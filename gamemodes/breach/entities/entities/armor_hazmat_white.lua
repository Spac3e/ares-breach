AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_white"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_6.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 3
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 2
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .95,
	[ DMG_BLAST ] = .8,
	[ DMG_PLASMA ] = .4,
	[ DMG_SHOCK ] = .95,
	[ DMG_ACID ] = .9,
	[ DMG_POISON ] = .8

}
