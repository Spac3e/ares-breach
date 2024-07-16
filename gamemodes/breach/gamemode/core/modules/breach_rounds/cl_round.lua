function IntroSound()
	local client = LocalPlayer()
	if client:GTeam() != TEAM_GUARD then
		FadeMusic(1)
	end
	if client:GTeam() == TEAM_GUARD then
		surface.PlaySound("nextoren/start_round/start_round_mtf.mp3")
	elseif client:GTeam() == TEAM_CLASSD then
		surface.PlaySound("nextoren/start_round/start_round_classd.mp3")
		timer.Simple(7, function()
			util.ScreenShake( Vector(0, 0, 0), 35, 15, 3, 150 )
			surface.PlaySound("nextoren/others/horror/horror_14.ogg")
			local blackscreen = vgui.Create( "DPanel" )
			blackscreen:SetSize(ScrW(), ScrH())
			blackscreen:SetAlpha(0)
			blackscreen:AlphaTo(255,0.6, 0, function()
				BREACH.Round.GeneratorsActivated = false
				blackscreen:AlphaTo(0,1,3,function()
					blackscreen:Remove()
				end)
			end)
			blackscreen.Paint = function(self, w, h)
				draw.RoundedBox(0,0,0,w,h,color_black)
			end
		end)
	elseif client:GTeam() == TEAM_SCP then
		surface.PlaySound("nextoren/start_round/start_round_scp.mp3")
	else
		surface.PlaySound("nextoren/start_round/start_round_sci.mp3")
	    timer.Simple(5, function()
			util.ScreenShake( Vector(0, 0, 0), 35, 15, 3, 150 )
			surface.PlaySound("nextoren/others/horror/horror_14.ogg")
			local blackscreen = vgui.Create( "DPanel" )
			blackscreen:SetSize(ScrW(), ScrH())
			blackscreen:SetAlpha(0)
			blackscreen:AlphaTo(255,0.6, 0, function()
				BREACH.Round.GeneratorsActivated = false
				blackscreen:AlphaTo(0,1,3,function()
					blackscreen:Remove()
				end)
			end)
			blackscreen.Paint = function(self, w, h)
				draw.RoundedBox(0,0,0,w,h,color_black)
			end
		end)
	end
end