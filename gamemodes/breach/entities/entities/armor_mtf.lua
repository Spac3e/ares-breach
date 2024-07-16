AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName = "l:armor_mtf"
ENT.InvIcon = Material("nextoren/gui/icons/guard_uniform.png")
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model = Model("models/cultist/armor_pickable/clothing.mdl")
ENT.SkinModel = 0
ENT.BodygroupModel = 0
ENT.HideBoneMerge = true
ENT.ArmorType = "Clothes"
ENT.ArmorSkin = 0
ENT.ArmorModel = "models/cultist/humans/mog/mog.mdl"
ENT.Bodygroups = {
  [0] = "1", -- шлем
  [1] = "1", -- разгрузка
  [2] = "0", -- бекпак
  [3] = "0", -- тело
  [4] = "0", -- плечи
  [5] = "0", -- шея
  [6] = "0", -- пенис
  [7] = "1", -- маска
  [8] = "0",
  [9] = "0",
  [10] = "0"
}
ENT.Bonemerge = {"models/cultist/humans/mog/head_gear/mog_helmet.mdl", "models/cultist/humans/balaclavas_new/balaclava_full.mdl"}
ENT.MultipliersType = {
    [DMG_BULLET] = .6,
    [DMG_BLAST] = .95,
    [268435464] = .95,
    [DMG_SHOCK] = .95,
    [DMG_ACID] = .95
}