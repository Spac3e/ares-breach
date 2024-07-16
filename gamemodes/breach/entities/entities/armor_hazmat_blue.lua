AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_blue"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_5.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 2
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 1
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .85,
	[ DMG_BLAST ] = .75,
	[ DMG_PLASMA ] = .75,
	[ DMG_SHOCK ] = .9,
	[ DMG_ACID ] = .9,
	[ DMG_POISON ] = .8

}
