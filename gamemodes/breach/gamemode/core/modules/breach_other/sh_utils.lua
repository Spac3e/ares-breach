local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
surface = surface or  {}
math = math or {}

local vec = FindMetaTable( "Vector" )
function vec:Copy()
	return Vector( self.x, self.y, self.z )
end

function math.TimedSinWave( freq, min, max )
	min = ( min + max ) / 2
	local wave = math.SinWave( RealTime(), freq, min - max, min )
	return wave
end

--based on wikipedia: f(x) = sin( angular frequency(in Hz) * x ) * amplitude + offset
function math.SinWave( x, freq, amp, offset )
	local wave = math.sin( 2 * math.pi * freq * x ) * amp + offset
	return wave
end

function surface.DrawRing( x, y, radius, thick, angle, segments, fill, rotation )
	angle = math.Clamp( angle or 360, 1, 360 )
	fill = math.Clamp( fill or 1, 0, 1 )
	rotation = rotation or 0

	local segmentstodraw = {}
	local segang = angle / segments
	local bigradius = radius + thick

	for i = 1, math.Round( segments * fill ) do
		local ang1 = math.rad( rotation + ( i - 1 ) * segang )
		local ang2 = math.rad( rotation + i * segang )

		local sin1 = math.sin( ang1 )
		local cos1 = -math.cos( ang1 )

		local sin2 = math.sin( ang2 )
		local cos2 = -math.cos( ang2 )

		surface.DrawPoly( {
			{ x = x + sin1 * radius, y = y + cos1 * radius },
			{ x = x + sin1 * bigradius, y = y + cos1 * bigradius },
			{ x = x + sin2 * bigradius, y = y + cos2 * bigradius },
			{ x = x + sin2 * radius, y = y + cos2 * radius }
		} )

	end
end

function AddTables( tab1, tab2 )
	for k, v in pairs( tab2 ) do
		if tab1[k] and istable( v ) then
			AddTables( tab1[k], v )
		else
			tab1[k] = v
		end
	end
end

INI_LOADER_VERSION = "GMOD 1.0"

local function WriteSections( f, tab )
	local d = file.Open( f, "w", "DATA" )
	if !d then 
		error( "Failed to open "..f )
	end

	d:Write( "# INI library by danx91 version: "..INI_LOADER_VERSION )

	for k, v in pairs( tab ) do
		d:Write( "\n\n"..string.format( "[%s]", k ) )
		for _k, _v in pairs( v ) do
			d:Write( "\n"..string.format( "%s = %s", _k, _v ) )
		end
	end

	d:Close()
end

local function CreateSections( tab, name, prefix, sections, char )
	local n = prefix..char..name
	sections[n] = {}
	for k, v in pairs( tab ) do
		if type( v ) == "table" then
			CreateSections( v, k, n, sections, char )
		elseif type( v ) != "function" and type( v ) != "userdata" then
			sections[n][k] = v
		end
	end
end

local function ParseFile( path )
	f = file.Open( path, "r", "DATA" )
	if !f then
		error( "Failed to open "..path )
	end

	local tab = {}
	local activetab

	local line_i = 0

	local line = f:ReadLine()
	while line do
		line_i = line_i + 1
		if !string.match( line, "^%s*#" ) and !string.match( line, "^%s+$" ) then
			local section = string.match( line, "%s*%[(%S+)%]" )
			if section then
				tab[section] = {}
				activetab = section
			end

			local key, value = string.match( line, "%s*(.+)%s+=%s*(.*%S+)%s*" )
			if key and value then
				if value == "true" then
					value = true
				elseif value == "false" then
					value = false
				elseif tonumber( value ) then
					value = tonumber( value )
				end
				tab[activetab][key] = value
			end

			if !section and !key and !value then
				error( "Unexpected char at line "..line_i )
			end
		end
		line = f:ReadLine()
	end

	f:Close()

	return tab
end

function util.LoadINI( f, target )
	local data = ParseFile( f )
	if !data._ini or !data._GLOBAL then return end

	local char = data._ini.char
	local version = data._ini.version
	if !char then return end

	if !version or version != INI_LOADER_VERSION then
		print( version, INI_LOADER_VERSION )
		MsgC( Color( 255, 50, 50 ), "Version of file and parser is different!", "\tFile: "..f, "\tVersion of parser: "..INI_LOADER_VERSION, "\tVersion of file: "..(version or "Undefined").."\n" )
	end

	local result = target or {}
	for k, v in pairs( data._GLOBAL ) do
		result[k] = v
	end

	for k, v in pairs( data ) do
		if k != "_ini" and k != "_GLOBAL" then
			local stack = {}

			for s in string.gmatch( k, "[^%"..char.."]+" ) do
				table.insert( stack, s )
			end

			local parent
			for i = 1, #stack do
				if !parent then
					result[stack[i]] = result[stack[i]] or {}
					parent = result[stack[i]]
				else
					parent[stack[i]] = parent[stack[i]] or {}
					parent = parent[stack[i]]
				end
				if i == #stack then
					for _k, _v in pairs( v ) do
						parent[_k] = _v
					end
				end
			end
		end
	end

	return result
end

function util.WriteINI( f, data, ignoretables, customchar )
	--PrintTable( data )
	customchar = customchar or "."
	local sections = {
		_GLOBAL = {},
		_ini = {
			char = customchar,
			version = INI_LOADER_VERSION
		}
	}
	for k, v in pairs( data ) do
		if type( v ) != "table" then
			sections._GLOBAL[k] = v
		else
			sections[k] = {}
			for _k, _v in pairs( v ) do
				if type( _v ) != "table" and type( _v ) != "function" and type( _v ) != "userdata" then
					sections[k][_k] = _v
				elseif type( _v ) == "table" and !ignoretables then
					CreateSections( _v, _k, k, sections, customchar )
				end
			end
		end
	end
	--PrintTable( sections )
	WriteSections( f, sections )
end

--Better timers
_TimersCache = {}

Timer = {}
Timer.__index = Timer

Timer.name = ""
Timer.repeats = 0
Timer.current = 0
Timer.time = 0
Timer.ncall = 0
Timer.alive = false
Timer.destroyed = false

function Timer:Create( name, time, repeats, callback, endcallback, noactivete, nocache )
	if !name or !time or !repeats or !callback then return end
	local t = setmetatable( {}, Timer )
	t.name = name
	t.time = time
	t.repeats = repeats
	t.callback = callback
	t.endcallback = endcallback

	t.Create = function() end

	if !nocache then
		_TimersCache[name] = t
	end

	if !noactivate then
		t:Start()
	end

	return t
end

function Timer:GetName()
	if self.destroyed then return end
	return self.name
end

function Timer:Stop()
	if self.destroyed then return end
	self.alive = false
end

function Timer:Start()
	if self.destroyed then return end
	self.alive = true
	self.ncall = CurTime() + self.time
end

function Timer:Reset()
	if self.destroyed then return end
	self.current = 0
end

function Timer:Change( time, repeats )
	if self.destroyed then return end
	if time then
		self.time = time
	end
	if repeats then
		self.repeats = repeats
	end
end

function Timer:StopReset()
	if self.destroyed then return end
	self:Stop()
	self:Reset()
end

function Timer:Destroy()
	if self.destroyed then return end
	self.destroyed = true
	_TimersCache[self.name] = nil
	self:Stop()
end

function Timer:Tick()
	if self.destroyed then return end

	self.ncall = self.ncall + self.time

	self.current = self.current + 1
	self.callback( self, self.current )

	if self.repeats > 0 then
		if self.current >= self.repeats then
			self:Destroy()
			if self.endcallback then
				self.endcallback()
			end
		end
	end
end

setmetatable( Timer, { __call = Timer.Create } )

function GetTimer( name )
	return _TimersCache[name]
end

hook.Add( "Tick", "TimersTick", function()
	for k, v in pairs( _TimersCache ) do
		if v.ncall <= CurTime() then
			v:Tick()
		end
	end
end )