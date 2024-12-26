MINPLAYERS = GetConVar("br_min_players"):GetInt()

function IsBigRound()
	return GetGlobalBool("BigRound", false)
end

function GetPrepTime()
	return 60
end

function GetRoundTime()
	if IsBigRound() then
		return 960
	end
	
	return 780
end

function GetPostTime()
	return 30
end