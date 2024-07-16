--[[


addons/[weapons]_ballistic_shields/lua/ballistic_shields/sh_bs_lang.lua

--]]

include( "ballistic_shields/sh_bs_util.lua" )

bshields.lang = {
	["English"] = {
		["sec"] = "[RMB] VISIBILITY",
		["dshieldprim"] = "[LMB] DEPLOY",
		["hshieldprim"] = "[LMB] BREACH DOOR",
		["rshieldprim"] = "[LMB] ATTACK",
		["hshieldcd1"] = "Wait ",
		["hshieldcd2"] = " seconds to breach next door!"	
	},
	["German"] = {
		["sec"] = "[RMB] SICHTBARKEIT",
		["dshieldprim"] = "[LMB] PLAZIEREN",
		["hshieldprim"] = "[LMB] TÜR AUFBRECHEN",
		["rshieldprim"] = "[LMB] ANGREIFEN",
		["hshieldcd1"] = "Warte ",
		["hshieldcd2"] = " Sekunden für das Aufbrechen der nächsten Tür!"	
	},
	["French"] = {
		["sec"] = "[RMB] VISIBILITÉ",
		["dshieldprim"] = "[LMB] DÉPLOYER",
		["hshieldprim"] = "[LMB] FORCER LA PORTE",
		["rshieldprim"] = "[LMB] ATTAQUER",
		["hshieldcd1"] = "Attendez ",
		["hshieldcd2"] = " secondes pour forcer la porte !"	
	},
	["Danish"] = {
		["sec"] = "[RMB] SIGTBARHED",
		["dshieldprim"] = "[LMB] SÆT",
		["hshieldprim"] = "[LMB] BREACH DØR",
		["rshieldprim"] = "[LMB] ANGRIB",
		["hshieldcd1"] = "Vent ",
		["hshieldcd2"] = " sekunder at bryde ved siden af!"   
	},
	["Turkish"] = {
		["sec"] = "[RMB] GORUNURLUK",
		["dshieldprim"] = "[LMB] YERLESTIR",
		["hshieldprim"] = "[LMB] BREACH DOOR",
		["rshieldprim"] = "[LMB] SALDIR",
		["hshieldcd1"] = "Bekle ",
		["hshieldcd2"] = " bir sonraki kapıyı kırmaya saniye kaldı!"   
	}
}  

if(bshields.lang[bshields.config.language]==nil) then bshields.config.language = "English" end