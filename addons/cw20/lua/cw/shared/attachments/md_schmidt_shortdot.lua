--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/md_schmidt_shortdot.lua

--]]

local att = {}
att.name = "md_schmidt_shortdot"
att.displayName = "Schmidt&Bender Short dot"
att.displayNameShort = "Short dot"
att.aimPos = {"ShortDotPos", "ShortDotAng"}
att.FOVModifier = 15
att.isSight = true
att.SpeedDec = 2

att.statModifiers = {OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/shortdot")
	att.description = {[1] = {t = "Provides 1.5-3x magnification.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Narrow scope reduces spatial awareness.", c = CustomizableWeaponry.textColors.NEGATIVE}}

	att.telescopicsFOVRange = {
		22.5, 
		20, 
		15
	}
	
	-- note that the FOVs in this table are inverted, that's because the FOV setup in CalcView subtracts the simple telescopics value
	-- instead of over-writing it
	att.newTelescopicsFOV = true
	att.simpleTelescopicsFOVRange = {
		29,
		26,
		20
	}

	att.shadowMaskConfig = {		
		w = 768,
		h = 768,
		wOff = 384, -- width offset for the mask texture
		hOff = 384, -- height offset for the mask texture
		maxOffset = 100, -- maximum pixel offset for the 'shadow' effect
		maskMaxStrength = 1, -- at what point will the shadow mask reach peak strength?
		maxZoom = 460,
		posX = 1, -- shadow offset position multiplier, X
		posY = 1, -- shadow offset positionc multiplier, Y
		flipAngles = false -- whether we should swap pitch with yaw when calculating the shadow mask offset
	}

	local old, x, y, ang
	local reticle = surface.GetTextureID("cw2/reticles/aim_reticule")
	
	att.zoomTextures = {{tex = reticle, offset = {0, 1}, size = {16, 16}, color = Color(255, 0, 0, 150)},
		{tex = reticle, offset = {0, 1}, size = {8, 8}, color = Color(255, 0, 0, 255)}}
	
	local lens = surface.GetTextureID("cw2/gui/lense")
	local lensMat = Material("cw2/gui/lense")
	local cd, alpha = {}, 0.5
	local Ini = true
	
	-- render target var setup
	cd.x = 0
	cd.y = 0
	cd.w = 512
	cd.h = 512
	cd.fov = 20
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
		
		if self.SchmidtShortDotAxisAlignNew then
			ang:RotateAroundAxis(ang:Right(), self.SchmidtShortDotAxisAlignNew.right)
			ang:RotateAroundAxis(ang:Up(), self.SchmidtShortDotAxisAlignNew.up)
			ang:RotateAroundAxis(ang:Forward(), self.SchmidtShortDotAxisAlignNew.forward)
		end
		
		local size = self:getRenderTargetSize()
		
		cd.w = size
		cd.h = size
		cd.angles = ang
		cd.origin = self.Owner:GetShootPos()
		
		self:adjustTelescopicsFOV(cd)
		
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
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(size * 0.5 - 1, 0, 2, size) -- middle top-bottom
				surface.DrawRect(0, size * 0.5 - 1, size, 2) -- middle left-right
				
				local retSize = size * 0.02
				
				surface.SetDrawColor(255, 0, 0, 255)
				surface.SetTexture(reticle)
				surface.DrawTexturedRect(size * 0.5 - retSize * 0.5, size * 0.5 - retSize * 0.5, retSize, retSize)
				
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
	self.OverrideAimMouseSens = 0.5
	self.SimpleTelescopicsFOV = 55
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