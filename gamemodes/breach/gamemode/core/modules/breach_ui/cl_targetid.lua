local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
--[[
gamemodes/breach/gamemode/cl_targetid.lua
--]]

--[[
function GM:HUDDrawTargetID()

	local trace = LocalPlayer():GetEyeTrace()

	local ply =  trace.Entity

	if !trace.Hit then return end

	if !trace.HitNonWorld then return end

	if !ply:IsValid() then return end

	if LocalPlayer():GTeam() == TEAM_SPEC then return end

	local text = clang.class_unknown or "Unknown"

	local font = "TargetID"

	local multiplier = 2 -- Увеличение эффекта ника



	local clr = color_white

	if ply:IsPlayer() then

		local clr2 = Color(255,255,255,255 - ply:GetPos():Distance(LocalPlayer():GetPos()) + multiplier)

	end



	if ply:IsPlayer() then

		if ply:Alive() == false then return end



		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 200 then return end

		if not ply.GetRoleName then

			player_manager.RunClass( ply, "SetupDataTables" )

		end

		if ply:GTeam() == TEAM_SPEC then return end

		--if ply:GTeam() == TEAM_SCP then return end

		if ply:GetNWBool( 'IsInsideLocker', true ) then return end

		if ply:GetRoleName() == SCP966 then

			local hide = true

			if IsValid(LocalPlayer():GetActiveWeapon()) then

				if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then

					hide = false

				end

			end

			if (LocalPlayer():GTeam() == TEAM_SCP) then

				hide = false

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_SCP  then

		  local hide = false

				if (LocalPlayer():GTeam() == TEAM_SCP) or (LocalPlayer():GTeam() == TEAM_DZ) then

			    hide = false



						draw.Text( {

		        text = " Существо: " ..ply:Nick(),

		        pos = { ScrW() / 2, ScrH() / 2 + 25 },

		        font = "SafeZone_INFO",

		        color = Color(255, 0, 0),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

						local clrhp = Color(112, 128, 144)

						local lowhp = math.abs(math.sin(CurTime() * 4) * 255)

						if ply:Health() <= 1000 then

							clrhp = Color(180, 0, 0, lowhp)

							draw.Text( {

			        text = " КРИТИЧЕСКОЕ СОСТОЯНИЕ ",

			        pos = { ScrW() / 2, ScrH() / 2 + 75 },

			        font = "SafeZone_INFO",

			        color = clrhp,

			        xalign = TEXT_ALIGN_CENTER,

			        yalign = TEXT_ALIGN_CENTER,

		          })

							draw.Text( {

							text = " SCP Number: " ..GetLangRole(ply:GetRoleName()),

							pos = { ScrW() / 2, ScrH() / 2  },

							font = "SafeZone_INFO",

							color = Color(120, 170, 0),

							xalign = TEXT_ALIGN_CENTER,

							yalign = TEXT_ALIGN_CENTER,

							})

						end

						draw.Text( {

		        text = " Здоровье существа: " ..ply:Health().. "/" ..ply:GetMaxHealth(),

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = clrhp,

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

						if ply:GetRoleName() == SCP082 then

						draw.Text( {

		        text = " SCP-082 агрессия: " .. math.Round(100/900 * ply:GetNWFloat("amountDamage")) .. "%",

		        pos = { ScrW() / 2, ScrH() / 2 + 100 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	          })

					  end



				end

				if hide == true then return end

		end

		if ply:GetRoleName() == CHAOSSPY then

			local hide = false



			if (LocalPlayer():GTeam() == TEAM_CHAOS) then

			    hide = false

				draw.Text( {

		        text = " Ваш союзник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_DZ then

			local hide = false



			if (LocalPlayer():GTeam() == TEAM_SCP) then

			    hide = false

				draw.Text( {

		        text = " Ваш союзник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(112, 128, 144),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_GUARD or ply:GetRoleName() == CHAOSSPY then

			local hide = false



			if (LocalPlayer():GetRoleName()  == MTFGeneral) then

			    hide = false

				draw.Text( {

		        text = " Сотрудник ",

		        pos = { ScrW() / 2, ScrH() / 2 + 50 },

		        font = "SafeZone_INFO",

		        color = Color(0, 0, 139),

		        xalign = TEXT_ALIGN_CENTER,

		        yalign = TEXT_ALIGN_CENTER,

	            })

			end

			if hide == true then return end

		end

		if ply:GetRoleName() == SCP1471 then

			local hide = true

			if IsValid(LocalPlayer():GetActiveWeapon()) then

				if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then

					hide = false

				end

			end

			if (LocalPlayer():GTeam() == TEAM_SCP) then

				hide = false

			end

			if hide == true then return end

		end

		if ply:GTeam() == TEAM_SCP then

			text = GetLangRole(ply:GetRoleName())

			clr = gteams.GetColor(ply:GTeam())

		else

			for k,v in pairs(SAVEDIDS) do

				if v.pl == ply then

					if v.id != nil then

						if isstring(v.id) then

							text = v.pl.knownrole

							clr = gteams.GetColor(ply:GTeam())

							text = GetLangRole(v.pl.knownrole)

						end

					end

				end

			end

		end

		AddToIDS(ply)

	else

		return

	end



	local x = ScrW() / 2

	local y = ScrH() / 2 + 30





  --[[if ply:GTeam() != TEAM_SCP then

	draw.Text( {

		text = ply:GetNamesurvivor() .. " ",

		pos = { x, y },

		font = "HUDFontTitle",

		color = clr2,

		xalign = TEXT_ALIGN_CENTER,

		yalign = TEXT_ALIGN_CENTER,

	})

end]]

--]]

function GM:HUDDrawTargetID()
end

local cam = cam
local surface = surface
local draw = draw

local szmat = Material("icon16/star.png")
local offset = Vector( 0, 0, 85 )
local angletobeedited = Angle(0, 0, 90)
local nicknamecolor = Color( 255, 255, 255, 220 )
local LocalPlayer = LocalPlayer
local role = role

local function DrawTargetID()
	local client = LocalPlayer()

	if client:GTeam() == TEAM_SPEC then return end
	if GetConVar("breach_config_screenshot_mode"):GetInt() == 1 then return end

	local tr = client:GetEyeTraceNoCursor()

	local ply = tr.Entity

--if ( ply:SteamID() == "STEAM_0:0:64560624" ) then return true end

	if !IsValid(ply) then return true end

	if !ply:IsPlayer() then return true end

	if ply:Health() < 0 then return true end --alive is slow

	--if ( ply:GetNamesurvivor() == "Tolya Pechenushkin" ) then return true end

	--if ply:Crouching() then return true end

	if ply:GetNoDraw() then return true end

	local plyteam = ply:GTeam()
	if plyteam == TEAM_SCP or plyteam == TEAM_SPEC then return true end

	--local offset = Vector( 0, 0, 85 )

  local ang = client:EyeAngles()

	local plypos = ply:GetPos()
	local lplypos = ply:GetPos()

  local pos = plypos + offset + ang:Up()

	ang:RotateAroundAxis( ang:Forward(), 90 )

  ang:RotateAroundAxis( ang:Right(), 90 )

	local nickp = ply:GetNamesurvivor()

	local spos = pos:ToScreen()

  local center = lplypos:ToScreen()

	angletobeedited["y"] = ang["y"]

	cam.Start3D2D( pos, angletobeedited, 0.1 )

		if plypos:DistToSqr(lplypos) < 40000 then

        --[[
			if ply:IsSuperAdmin() or ply:GetUserGroup() == "Developer" then

				draw.DrawText( "NO Developer", "char_title", 2, -24, Color( 255, 0, 0, 220 ), TEXT_ALIGN_CENTER )

				surface.SetDrawColor( Color( 255, 0, 0, 220 ) )

				surface.DrawOutlinedRect( -180, -22, ScrW() / 5.3, 50 )

				surface.DrawOutlinedRect( -180, -23.3, ScrW() / 5.3, 52 )

				draw.RoundedBox(0,-180, -22,ScrW() / 5.3, 50,Color( 0, 0, 0, 120 ))

			end]]


		if client:IsAdmin() then nickp = nickp.. " ("..ply:Nick()..")" end

		draw.DrawText( nickp, "char_title", 2, 22, nicknamecolor, TEXT_ALIGN_CENTER )
		

	    surface.SetFont("char_title")

	    local sizex,_ = surface.GetTextSize( nickp )

			local plyrole = ply:GetRoleName()
			
			if plyrole == role.MTF_Com or plyrole == role.MTF_HOF then

		    surface.SetDrawColor( 0, 0, 255, 255 )

		    surface.SetMaterial( szmat ) -- If you use Material, cache it!

		    surface.DrawTexturedRect( -((sizex/2)+32), 30, 32, 32 )

			end

		end

	cam.End3D2D()

end







hook.Add( "PostDrawTranslucentRenderables", "DrawTargetID", DrawTargetID )