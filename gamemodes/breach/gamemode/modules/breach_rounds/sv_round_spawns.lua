BREACH.Round = BREACH.Round or {}

local function RandomItem(list)
    if #list == 0 then return nil end
    
    local totalWeight = 0

    for _, item in ipairs(list) do
        totalWeight = totalWeight + item[2]
    end

    local randomValue = math.random(1, totalWeight)
    local weightSum = 0

    for _, item in ipairs(list) do
        weightSum = weightSum + item[2]
        if randomValue <= weightSum then
            return item[1]
        end
    end

    return nil
end

local function SpawnSingle(class, pos, ang)
    local ent = ents.Create(class)
    if IsValid(ent) then
        pos = pos or Vector(0, 0, 0)
        ang = ang or Angle(0, 0, 0)

        ent:SetPos(pos)
        ent:SetAngles(ang)
        ent:Spawn()
    end
end

function BREACH.Round.SpawnLoot()
    SpawnSingle("scptree", SPAWN_SCPTREE)
    SpawnSingle("weapon_special_gaus", SPAWN_GAUSS)
    SpawnSingle("warhead")

    local scpsobjectItems = table.Copy(SPAWN_SCP_OBJECT.ents)
    local scpobjectspawns = table.Copy(SPAWN_SCP_OBJECT.spawns)

    for i = 1, SPAWN_SCP_OBJECT.amount do
        if #scpsobjectItems > 0 then
            local spawnIndex = math.random(1, #scpobjectspawns)
            local selectedEntity = table.remove(scpsobjectItems, 1)
            local newItem = ents.Create(selectedEntity)
            if IsValid(newItem) then
                newItem:SetPos(scpobjectspawns[spawnIndex])
                newItem:Spawn()
            end

            table.remove(scpobjectspawns, spawnIndex)
        else
            break
        end
    end

    for _, tesla in pairs(SPAWN_TESLA) do
        local spawns = table.Copy(tesla.spawns)
        local availableSpawns = table.Copy(tesla.spawns)
        local amountToSpawn = math.min(tesla.amount, #spawns)
        for i = 1, amountToSpawn do
            local spawnIndex = math.random(1, #availableSpawns)
            local tesla = ents.Create("test_entity_tesla")
            if IsValid(tesla) then
                tesla:SetPos(availableSpawns[spawnIndex])
                local spawnPos = availableSpawns[spawnIndex]
                if spawnPos == Vector(8814.4169921875, -366.80648803711, 129.061483383179) then
                    tesla:SetAngles(Angle(0, 0, 0))
                elseif spawnPos == Vector(6282.9453125, 1177.1953125, 129.061498641968) then
                    tesla:SetAngles(Angle(0, 90, 0))
                elseif spawnPos == Vector(3522.5834960938, 4021.2414550781, 129.061498641968) or spawnPos == Vector(4158.148926, 1878.148560, 129.361298) or spawnPos == Vector(4157.9526367188, -932.20758056641, 129.061511993408) or spawnPos == Vector(8168.5478515625, 336.69119262695, 129.061496734619) then
                    tesla:SetAngles(Angle(0, -90, 0))
                end

                tesla:Spawn()
                table.remove(availableSpawns, spawnIndex)
            end
        end
    end

    local uniformSpawnCount = IsBigRound() and math.random(SPAWN_UNIFORMS.bigroundamount[1], SPAWN_UNIFORMS.bigroundamount[2]) or math.random(SPAWN_UNIFORMS.smallroundamount[1], SPAWN_UNIFORMS.smallroundamount[2])

    for i = 1, uniformSpawnCount do
        local spawnPos = table.Random(SPAWN_UNIFORMS.spawns)
        local entityName = table.Random(SPAWN_UNIFORMS.entities)
        
        if spawnPos then
            local ent = ents.Create(entityName)
            if IsValid(ent) then
                ent:SetPos(spawnPos)
                ent:Spawn()
            end
        end
    end

    timer.Simple(4, function()
        for k, v in ipairs(SPAWN_VEHICLE) do
            local car = ents.Create("prop_vehicle_jeep")
            car:SetModel("models/scpcars/scpp_wrangler_fnf.mdl")
            car:SetKeyValue("vehiclescript", "scripts/vehicles/wrangler88.txt")
            car:SetPos(v[1])
            car:SetAngles(v[2])
            car:Spawn()
            car:Activate()
            WakeEntity(car)
        end
    
        for _, entity in ipairs(ENTITY_SPAWN_LIST) do
            for _, spawn in ipairs(entity.Spawns) do
                local pos = spawn.pos or spawn
                local ang = spawn.ang or Angle(0, 0, 0)
                local ent = ents.Create(entity.Class)
                ent:SetPos(pos)
                ent:SetAngles(ang)
                ent:Spawn()
            end
        end

        for i = 1, math.random(10, 15) do
            if #SPAWN_TRASHBINS > 0 then
                local spawnIndex = math.random(1, #SPAWN_TRASHBINS)
                local spawnData = table.remove(SPAWN_TRASHBINS, spawnIndex)
                local trashbin = ents.Create("breach_trashbin")
                if IsValid(trashbin) then
                    trashbin:SetPos(spawnData.pos)
                    trashbin:SetAngles(spawnData.ang)
                    trashbin:SetModelScale(spawnData.modelscale)
                    trashbin:Spawn()
                end
            else
                break
            end
        end
        
        local maxGenerators = 5
        for i = 1, maxGenerators do
            if #SPAWN_GENERATORS > 0 then
                local spawnIndex = math.random(1, #SPAWN_GENERATORS)
                local spawnData = table.remove(SPAWN_GENERATORS, spawnIndex)
                local generatorEntity = ents.Create("ent_generator")
                if IsValid(generatorEntity) then
                    generatorEntity:SetPos(spawnData.Pos)
                    generatorEntity:SetAngles(spawnData.Ang)
                    generatorEntity:Spawn()
                end
            else
                break
            end
        end
    
        for i = 1, 2 do
            local index = math.random(1, #SPAWN_GOC_UNIFORMS)
            local spawnpos = SPAWN_GOC_UNIFORMS[index]
            local armor_goc = ents.Create("armor_goc")
            armor_goc:SetPos(spawnpos)
            armor_goc:Spawn()
        end

        if IsBigRound() then
            local pistol = ents.Create("cw_kk_ins2_g17")
            local ammo = ents.Create("breach_baseammo")
            local uniform = ents.Create("armor_sci")
        
            uniform:SetPos(Vector(7579, -5314, 129))
            uniform:Spawn()

            pistol:SetPos(Vector(7680, -5270, 166))
            pistol:Spawn()
        
            ammo:SetPos(Vector(7684, -5391, 170))
            ammo:Spawn()
        else
            local ammo = ents.Create("breach_baseammo")
            ammo:SetPos(Vector(7684, -5391, 170))
            ammo:Spawn()

            if math.random() < 0.5 then
                local pistol = ents.Create("cw_kk_ins2_g17")
                local uniform = ents.Create("armor_sci")

                uniform:SetPos(Vector(7579, -5314, 129))
                uniform:Spawn()
    
                pistol:SetPos(Vector(7680, -5270, 166))
                pistol:Spawn()
            end
        end        

        for k, v in pairs(SPAWN_AMMONEW) do
            local spawns = table.Copy(v.spawns)
            local dices = {}
            local n = 0
            for _, dice in pairs(v.ents) do
                local d = {
                    min = n,
                    max = n + dice[2],
                    ent = dice[1]
                }
    
                table.insert(dices, d)
                n = n + dice[2]
            end
    
            for i = 1, math.min(v.amount, #spawns) do
                local spawn = table.remove(spawns, math.random(1, #spawns))
                local dice = math.random(0, n - 1)
                local ent
                for _, d in pairs(dices) do
                    if d.min <= dice and d.max > dice then
                        ent = d.ent
                        break
                    end
                end
    
                if ent then
                    local weapon = ents.Create(ent)
                    if IsValid(weapon) then
                        weapon:Spawn()
                        weapon:SetPos(spawn)
                    end
                end
            end
        end
    
        timer.Simple(6, function()
            for area, spawnData in pairs(SPAWN_ITEMS) do
                local spawns = table.Copy(spawnData.spawns)
                local amountToSpawn = math.min(spawnData.amount, #spawns)
                for i = 1, amountToSpawn do
                    local spawnIndex = math.random(1, #spawns)
                    local selectedEntity = RandomItem(spawnData.ents)
                    local newItem = ents.Create(selectedEntity)
                    if IsValid(newItem) then
                        newItem:Spawn()
                        newItem:SetPos(spawns[spawnIndex])
                    end
    
                    table.remove(spawns, spawnIndex)
                end
            end
        end)
    end)

    local function TemporaryEntitySpawn(tbl, spawn)
        local spawncount = {}
    
        for _, entdata in ipairs(tbl) do
            spawncount[entdata.class] = 0
        end
    
        for _, pos in ipairs(spawn) do
            local entdata = tbl[math.random(#tbl)]
    
            if math.random() <= entdata.chance and spawncount[entdata.class] < (entdata.max) then
                local ent = ents.Create(entdata.class)
                ent:SetPos(pos)
                ent:Spawn()
    
                spawncount[entdata.class] = spawncount[entdata.class] + 1
            end
        end
    end
    
    local dragocennostiyopta = {
        {class = "hand_key", chance = 0.6, max = 1},
        {class = "item_keys", chance = 0.4, max = 2},
        {class = "item_chaos_radio", chance = 0.3, max = 1}
    }
    
    local spawnposyopta = {
        Vector(-107.30149841309, 2475.0849609375, 30.031248092651),
        Vector(-106.29196929932, 2484.3715820313, 50.03125),
        Vector(89.573989868164, 2569.9985351563, 46.531150817871),
        Vector(234.0922088623, 2565.0986328125, 46.485954284668),
        Vector(230.14303588867, 2423.2783203125, 46.485950469971),
        Vector(470.6689453125, 2629.7438964844, 46.031242370605),
        Vector(471.71127319336, 2549.6938476563, 46.031253814697),
        Vector(471.71145629883, 2459.3627929688, 46.03125),
        Vector(379.76351928711, 2450.5932617188, 36.045669555664),
        Vector(-1362.6605224609, 2480.2687988281, 46.4326171875),
        Vector(-1372.9919433594, 2666.8876953125, 50.313163757324),
        Vector(-1365.4041748047, 2733.5744628906, 58.388927459717),
        Vector(-1365.4083251953, 2754.3979492188, 58.390380859375),
        Vector(-1365.4008789063, 2770.8247070313, 58.391525268555),
        Vector(-1365.3990478516, 2784.6638183594, 58.39249420166),
        Vector(-1365.3980712891, 2798.3518066406, 58.393447875977),
        Vector(-1119.2919921875, 3174.8747558594, 50.371429443359),
        Vector(-1115.8681640625, 3105.0092773438, 50.740936279297),
        Vector(-1149.0252685547, 3218.306640625, 46.413318634033),
        Vector(-1630.0212402344, 2927.9736328125, 46.532066345215),
        Vector(-1689.2351074219, 3140.3251953125, 45.180335998535),
        Vector(-1601.3352050781, 3233.8840332031, 45.313674926758),
        Vector(-1576.7423095703, 3236.1477050781, 45.29988861084),
        Vector(-1554.5638427734, 3236.5903320313, 45.288093566895),
        Vector(-1551.7850341797, 3235.0563964844, 45.287254333496),
        Vector(-1776.2905273438, 3235.7827148438, 58.397621154785),
        Vector(-1738.3233642578, 3232.8439941406, 58.399410247803),
        Vector(-1753.5607910156, 3233.7326660156, 34.398735046387),
        Vector(-1789.3516845703, 3237.3549804688, 34.396915435791),
        Vector(-2169.2736816406, 3300.6625976563, 26.843326568604),
        Vector(-2172.4875488281, 2716.49609375, 26.855140686035),
        Vector(-2197.2668457031, 2718.5715332031, 27.01358795166),
        Vector(5753.9169921875, -3202.3969726563, 48.097679138184),
        Vector(5491.8642578125, -2838.5402832031, 48.28125),
        Vector(5328.3129882813, -2675.5029296875, 36.531349182129),
        Vector(5375.41796875, -2676.6467285156, 36.531349182129),
        Vector(4900.8969726563, -2825.3664550781, 36.281242370605),
        Vector(4901.0092773438, -2856.7268066406, 36.281253814697),
        Vector(5819.1044921875, -2029.3624267578, 48.414352416992),
        Vector(5838.685546875, -2031.3370361328, 48.412380218506),
        Vector(5831.2436523438, -1871.6145019531, 47.342880249023),
        Vector(5870.4599609375, -1873.0052490234, 47.342880249023),
        Vector(5863.34375, -1825.7775878906, 47.342884063721),
        Vector(5743.1342773438, -1593.8032226563, 47.317474365234),
        Vector(5788.5478515625, -1595.7438964844, 47.334274291992),
        Vector(5818.82421875, -1597.0264892578, 47.334270477295),
        Vector(6702.3491210938, -4686.6118164063, 47.331047058105),
        Vector(7060.9130859375, -4689.75390625, 47.331050872803),
        Vector(7160.1459960938, -4700.1342773438, 47.331047058105),
        Vector(7162.4345703125, -4653.5126953125, 47.331047058105),
        Vector(7161.59765625, -4592.3793945313, 47.819053649902),
        Vector(7160.7299804688, -4562.0883789063, 47.817520141602),
        Vector(7161.0756835938, -4578.3046875, 47.818412780762),
        Vector(7001.5576171875, -4917.3256835938, 47.717067718506),
        Vector(6971.2841796875, -4918.6655273438, 47.720821380615),
        Vector(7109.4028320313, -4922.7685546875, 35.689617156982),
        Vector(7074.48828125, -4919.87109375, 35.693996429443),
        Vector(7077.404296875, -4921.1611328125, 59.694492340088),
        Vector(6781.091796875, -4696.3305664063, 47.3310546875),
        Vector(6994.8984375, -5349.2231445313, 163.58125305176),
        Vector(7364.259765625, -5259.1499023438, 163.58125305176),
        Vector(7430.5986328125, -5814.869140625, 187.705078125),
        Vector(7312.544921875, -5482.6860351563, 156.64218139648),
        Vector(6500.3764648438, -6572.3515625, 176.27925109863),
        Vector(6454.7709960938, -6562.4375, 176.27923583984),
        Vector(6611.7783203125, -6568.9501953125, 174.11724853516),
        Vector(6851.7333984375, -6804.7587890625, 176.46151733398)
    }
        
    TemporaryEntitySpawn(dragocennostiyopta, spawnposyopta)    
end