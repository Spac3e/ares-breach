AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_lighthazmat_white"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_1.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 1
ENT.BodygroupModel = 2

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_1.mdl"
ENT.ArmorSkin = 1
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

  [ DMG_POISON ] = .8

}
