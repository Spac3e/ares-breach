AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Sound Effect (Alarm)"
ENT.Category = "NextOren Breach"
ENT.Spawnable = true


function ENT:Draw()

end

function ENT:Think()

  if ( !self.AlarmIsPlaying ) then

    self.AlarmIsPlaying = CreateSound( self, "nextoren/ambience/lz/alarmloop.wav" )
    self.AlarmIsPlaying:SetDSP( 17 )
    self.AlarmIsPlaying:Play()

  end

end

function ENT:OnRemove()

  if ( self.AlarmIsPlaying ) then

    self.AlarmIsPlaying:Stop()

  end

end