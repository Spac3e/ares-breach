-- Code was kindfullly given by CODING BEAST NAMED SHAKY BRICHERS

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
local blur = Material("pp/blurscreen")

ROLEMENU = ROLEMENU || {}

local faction_switched = nil

function DrawBlurPanel( panel, amount, heavyness )

  local x, y = panel:LocalToScreen( 0, 0 )
  local scrW, scrH = ScrW(), ScrH()
  surface.SetDrawColor( 255, 255, 255 )
  surface.SetMaterial(blur)

  for i = 1, ( heavyness || 3 ) do

    blur:SetFloat( "$blur", ( i / 3 ) * ( amount || 6 ) )
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

  end

end

local small_box_adjust = {
	["SCP-096"] = {
		ang = Angle(-5,75,-5),
		pos = Vector(45,43,-20),
		seq = "idle",
	},
	["SCP-682"] = {
		ang = Angle(0,75,0),
		pos = Vector(15,-25,-6),
		seq = "0_Stand_0",
	},
	["SCP-082"] = {
		ang = Angle(0,75,0),
		pos = Vector(39,39,-32),
		seq = "idle_knife",
	},
	["SCP-106"] = {
		ang = Angle(0,0,0),
		pos = Vector(0,0,1),
	},
	["SCP-2012"] = {
		ang = Angle(0,0,0),
		pos = Vector(0,0,3),
	},
	["SCP-811"] = {
		ang = Angle(0,0,0),
		pos = Vector(0,0,2),
	},
	["SCP-973"] = {
		ang = Angle(0,0,0),
		pos = Vector(0,0,2),
	},
	["SCP-638"] = {
		ang = Angle(0,0,0),
		pos = Vector(0,0,0),
	},
	["SCP-999"] = {
		ang = Angle(0,95,0),
		pos = Vector(33,5,11),
	},
	["SCP-062-FR"] = {
		ang = Angle(0,75,-5),
		pos = Vector(40,30,-20),
	},
	["SCP-939"] = {
		ang = Angle(0,0,0),
		pos = Vector(5,37,-2),
	},
}


local function adjust_position(pn, model, rolename)

	pn._ang = Angle(0, 45, 0)
	pn._pos = Vector(0, -2, 0)

	if model == "models/cultist/scp/scp_939.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-33, -33, 0)
		pn.customseq = "idle_knife"

	elseif model == "models/cultist/scp/scp_999_new.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-33, -33, 0)
		pn.customseq = "idle_knife"

	elseif model == "models/cultist/scp/scp_062fr_new.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-15, -15, 0)
		pn.customseq = "stand_idle_2"


	elseif model == "models/cultist/scp/scp_082.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-24, -24, -6)
		pn.customseq = "idle_knife"
		pn.Entity:SetPlaybackRate(0.4)

	elseif model == "models/cultist/scp/scp_811.mdl" then

		pn.customseq = "811_Walk_01"
		pn.Entity:SetPlaybackRate(0.4)


	elseif model == "models/cultist/scp/scp_049.mdl" then

		pn.customseq = "0_049_idle"

	elseif model == "models/cultist/scp/scp_106.mdl" then

		pn.customseq = "0_106_Idle_new"

	elseif model == "models/cultist/scp/scp_096.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-5, -5, 0)
		pn.customseq = "idle"

	elseif model == "models/cultist/scp/scp638/scp_638.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(-5, -5, 0)
		pn.customseq = "idle_standing"

	elseif model == "models/cultist/scp/scp_682.mdl" then

		pn._ang = Angle(0, 35, 0)
		pn._pos = Vector(-65, -55, -10)
		pn.customseq = "0_Stand_0"

	elseif model == "models/cultist/humans/class_d/shaky/class_d_bor_new.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(0, -2, 0)
		pn.customseq = nil

		pn.Entity:SetPlaybackRate(0.4)

		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(7,5,0))
		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-9,0,0))
		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_ForeArm"), Angle(9,0,0))
		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_ForeArm"), Angle(-5,0,0))

		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(5,0,0))

	elseif model == "models/cultist/humans/class_d/shaky/class_d_fat_new.mdl" then

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(0, -2, 0)
		pn.customseq = nil

		pn.Entity:SetPlaybackRate(0.4)

		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(7,0,0))
		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-6,0,0))

		pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(5,0,0))

	else

		pn._ang = Angle(0, 45, 0)
		pn._pos = Vector(0, -2, 0)
		pn.customseq = nil

		pn.Entity:SetPlaybackRate(0.4)

		if pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm") then

			pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0,17,0))

			pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(5,0,0))

			if model:find("class_d") or model:find("head_site") or model:find("sci") or model:find("secur") then
				pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(3,0,0))
				if model:find("head_site") then
					pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(2,0,0))
					pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0,17,0))
				else
					pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-1,0,0))
				end
			else
				pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(3,0,0))
				pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-3,0,0))
			end

			if rolename == "GOC Juggernaut" then
				pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(8,0,0))
				pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(-6,0,0))
			end

			pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_Spine4"), Angle(0,10,0))
			pn.Entity:ManipulateBoneAngles(pn.Entity:LookupBone("ValveBiped.Bip01_Spine1"), Angle(0,-10,0))
		end
	end

end


local blur = Material("pp/blurscreen")
function draw.Blur_New(_x, _y, _w, _h, panel, amount, heavyness)
	local x, y = panel:LocalToScreen( 0, 0 )

	  local scrW, scrH = ScrW(), ScrH()
	  surface.SetDrawColor( 255, 255, 255 )
	  surface.SetMaterial(blur)

	  local sx, sy = panel:LocalToScreen( _x, _y )
	  local sex, syx = panel:LocalToScreen( _x+_w, _y+_h )

	  for i = 1, ( heavyness || 3 ) do

	  	blur:SetFloat( "$blur", ( i / 3 ) * ( amount || 6 ) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()

	  	render.SetScissorRect(sx, sy, sex, syx, true)

		    surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

	    render.SetScissorRect( 0, 0, 0, 0, false )

	end
end

function draw.Blur(x, y, w, h)
	local X, Y = 0,0

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	for i = 1, 5 do
		blur:SetFloat("$blur", (i / 3) * (2))
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
   
   --draw.RoundedBox(0,x,y,w,h, color)
   surface.SetDrawColor(0,0,0, 50) 
   surface.DrawOutlinedRect(x,y,w,h)
end
BREACH = BREACH || {}

local cdforuse_role = 0
local cdforuse_roletime = 0.2
local mat_head = Material( "nextoren/gui/f2_menu/3.png" )
local mat_body = Material( "nextoren/gui/f2_menu/2.png" )
local mat_bottom = Material( "nextoren/gui/f2_menu/1.png" )

local gradient = Material("vgui/gradient-r")

function OpenClassMenu()
if LocalPlayer():GTeam() != TEAM_SPEC then
	AresWarning(BREACH.TranslateString("l:f2_only_for_specs"))
	return
end
	local client = LocalPlayer()

	if ( cdforuse_role > CurTime() ) then return end

	local mat_precache = Material( "nextoren/gui/roles_icon/mtf.png" )

    local gradient_down = Material( "gui/gradient_up" )

    local clr_red = Color( 255, 0, 0, 180 )
    local clr_gray = Color( 198, 198, 198, 180 )
    local clr_gray_noalpha = Color( 198, 198, 198 )
    local clr_white_gray = Color( 210, 210, 210 )
    local clr_whiter = Color( 222, 222, 222 )

	local clr_green = Color( 170, 170, 170 )
    local clr_green_blue = Color( 0, 255, 255 )

    local eye_offset = Vector( 2, 0, 2 )
    local pos_offset = Vector( -13, 0, 0 )

    local function toLines(text, font, mWidth)
		surface.SetFont(font)
			
		local buffer = { }
		local nLines = { }
	
		for word in string.gmatch(text, "%S+") do
			local w,h = surface.GetTextSize(table.concat(buffer, " ").." "..word)
			if w > mWidth then
				table.insert(nLines, table.concat(buffer, " "))
				buffer = { }
			end
			table.insert(buffer, word)
		end
				
		if #buffer > 0 then -- If still words to add.
			table.insert(nLines, table.concat(buffer, " "))
		end
			
		return nLines
	end

	local function drawMultiLine(text, font, mWidth, spacing, x, y, color, alignX, alignY, oWidth, oColor)
		
		local mLines = toLines(text, font, mWidth)
	
		for i,line in pairs(mLines) do
			if oWidth and oColor then
				draw.SimpleTextOutlined(line, font, x, y + (i - 1) * spacing, color, alignX, alignY, oWidth, oColor)
			else
				draw.SimpleText(line, font, x, y + (i - 1) * spacing, color, alignX, alignY)
			end
		end
			
		return (#mLines - 1) * spacing
		-- return #mLines * spacing
	end
	
	local weight, height = ScrW(), ScrH()
	local dividedw, dividedh = weight / 2, height / 2
	
	gui.EnableScreenClicker( true )

	ROLEMENU.enabled = true
	
	BREACH.RoleMenu = vgui.Create( "DPanel" )
	BREACH.RoleMenu:SetSize( 960, 702 )
	BREACH.RoleMenu:Center()
	BREACH.RoleMenu:SetText( "" )
	BREACH.RoleMenu.OnRemove = function()
	
		if ( vgui.CursorVisible() ) then
	
		  gui.EnableScreenClicker( false )
	
		end
	
	end
	
	BREACH.RoleMenu.Paint = function( self, w, h )
	
		if ( !vgui.CursorVisible() ) then
	
		  gui.EnableScreenClicker( true )
	
		end
	
		draw.RoundedBox( 0, 0, 0, w, h, color_black )
	
	end
	local menuw, menuh = BREACH.RoleMenu:GetSize()

	BREACH.FactionInformation = vgui.Create( "DPanel", BREACH.RoleMenu )
	BREACH.FactionInformation:SetPos( menuw * .25, 0 )
	BREACH.FactionInformation:SetSize( menuw * .75, 702 )
	BREACH.FactionInformation:SetText( "" )
  
	BREACH.FactionInformation.MatIcon = Material( "nextoren/gui/roles_icon/scp.png" )
  
	BREACH.FactionInformation.Paint = function( self, w, h )
  
	  draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
  
	  surface.SetDrawColor( color_white )
	  surface.SetMaterial( self.MatIcon )
	  surface.DrawTexturedRect( w / 2 - 48, 32, 96, 96 )
  
	end
  
	local inf_menu_width, inf_menu_height = BREACH.FactionInformation:GetSize()

	BREACH.FactionInformation.Desc = vgui.Create( "DPanel", BREACH.FactionInformation )
	BREACH.FactionInformation.Desc:SetSize( inf_menu_width, inf_menu_height * .5 )
	BREACH.FactionInformation.Desc:SetPos( 0, inf_menu_height * .25 )
	BREACH.FactionInformation.Desc:SetText( "" )
	BREACH.FactionInformation.Desc.Paint = function( self, w, h )
  
	  surface.SetDrawColor( color_white )
	  surface.SetMaterial( mat_body )
	  surface.DrawTexturedRect( 0, 0, w, h )

  
		draw.SimpleText( L"l:f2_choose", "ChatFont_new", w / 2, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
  
	end
  
	BREACH.FactionInformation.Desc.Title = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
	BREACH.FactionInformation.Desc.Title:SetPos( inf_menu_width * .5, 8 )
	BREACH.FactionInformation.Desc.Title:SetSize( 24, 24 )
	BREACH.FactionInformation.Desc.Title.Paint = function( self, w, h )
  
  
		surface.SetFont( "ChatFont_new" )
  
		local n_w, n_h = surface.GetTextSize( "" )
  
		self:SetSize( n_w, n_h )
		self:SetPos( inf_menu_width * .5 - n_w / 2, 8 )
  
		draw.SimpleText( "", "ChatFont_new", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
		draw.RoundedBox( 0, 0, h - 2, w, 2, color_black )
  
  
	end

	BREACH.FactionInformation.Roles = vgui.Create( "DPanel", BREACH.FactionInformation )
    BREACH.FactionInformation.Roles:SetSize( inf_menu_width, inf_menu_height * .26 )
    BREACH.FactionInformation.Roles:SetPos( 0, inf_menu_height * .75 )
    BREACH.FactionInformation.Roles:SetText( "" )
    BREACH.FactionInformation.Roles.Paint = function( self, w, h )

     draw.RoundedBox( 0, 0, 0, w, h, clr_gray_noalpha )
     draw.OutlinedBox( 0, 0, w, 2, 2, color_black )
     surface.SetDrawColor( color_white )
     surface.SetMaterial( mat_bottom )
     surface.DrawTexturedRect( 0, 0, w, h )

    end

	BREACH.FactionInformation.Head = vgui.Create( "DPanel", BREACH.FactionInformation )
    BREACH.FactionInformation.Head:SetSize( inf_menu_width, inf_menu_height * .25 )
    BREACH.FactionInformation.Head:SetText( "" )

    BREACH.FactionInformation.Head.Paint = function( self, w, h )

     draw.RoundedBox( 0, 0, 0, w, h, clr_green_blue )

     surface.SetDrawColor( color_white )
     surface.SetMaterial( mat_head )
     surface.DrawTexturedRect( 0, 0, w, h )

    end 
	local faction_table = {

		[ 1 ] = { name = clang.ClassD, icon = "nextoren/gui/roles_icon/class_d.png", roles = BREACH_ROLES.CLASSD, Desc = "l:f2_classd" },
		[ 2 ] = { name = clang.SECURITY, icon = "nextoren/gui/roles_icon/sb.png", roles = BREACH_ROLES.SECURITY, Desc = "l:f2_security" },
		[ 3 ] = { name = clang.SCI, icon = "nextoren/gui/roles_icon/sci.png", roles = BREACH_ROLES.SCI, Desc = "l:f2_sci" },
		[ 4 ] = { name = clang.SCI_SPECIAL, icon = "nextoren/gui/roles_icon/sci_special.png", roles = BREACH_ROLES.SPECIAL, Desc = "l:f2_sci" },
		[ 5 ] = { name = clang.MTF, icon = "nextoren/gui/roles_icon/mtf.png", roles = BREACH_ROLES.MTF, Desc = "l:f2_mtf" },
		[ 6 ] = { name = clang.QRT, icon = "nextoren/gui/roles_icon/obr.png", roles = BREACH_ROLES.OBR, Desc = "l:f2_qrt" },
		[ 7 ] = { name = clang.NTF, icon = "nextoren/gui/roles_icon/ntf.png", roles = BREACH_ROLES.NTF, Desc = "l:f2_ntf" },
		[ 8 ] = { name = clang.Chaos, icon = "nextoren/gui/roles_icon/chaos.png", roles = BREACH_ROLES.CHAOS, Desc = "l:f2_chaos" },
		--[ 9 ] = { name = clang.GRU, icon = "nextoren/gui/roles_icon/gru.png", roles = BREACH_ROLES.GRU, Desc = "l:f2_gru" },
		[ 9 ] = { name = clang.Goc, icon = "nextoren/gui/roles_icon/goc.png", roles = BREACH_ROLES.GOC, Desc = "l:f2_goc" },
		[ 10 ] = { name = clang.Cult, icon = "nextoren/gui/roles_icon/scarlet.png", roles = BREACH_ROLES.COTSK, Desc = "l:f2_cult" },
		[ 11 ] = { name = clang.UIU, icon = "nextoren/gui/roles_icon/fbi.png", roles = BREACH_ROLES.FBI, Desc = "l:f2_uiu" },
		[ 12 ] = { name = clang.DZ, icon = "nextoren/gui/roles_icon/dz.png", class_d = "Враг", roles = BREACH_ROLES.DZ, Desc = "l:f2_dz" },
		[ 13 ] = { name = "SCP", icon = "nextoren/gui/roles_icon/scp.png", roles = BREACH_ROLES.SCP, Desc = "l:f2_scp" },
	}

	for i = 1, #faction_table do

	    local faction_tbl = faction_table[ i ]

	    if ( faction_tbl.roles ) then

	    	for i, _ in pairs(faction_tbl.roles) do

		      table.SortByMember( faction_tbl.roles[i].roles, "level", true )

		    end

	    end

	end
  
	BREACH.NameFac = vgui.Create( "DPanel", BREACH.RoleMenu )
	BREACH.NameFac:SetSize( 240, 64 )
	BREACH.NameFac:SetPos( 0, 0 )
	BREACH.NameFac:SetText( "" )
  
	local client = LocalPlayer()
  
	BREACH.NameFac.Paint = function( self, w, h )
  
	  draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
	  draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
  
	  draw.DrawText( "Фракции", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  
	end
	BREACH.FactionsSelector = vgui.Create( "DPanel", BREACH.RoleMenu )
    BREACH.FactionsSelector:SetText( "" )
    BREACH.FactionsSelector:SetSize( menuw / 4, menuh )
    BREACH.FactionsSelector.CurrentTeamID = -1
    BREACH.FactionsSelector.Paint = function( self, w, h )

      draw.RoundedBox( 0, 0, 0, w, h, color_black )
      draw.OutlinedBox( 0, 0, w, h, 4, color_white )
      draw.RoundedBox( 0, 0, menuh * .995, w, menuh * .99, color_white )

    end

	local model_pos_x = 110
	local model_pos_y = 90
	local model_fov = 40
	
	local class_modelpanel2 = vgui.Create( "DPanel", BREACH.RoleMenu )
    class_modelpanel2:SetPos(model_pos_x + 450, model_pos_y - 50)
    class_modelpanel2:SetSize(100, 100)
	class_modelpanel2.Paint = function( self, w, h )

    end

	local faction_title = vgui.Create( "DPanel", BREACH.RoleMenu )
    faction_title:SetPos(model_pos_x + 250, model_pos_y - 10)
    faction_title:SetSize(500, 100)
	faction_title.Paint = function( self, w, h )

    end

    local icon_SPEC = vgui.Create( "DModelPanel", BREACH.RoleMenu )
    icon_SPEC:SetSize(190,324)
	icon_SPEC:SetPos(model_pos_x+160, model_pos_y + 100)
	icon_SPEC:SetFOV( model_fov )
    icon_SPEC:SetModel("")
	icon_SPEC:SetAnimated(false)

	icon_SPEC._ang = Angle(0, 45, 0)
	icon_SPEC._pos = Vector(0, -2, 0)


	icon_SPEC.Pressed = false


	function icon_SPEC:DragMousePress()
		self.PressX, self.PressY = input.GetCursorPos()
		self.Pressed = true
	end

	function icon_SPEC:DragMouseRelease() self.Pressed = false end




    function icon_SPEC:LayoutLocation( Entity )
    	if ( self.Pressed ) then
				local mx, my = input.GetCursorPos()
				self._ang = self._ang - Angle( 0, ( ( self.PressX or mx ) - mx ) / 2, 0 )

				self.PressX, self.PressY = mx, my
			end
    	
        Entity:SetAngles(self._ang)
        Entity:SetPos(self._pos)
    end
    icon_SPEC._Paint = icon_SPEC.Paint
    icon_SPEC.Paint = function(self, w, h)
	    	if self:GetModel() then

	    		local _lerp = (1-self.lerp)
		    	
	    		local bg_x, bg_y, bg_w, bg_h = 0,0+(h/2*_lerp),w, h*self.lerp

	    		draw.Blur_New(bg_x, bg_y, bg_w, bg_h, self)

		    	draw.RoundedBox(0,bg_x, bg_y, bg_w, bg_h,ColorAlpha( color_black, 180 ))

		    	self.startx = 0
				self.starty = (self:GetTall()/2*_lerp)
				self.endx = 0
				self.endy = -(self:GetTall()/2*_lerp)

				self._Paint(self, w, h)


				draw.RoundedBox(0, 0, (h/2*_lerp), w, 15,clr_gray_noalpha)
				draw.RoundedBox(0, 0, (h-15)-(h/2*_lerp), w, 15,clr_gray_noalpha)


		    	self.lerp = math.Approach(self.lerp, 1, RealFrameTime()*2)

		    else
		    	self.lerp = 0
		    end
		end

	BREACH.FactionsSelector.ActualWindow = vgui.Create( "DPanel", BREACH.RoleMenu )
    BREACH.FactionsSelector.ActualWindow:SetText( "" )
    BREACH.FactionsSelector.ActualWindow:SetPos( 0, 4 )
    BREACH.FactionsSelector.ActualWindow:SetSize( menuw / 4, menuh * .99 )
    BREACH.FactionsSelector.ActualWindow.Paint = function() end

    BREACH.FactionsSelector.Scroller = vgui.Create( "DScrollPanel", BREACH.FactionsSelector.ActualWindow )
    BREACH.FactionsSelector.Scroller:Dock( FILL )
    local sbar = BREACH.FactionsSelector.Scroller:GetVBar()
    function sbar:Paint() end
    function sbar.btnGrip:Paint() end
    function sbar.btnDown:Paint() end
    function sbar.btnUp:Paint() end

	local sizew = ( menuw / 4 ) * .4 - 5
    local offset = 0

	BREACH.FactionsSelector.Button = {}

    for i = 1, #faction_table do

		BREACH.FactionInformation.Desc.PlayerDescModel = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetText( "" )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetPos( inf_menu_width * .4, 16 )
		BREACH.FactionInformation.Desc.PlayerDescModel:SetSize( inf_menu_width / 2, inf_menu_height / 4 )
		BREACH.FactionInformation.Desc.PlayerDescModel.Box1x = ( inf_menu_width / 2 ) / 2
		BREACH.FactionInformation.Desc.PlayerDescModel.Box2x = ( inf_menu_width / 2 ) / 2
		BREACH.FactionInformation.Desc.PlayerDescModel.icon_Alpha = 0
		BREACH.FactionInformation.Desc.PlayerDescModel.desc_Alpha = 0
  
		BREACH.FactionInformation.Desc.PlayerDescModel.TimeCreation = RealTime()

  
		mat_precache = Material( faction_table[ i ].icon )
  
		BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function( self, w, h )
  
		end

		BREACH.FactionInformation.Desc.PlayerStatistics = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetText( "" )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetPos( inf_menu_width * .4, inf_menu_height / 4 + 32 )
        BREACH.FactionInformation.Desc.PlayerStatistics:SetSize( inf_menu_width / 2, inf_menu_height / 6 )
        BREACH.FactionInformation.Desc.PlayerStatistics.Box1y = ( inf_menu_height / 6 ) / 2 - 16
        BREACH.FactionInformation.Desc.PlayerStatistics.Box2y = ( inf_menu_height / 6 ) / 2
        BREACH.FactionInformation.Desc.PlayerStatistics.TextAlpha = 0

        local function reset_animation()
			BREACH.FactionInformation.Desc.PlayerDescModel.Box1x = ( inf_menu_width / 2 ) / 2
			BREACH.FactionInformation.Desc.PlayerDescModel.Box2x = ( inf_menu_width / 2 ) / 2
			BREACH.FactionInformation.Desc.PlayerDescModel.icon_Alpha = 0
			BREACH.FactionInformation.Desc.PlayerDescModel.desc_Alpha = 0
			BREACH.FactionInformation.Desc.PlayerDescModel.TimeCreation = RealTime() -0.2

			BREACH.FactionInformation.Desc.PlayerStatistics.Box1y = ( inf_menu_height / 6 ) / 2 - 16
	        BREACH.FactionInformation.Desc.PlayerStatistics.Box2y = ( inf_menu_height / 6 ) / 2
	        BREACH.FactionInformation.Desc.PlayerStatistics.TextAlpha = 0
		end

        BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function( self, w, h )

        end

     BREACH.FactionsSelector.Button[ i ] = BREACH.FactionsSelector.Scroller:Add( "DImageButton", BREACH.FactionsSelector )
     local button = BREACH.FactionsSelector.Button[ i ]
     button:SetSize( sizew, 96 )
     button:SetImage( faction_table[ i ].icon )

        if ( ( i - 1 ) % 2 == 0 && ( i - 1 ) > 0 ) then

         offset = 110 * ( ( i - 1 ) / 2 )

        end

     button:SetPos( 18 + ( sizew * ( ( i - 1 ) % 2 ) ) * 1.2, 16 + offset )
     button:SetText( "" )
     button.AlphaClr = 0
        button.Paint = function( self, w, h )

            if ( self:IsHovered() || ( BREACH.FactionsSelector.CurrentTeamID || false ) == i ) then

             button.AlphaClr = math.Approach( button.AlphaClr, 180, FrameTime() * 256 )

            elseif ( button.AlphaClr > 0 && !self:IsHovered() ) then

             button.AlphaClr = math.Approach( button.AlphaClr, 0, FrameTime() * 512 )

            end

          surface.SetDrawColor( ColorAlpha( color_white, button.AlphaClr ) )
          surface.SetMaterial( gradient_down )
          surface.DrawTexturedRect( 0, 0, w, h )

        end

		

        button.DoClick = function()
			faction_switched = true
			timer.Simple( 0.1 , function()
			    faction_switched = false
			end)

			
			if ( BREACH.FactionInformation.Roles.ActualMenu ) then
				BREACH.FactionInformation.Roles.ActualMenu:Remove()
			end



			BREACH.FactionInformation.Desc.Paint = function( self, w, h )
  
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_body )
				surface.DrawTexturedRect( 0, 0, w, h )
		  
		  
				drawMultiLine( L(faction_table[ i ].Desc), "rolemenu_desc", w / 1.5, 18, 64, 32, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			
			end
			local localmat = Material(faction_table[ i ].icon, "smooth noclamp")
			class_modelpanel2.Paint = function( self, w, h )
				surface.SetDrawColor( 255,255,255  )
				surface.SetMaterial( localmat )
				surface.DrawTexturedRect( 0, 0, 100, 100 )
			end
			faction_title.Paint = function( self, w, h )
				draw.SimpleText( faction_table[ i ].name, "JuneFont", w / 2, h / 1.35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			BREACH.FactionInformation.Roles.ActualMenu = vgui.Create( "DPanel", BREACH.FactionInformation.Roles )
            BREACH.FactionInformation.Roles.ActualMenu:SetText( "" )
            BREACH.FactionInformation.Roles.ActualMenu:SetSize( inf_menu_width, inf_menu_height * .23  )
            BREACH.FactionInformation.Roles.ActualMenu.Paint = function( self, w, h ) end

            BREACH.FactionInformation.Roles.Scroller = vgui.Create( "DScrollPanel", BREACH.FactionInformation.Roles.ActualMenu )
            BREACH.FactionInformation.Roles.Scroller:Dock( FILL )
            local sbar = BREACH.FactionInformation.Roles.Scroller:GetVBar()
            function sbar:Paint( w, h ) end
            function sbar.btnGrip:Paint( w, h )

                draw.RoundedBoxEx( 4, 0, 0, 8, h, clr_gray_noalpha, true, true, true, true )

            end
            function sbar.btnDown:Paint( w, h ) end
            function sbar.btnUp:Paint( w, h ) end

            local y_offset = 0
            local x_offset = 0

            local x_offset2 = 0
			if faction_table[ i ].roles != nil then
				for k, v in pairs( faction_table[ i ].roles ) do
					


					for i,cls in ipairs(v.roles) do
						local isblack = math.random(1,3) == 1

						if cls.name == "CI Spy" then
							local values = BREACH.ChaosSpy_CanBe
							local val = values[math.random(1, #values)]
							local tab

							for i, v in pairs(BREACH_ROLES.SECURITY.security.roles) do
								if v.name == val then
									tab = v
								end
							end

							cls.weapons = tab.weapons
							cls.headgear = tab.headgear
							cls.head = tab.head
							cls.walkspeed = tab.walkspeed
							cls.runspeed = tab.runspeed
							cls.jumppower = tab.jumppower
							cls.keycard = tab.keycard
							cls.usehead = tab.usehead
							cls.randomizehead = tab.randomizehead
							cls.randomizeface = tab.randomizeface
							cls.ammo = tab.ammo
							for i = 0, 9 do
								cls["bodygroup"..i] = tab["bodygroup"..i]
							end
						end

						if cls["white"] then isblack = false end
						if cls["level"] > 100 then continue end
						local headtext = PickFaceSkin(isblack)
						local HeadModel = istable(cls["head"]) and table.Random(cls["head"]) or cls["head"]


						if cls["usehead"] then
							if cls["randomizehead"] then
								HeadModel = PickHeadModel()
							else
								HeadModel = "models/cultist/heads/male/male_head_1.mdl"
							end
						end
						local HairModel = nil
						if math.random(1, 5) > 1 then
							if isblack and cls["blackhairm"] then
								HairModel = cls["blackhairm"][math.random(1, #cls["blackhairm"])]
							elseif cls["hairm"] then
								HairModel = cls["hairm"][math.random(1, #cls["hairm"])]
							end
						end
						if ( 16 + 90 * ( i - 1 ) > inf_menu_width * .8 ) and ( 16 + 90 * ( i - 2 ) < (inf_menu_width * .8)*2 ) then
	
							x_offset = x_offset + 1
							y_offset = 1.1

						elseif ( 16 + 90 * ( i - 2 ) > (inf_menu_width * 2 * .8) ) then

							x_offset2 = x_offset2 + 1
							y_offset = 2.2
					  
						end
					  
						BREACH.FactionInformation.Roles.RoleIcon = BREACH.FactionInformation.Roles.Scroller:Add( "DPanel", BREACH.FactionInformation.Roles )
						BREACH.FactionInformation.Roles.RoleIcon:SetText( "" )
					  
						if ( y_offset <= 0 ) then
					  
							BREACH.FactionInformation.Roles.RoleIcon:SetPos( 16 + 90 * ( i - 1 ), 16 )
					  
						elseif y_offset == 2.2 then
					  
							BREACH.FactionInformation.Roles.RoleIcon:SetPos( 16 + 90 * ( x_offset2 - 1 ), 16 + ( 80 * y_offset ) )

						else
					  
							BREACH.FactionInformation.Roles.RoleIcon:SetPos( 16 + 90 * ( x_offset - 1 ), 16 + ( 80 * y_offset ) )
					  
						end
					  
						BREACH.FactionInformation.Roles.RoleIcon:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.RoleIcon.Paint = function( self, w, h )
					  
							draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
					  
						end
					  
						local player_level = LocalPlayer():GetNLevel()
					  
						local role_level = cls["level"]
	
						BREACH.FactionInformation.Roles.FaceModel = vgui.Create( "DModelPanel", BREACH.FactionInformation.Roles.RoleIcon )
						BREACH.FactionInformation.Roles.FaceModel:SetModel( table.Random(cls["models"]) || "models/player/Group01/male_01.mdl" )
						BREACH.FactionInformation.Roles.FaceModel:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.FaceModel.LayoutEntity = function( self, ent ) end

						local h, s, v = gteams.GetColor(cls["team"]):ToHSV()

						local tcolor = HSVToColor(h, s, 1)
						local tcolor2 = HSVToColor(h, s, 0.4)
						local col = HSVToColor(h, 0.3, 1)

						local colors_shading = {
							[BOX_TOP] = Color(50, 50, 50),
							[BOX_BOTTOM] = Color(50, 50, 50),
							[BOX_BACK] = Color(50, 50, 50),
							[BOX_FRONT] = col,
							[BOX_RIGHT] = tcolor,
							[BOX_LEFT] = tcolor2,
						}

						for i, v in pairs(colors_shading) do
							BREACH.FactionInformation.Roles.FaceModel:SetDirectionalLight(i, v)
						end
					  
						local faceinfentity = BREACH.FactionInformation.Roles.FaceModel.Entity
					  
						local idle_seq
					  
						local head = faceinfentity:LookupBone( "ValveBiped.Bip01_Head1" )

						if small_box_adjust[cls["name"]] then
							if small_box_adjust[cls["name"]].seq then
								idle_seq = faceinfentity:LookupSequence( small_box_adjust[cls["name"]].seq )
							end
							faceinfentity:SetPos(faceinfentity:GetPos() + small_box_adjust[cls["name"]].pos)
							faceinfentity:SetAngles(faceinfentity:GetAngles() + small_box_adjust[cls["name"]].ang)
						end

						if cls["name"] == "SCP-638" then
							faceinfentity:ManipulateBoneAngles(9, Angle(15,0,80))
						end

						if idle_seq then
							faceinfentity:ResetSequence(idle_seq)
						end
					  
						if ( head ) then
							if cls["name"] == SCP106 then return end
					  
							local eyepos = faceinfentity:GetBonePosition( head )
							eyepos:Add( eye_offset )
					  
							BREACH.FactionInformation.Roles.FaceModel:SetLookAt( eyepos )
							BREACH.FactionInformation.Roles.FaceModel:SetFOV(40)
							BREACH.FactionInformation.Roles.FaceModel.Entity:SetAngles(Angle(-5,math.Rand(25, 35),0))
							BREACH.FactionInformation.Roles.FaceModel.Entity:SetPos(Vector(-5,math.Rand(2.5, 3),math.Rand(-0.25,0.25)))

							BREACH.FactionInformation.Roles.FaceModel.Entity:ManipulateBoneAngles(head, Angle(math.Rand(-2, -7),5,math.Rand(-20, -10)))
							if cls["name"] == role.UIU_Clocker then
								BREACH.FactionInformation.Roles.FaceModel.Entity:ManipulateBoneAngles(head, Angle(math.Rand(-2, -7),-7,math.Rand(10, 15)))
							end

							if cls["team"] != TEAM_SCP then
								local l1 = 10
								local l2 = -10
								if math.random(0,1) == 1 then
									l1 = l2
									l2 = 10
								end
								BREACH.FactionInformation.Roles.FaceModel.Entity:ManipulateBoneAngles(faceinfentity:LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(math.Rand(-10,10), math.Rand(0, l1), 0))
								BREACH.FactionInformation.Roles.FaceModel.Entity:ManipulateBoneAngles(faceinfentity:LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(math.Rand(-10,10), math.Rand(0, l2), 0))
							end

							BREACH.FactionInformation.Roles.FaceModel:SetCamPos( eyepos - pos_offset )
							faceinfentity:SetEyeTarget( eyepos - pos_offset )
					  
							if ( cls["skin"] ) then
					  
							  faceinfentity:SetSkin( cls["skin"] )
					  
							end

							if isblack and faceinfentity:GetModel():find("class_d") then faceinfentity:SetSkin(1) end
	
							for i = 0, 15 do
								if ( cls["bodygroup"..i] ) then
						  
									faceinfentity:SetBodygroup( i, cls["bodygroup"..i] )
							
								end
							end

							if faceinfentity:GetModel():find("class_d") and !faceinfentity:GetModel():find("cleaner") and LocalPlayer():IsPremium() then
								faceinfentity:SetBodygroup( 0, math.random(0,4) )
							end
	
							if cls["head"] != nil or cls["usehead"] then
								if HeadModel:find("male_head") or HeadModel:find("balaclava") then
									BREACH.FactionInformation.Roles.FaceModel:BoneMerged( HeadModel, headtext )
								else
									BREACH.FactionInformation.Roles.FaceModel:BoneMerged( HeadModel )
								end
							end

							if HairModel then
								BREACH.FactionInformation.Roles.FaceModel:BoneMerged( HairModel )
							end
					   
							if cls["headgear"] != nil then
								BREACH.FactionInformation.Roles.FaceModel:BoneMerged( cls["headgear"] )
							end
					   
							if cls["hackerhat"] != nil then
								BREACH.FactionInformation.Roles.FaceModel:BoneMerged( cls["hackerhat"] )
							end
					   
							if cls["headgearrandom"] != nil then
								BREACH.FactionInformation.Roles.FaceModel:BoneMerged( cls["headgearrandom"] )
							end
					  
							if ( player_level < ( role_level || 0 ) ) then
					  
					  			if faceinfentity.BoneMergedEnts then
					  				for i, v in pairs(faceinfentity.BoneMergedEnts) do
					  					v:SetMaterial( "lights/white001" )
					  					v:SetColor(color_black)
					  				end
					  			end
								faceinfentity:SetMaterial( "lights/white001" )
								faceinfentity:SetColor(color_black)
							--	BREACH.FactionInformation.Roles.FaceModel:SetColor( clr_white_gray )
					  
							end
	
					  
						end
					  
						BREACH.FactionInformation.Roles.FaceModel.Closed = vgui.Create( "DButton", BREACH.FactionInformation.Roles.FaceModel )
						if cls["team"] != TEAM_SCP and ( player_level >= ( role_level || 0 ) ) then

								local anim_savepos = faceinfentity:GetPos()
								local anim_svaeang = faceinfentity:GetAngles()

								local aimang = Angle(-5,5,0)
								local aimpos = Vector(-5,0.3,1)

								local anim_origbones = {}

								for i = 0, faceinfentity:GetBoneCount() - 1 do
						        local ang = faceinfentity:GetManipulateBoneAngles(i)

						        if ang != angle_zero then
						        	anim_origbones[i] = ang
						        end
						    end

						    BREACH.FactionInformation.Roles.FaceModel.Closed.PaintOver = function(self, w, h)
						    	if self:IsHovered() then
						    		faceinfentity:SetAngles(LerpAngle(math.min(0.5, FrameTime()*20), faceinfentity:GetAngles(), aimang))
						    		faceinfentity:SetPos(LerpVector(math.min(0.5, FrameTime()*13), faceinfentity:GetPos(), aimpos))
						    		for i, v in pairs(anim_origbones) do
						    			faceinfentity:ManipulateBoneAngles(i, LerpAngle(math.min(0.5, FrameTime()*10), faceinfentity:GetManipulateBoneAngles(i), angle_zero))
						    		end
						    	else
						    		faceinfentity:SetAngles(LerpAngle(math.min(0.5, FrameTime()*15), faceinfentity:GetAngles(), anim_svaeang))
						    		faceinfentity:SetPos(LerpVector(math.min(0.5, FrameTime()*8), faceinfentity:GetPos(), anim_savepos))
						    		for i, v in pairs(anim_origbones) do
						    			faceinfentity:ManipulateBoneAngles(i, LerpAngle(math.min(0.5, FrameTime()*8), faceinfentity:GetManipulateBoneAngles(i), v))
						    		end
						    	end
						  	end

						end
						BREACH.FactionInformation.Roles.FaceModel.Closed:SetText( "" )
						BREACH.FactionInformation.Roles.FaceModel.Closed:SetSize( 80, 80 )
						BREACH.FactionInformation.Roles.FaceModel.Closed.Paint = function( self, w, h )
					  
							if ( self:IsHovered() ) then
					  
								draw.OutlinedBox( 0, 0, w, h, 2, color_black )
	
								if ( self:IsHovered() ) then
	
								   self:SetCursor( "hand" )
					  
								end
					  
							else
					  
							  draw.OutlinedBox( 0, 0, w, h, 2, clr_whiter )
					  
							end
					  
							if ( player_level < ( role_level || 0 ) ) then
					  
							  draw.RoundedBox( 0, 0, 0, w, h, clr_gray )
							  draw.SimpleText( role_level, "ChatFont_new", w / 2, h / 2, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					  
							end
					  
						end

			
						BREACH.FactionInformation.Roles.FaceModel.Closed.DoClick = function()

							if cls["level"] > LocalPlayer():GetNLevel() then return end

							reset_animation()

							icon_SPEC:SetDirectionalLight(BOX_FRONT, colors_shading[BOX_FRONT])
							icon_SPEC:SetDirectionalLight(BOX_RIGHT, Color(25,25,25))

							icon_SPEC.lerp = 0
	
							BREACH.FactionInformation.Desc.Paint = function( self, w, h )
	  
								surface.SetDrawColor( color_white )
								surface.SetMaterial( mat_body )
								surface.DrawTexturedRect( 0, 0, w, h )
						  
							end
	
							BREACH.FactionInformation.Desc.PlayerFullModel = vgui.Create( "DPanel", BREACH.FactionInformation.Desc )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetText( "" )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetPos( 16, 16 )
							BREACH.FactionInformation.Desc.PlayerFullModel:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Box1y = ( inf_menu_height / 2.2 ) / 2
							BREACH.FactionInformation.Desc.PlayerFullModel.Box2y = ( inf_menu_height / 2.2 ) / 2
					  
							BREACH.FactionInformation.Desc.PlayerFullModel.Paint = function( self, w, h )
					  

					  
							end
	
							BREACH.FactionInformation.Desc.PlayerFullModel.Model = vgui.Create( "DModelPanel", BREACH.FactionInformation.Desc )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetPos( 16, 16 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Model.LayoutEntity = function( ent ) end
							BREACH.FactionInformation.Desc.PlayerFullModel.Model:SetAnimated( true )
	
							BREACH.FactionInformation.Desc.PlayerFullModel.Render = vgui.Create( "DPanel", BREACH.FactionInformation.Desc.PlayerFullModel.Model )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render:SetText( "" )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render:SetSize( inf_menu_width / 3.5, inf_menu_height / 2.2 )
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Box1y = ( inf_menu_height / 2.2 ) / 2
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Box2y = ( inf_menu_height / 2.2 ) / 2 - 24
					  
							BREACH.FactionInformation.Desc.PlayerFullModel.Render.Paint = function( self, w, h )


					  
							end

							local roles_icons = Material("nextoren/gui/roles_icon/scp.png")
								if cls["team"] == TEAM_GUARD then
									roles_icons = Material("nextoren/gui/roles_icon/mtf.png")
								elseif cls["team"] == TEAM_SECURITY then
									roles_icons = Material("nextoren/gui/roles_icon/sb.png")
								elseif cls["team"] == TEAM_DZ then
									roles_icons = Material("nextoren/gui/roles_icon/dz.png")
								elseif cls["team"] == TEAM_CHAOS then
									roles_icons = Material("nextoren/gui/roles_icon/chaos.png")
								elseif cls["team"] == TEAM_CLASSD then
									roles_icons = Material("nextoren/gui/roles_icon/class_d.png")
								elseif cls["team"] == TEAM_COTSK then
									roles_icons = Material("nextoren/gui/roles_icon/scarlet.png")
								elseif cls["team"] == TEAM_GOC then
									roles_icons = Material("nextoren/gui/roles_icon/goc.png")
								elseif cls["team"] == TEAM_GRU then
									roles_icons = Material("nextoren/gui/roles_icon/gru.png")
								elseif cls["team"] == TEAM_USA then
									roles_icons = Material("nextoren/gui/roles_icon/fbi.png")
								elseif cls["team"] == TEAM_SCI then
									roles_icons = Material("nextoren/gui/roles_icon/sci.png")
								elseif cls["team"] == TEAM_SPECIAL then
									roles_icons = Material("nextoren/gui/roles_icon/sci_special.png")
								elseif cls["team"] == TEAM_NTF then
									roles_icons = Material("nextoren/gui/roles_icon/ntf.png")
								elseif cls["team"] == TEAM_OSN then
									roles_icons = Material("nextoren/gui/roles_icon/osn.png")
								elseif cls["team"] == TEAM_QRT then
									roles_icons = Material("nextoren/gui/roles_icon/obr.png")
								elseif cls["team"] == TEAM_SCP then
									roles_icons = Material("nextoren/gui/roles_icon/scp.png")
								end
	
							BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function( self, w, h )
	  
								self.Box1x = math.Approach( self.Box1x, 24, FrameTime() * 312 )
								self.Box2x = math.Approach( self.Box2x, w - 24, FrameTime() * 312 )
								self.icon_Alpha = math.Approach( self.icon_Alpha, 160, FrameTime() * 128 )
								DrawBlurPanel( self )
		
								surface.SetDrawColor( ColorAlpha( color_white, self.icon_Alpha ) )
								surface.SetMaterial( roles_icons )
								surface.DrawTexturedRect( w / 2 - 64, h / 2 - 64, 128, 128 )
						
								draw.RoundedBox( 0, self.Box1x - 24, 0, ( self.Box2x + 24 ) - self.Box1x, h, ColorAlpha( color_black, 180 ) )
						
								draw.RoundedBox( 0, self.Box1x - 24, 0, 24, h, clr_gray_noalpha )
								draw.RoundedBox( 0, self.Box2x, 0, 24, h, clr_gray_noalpha )
						
								if ( self.TimeCreation + .8 < RealTime() ) then
	
									if cls["team"] == TEAM_SCP then
										self.desc_Alpha = math.Approach( self.desc_Alpha, 255, FrameTime() * 156 )
						
										draw.SimpleText( L"l:scoreboard_level"..": " .. cls["level"], "ChatFont_new", 34, 12, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										draw.SimpleText( L"l:f2_name " .. cls["name"], "ChatFont_new", 34, 30, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										drawMultiLine( L"l:f2_objectives " .. ( L(cls["tasks"]) || L"l:f2_no_objectives" ), "ChatFont_new", w / 1.5, 16, 34, 16 * 3, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									else
						
										self.desc_Alpha = math.Approach( self.desc_Alpha, 255, FrameTime() * 156 )
						
										draw.SimpleText( L"l:scoreboard_level"..": " .. cls["level"], "ChatFont_new", 34, 12, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										draw.SimpleText( L"l:f2_name " .. GetLangRole(cls["name"]), "ChatFont_new", 34, 30, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
						
										drawMultiLine( L"l:f2_objectives " .. ( L(cls["tasks"]) || L"l:f2_no_objectives" ), "ChatFont_new", w / 1.5, 16, 34, 16 * 3, ColorAlpha( color_white, self.desc_Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									end
						
								end
						
							end

							local stamina = "100"

							if cls["stamina"] then
								stamina = tostring(cls["stamina"]*100)
							end
	
							BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function( self, w, h )
					
								self.Box1y = math.Approach( self.Box1y, 0, FrameTime() * 128 )
								self.Box2y = math.Approach( self.Box2y, inf_menu_height / 6 - 16, FrameTime() * 128 )
					
								draw.RoundedBox( 0, 0, self.Box1y, w, self.Box2y - self.Box1y, clr_gray )
					
								DrawBlurPanel( self )
					
								draw.RoundedBox( 0, 0, self.Box1y, w, 16, clr_gray_noalpha )
								draw.RoundedBox( 0, 0, self.Box2y, w, 16, clr_gray_noalpha )
					
								if ( self.Box1y == 0 ) then
					
									self.TextAlpha = math.Approach( self.TextAlpha, 210, FrameTime() * 256 )
					
									draw.SimpleText( L"l:f2_char_stats", "ChatFont_new", w / 2, 28, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					
									draw.SimpleText( L"l:f2_health " .. cls["health"], "ChatFont_new", 16, 40, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
									draw.SimpleText( L"l:f2_stamina " .. stamina, "ChatFont_new", 16, 40 * 1.5, ColorAlpha( color_black, self.TextAlpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
					
								end
					
							end
						 
							if cls["models"] != nil then
								icon_SPEC:SetModel( table.Random(cls["models"]) ) 
							elseif cls["models"] == nil then
								icon_SPEC:SetModel("")
							end

							adjust_position(icon_SPEC, icon_SPEC:GetModel(), cls["name"])

							if HairModel then
								icon_SPEC:BoneMerged(HairModel)
							end
					   
							if cls["headgear"] != nil then
								icon_SPEC:BoneMerged(cls["headgear"])
							end
					   
							if cls["hackerhat"] != nil then
								icon_SPEC:BoneMerged(cls["hackerhat"])
							end
					   
							if cls["headgearrandom"] != nil then
								icon_SPEC:BoneMerged(cls["headgearrandom"])
							end
					   
							function icon_SPEC:LayoutEntity( Entity )
								
								local seq = "l4d_idle_calm_frying_pan"

								if self.customseq then seq = self.customseq end

								local idle_seq = Entity:LookupSequence( seq )

								Entity:SetSequence(idle_seq)
								self:RunAnimation()

								if self.LayoutLocation then
									self.LayoutLocation(self, Entity)
								end
	
							end

							for i = 0, 13 do
								icon_SPEC.Entity:SetBodygroup( i, faceinfentity:GetBodygroup(i))
							end

							if cls["skin"] != nil then
								  icon_SPEC.Entity:SetSkin( cls["skin"] )
							end
							if isblack and ( icon_SPEC.Entity:GetModel():find("class_d") or icon_SPEC.Entity:GetModel():find("fbi_agent") ) then icon_SPEC.Entity:SetSkin(1) end

							if cls["head"] != nil or cls["usehead"] then
								if isblack and icon_SPEC.Entity:GetModel():find("class_d") then icon_SPEC.Entity:SetSkin(1) end
								if HeadModel:find("male_head") or HeadModel:find("balaclava") then
									icon_SPEC:BoneMerged(HeadModel, headtext)
								else
									icon_SPEC:BoneMerged(HeadModel)
								end
							end

						end
					end
					BREACH.FactionInformation.Roles.FaceModel.Closed.Think = function()
						if faction_switched then
							icon_SPEC:SetModel("")
							BREACH.FactionInformation.Desc.PlayerStatistics.Paint = function()
							end
							BREACH.FactionInformation.Desc.PlayerDescModel.Paint = function()
							end

						end
					end
				end
			end
        end

    end
end

function CloseRoleMenu(open_rolemenu)

	if ( !open_rolemenu ) then

		cdforuse_role = CurTime() + cdforuse_roletime

	end

	ROLEMENU.enabled = false
	gui.EnableScreenClicker( false )

	if ( IsValid( BREACH.RoleMenu ) ) then

		BREACH.RoleMenu:Remove()

	end

end

function IsRoleMenuVisible()

	return ROLEMENU.enabled 
	
end
