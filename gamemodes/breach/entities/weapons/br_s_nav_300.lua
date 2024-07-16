AddCSLuaFile()

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/snav_1.png" )

end

SWEP.PrintName			= "S-Nav 300"			

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 0
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.Equipableitem = true

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType 			= "normal"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		if SERVER then self.Owner:DrawWorldModel( false ) end
		self.Owner:DrawViewModel( false )
	end
end

function SWEP:Holster()
	return true
end

SWEP.cPlayer = 0
function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:DrawHUD()

	--  > Font
	local font = "guthscpsnav:scp"
	surface.CreateFont( font, {
		font = "DS-Digital",
		size = math.Round( ScreenScale( 7.5 ) ),
		weight = 600,
	} )
	surface.CreateFont( font .. ":info", {
		font = "DS-Digital",
		size = math.Round( ScreenScale( 7.5 ) ),
	} )

	local snav_map_texture = Material( "guth_scp/snav/gm_site19_alpha_nextoren.png" )
    local snav_map_w, snav_map_h = snav_map_texture:Width(), snav_map_texture:Height()
    local snav_texture = Material( "guth_scp/snav/navigator.png" )
    local snav_w, snav_h = snav_texture:Width(), snav_texture:Height()
    local snav_x, snav_y = ScrW() - snav_w * .95, ScrH() - snav_h * .95
    local snav_screen_coords = {
		start = {
			--x = 73,
			--y = 42,
			x = 83,
			y = 76,
		},
		endpos = {
			--x = 361,
			--y = 306 - 13,
			x = 348,
			y = 296,
		}
    }

    --  > Screen bounds
    local screen_x, screen_y = snav_x + snav_screen_coords.start.x, snav_y + snav_screen_coords.start.y
    local screen_w, screen_h = snav_screen_coords.endpos.x - snav_screen_coords.start.x, snav_screen_coords.endpos.y - snav_screen_coords.start.y

    --  > Map bounds
    local map_start, map_end
    local map_width, map_height
    local function get_map_bounds()
        if game.GetWorld() == NULL then return end
        map_start, map_end = game.GetWorld():GetModelBounds()
        map_width, map_height = map_end.x - map_start.x, map_end.y - map_start.y
    end
    get_map_bounds()
	hook.Add( "InitPostEntity", "scpsnav-300", get_map_bounds )

	local function draw_triangle( x, y, ang, scale )
		local ang, ang_dif = math.rad( ang ), math.rad( 150 )
		local triangle = {
			--  > Spike point
			{ x = x + math.cos( ang ) * scale , y = y + math.sin( ang ) * scale },
			--  > Segment points
			{ x = x + math.cos( ang + ang_dif ) * scale , y = y + math.sin( ang + ang_dif ) * scale },
			{ x = x + math.cos( ang - ang_dif ) * scale , y = y + math.sin( ang - ang_dif ) * scale }
		}
	
		--  > Draw lines
		local last_x, last_y = triangle[1].x, triangle[1].y
		for i = 2, #triangle do
			local v = triangle[i]
			surface.DrawLine( last_x, last_y, v.x, v.y )
			
			last_x = v.x
			last_y = v.y
		end
		surface.DrawLine( last_x, last_y, triangle[1].x, triangle[1].y )
	end

	local scps_infos = {}
    local color_black, color_scp_ring = Color( 0, 0, 0 ), Color( 115, 31, 28 )

    --  > S-NAV Texture
    surface.SetMaterial( snav_texture )
    surface.SetDrawColor( color_white )
    surface.DrawTexturedRect( snav_x, snav_y, snav_w, snav_h )

    --  > S-NAV Screen
    local ply_pos = self.Owner:GetPos()
    local relative_x, relative_y = math.Remap( ply_pos.y, map_end.y, map_start.y, 0, snav_map_h ), math.Remap( ply_pos.x, map_end.x, map_start.x, 0, snav_map_w )
    local center_x, center_y = screen_x + screen_w / 2, screen_y + screen_h / 2

    surface.SetDrawColor( color_black )
    surface.DrawOutlinedRect( screen_x, screen_y, screen_w, screen_h )
    local offset = 5
    draw.SimpleText( "S-Nav ".."version ".."300", font .. ":info", screen_x + screen_w / 2, screen_y - 200 + screen_h - draw.GetFontHeight( font ) - offset, Color(244,244,244), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    render.SetScissorRect( screen_x, screen_y, screen_x + screen_w, screen_y + screen_h, true )
        --  > Map
		surface.SetMaterial( snav_map_texture )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( screen_x - relative_x + screen_w / 2, screen_y - relative_y + screen_h / 2, snav_map_w, snav_map_h )

		surface.SetDrawColor( color_black )
		draw_triangle( center_x, center_y, 180 - self.Owner:GetAngles().y + 90, 6 )


    render.SetScissorRect( 0, 0, 0, 0, false )
end