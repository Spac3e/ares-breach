include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self.CreationTime = CurTime() + 1
end

function ENT:Think()
    if self.CreationTime < CurTime() then
        self.hover_snd = CreateSound(self, "nextoren/others/chaos_car/car_driving.wav")
        self.hover_snd:SetDSP(17)
        self.hover_snd:Play()
    end
end

function ENT:OnRemove()
    if self.hover_snd and self.hover_snd:IsPlaying() then self.hover_snd:Stop() end
end