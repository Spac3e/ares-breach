local basename = "Ares Project: SCP Foundation [BREACH]"
local version = "Beta 1.0"

local emojitable = {
    "🧪 ",
    "🧬 ",
    "🦠 ",
    "🌀 ",
}

function RandomEmoji()
    local emoji = tostring(emojitable[math.random(1, #emojitable)])

    return emoji
end

function CheckHostName(force)
    local formatedhost = RandomEmoji() .. basename .. ' | ' .. version

    if force and isstring(force) then
        formatedhost = force
    end

    ChangeHostName(formatedhost)
end

function ChangeHostName(str)
    local stringname = tostring(str)

    return RunConsoleCommand("hostname", stringname)
end

CheckHostName()

timer.Create("Randomhostname", 45, 0, function()
    CheckHostName()
end)