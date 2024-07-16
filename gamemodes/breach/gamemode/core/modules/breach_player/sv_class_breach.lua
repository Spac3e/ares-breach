local mply = FindMetaTable("Player")

function mply:SetUsingHelmet(str)
	return self:SetNWString("_UsingHelmet", str)
end

function mply:SetUsingBag(str)
	return self:SetNWString("_UsingBag", str)
end

function mply:SetUsingArmor(str)
	return self:SetNWString("_UsingArmor", str)
end

function mply:SetUsingCloth(str)
	return self:SetNWString("_UsingCloth", str)
end
