function string.NiceTime_Full_Eng(seconds)
    local d = math.floor(seconds / 86400)
    local h = math.floor((seconds % 86400) / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)

    local parts = {}
    
    if d > 0 then
        table.insert(parts, d .. " day" .. (d > 1 and "s" or ""))
    end

    if h > 0 then
        table.insert(parts, h .. " hour" .. (h > 1 and "s" or ""))
    end

    if m > 0 then
        table.insert(parts, m .. " minute" .. (m > 1 and "s" or ""))
    end

    if s > 0 then
        table.insert(parts, s .. " second" .. (s > 1 and "s" or ""))
    end

    if #parts == 0 then
        return "0 seconds"
    else
        return table.concat(parts, ", ")
    end
end

local cases = {[0] = 3, [1] = 1, [2] = 2, [3] = 2, [4] = 2, [5] = 3}

local function pluralize(n, titles)
	n = math.abs(n)
	return titles[
		(n % 100 > 4 and n % 100 < 20) and 3 or
		cases[(n % 10 < 5) and n % 10 or 6]
	]
end

local min, hour, day, week, year, t = 60, 60 * 60, 60 * 60 * 24, 60 * 60 * 24 * 7, 60 * 60 * 24 * 365

function string.NiceTime_Full_Rus(time)
    if time <= 0 or time == nil then return end

    if time < min then
        t = math.floor(time)
        return t .. pluralize(t, {" секунда", " секунды", " секунд"})
    end

    if time < hour then
        t = math.floor(time / min)
        return t .. pluralize(t, {" минута", " минуты", " минут"})
    end

    if time < day then
        t = math.floor(time / hour)
        return t .. pluralize(t, {" час", " часа", " часов"})
    end

    if time < week then
        t = math.floor(time / day)
        return t ..  pluralize(t, {" день", " дня", " дней"})
    end

    if time < year then
        t = math.floor(time / week)
        return t .. pluralize(t, {" неделя", " недели", " недель"})
    end

    t = math.floor(time / year)
    return t .. pluralize(t, {" год", " года", " лет"})
end