local col = brlib.colors

function brlib.msg(txt, color, ...)
    color = color or Color(255, 255, 255)
    MsgN(col.blue, '[Breach.Library]', color, os.date(' %H:%M:%S - ', os.time()) .. string.format(txt, ...))
end

function brlib.Require(name, cb)
	if util.IsBinaryModuleInstalled(name) == false then
		brlib.msg(string.format("[Require] Module [%s] not found", name))
		return false
	end

	require(name)

	if cb ~= nil and pcall(cb) == false then
		brlib.msg(string.format("[Require] Module's [%s] callback got error", name))
		return false
	end

	return true
end

brlib.IncludeDir("library/extensions")
brlib.IncludeDir("library/libraries", true)