local units = units
local hook = hook

local surface_CreateFont = surface.CreateFont
local setmetatable = setmetatable
local ArgAssert = ArgAssert
local math_max = math.max
local assert = assert
local pairs = pairs
local type = type

module( "fonts" )

local fonts = {}

function GetAll()
    return fonts
end

function Get( fontName )
    return fonts[ fontName ]
end

local meta = {}
meta.__index = meta

function meta:GetName()
    return self.name
end

function meta:GetSize()
    return self.parameters.size
end

function meta:__tostring()
    return "Font [" .. self:GetName() .. "][" .. self:GetSize()  .. "]"
end

-- https://wiki.facepunch.com/gmod/Structures/FontData
function meta:Get( key )
    return self.parameters[ key ]
end

function meta:Set( key, value )
    self.parameters[ key ] = value
    self:Update()
end

function meta:Update()
    local data, size = {}, "undefined"
    for key, value in pairs( self.parameters ) do
        if key ~= "size" then
            data[ key ] = value
            continue
        end

        data[ key ] = math_max( 4, units.Get( value ) )
        size = value
    end

    surface_CreateFont( self.name, data )
    hook.Run( "FontUpdated", self )
end

function Register( fontName, font, size, weight, antialias, extended )
    ArgAssert( fontName, 1, "string" )
    ArgAssert( font, 2, "string" )

    assert( size ~= nil, "Font size cannot be nil!" )

    local parameters = {
        ["antialias"] = antialias ~= false,
        ["extended"] = extended ~= false,
        ["font"] = font,
        ["size"] = size
    }

    if type( weight ) == "number" then
        parameters.weight = weight
    end

    local new = setmetatable( {
        ["name"] = fontName,
        ["parameters"] = parameters
    }, meta )

    fonts[ fontName ] = new
    new:Update()

    return new
end

function UpdateAll()
    local count = 0
    for _, font in pairs( fonts ) do
        count = count + 1
        font:Update()
    end

    print( "All %d fonts have been updated!" ..count )
end

hook.Add( "OnScreenSizeChanged", "ScreenSizeChanged", UpdateAll )