--各項紀錄
_G.game_id = 0
if RECORD == nil then
    RECORD = class({})
end

function SendHTTPRequest_record(path, method, values, callback)
    local req = CreateHTTPRequestScriptVM(method, "https://103.29.70.64/clientApi/record/" .. path)
    for key, value in pairs(values) do
        req:SetHTTPRequestGetOrPostParameter(key, value)
    end
    req:Send(
        function(result)
            print("status code " .. result.StatusCode)
            print("result : " .. result.Body)
            callback(result.Body)
        end
    )
end

function RECORD:StoreToPlayers(keys)
    SendHTTPRequest_record(
        "players/",
        "POST",
        {
            steam_id = tostring(keys.steam_id),
            afkcount = tostring(keys.afkcount),
            wincount = tostring(keys.wincount),
            losecount = tostring(keys.losecount),
            playcount = tostring(keys.playcount),
            invalidcount = tostring(keys.invalidcount)
        },
        function(res)
            if (string.match(res, "error")) then
                print("store to Players fail")
            end
        end
    )
end

function RECORD:StoreToAFKRecord(keys)
    SendHTTPRequest_record(
        "afk_record/",
        "POST",
        {game_id = tostring(keys.game_id), steam_id = tostring(keys.steam_id)},
        function(res)
            if (string.match(res, "error")) then
                print("store to AFKRecord fail")
                callback()
            end
        end
    )
end

function RECORD:StoreToFinishedGame(keys)
    local game_id = 0;
    SendHTTPRequest_record(
        "finished_game/",
        "POST",
        {
            createtime = tostring(keys.createtime),
            endtime = tostring(keys.endtime)
        },
        function(res)
            if (string.match(res, "error")) then
                print("store to FinishedGame fail")
                callback()
            else
                _G.game_id = tostring(res)
            end
        end
    )
end

function RECORD:StoreToFinishedDetail(keys)
    PrintTable(keys)
    print(keys.level)
    print(keys.play_time)
    SendHTTPRequest_record(
        "finished_detail/",
        "POST",
        {
            game_id = tostring(keys.game_id),
            steam_id = tostring(keys.steam_id),
            equ_1 = tostring(keys.equ_1),
            equ_2 = tostring(keys.equ_2),
            equ_3 = tostring(keys.equ_3),
            equ_4 = tostring(keys.equ_4),
            equ_5 = tostring(keys.equ_5),
            equ_6 = tostring(keys.equ_6),
            damage_to_hero = tostring(keys.damage_to_hero),
            physical_damage_to_hero = tostring(keys.physical_damage_to_hero),
            magical_damage_to_hero = tostring(keys.magical_damage_to_hero),
            true_damage_to_hero = tostring(keys.true_damage_to_hero),
            damage = tostring(keys.damage),
            physical_damage = tostring(keys.physical_damage),
            magical_damage = tostring(keys.magical_damage),
            true_damage = tostring(keys.true_damage),
            maximum_critical_damage = tostring(keys.maximum_critical_damage),
            damage_to_tower = tostring(keys.damage_to_tower),
            damage_to_unit = tostring(keys.damage_to_unit),
            heal = tostring(keys.heal),
            damage_taken = tostring(keys.damage_taken),
            physical_damage_taken = tostring(keys.physical_damage_taken),
            magical_damage_taken = tostring(keys.magical_damage_taken),
            true_damage_taken = tostring(keys.true_damage_taken),
            damage_reduce = tostring(keys.damage_reduce),
            hero = tostring(keys.hero),
            res = tostring(keys.res),
            pos = tostring(keys.pos),
            k = tostring(keys.k),
            d = tostring(keys.d),
            a = tostring(keys.a),
            largest_killing_spree = tostring(keys.largest_killing_spree),
            largest_multi_kill = tostring(keys.largest_multi_kill),
            first_blood = tostring(keys.first_blood),
            skillw = tostring(keys.skillw),
            skille = tostring(keys.skille),
            skillr = tostring(keys.skillr),
            skillt = tostring(keys.skillt),
            skilld = tostring(keys.skilld),
            income = tostring(keys.income),
            spent = tostring(keys.spent),
            killed_unit = tostring(keys.killed_unit),
            point1 = tostring(keys.point1),
            point2 = tostring(keys.point2),
            point3 = tostring(keys.point3),
            point4 = tostring(keys.point4),
            point5 = tostring(keys.point5),
            point6 = tostring(keys.point6),
            point7 = tostring(keys.point7),
            point8 = tostring(keys.point8),
            point9 = tostring(keys.point9),
            point10 = tostring(keys.point10),
            point11 = tostring(keys.point11),
            point12 = tostring(keys.point12),
            point13 = tostring(keys.point13),
            point14 = tostring(keys.point14),
            point15 = tostring(keys.point15),
            level = tostring(keys.level),
            play_time = tostring(keys.play_time),
        },
        function(res)
            if (string.match(res, "error")) then
                print("store to FinishedDetail fail")
                callback()
            end
        end
    )
end

function RECORD:StoreToHeroUsage(keys)
    SendHTTPRequest_record(
        "hero_usage/",
        "POST",
        {
            steam_id = tostring(keys.steam_id),
            hero = tostring(keys.hero),
            choose_count = tostring(keys.choose_count)
        },
        function(res)
            if (string.match(res, "error")) then
                callback()
            end
        end
    )
end

function RECORD:StoreToHeroDetail(keys)
    SendHTTPRequest_record(
        "hero_detail/",
        "POST",
        {
            hero = tostring(keys.hero),
            k = tostring(keys.k),
            d = tostring(keys.d),
            a = tostring(keys.a),
            win = tostring(keys.win),
            lose = tostring(keys.lose),
            afk = tostring(keys.afk),
            totalcount = tostring(keys.totalcount),
            money = tostring(keys.money),
            skillw = tostring(keys.skillw),
            skille = tostring(keys.skille),
            skillr = tostring(keys.skillr),
            skillt = tostring(keys.skillt),
            skilld = tostring(keys.skilld),
            damage = tostring(keys.damage),
            damage_to_hero = tostring(keys.damage_to_hero),
            damage_taken = tostring(keys.damage_taken),
            heal = tostring(keys.heal)
        },
        function(res)
            if (string.match(res, "error")) then
                callback()
            end
        end
    )
end

function RECORD:StoreToEquipmentDetail(keys)
    SendHTTPRequest_record(
        "equipment_detail/",
        "POST",
        {
            equipment = tostring(keys.equipment),
            win = tostring(keys.win),
            lose = tostring(keys.lose),
            afk = tostring(keys.afk),
            totalgame = tostring(keys.totalgame)
        },
        function(res)
            if (string.match(res, "error")) then
                callback()
            end
        end
    )
end

function RECORD:StoreToEquipmentPurchased(keys)
    SendHTTPRequest_record(
        "equipment_purchased/",
        "POST",
        {
            game_id = tostring(keys.game_id),
            steam_id = tostring(keys.steam_id),
            purchased_time = tostring(keys.purchased_time),
            purchased_count = tostring(keys.purchased_count),
            equipment = tostring(keys.equipment)
        },
        function(res)
            if (string.match(res, "error")) then
                callback()
            end
        end
    )
end

function RECORD:EndGame(keys)
    SendHTTPRequest(
        "end_game/",
        "POST",
        {
            id = tostring(keys.steam_id),
            res = tostring(keys.res)
        },
        function(res)
            if (string.match(res, "error")) then
                callback()
            end
        end
    )
end

function RECORD:RecordAll(keys)
    local req = CreateHTTPRequestScriptVM("POST", "https://103.29.70.64/clientApi/record/")
    req:SetHTTPRequestRawPostBody("application/json", keys)
    req:Send(
        function(result)
            print("status code " .. result.StatusCode)
            print("result : " .. result.Body)
        end
    )
end