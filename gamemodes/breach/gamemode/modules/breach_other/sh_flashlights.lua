if CLIENT then

function CreateFirstPersonFlashlight(texture, enableshadows, farz, fov, brightness)
	if texture == nil then
		texture = "effects/flashlight001"
	end
	if enableshadows == nil then
		enableshadows = true
	end
	if farz == nil then
		farz = 512
	end
	if fov == nil then
		fov = 60
	end
	if brightness == nil then
		brightness = 3
	end

	local pt = ProjectedTexture()
    pt:SetTexture(texture)
    pt:SetEnableShadows(enableshadows)
    pt:SetFarZ(farz)
    pt:SetFOV(fov)
    pt:SetBrightness(brightness)
    LocalPlayer().FlashlightProjectedTexture = pt

    return LocalPlayer().FlashlightProjectedTexture
end

function EnableFirstPersonFlashlight()
	if !IsValid(LocalPlayer().FlashlightProjectedTexture) then
		CreateFirstPersonFlashlight()
		return
	end

	LocalPlayer().FlashlightProjectedTexture:SetNearZ(0)
end

function DisableFirstPersonFlashlight()
	if !IsValid(LocalPlayer().FlashlightProjectedTexture) then
		CreateFirstPersonFlashlight()
	end

	LocalPlayer().FlashlightProjectedTexture:SetNearZ(1)
end

hook.Add('NotifyShouldTransmit', 'FlashLight_NotifyShouldTransmit', function(ent, shouldTransmit)
    if ent:GetClass() == 'ent_flashlight' then
        local owner = ent:GetParent()
        if owner and owner:IsValid() then
            ent:SetParent(owner)
        end
    end
end)

end