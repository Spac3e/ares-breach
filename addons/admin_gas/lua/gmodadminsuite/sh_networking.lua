--[[


addons/[admin]_gmodadminsuite/lua/gmodadminsuite/sh_networking.lua

--]]

if (SERVER) then AddCSLuaFile() end

GAS.Networking = {}

function GAS:netInit(msg)
	util.AddNetworkString("gmodadminsuite:" .. msg)
end
function GAS:netStart(msg)
	xpcall(net.Start, function(err)
		if (err:find("Calling net.Start with unpooled message name!")) then
			if (CLIENT) then
				GAS:chatPrint("Unpooled message name: gmodadminsuite:" .. msg, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
				GAS:chatPrint("This error usually occurs because some serverside code has not loaded. This is probably a failure with the DRM, please read your whole server's console!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			else
				GAS:print("Unpooled message name: gmodadminsuite:" .. msg, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
				GAS:print("This error usually occurs because some serverside code has not loaded. This is probably a failure with the DRM, please read your whole server's console!", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			end
			debug.Trace()
		else
			error("Error with starting net message: gmodadminsuite:" .. msg)
			debug.Trace()
		end
	end, "gmodadminsuite:" .. msg)
end
function GAS:netReceive(msg, func)
	if (CLIENT) then
		net.Receive("gmodadminsuite:" .. msg, func)
	else
		net.Receive("gmodadminsuite:" .. msg, function(l, ply)
			func(ply, l)
		end)
	end
end
function GAS:netQuickie(msg, ply)
	GAS:netStart(msg)
	if (CLIENT) then
		net.SendToServer()
	else
		net.Send(ply)
	end
end

if (CLIENT) then
	GAS.Networking.Transactions = {}
	function GAS:StartNetworkTransaction(msg, sender_function, callback)
		if (not GAS.Networking.Transactions[msg]) then
			GAS.Networking.Transactions[msg] = {
				id = 0
			}
		end

		local transaction = GAS.Networking.Transactions[msg]
		transaction.id = transaction.id + 1
		transaction.callback = callback

		local my_id = transaction.id
		GAS:netReceive(msg, function(l)
			local transaction_id = net.ReadUInt(16)
			if (my_id ~= transaction_id) then return end
			if (transaction.callback) then
				transaction.callback(true, l)
			end
		end)

		GAS:netStart(msg)
			net.WriteUInt(transaction.id, 16)
			if (sender_function) then
				sender_function(transaction.id)
			end
		net.SendToServer()

		return transaction.id
	end

	function GAS:CancelNetworkTransaction(msg, transaction_id)
		if (GAS.Networking.Transactions[msg] and GAS.Networking.Transactions[msg].id == transaction_id) then
			GAS.Networking.Transactions[msg].callback = nil
		end
	end

	GAS:netReceive("transaction_no_data", function()
		local msg = net.ReadString()
		local transaction_id = net.ReadUInt(16)
		local transaction = GAS.Networking.Transactions[msg]
		if (transaction and transaction.callback and transaction.id == transaction_id) then
			transaction.callback(false)
		end
	end)
else
	GAS:netInit("transaction_no_data")
	function GAS:ReceiveNetworkTransaction(msg, sender_function)
		GAS:netReceive(msg, function(ply, l)
			sender_function(net.ReadUInt(16), ply, l)
		end)
	end
	function GAS:TransactionNoData(msg, transaction_id, ply)
		GAS:netStart("transaction_no_data")
			net.WriteString(msg)
			net.WriteUInt(transaction_id, 16)
		net.Send(ply)
	end
end