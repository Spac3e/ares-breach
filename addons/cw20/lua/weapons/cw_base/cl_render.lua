--[[


addons/[weapons]_cw_20/lua/weapons/cw_base/cl_render.lua

--]]

-- fallback texture config
SWEP.shadowMask = "cw2/effects/scope_shadowmask"
SWEP.shadowMaskTextureID = surface.GetTextureID(SWEP.shadowMask)

-- default shadow mask config
SWEP.shadowMaskConfig = {
	textureID = SWEP.shadowMaskTextureID,
	
	w = 768, -- base width of the texture, should match the texture size
	h = 768, -- same, but height
	wOff = 512, -- width offset for the mask texture
	hOff = 512, -- height offset for the mask texture
	maxOffset = 164, -- maximum pixel offset for the 'shadow' effect
	maskMaxStrength = 1, -- at what point will the shadow mask reach peak strength?
	maxZoom = 512, -- how many pixels can we zoom in at most based on the difference between our base viewmodel position and aim position?
	posX = 1, -- shadow offset position multiplier, X
	posY = 1, -- shadow offset position multiplier, Y
	flipAngles = false -- whether we should swap pitch with yaw when calculating the shadow mask offset
}

-- this should only be called inside the scope's RT render method
-- otherwise enjoy problems
-- w, h - RT dimensions
-- shadowMaskConfig is the config of the shadow mask (LOL!!!)
function SWEP:drawLensShadow(w, h, shadowMaskConfig)
	shadowMaskConfig = shadowMaskConfig or self.shadowMaskConfig
	maskTextureID = shadowMaskConfig.textureID or self.shadowMaskTextureID
	local texW, texH = shadowMaskConfig.w, shadowMaskConfig.h
	local wScale, hScale = texW / w, texH / h
	
	local p, y = self.AngleDelta.p, self.AngleDelta.y
	-- also take the delta of blend and aim position into account
		
	-- swap pitch with yaw if needed
	if shadowMaskConfig.flipAngles then
		p, y = y, p
	end
	
	-- calculate mask offset strength, clamp to [-1, 1]
	local deltaX, deltaY = math.min(1, math.max(-1, y / shadowMaskConfig.maskMaxStrength)), math.min(1, math.max(-1, p / shadowMaskConfig.maskMaxStrength))
	
	-- calculate the size diff between the RT size and the mask texture
	local wOff, hOff = shadowMaskConfig.wOff, shadowMaskConfig.hOff
	
	-- grab the base VM pos and aim pos
	local basePos = self:getBaseViewModelPos()
	
	-- normalize the Y value (zoom) between the aim position and the base position
	local aimPos = self.AimPos
	local normY = math.abs(aimPos.y - basePos.y)
	-- normalize Y between aim and blend
	local normYBlend = math.abs(aimPos.y - self.BlendPos.y)
	-- get linear distance between the aim pos Y and base weapon position Y
	-- also clamp to the range of [0, 1]
	-- multiply by two, while keeping it clamped, so that we accentuate the zoom shadow when we just start aiming
	local zoomRel = math.max(0, math.min(1, normYBlend / normY * 2))
	local zoomRelInverse = 1 - zoomRel

	local maxZoom = shadowMaskConfig.maxZoom
	local halfZoom = maxZoom * 0.5
		
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(maskTextureID)
	
	-- draw my HUGE ASS into the FRAMEBUFFER!!! yeah. I'm going to CUM. HARD.
	surface.DrawTexturedRect(
		-deltaX * shadowMaskConfig.posX * shadowMaskConfig.maxOffset / wScale * zoomRelInverse + (halfZoom * zoomRel / wScale) - wOff * 0.5 / wScale,
		deltaY * shadowMaskConfig.posY * shadowMaskConfig.maxOffset / hScale * zoomRelInverse + (halfZoom * zoomRel / hScale) - hOff * 0.5 / hScale,
		w + wOff / wScale - (maxZoom * zoomRel / wScale), 
		h + hOff / hScale - (maxZoom * zoomRel / hScale)
	)
	-- OH NO, I COVERED THE SCREEN WITH CUM! sorry bro, but you asked for this anyway! =)
end

function SWEP:setTelescopicsFOVRange(range, rangeSimple)
	if range then
		self.telescopicsFOVRange = range
		self.telescopicsFOVIndex = #range
		
		self.simpleTelescopicsFOVRange = rangeSimple
		
		self:changeTelescopicsFOVIndex(0)
	else
		self.telescopicsFOVRange = nil
		self.telescopicsFOVIndex = nil
		self.telescopicsFOV = nil
	end
end

function SWEP:adjustTelescopicsFOV(renderData)
	-- adjusts telescopics FOV based on the current zoom settings
	if self.telescopicsFOV then
		renderData.fov = self.telescopicsFOV
	end
end

function SWEP:_changeTelescopicsFOVIndex(bind)
	if bind == self.magnificationIncreaseButton then
		if self:changeTelescopicsFOVIndex(1) then
			surface.PlaySound("cw/switch3.wav")
		end
		
		return true
	elseif bind == self.magnificationDecreaseButton then
		if self:changeTelescopicsFOVIndex(-1) then
			surface.PlaySound("cw/switch1.wav")
		end
		
		return true
	end
	
	return false
end

function SWEP:changeTelescopicsFOVIndex(direction)
	if self.telescopicsFOVRange then
		local newIndex = math.max(1, math.min(#self.telescopicsFOVRange, self.telescopicsFOVIndex + direction))
		local prevIndex = self.telescopicsFOVIndex
		self.telescopicsFOVIndex = newIndex
		self.telescopicsFOV = self.telescopicsFOVRange[newIndex]
		
		self.SimpleTelescopicsFOV = self.simpleTelescopicsFOVRange[newIndex]
		
		return newIndex ~= prevIndex
	end
	
	return false
end