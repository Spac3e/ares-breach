AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_lighthazmat_yellow"
ENT.InvIcon = Material( "nextoren/gui/icons/hazmat_1-1.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 0
ENT.BodygroupModel = 2

ENT.ArmorModel 			= "models/cultist/humans/sci/hazmat_1.mdl"
ENT.ArmorSkin = 0
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.MultipliersType = {

  [ DMG_PLASMA ] = 0.65, --DMG_BURN
  [ DMG_POISON ] = .8

}
