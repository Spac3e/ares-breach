AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_hazmat_yellow"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_7.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 4
ENT.BodygroupModel = 1

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_2.mdl"
ENT.ArmorSkin = 3
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

	[ DMG_BULLET ] = .75,
	[ DMG_BLAST ] = .95,
	[ DMG_PLASMA ] = .95,
	[ DMG_SHOCK ] = .85,
	[ DMG_ACID ] = .85,
	[ DMG_POISON ] = .8

}
