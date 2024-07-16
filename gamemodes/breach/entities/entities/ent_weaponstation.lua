AddCSLuaFile()

if ( CLIENT ) then

  net.Receive( "WeaponStation_RedactMessage", function()

    local bool = net.ReadBool()

    if ( bool ) then

    local gays = input.LookupBinding( "+menu_context" ):upper() || "none"
      BREACH.Player:ChatPrint( true, true, "l:temp_attach_avaliable_pt1 \"" .. gays .. "\" l:temp_attach_avaliable_pt2" )

    else

      BREACH.Player:ChatPrint( true, true, "l:temp_attach_zone_left" )

      local survivor = LocalPlayer()

      local wep = survivor:GetActiveWeapon()

      if ( IsValid(wep) && wep.dt && wep.dt.State == CW_CUSTOMIZE ) then

        survivor:ConCommand( "cw_customize" )

      end

    end

  end )

end

if ( SERVER ) then

  util.AddNetworkString( "WeaponStation_RedactMessage" )

end

ENT.Base        = "base_gmodentity"

ENT.Category    = "Breach"

ENT.Model       = Model( "models/cult_props/entity/workbench.mdl" )
ENT.Angles      = Angle( 0, 180, 0 )
ENT.Pos         = {

  Vector( 7520.312012, -4175.750000, 0.031254 ),
  Vector( -1765.097412, 1982.283203, 0.031254 )

}

function ENT:Initialize()

  self:SetModel( self.Model )

  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_BBOX )


  if ( !self.n_Type ) then return end

  self:SetPos( self.Pos[ self.n_Type ] )
  self:SetAngles( self.Angles * ( -1 + self.n_Type ) )

end

if ( SERVER ) then

  ENT.AllSurvivors = {}

  function ENT:Think()

    if ( #self.AllSurvivors != 0 ) then

      local allsurvivors = self.AllSurvivors

      for i = 1, #allsurvivors do

        local survivor = allsurvivors[ i ]

        if ( survivor && survivor:IsValid() && survivor:GetPos():DistToSqr( self:GetPos() ) > 10000 && ( self.NextCanAttach || 0 ) < CurTime() ) then

          self.NextCanAttach = CurTime() + 2

          net.Start( "WeaponStation_RedactMessage" )

            net.WriteBool( false )

          net.Send( survivor )

          table.RemoveByValue( self.AllSurvivors, survivor )

          survivor.CanAttach = nil
          survivor:SetNW2Bool("Breach:CanAttach", false)

        end

      end

    end

  end

  function ENT:Use( survivor )

    if ( survivor.CanAttach ) then return end
    if ( survivor:GTeam() == TEAM_SCP ) then return end
    if ( survivor:GetPos():DistToSqr( self:GetPos() ) > 10000 ) then return end

    net.Start( "WeaponStation_RedactMessage" )

      net.WriteBool( true )

    net.Send( survivor )

    survivor.CanAttach = true
    survivor:SetNW2Bool("Breach:CanAttach", true)

    self.AllSurvivors[ #self.AllSurvivors + 1 ] = survivor

  end

  function ENT:OnRemove()

    local allsurvivors = self.AllSurvivors

    for i = 1, #allsurvivors do

      local survivor = allsurvivors[ i ]

      if ( survivor && survivor:IsValid() ) then

        survivor.CanAttach = nil
        survivor:SetNW2Bool("Breach:CanAttach", false)

      end

    end

  end

end


function ENT:Draw()

  self:DrawModel()

end