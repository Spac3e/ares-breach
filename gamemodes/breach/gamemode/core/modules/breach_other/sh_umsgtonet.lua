/* 
	
	This script handles conversion from the outdated USMG system to net.
	
	Not 100% mine. I just made it into one addon and made it work for gmod now.

*/

local devmode = false // Toggle only if something broke so that you can report it back to me
local META_PLAYER = FindMetaTable("Player")

if ( SERVER ) then

	local networking = {}
	
	networking.Senders = {
		[ TYPE_CONVAR ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write ConVar( 27 ) value!" ); end;
		[ TYPE_COUNT ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write Amount of TYPE_* enums( 39 ) value!" ); end;
		[ TYPE_DAMAGEINFO ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CTakeDamageInfo( 15 ) value!" ); end;
		[ TYPE_DLIGHT ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write TYPE_DLIGHT( 30 ) value!" ); end;
		[ TYPE_EFFECTDATA ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CEffectData( 16 ) value!" ); end;
		[ TYPE_FILE ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write File( 34 ) value!" ); end;
		[ TYPE_FUNCTION ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write function( 6 ) value!" ); end;
		[ TYPE_IMESH ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write IMesh( 28 ) value!" ); end;
		[ TYPE_INVALID ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write Invalid type( -1 ) value!" ); end;
		[ TYPE_LIGHTUSERDATA ]		= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write TYPE_LIGHTUSERDATA( 32 ) value!" ); end;
		[ TYPE_MATERIAL ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write IMaterial( 21 ) value!" ); end;
		[ TYPE_MATRIX ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write VMatrix( 29 ) value!" ); end;
		[ TYPE_MOVEDATA ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CMoveData( 17 ) value!" ); end;
		[ TYPE_PANEL ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write Panel( 22 ) value!" ); end;
		[ TYPE_PARTICLE ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CLuaParticle( 23 ) value!" ); end;
		[ TYPE_PARTICLEEMITTER ]	= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CLuaEmitter( 24 ) value!" ); end;
		[ TYPE_PHYSOBJ ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write PhysObj( 12 ) value!" ); end;
		[ TYPE_PIXELVISHANDLE ]		= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write pixelvis_handle_t( 30 ) value!" ); end;
		[ TYPE_RECIPIENTFILTER ]	= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CRecipientFilter( 18 ) value!" ); end;
		[ TYPE_RESTORE ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write IRestore( 14 ) value!" ); end;
		[ TYPE_SAVE ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write ISave( 13 ) value!" ); end;
		[ TYPE_SOUND ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write TYPE_SOUND( 30 ) value!" ); end;
		[ TYPE_TEXTURE ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write ITexture( 24 ) value!" ); end;
		[ TYPE_THREAD ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write thread( 8 ) value!" ); end;
		[ TYPE_USERCMD ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write CUserCmd( 19 ) value!" ); end;
		[ TYPE_USERMSG ]			= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write TYPE_USERMSG( 26 ) value!" ); end;
		[ TYPE_VIDEO ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write IVideoWriter( 33 ) value!" ); end;
		[ TYPE_NIL ]				= function( _data )	ErrorNoHalt( "Networking:SenderError", "Can't write NIL( 0 ) value!" ); end;
		
		[ TYPE_BOOL ]				= function( _data )	net.WriteBool( _data ); end; // 1
		[ TYPE_NUMBER ]				= function( _data )	net.WriteDouble( _data ); end; // 3
		[ TYPE_STRING ]				= function( _data )	net.WriteString( _data ); end; // 4
		[ TYPE_TABLE ]				= function( _data )	net.WriteTable( _data ); end; // 5
		[ TYPE_ENTITY ]				= function( _data )	net.WriteEntity( _data ); end; // 9
		[ TYPE_VECTOR ]				= function( _data )	net.WriteVector( _data ); end; // 10
		[ TYPE_ANGLE ]				= function( _data )	net.WriteAngle( _data ); end; // 11
		[ TYPE_SCRIPTEDVEHICLE ]	= function( _data )	net.WriteEntity( _data ); end; // 20
		[ TYPE_COLOR ]				= function( _data )	net.WriteColor( _data ); end;
	};

	PENDING_USERMESSAGE = PENDING_USERMESSAGE or { };
	util.AddNetworkString( "UMSG" );
	util.AddNetworkString( "SendPlayerLua" );
	util.AddNetworkString( "SendUserMessage" );

	function BroadcastLua( _data )
		net.Start( "SendPlayerLua" );
			net.WriteString( _data );
		net.Broadcast( );
	end

	function SendUserMessage( _name, _p, ... )
		local _tab = { ... };
		local _count = table.Count( _tab );
		local _net = net.WriteVars;

		net.Start( "SendUserMessage", true );
			net.WriteString( _name );
			if ( _count > 0 ) then
				for k, v in pairs( _tab ) do
					local _typeid = TypeID( v );
					local _write_as = networking.Senders[ _typeid ];

					if ( _write_as ) then
						_write_as( v );
					else
						ErrorNoHalt( "Error sending user message data: " .. _name );
					end
				end
			end
		net.Send( _p );
	end

	function META_PLAYER:SendLua( _data )
		net.Start( "SendPlayerLua", true );
			net.WriteString( _data );
		net.Send( self );
	end

	function umsg.Start( _name, _players )

		if ( PENDING_USERMESSAGE.active ) then
			if ( devmode ) then
				ErrorNoHalt( "You must dispatch the current UMSG using umsg.End( ) before Starting another!" );
				print( "PENDING_USERMESSAGE DATA: " .. PENDING_USERMESSAGE.name );
			end

			PENDING_USERMESSAGE = { };
			return;
		end

		PENDING_USERMESSAGE.name = _name;
		PENDING_USERMESSAGE.active = true;
		PENDING_USERMESSAGE.recipients = _players;

		net.Start( "UMSG", true ); net.WriteString( _name );
	end

	function umsg.Angle( _ang )
		net.WriteAngle( _ang || Angle(0) );
	end

	function umsg.Bool( _bool )
		net.WriteBool( _bool || false );
	end

	function umsg.Char( _char )
		local _char = ( isstring( _char ) && string.char( _char ) or _char );
		net.WriteInt( _char || 0, 8 );
	end
	
	function umsg.Entity( _ent )
		local _valid = IsValid( _ent );
		local _id = -1;
		if ( _valid ) then
			_id = _ent:EntIndex( );
		end
		net.WriteInt( _id || 0, 16 );
	end

	function umsg.Float( _float )
		net.WriteFloat( _float || 0 );
	end

	function umsg.Long( _long )
		net.WriteInt( _long || 0, 32 );
	end

	function umsg.Short( _short )
		net.WriteInt( _short || 0, 16 );
	end

	function umsg.String( _string )
		net.WriteString( _string || "" );
	end

	function umsg.Vector( _vector )
		net.WriteVector( _vector || Vector(0,0,0) );
	end
	
	function umsg.VectorNormal( _vector )
		net.WriteVector( _vector || Vector(0,0,0));
	end

	function umsg.End( )
	
		local _players = PENDING_USERMESSAGE.recipients;
		if ( istable( _players ) or type( _players ) == "LRecipientFilter" ) then
			if ( _players.GetRecipients ) then
				PENDING_USERMESSAGE.recipients = _players:GetRecipients( );
			else
				PENDING_USERMESSAGE.recipients = _players;
			end
		else
			if ( IsValid( _players ) ) then
				PENDING_USERMESSAGE.recipients = _players;
			end
		end

		if ( !PENDING_USERMESSAGE.recipients ) then
			net.Broadcast( );
			if ( devmode ) then
				print( ">>UMSG Broadcasting: " .. PENDING_USERMESSAGE.name );
			end
		else
			net.Send( PENDING_USERMESSAGE.recipients );
			if ( devmode ) then
				print( ">>UMSG Sending: " .. PENDING_USERMESSAGE.name );
			end
		end

		PENDING_USERMESSAGE = { };
	end
else

	function usermessage:ReadAngle( )
		return net.ReadAngle( );
	end

	function usermessage:ReadBool( )
		return net.ReadBool( );
	end

	function usermessage:ReadChar( )
		return net.ReadInt( 8 );
	end

	function usermessage:ReadEntity( )
		local _id = net.ReadInt( 16 );
		if ( _id == -1 ) then
			return NULL;
		else
			return Entity( _id ) or NULL;
		end
	end

	function usermessage:ReadFloat( )
		return net.ReadFloat( );
	end

	function usermessage:ReadLong( )
		return net.ReadInt( 32 );
	end

	function usermessage:ReadShort( )
		return net.ReadInt( 16 );
	end

	function usermessage:ReadString( )
		return net.ReadString( );
	end

	function usermessage:ReadVector( )
		return net.ReadVector( );
	end

	function usermessage:ReadVectorNormal( )
		return net.ReadVector( );
	end

	function usermessage:Reset( )
		if ( devmode ) then 
			debug.Trace()
			ErrorNoHalt( "Store the reads into vars and go back to them that way!" );
		end
	end

	net.Receive( "UMSG", function( _len )
		local _name = net.ReadString( );

		local _callback = usermessage.__hooks[ _name ];
		local _callback_other = usermessage.GetTable( )[ _name ];

		if ( _callback ) then
			_callback( usermessage );
		elseif( _callback_other ) then
			_callback_other( usermessage );
		else
			error( "Undefined User Message. Client Code / Addon doesn't contain usermessage.Hook( " .. _name .. ", function( _um ) ... end );" );
		end
	end );

	net.Receive( "SendUserMessage", function( _len )
		local _name = net.ReadString( );
		local _callback = usermessage.__hooks[ _name ];
		local _callback_other = usermessage.GetTable( )[ _name ];

		if ( _callback ) then
			_callback( usermessage );
		elseif( _callback_other ) then
			_callback_other( usermessage );
		end
		print( "Usermessage Received ".._name );
	end );

	net.Receive( "SendPlayerLua", function( _len )
		local _data = net.ReadString( );
		if ( _data && _data != "" ) then
			if ( devmode ) then
				RunStringEx( _data, "" );
				print( "LUA Received ".._data );
			else
				RunString( _data );
			end
		end
	end );

	usermessage.__hooks = usermessage.__hooks or { };
	function usermessage.Hook( _name, _callback )
		if ( devmode ) then
			print( "Adding NetUMSGReplacement Hook: ".. _name.." instead of here: " ..debug.getinfo(2).short_src );
		end
		usermessage.__hooks[ _name ] = _callback;
	end

	for _name, v in pairs( usermessage:GetTable( ) ) do
		if ( devmode ) then
			print( "Adding NetUMSGReplacement Hook: ".. _name.." instead of here: " ..debug.getinfo(2).short_src );
		end
		usermessage.Hook( _name, v.Function );
	end
end
