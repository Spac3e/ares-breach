AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_medic"
ENT.InvIcon = Material( "nextoren/gui/icons/medic_uniform.png" )
ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 0
ENT.BodygroupModel = 3

ENT.ArmorType = "Clothes"

ENT.MultiGender = true
ENT.ArmorModel 			= "models/cultist/humans/sci/scientist.mdl"
ENT.ArmorModelFem 			= "models/cultist/humans/sci/scientist_female.mdl"

ENT.HideBonemergeEnt = "models/cultist/humans/class_d/head_gear/hacker_hat.mdl"

ENT.Team = TEAM_CLASSD

ENT.Bodygroups = {

  [0] = "1", -- тело
  [1] = "0",
  [2] = "1", -- рубашка
  [3] = "1",  -- штаны
  [4] = "1",  -- шапка
  [5] = "0",
  [6] = "0"

}
ENT.MultipliersType = {}
