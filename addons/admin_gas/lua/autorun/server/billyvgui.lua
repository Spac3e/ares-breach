resource.AddFile("resource/fonts/rubik.ttf")
resource.AddFile("resource/fonts/rubik-bold.ttf")
resource.AddFile("resource/fonts/circular-medium.ttf")
resource.AddFile("resource/fonts/circular-bold.ttf")

for _,v in pairs(file.Find("vgui/bvgui/*", "LUA")) do
	AddCSLuaFile("vgui/bvgui/" .. v)
end
for _,v in pairs(file.Find("materials/vgui/bvgui/*", "GAME")) do
	resource.AddFile("materials/vgui/bvgui/" .. v)
end