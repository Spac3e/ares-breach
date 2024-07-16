AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_sci"
ENT.InvIcon = Material( "nextoren/gui/icons/sci_uniform.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 1
ENT.BodygroupModel = 3

ENT.ArmorType = "Clothes"
ENT.MultiGender = true
ENT.ArmorModel 			= "models/cultist/humans/sci/scientist.mdl"
ENT.ArmorModelFem 			= "models/cultist/humans/sci/scientist_female.mdl"

ENT.Team = TEAM_CLASSD

ENT.Bodygroups = {

  [1] = "0", -- тело
  [2] = "0",
  [3] = "0",
  [4] = "0",
  [5] = "0",
  [6] = "0"

}
ENT.MultipliersType = {}
