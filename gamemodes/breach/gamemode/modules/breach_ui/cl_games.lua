local BUTTON_UP = 1
local BUTTON_LEFT = 2
local BUTTON_DOWN = 3
local BUTTON_RIGHT = 4

local BUTTONS_DOWN = {}

local snake_enabled = false
local freeze_game = false

local MAP_BOUNDS = 51

local SNAKE = {
	{
		x = 25,
		y = 25
	}
}
local APPLE = {
	x = 0,
	y = 0
}

local xvel = 0
local yvel = 0

local tickdelay = 0.1

function SnakeOpen()
	if LocalPlayer():GTeam() != TEAM_SPEC then return end
	snake_enabled = true
	if freeze_game then
		timer.Simple( 2, function()
			freeze_game = false
		end )
	end
end

function SnakeClose()
	snake_enabled = false
	freeze_game = true
	BUTTONS_DOWN = {}
end

function IsKeyDown( key )
	if BUTTONS_DOWN[key] then
		BUTTONS_DOWN[key] = nil
		return true
	end
end

local ntick = 0
function SnakeUpdate()
	if !snake_enabled or freeze_game then return end
	if ntick > CurTime() then return end
	ntick = CurTime() + tickdelay
	if LocalPlayer():GTeam() != TEAM_SPEC then
		SnakeClose()
	end
	if IsKeyDown( BUTTON_UP ) then
		if not ( yvel == 1 and #SNAKE > 1 ) then
			yvel = -1
			xvel = 0
		end
	elseif IsKeyDown( BUTTON_DOWN ) then
		if not ( yvel == -1 and #SNAKE > 1 ) then
			yvel = 1
			xvel = 0
		end
	elseif IsKeyDown( BUTTON_LEFT ) then
		if not ( xvel == 1 and #SNAKE > 1 ) then
			yvel = 0
			xvel = -1
		end
	elseif IsKeyDown( BUTTON_RIGHT ) then
		if not ( xvel == -1 and #SNAKE > 1 ) then
			yvel = 0
			xvel = 1
		end
	end
	local lastx, lasty = 0, 0
	for i, v in ipairs( SNAKE ) do
		local cx, cy = v.x, v.y
		if i == 1 then
			v.x = v.x + xvel
			v.y = v.y + yvel
			if v.x > MAP_BOUNDS then v.x = 1 end
			if v.y > MAP_BOUNDS then v.y = 1 end
			if v.x < 1 then v.x = MAP_BOUNDS end
			if v.y < 1 then v.y = MAP_BOUNDS end
			if v.x == APPLE.x and v.y == APPLE.y then
				GenerateApple()
				table.insert( SNAKE, { x = cx, y = cy } )
				--break
			end
		else
			v.x = lastx
			v.y = lasty
		end
		lastx = cx
		lasty = cy
	end
	for i, v in ipairs( SNAKE ) do
		for _i, _v in ipairs( SNAKE ) do
			if v != _v then
				if v.x == _v.x and v.y == _v.y then
					freeze_game = true
					timer.Simple( 2, function()
						SnakeRestart()
					end )
					return
				end
			end
		end
	end
end

function SnakeDraw()
	if !snake_enabled then return end
	local w, h = ScrW() / 2, ScrH() / 2
	local grid = math.Round( h * 0.031 )
	local sub = grid * MAP_BOUNDS / 2
	surface.SetDrawColor( Color( 245, 245, 245, 255 ) )
	surface.DrawRect( w - sub - grid, h - sub - grid, ( sub + grid ) * 2, ( sub + grid ) * 2 )
	surface.SetDrawColor( Color( 10, 10, 10, 255 ) )
	surface.DrawRect( w - sub - grid / 2, h - sub - grid / 2, ( sub + grid / 2 ) * 2, ( sub + grid / 2 ) * 2 )
	for y = 1, MAP_BOUNDS do
		for x = 1, MAP_BOUNDS do
			surface.SetDrawColor( Color( 100, 100, 100, 200 ) )
			surface.DrawRect( w - sub + grid * ( x - 1 ), h - sub + grid * ( y - 1 ), grid * 0.99, grid * 0.99 )
		end
	end
	for k, v in pairs( SNAKE ) do
		surface.SetDrawColor( Color( 200, 150, 100, 200 ) )
		surface.DrawRect( w - sub + ( v.x - 1 ) * grid, h - sub + ( v.y - 1 ) * grid, grid * 0.99, grid * 0.99 )
	end
	surface.SetDrawColor( Color( 225, 25, 25, 200 ) )
	surface.DrawRect( w - sub + ( APPLE.x - 1 ) * grid, h - sub + ( APPLE.y - 1 ) * grid, grid * 0.99, grid * 0.99 )
end

hook.Add( "Tick", "SnakeUpdate", SnakeUpdate )
hook.Add( "DrawOverlay", "SnakeDraw", SnakeDraw )

hook.Add( "PlayerButtonDown", "SnakeButtons", function( ply, key )
	if !snake_enabled or freeze_game then return end
	key = key - 87
	if key > 0 and key < 5 then
		BUTTONS_DOWN[key] = true
	end
end )

concommand.Add( "br_snake", function( ply )
	if LocalPlayer():GTeam() == TEAM_SPEC then
		if snake_enabled then
			SnakeClose()
		else
			SnakeOpen()
		end
	end
end )

concommand.Add( "br_snake_reset", function()
	SnakeRestart()
end )

hook.Add( "OnPlayerChat", "SnakeChat", function( ply, text, teamChat, isDead )
	if LocalPlayer() != LocalPlayer() then return end
	text = string.lower( text )
	if text == "!snake" or text == "/snake" then
		if !LocalPlayer().GTeam then return end
		if LocalPlayer():GTeam() == TEAM_SPEC then
			if snake_enabled then
				SnakeClose()
			else
				SnakeOpen()
			end
			return true
		end
	elseif text == "!s reset" or text == "/s reset" then
		SnakeRestart()
		return true
	end
end )

function SnakeRestart()
	GenerateApple()
	SNAKE = {
		{
			x = 25,
			y = 25
		}
	}
	xvel = 0
	yvel = 0
	freeze_game = false
	BUTTONS_DOWN = {}
end

function GenerateApple()
	local x = math.random( 1, MAP_BOUNDS )
	local y = math.random( 1, MAP_BOUNDS )

	local snaketab = {}
	for k, v in pairs( SNAKE ) do
		local sx = v.x
		local sy = v.y
		if !snaketab[sy] then
			snaketab[sy] = {}
		end
		snaketab[sy][sx] = true
	end

	while snaketab[y] and snaketab[y][x] do
		x = x + 1
		if x > MAP_BOUNDS then
			y = y + 1
			x = 1
		end
		if y > MAP_BOUNDS then
			y = 1 
		end
	end

	APPLE.x = x
	APPLE.y = y
end

GenerateApple()