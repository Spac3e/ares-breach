AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_black"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_4.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 1
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 4
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .5,
	[ DMG_BLAST ] = .5,
	[ DMG_PLASMA ] = .5,
	[ DMG_SHOCK ] = .5,
	[ DMG_ACID ] = .6,
	[ DMG_POISON ] = .8

}
