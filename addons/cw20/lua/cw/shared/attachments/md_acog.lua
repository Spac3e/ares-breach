--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_acog.lua

--]]

local att = {}
att.name = "md_acog"
att.displayName = "Trijicon ACOG"
att.displayNameShort = "ACOG"
att.aimPos = {"ACOGPos", "ACOGAng"}
att.FOVModifier = 15
att.isSight = true
att.SpeedDec = 1

att.statModifiers = {OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/acog")
	att.description = {[1] = {t = "Provides 4x magnification.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Has back-up sights. Double-tap use key to toggle.", c = CustomizableWeaponry.textColors.POSITIVE},
	[3] = {t = "Narrow scope reduces spatial awareness.", c = CustomizableWeaponry.textColors.NEGATIVE}}

	local old, x, y, ang	
	local reticle = surface.GetTextureID("cw2/reticles/reticle_chevron_clean")
	
	att.newTelescopicsFOV = true
	-- default shadow mask config
	att.shadowMaskConfig = {		
		w = 768, -- base width of the texture, should match the texture size
		h = 768, -- same, but height
		wOff = 352, -- width offset for the mask texture
		hOff = 352, -- height offset for the mask texture
		maxOffset = 130, -- maximum pixel offset for the 'shadow' effect
		maskMaxStrength = 1, -- at what point will the shadow mask reach peak strength?
		maxZoom = 416, -- how many pixels can we zoom in at most based on the difference between our base viewmodel position and aim position?
		posX = 1, -- shadow offset position multiplier, X
		posY = 1, -- shadow offset position multiplier, Y
		flipAngles = false -- whether we should swap pitch with yaw when calculating the shadow mask offset
	}

	att.zoomTextures = {[1] = {tex = reticle, offset = {0, 1}}}
	
	local lens = surface.GetTextureID("cw2/gui/lense")
	local lensMat = Material("cw2/gui/lense")
	
	local cd, alpha = {}, 0.5
	local Ini = true
	
	-- render target var setup
	cd.x = 0
	cd.y = 0
	cd.w = 512
	cd.h = 512
	cd.fov = 10
	cd.drawviewmodel = false
	cd.drawhud = false
	cd.dopostprocess = false
	
	function att:drawRenderTarget()
		local complexTelescopics = self:canUseComplexTelescopics()
		
		-- if we don't have complex telescopics enabled, don't do anything complex, and just set the texture of the lens to a fallback 'lens' texture
		if not complexTelescopics then
			self.TSGlass:SetTexture("$basetexture", lensMat:GetTexture("$basetexture"))
			return
		end
		
		if self:canSeeThroughTelescopics(att.aimPos[1]) then
			alpha = math.Approach(alpha, 0, FrameTime() * 5)
		else
			alpha = math.Approach(alpha, 1, FrameTime() * 5)
		end
		
		x, y = ScrW(), ScrH()
		old = render.GetRenderTarget()
	
		ang = self:getTelescopeAnglesNew()
		
		if not self.TelescopeSkipRotate then
			if self.ViewModelFlip then
				ang.r = -self.BlendAng.z
			else
				ang.r = self.BlendAng.z
			end
		end
		
		if self.ACOGAxisAlignNew then
			ang:RotateAroundAxis(ang:Right(), self.ACOGAxisAlignNew.right)
			ang:RotateAroundAxis(ang:Up(), self.ACOGAxisAlignNew.up)
			ang:RotateAroundAxis(ang:Forward(), self.ACOGAxisAlignNew.forward)
		end
		
		local size = self:getRenderTargetSize()
		
		cd.w = size
		cd.h = size
		cd.angles = ang
		cd.origin = self.Owner:GetShootPos()
		render.SetRenderTarget(self.ScopeRT)
		render.SetViewPort(0, 0, size, size)
			if alpha < 1 or Ini then
				render.RenderView(cd)
				Ini = false
			end
			
			ang = self.Owner:EyeAngles()
			ang.p = ang.p + self.BlendAng.x
			ang.y = ang.y + self.BlendAng.y
			ang.r = ang.r + self.BlendAng.z
			ang = -ang:Forward()
			
			local light = render.ComputeLighting(self.Owner:GetShootPos(), ang)
			
			cam.Start2D()				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetTexture(reticle)
				surface.DrawTexturedRect(size * 0.125, size * 0.125, size * 0.75, size * 0.75)
				
				if alpha < 1 then
					self:drawLensShadow(size, size, att.shadowMaskConfig)
				end
				
				surface.SetDrawColor(150 * light[1], 150 * light[2], 150 * light[3], 255 * alpha)
				surface.SetTexture(lens)
				surface.DrawTexturedRectRotated(size * 0.5, size * 0.5, size, size, 90)
			cam.End2D()
		render.SetViewPort(0, 0, x, y)
		render.SetRenderTarget(old)
		
		if self.TSGlass then
			self.TSGlass:SetTexture("$basetexture", self.ScopeRT)
		end
	end
end

function att:attachFunc()
	self.OverrideAimMouseSens = 0.35
	self.SimpleTelescopicsFOV = 12
	self.AimViewModelFOV = 50
	self.BlurOnAim = true
	self.ZoomTextures = att.zoomTextures
end

function att:detachFunc()
	self.OverrideAimMouseSens = nil
	self.SimpleTelescopicsFOV = nil
	self.AimViewModelFOV = self.AimViewModelFOV_Orig
	self.BlurOnAim = false
end

CustomizableWeaponry:registerAttachment(att)