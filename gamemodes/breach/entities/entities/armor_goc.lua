AddCSLuaFile()

ENT.Base = "armor_base"
ENT.PrintName 			= "l:armor_goc"

ENT.Type 						=	"anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Model = Model( "models/cultist/armor_pickable/clothing.mdl" )
ENT.SkinModel = 3
ENT.BodygroupModel = 1

ENT.CantStrip = true

ENT.SlotNeeded = 2

ENT.FuncOnPickup = function( ply )
  ply:BreachGive( "breach_keycard_crack" )
  ply:BreachGive( "cw_cultist_semisniper_arx160" )
  ply:BreachGive( "item_nightvision_white" )

  ply:ClearBodyGroups()

  ply:SetAmmo( 200, "GOC" )

  ply:StripWeapon("item_knife")

  BREACH.Players:ChatPrint( ply, true, true, "l:sgoc_first_objective" )

  ply:AddToStatistics( "l:sgoc_first_objective_completed", 100 )

  ply:SetUsingCloth("")

end
ENT.Team = TEAM_GOC
ENT.ArmorModel 			= "models/cultist/humans/goc/goc.mdl"
ENT.ArmorSkin = 2
ENT.ArmorType = "Clothes"
ENT.ShouldUnwearArmor = true
ENT.ShouldUnwearHat = false
ENT.Bodygroups = {

  [0] = "0", -- шлем
  [1] = "0", -- броня
  [2] = "0"

}
ENT.MultipliersType = {

	[ DMG_BULLET ] = .5,
	[ DMG_BLAST ] = .5,
	[ DMG_PLASMA ] = .5,
	[ DMG_SHOCK ] = .5,
	[ DMG_ACID ] = .6,
	[ DMG_POISON ] = .8


}

if ( CLIENT ) then

  local outline_clr = gteams.GetColor( TEAM_GOC )

  function ENT:Draw()

    local client = LocalPlayer()

    if ( client:GetRoleName() == role.ClassD_GOCSpy ) then

      self:DrawModel()

      local client_trace_pos = client:GetEyeTrace().HitPos

      if ( client_trace_pos:DistToSqr( self:GetPos() ) < 19600 ) then

        outline.Add( { self }, outline_clr, OUTLINE_MODE_VISIBLE )

      end

    end

  end

end
