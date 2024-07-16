AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Blood Sucker's Trap"
ENT.Model = "models/scp_trap/hunter_trap.mdl"

function ENT:Initialize()

  self:SetModel( self.Model )

  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_VPHYSICS )

end

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Triggered" )

  self:SetTriggered( false )

end

if ( SERVER ) then

  function ENT:Activate()

    if ( self:GetTriggered() ) then return end

    ents_in_pos = ents.FindInSphere(self:GetPos(), 80)

    if ents_in_pos then

      for _, victim in ipairs(ents_in_pos) do

        if victim:IsPlayer() then

          if victim && victim:IsValid() then

            victim:Freeze(true)

            if victim:HasWeapon("br_holster") then

              victim:SelectWeapon("br_holster")

            end

            if victim:Health() < 30 then

              victim:Kill()

            end

          end

        end

      end

    end

    timer.Simple(5, function()

      if !(self && self:IsValid()) then return end

      self:Remove()

    end)

  end

  function ENT:Think()

    ents_detect_radius = ents.FindInSphere(self:GetPos(), 80)

    if ents_detect_radius then

      for _, victim in ipairs(ents_in_pos) do

        if victim:IsPlayer() then

          if victim && victim:IsValid() then

            self:Activate()

          end

        end

      end

    end

  end


  function ENT:OnTakeDamage()

    if ( self:GetTriggered() ) then return end

    self:SetTriggered( true )

    self:Activate()    

  end

  function ENT:Use( activator )

    if ( activator != self.Owner ) then return end

    activator:SetNWInt("trap", activator:GetNWInt("trap") - 1)

    self:Remove()

  end

end