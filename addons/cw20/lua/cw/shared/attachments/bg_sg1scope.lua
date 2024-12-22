--[[


addons/[weapons]_cw_20/lua/cw/shared/attachments/bg_sg1scope.lua

--]]

local att = {}
att.name = "bg_sg1scope"
att.displayName = "SG1 Scope"
att.displayNameShort = "SG1"
att.isBG = true
att.isSight = true
att.aimPos = {"SG1Pos", "SG1Ang"}
att.withoutRail = true
att.SpeedDec = 3

att.statModifiers = {OverallMouseSensMult = -0.2}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/sg1scope")
	att.description = {[1] = {t = "Provides 6x magnification.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Narrow scope greatly decreases awareness.", c = CustomizableWeaponry.textColors.NEGATIVE},
	[3] = {t = "Is disorienting at close range.", c = CustomizableWeaponry.textColors.NEGATIVE}}
	
	local old, x, y, ang
	local reticle = surface.GetTextureID("cw2/reticles/scope_leo")
	
	att.zoomTextures = {[1] = {tex = reticle, offset = {0, 1}}}

	att.shadowMaskConfig = {		
		w = 768, -- base width of the texture, should match the texture size
		h = 768, -- same, but height
		wOff = 352, -- width offset for the mask texture
		hOff = 352, -- height offset for the mask texture
		maxOffset = 164, -- maximum pixel offset for the 'shadow' effect
		maskMaxStrength = 1, -- at what point will the shadow mask reach peak strength?
		maxZoom = 352, -- how many pixels can we zoom in at most based on the difference between our base viewmodel position and aim position?
		posX = 1, -- shadow offset position multiplier, X
		posY = 1, -- shadow offset position multiplier, Y
		flipAngles = false -- whether we should swap pitch with yaw when calculating the shadow mask offset
	}

	local lens = surface.GetTextureID("cw2/gui/lense")
	local lensMat = Material("cw2/gui/lense")
	local cd, alpha = {}, 0.5
	local Ini = true
	
	-- render target var setup
	cd.x = 0
	cd.y = 0
	cd.w = 512
	cd.h = 512
	cd.fov = 7
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
		
		--[[if not self.freeAimOn then
			ang.r = self.BlendAng.z
			ang:RotateAroundAxis(ang:Right(), self.ACOGAxisAlign.right)
			ang:RotateAroundAxis(ang:Up(), self.ACOGAxisAlign.up)
			ang:RotateAroundAxis(ang:Forward(), self.ACOGAxisAlign.forward)
		end]]
		
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
				surface.DrawTexturedRect(0, 0, size, size)

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
	self.OverrideAimMouseSens = 0.3
	self.SimpleTelescopicsFOV = 80
	self.BlurOnAim = true
	self.ZoomTextures = att.zoomTextures
	
	self:setBodygroup(self.SightBGs.main, self.SightBGs.sg1)
	self.AimBreathingEnabled = true
end

function att:detachFunc()
	self.OverrideAimMouseSens = nil
	self.SimpleTelescopicsFOV = nil
	self.BlurOnAim = false
	self.AimBreathingEnabled = true
end

CustomizableWeaponry:registerAttachment(att)