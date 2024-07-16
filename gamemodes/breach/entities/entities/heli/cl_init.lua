include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self.CreationTime = CurTime() + 2
end

function ENT:Think()
    if not self.SoundCreated and self.CreationTime < CurTime() then
        self.SoundCreated = true
        self.hover_snd = CreateSound(self, "nextoren/others/helicopter/apache_hover.wav")
        self.hover_snd:SetDSP(17)
        self.hover_snd:Play()
    end
end

function ENT:OnRemove()
    if self.hover_snd and self.hover_snd:IsPlaying() then self.hover_snd:Stop() end
end