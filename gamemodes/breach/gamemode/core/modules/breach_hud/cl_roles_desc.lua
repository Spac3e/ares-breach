BREACH = BREACH || {}
BREACH.Descriptions = BREACH.Descriptions || {}
BREACH.Descriptions.russian = BREACH.Descriptions.russian || {}
BREACH.Descriptions.english = BREACH.Descriptions.english || {}

function BREACH.GetDescription(rolename)

	local mylang = langtouse

	if !mylang then mylang = "english" end

	local langtable = BREACH.Descriptions[mylang]
	if !langtable then
		if mylang == "ukraine" then
			langtable = BREACH.Descriptions.russian
		else
			langtable = BREACH.Descriptions.english
		end
	end

	if !langtable[rolename] and rolename:find("SCP") then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - Аномальный SCP-Объект\n\nСкооперируйтесь с другими SCP, убейте всех людей кроме Длани Змей и сбегите!"
		else
			return "You - Are the SCP-Object\n\nCooperate with others SCP, kill everyone except of the Serpent Hands and escape from the Facility!"
		end
	elseif !langtable[rolename] then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - "..GetLangRole(rolename).."\n\nВыполняйте свою нынешнюю задачу."
		else
			return "You - "..GetLangRole(rolename).."\n\nComplete your current task."
		end
	else
		return langtable[rolename]
	end

end