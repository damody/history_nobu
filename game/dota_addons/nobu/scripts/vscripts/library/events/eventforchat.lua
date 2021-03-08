local json = require "game/dkjson"
--[[
BUG
	O大廳裡面也可以捕捉到，這時候caster值為nil
]]

local inspect = require("inspect")

author = {
	["186150724"] = true,
	["128732954"] = true,
	["107980391"] = true,
	["114421287"] = true,
	["114421287"] = true,
	["159955467"] = true,
	["76561199061595916"] = true,
	["76561199061408231"] = true,
	["76561199061338093"] = true,
	["76561199061592712"] = true,
	["76561199061661919"] = true,
	["76561199061568418"] = true,
	["76561199061350649"] = true,
	["76561199061585478"] = true,
	["76561199061543637"] = true,
	["76561199061663243"] = true,
	["76561198977700714"] = true,
	["76561198089591268"] = true,
	["76561198120221195"] = true,
	["1017434986"] = true,
	["1101330188"] = true,
}

-- skin_table = {
-- 	["128732954"] = true,
-- 	["164167573"] = true,
-- 	["245903351"] = true,
-- 	["89504404"] = true,
-- 	["5491971"] = true,
-- 	["45356591"] = true,
-- 	["190143365"] = true,
-- 	["161033081"] = true,
-- 	["245761935"] = true, --買濃姬 但付1000元
-- 	["180580201"] = true, --買濃姬跟阿市
-- 	["237024969"] = true, --買濃姬跟阿市
-- 	["377214232"] = true, --大陸 李維
-- 	["100789172"] = true, --大陸 Sai
	
-- 	["38652551"] = true,
-- 	["159955467"] = true,
-- 	["47467611"] = true,
-- 	["159901591"] = true,
-- 	["175307731"] = true,
-- 	["175423750"] = true,
-- 	["219044134"] = true,
-- 	["159930923"] = true,
-- 	["440895734"] = true,
-- 	["411167283"] = true,
-- 	["19350721"] = true,
-- 	["230137710"] = true,
-- 	["167209936"] = true,
-- 	["21796396"] = true,
-- 	["24066882"] = true,
-- 	["399854621"] = true,
-- 	["156338995"] = true,
-- 	["78644565"] = true,
-- 	["407915261"] = true,
-- 	["421960552"] = true,
-- 	["196686525"] = true,
-- 	["246810545"] = true,
-- 	["126912859"] = true,
-- 	["162580111"] = true,
-- 	["275101304"] = true,
-- 	["68694022"] = true,
-- 	["54971063"] = true,
-- 	["109888730"] = true,
-- 	["30107422"] = true,
-- 	["6938200"] = true,
-- 	["20304940"] = true,
-- 	["30314550"] = true,
-- 	["49456980"] = true,
	
-- 	["404284631"] = true,
-- 	["404414261"] = true,
-- 	["100577207"] = true,
-- 	["408231324"] = true,
-- 	["113634843"] = true,
-- 	["113740368"] = true,
-- 	["113690980"] = true,
-- 	["90426648"] = true,
-- 	["177216989"] = true,
-- 	["398755156"] = true,
-- 	["251717040"] = true,
-- 	["200372686"] = true,
-- 	["396968659"] = true,
-- 	["302208218"] = true,
-- 	["171799875"] = true,
-- 	["395315757"] = true,
-- 	["398587433"] = true,
-- 	["228146869"] = true,
-- 	["116590244"] = true,
-- 	["109942126"] = true,
-- 	["167209936"] = true,
-- 	["254803433"] = true,
-- 	["60214844"] = true,
-- 	["190108038"] = true,
-- 	["140227500"] = true,
-- 	["180978974"] = true,
-- 	["264678988"] = true,
-- 	["179204453"] = true,
-- 	["83391337"] = true,
-- 	["309242731"] = true,
-- 	["165371710"] = true,
-- 	["200824320"] = true,
-- 	["357390739"] = true,
-- 	["403262581"] = true,
-- 	["98913961"] = true,
-- 	["219797805"] = true,
-- 	["403273081"] = true,
-- 	["13876401"] = true,
-- 	["183611649"] = true,
-- 	["127008996"] = true,
-- 	["112092405"] = true,
-- 	["77216853"] = true,
-- 	["406000739"] = true,
-- 	["411167283"] = true,
-- 	["400491255"] = true,
-- 	["404501308"] = true,
-- 	["410736014"] = true,
-- 	["126912859"] = true,
-- 	["175091151"] = true,
-- 	["178655368"] = true,
-- 	["178162295"] = true,
-- 	["190893903"] = true,
-- 	["19350721"] = true,
-- 	["245903351"] = true,
-- 	["67772815"] = true,
-- 	["214260739"] = true,
-- 	["299292950"] = true,
-- 	["362586887"] = true,
-- 	["80008129"] = true,
-- 	["151910810"] = true,
-- 	["401484673"] = true,
-- 	["128561432"] = true,
-- 	["92011585"] = true,
-- 	["186995583"] = true,
-- 	["108494462"] = true,
-- 	["181277080"] = true,
-- 	["297194236"] = true,
-- 	["397235448"] = true,
-- 	["298925966"] = true,
-- 	["302672845"] = true,
-- 	["164156799"] = true,
-- 	["400642280"] = true,
-- 	["408279637"] = true,
-- 	["51993736"] = true,
-- 	["134859659"] = true,
-- 	["138927341"] = true,
-- 	["373384051"] = true,
-- 	["285511808"] = true,
-- 	["140165795"] = true,
-- 	["152151982"] = true,
-- 	["95837015"] = true,
-- 	["406071443"] = true,
-- 	["190585955"] = true,
-- 	["404550388"] = true,
-- 	["322632934"] = true,
-- 	["328872748"] = true,
-- 	["136330017"] = true,
-- 	["405867669"] = true,
-- 	["245521237"] = true,
-- 	["406101239"] = true,
-- 	["176398348"] = true,
-- 	["114421287"] = true,
-- 	["107980391"] = true,
-- 	["186150724"] = true,
-- }

function DumpTable( tTable )
	local inspect = require('inspect')
	local iDepth = 5
 	print(inspect(tTable,
 		{depth=iDepth} 
 	))
end


function SendHTTPRequest_local(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://127.0.0.1/"..path )
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		callback(result.Body)
	end)
end

local function chat_of_test(keys)
	--DeepPrintTable(keys)
	-- [   VScript ]:    playerid                        	= 0 (number)
	-- [   VScript ]:    text                            	= "3" (string)
	-- [   VScript ]:    teamonly                        	= 1 (number)
	-- [   VScript ]:    userid                          	= 1 (number)
	-- [   VScript ]:    splitscreenplayer               	= -1 (number)

	--local id    = keys.player --BUG:在講話事件裡，讀取不到玩家，是整數。
	local s   	   = keys.text:lower()
	local p 	     = PlayerResource:GetPlayer(keys.playerid)--可以用索引轉換玩家方式，來捕捉玩家
	local caster 	   = p:GetAssignedHero() --获取该玩家的英雄
	if caster == nil then return end
	local point    = caster:GetAbsOrigin()
	-- if string.match(s,"test") then
	-- 	local pID = tonumber(string.match(s, '%d+'))
	-- 	local steamID = PlayerResource:GetSteamAccountID(pID)
	-- 	GameRules: SendCustomMessage(tostring(steamID),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
	-- end
	if _G.CountUsedAbility_Table == nil then
		_G.CountUsedAbility_Table = {}
	end
	if _G.CountUsedAbility_Table[keys.playerid + 1] == nil then
		_G.CountUsedAbility_Table[keys.playerid + 1] = {}
	end
	if s == "-se" then
		_G.CountUsedAbility_Table["winteam"] = DOTA_TEAM_GOODGUYS
		for playerID = 0, 9 do
			local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id)
	  		local steamid = PlayerResource:GetSteamAccountID(id)
	    	if p ~= nil and (p:GetAssignedHero()) ~= nil then
			  local hero = p:GetAssignedHero()

			  if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			  	_G.CountUsedAbility_Table[id+1]["res"] = "W"
			  else
			  	_G.CountUsedAbility_Table[id+1]["res"] = "L"
			  end
			  _G.CountUsedAbility_Table[id+1]["name"] = hero.name
			  _G.CountUsedAbility_Table[id+1]["version"] = hero.version
			  _G.CountUsedAbility_Table[id+1]["damage"] = hero.damage
			  _G.CountUsedAbility_Table[id+1]["takedamage"] = hero.takedamage
			  _G.CountUsedAbility_Table[id+1]["herodamage"] = hero.herodamage
			  _G.CountUsedAbility_Table[id+1]["building_count"] = hero.building_count
			  _G.CountUsedAbility_Table[id+1]["team"] = hero:GetTeamNumber()
			  _G.CountUsedAbility_Table[id+1]["kda"] = {}
			  _G.CountUsedAbility_Table[id+1]["kda"]["k"] = tostring(hero:GetKills())
			  _G.CountUsedAbility_Table[id+1]["kda"]["d"] = tostring(hero:GetDeaths())
			  _G.CountUsedAbility_Table[id+1]["kda"]["a"] = tostring(hero:GetAssists())
			  _G.CountUsedAbility_Table[id+1]["kda"]["kcount"] = tostring(hero.kill_count)
			  _G.CountUsedAbility_Table[id+1]["kda"]["steamid"] = steamid
			end
		end
		if _G.game_level > 0 and _G.game_level < 10 then
			_G.CountUsedAbility_Table.rank = 1
		end
		DeepPrintTable(_G.CountUsedAbility_Table)
		
		SendHTTPRequest_local("save_ability_data", "GET",
			{
			  data = tostring(inspect(_G.CountUsedAbility_Table)),
			},
			function(result)
				print("SendHTTPRequest_local")
			  print(result)
			end)
		
	end
	local accountID = PlayerResource:GetSteamAccountID(caster:GetPlayerOwnerID())
	local steamid = PlayerResource:GetSteamID(caster:GetPlayerOwnerID())
	local skin = false
	local preregist = false
	if _G.skin_table[tostring(steamid)] == true then
		skin = true
	end
	if _G.skin_table[tostring(accountID)] == true then
		skin = true
	end
	local preregist = false
	if _G.preregist_table[tostring(accountID)] == true then
		preregist = true
	end
	if _G.preregist_table[tostring(steamid)] == true then
		preregist = true
	end
	
	--DebugDrawText(caster:GetAbsOrigin(), "殺爆全場就是現在", false, 10)
	--舊版模式
	local nobu_id = _G.heromap[caster:GetName()]

	if (s == "-skin" and nobu_id == "C17" and skin) then
		if caster.use_skin then
			caster.use_skin = false
			caster:SetModel("models/c17/oichi_yukata.vmdl")
			caster:SetModelScale(0.5)
			caster:SetOriginalModel("models/c17/oichi_yukata.vmdl")
		else
			caster.use_skin = true
			caster.skin = "school"
			caster:SetModel("models/c17/c17_school.vmdl")
			caster:SetModelScale(1.3)
			caster:SetOriginalModel("models/c17/c17_school.vmdl")
		end
		
	end
	if (s == "-skin" and nobu_id == "A26" and skin) then
		if caster.use_skin then
			caster.use_skin = false
			caster:SetModel("models/a26/a26.vmdl")
			caster:SetOriginalModel("models/a26/a26.vmdl")
		else
			caster.use_skin = true
			caster.skin = "school"
			caster:SetModel("models/a26/a26_school.vmdl")
			caster:SetOriginalModel("models/a26/a26_school.vmdl")
		end
	end
	if (s == "-skin" and nobu_id == "B16" and skin) then
		if caster.use_skin then
			caster.use_skin = false
			caster:SetModel("models/b16/b16.vmdl")
			caster:SetOriginalModel("models/b16/b16.vmdl")
		else
			caster.use_skin = true
			caster.skin = "school"
			caster:SetModel("models/b16/b16_school.vmdl")
			caster:SetOriginalModel("models/b16/b16_school.vmdl")
		end
	end
	if (s == "-skin" and nobu_id == "C19" and skin) then
		if caster.use_skin then
			caster.use_skin = false
			caster:SetModel("models/new/c19/c19_model.vmdl")
			caster:SetOriginalModel("models/new/c19/c19_model.vmdl")
			caster:RemoveAbility("C19_school")
		else
			caster.use_skin = true
			caster.skin = "school"
			caster:SetModel("models/c19/c19_school.vmdl")
			caster:SetOriginalModel("models/c19/c19_school.vmdl")
			caster:AddAbility("C19_school"):SetLevel(1)
		end
	end
	if (s == "-long" and nobu_id == "A31") then
		caster:SetModel("models/a31/a31_long.vmdl")
		caster:SetOriginalModel("models/a31/a31_long.vmdl")
	end
	if (s == "-short" and nobu_id == "A31") then
		caster:SetModel("models/a31/a31.vmdl")
		caster:SetOriginalModel("models/a31/a31.vmdl")
	end
	if (s == "tt" and nobu_id == "A21") then
		local weap = SpawnEntityFromTableSynchronous("prop_dynamic", {
			model = "models/items/luna/luna_ti9_immortal/luna_ti9_immortal.vmdl",
		})
		weap:FollowEntity(caster, true)
		caster.weap = weap
	end
	-- if (s == "-donkey" and caster.has_dota_donkey == nil and not _G.hardcore) then
	-- 	caster.has_dota_donkey = 1
	-- 	local donkey = CreateUnitByName("npc_dota_courier2", caster:GetAbsOrigin()+Vector(100, 100, 0), true, caster, caster, caster:GetTeam())
	-- 	donkey:SetControllableByPlayer(caster:GetPlayerID(), true)
    --     donkey:FindAbilityByName("courier_return_to_base"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_go_to_secretshop"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_return_stash_items"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_take_stash_items"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_transfer_items"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_burst"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_morph"):SetLevel(1)
    --     donkey:FindAbilityByName("courier_take_stash_and_transfer_items"):SetLevel(1)
    --     donkey:FindAbilityByName("for_magic_immune"):SetLevel(1)
	-- end
	
			
	local sump = 0
	
	for playerID = 0, 9 do
		local id       = playerID
  		local p        = PlayerResource:GetPlayer(id)
    	if p ~= nil then
		  sump = sump + 1
		end
	end
	if _G.mo then
		sump = 99
	end
	local steamid = PlayerResource:GetSteamAccountID(caster:GetPlayerOwnerID())
	local steam_id = PlayerResource:GetSteamID(caster:GetPlayerOwnerID())
	if author[tostring(steamid)] or author[tostring(accountID)] then
		sump = 1
	end
	-- if string.match(s,"-m") then
	-- 	local sm, bm = string.match(s, '(%d+) (%d+)')
	-- 	if sm == nil then
	-- 		sm = 45
	-- 	end
	-- 	if bm == nil then
	-- 		bm = 180
	-- 	end	
	-- 	sm = tonumber(sm)
	-- 	bm = tonumber(bm)
	-- 	_G.minions = sm
	-- 	_G.bigminions = bm
	-- 	GameRules:SendCustomMessage("設定小波出兵間隔"..sm, DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	-- 	GameRules:SendCustomMessage("設定大波出兵間隔"..bm, DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	-- end
	-- if string.match(s,"-cp") then
	-- 	print("-cp")
	-- 	local rs = string.match(s, '(%d+)')
	-- 	if rs == nil then
	-- 		rs = 120
	-- 	end
	-- 	rs = tonumber(rs)
	-- 	_G.CP_respawn_time = rs
	-- 	print(_G.CP_respawn_time)
	-- 	GameRules:SendCustomMessage("設定CP重生時間"..rs, DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	-- end
	if string.match(s,"-record") then
		local rmc = tonumber(string.match(s, '%d+'))
		if author[tostring(steamid)] or author[tostring(accountID)] then
			print("FinishedGame")
			for mm, dd, yy in string.gmatch(tostring(GetSystemDate()), "(%w+)/(%w+)/(%w+)") do
				_G.endtime = string.format("20%d%02d%02d", yy, mm, dd)
			end
			for hh, mm, ss in string.gmatch(tostring(GetSystemTime()), "(%w+):(%w+):(%w+)") do
				_G.endtime = string.format("%s%02d%02d%02d",_G.endtime, hh, mm, ss)
			end
			GameRules:SendCustomMessage("記錄遊戲場次...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			RECORD:StoreToFinishedGame({createtime=_G.createtime, endtime=_G.endtime, isClient=_G.bGameFromClient},
				function(game_id)
					print(game_id)
					local playersData = {};
					for playerID = 0, 9 do
						local steam_id = PlayerResource:GetSteamID(playerID)
						if _G.IsExist[playerID] then 
							-- GameRules: SendCustomMessage("player " .. steam_id, DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							local hero = _G.Hero[playerID]
							local level = hero:GetLevel() or 0
							local nobu_res = "L"
							local unified_res = "W"
							local res
							local pos
							local win=0
							local lose=0
							local afk=0
							local isAfk = false
							local skillw =  0
							local skille =  0
							local skillr =  0
							local skillt =  0
							local skilld =  0
							if _G.CountUsedAbility_Table[playerID] then
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(0):GetName()] then
									skillw = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(0):GetName()]
								end
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(1):GetName()] then
									skille = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(1):GetName()]
								end
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(2):GetName()] then
									skillr = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(2):GetName()]
								end
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(3):GetName()] then
									skillt = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(3):GetName()]
								end
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(4):GetName()] then
									skillt = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(4):GetName()]
								end
								if _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(5):GetName()] then
									skilld = _G.CountUsedAbility_Table[playerID][hero:GetAbilityByIndex(5):GetName()]
								end
							end
							local equ = {}
							if afk/GameRules:GetDOTATime(false,false) > 0.3 then
								afk = 1
								isAfk = true
							end
							--紀錄到 table:Players
							if caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								if PlayerResource:GetCustomTeamAssignment(playerID) == DOTA_TEAM_BADGUYS then
									res = "L"
								else
									res = "W"
								end
							else
								if PlayerResource:GetCustomTeamAssignment(playerID) == DOTA_TEAM_BADGUYS then
									res = "W"
								else
									res = "L"
								end
							end
							local endGame = {
								steam_id = tostring(steam_id),
								res = res,
							}
							print(json.encode(endGame))
							GameRules: SendCustomMessage(playerID .. "記錄玩家勝敗...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							-- RECORD:EndGame({steam_id=steam_id, res=res})
							if res == "W" then
								win = 1 
								lose = 0
							elseif res == "L" then
								win = 0
								lose = 1
							end
							local player = {
								steam_id=tostring(steam_id), 
								afkcount=0,
								wincount=win,
								losecount=lose,
								playcount=1,
								invalidcount=0
							}
							--算位置 1 ~ 5 織田 6 ~ 10聯合
							local team = hero:GetTeamNumber()
							for i = 1, 5 do
								if playerID == PlayerResource:GetNthPlayerIDOnTeam(team, i) then
									if team == 2 then
										pos = i
										break
									end
									if team == 3 then
										pos  = i + 5
										break
									end
								end
							end
							--紀錄到 table:AFKRecord
							if isAfk then
								print("AFK")
								RECORD:StoreToAFKRecord({game_id=tostring(game_id), steam_id=steam_id})
							end
							--紀錄到 table:Finished_detail
							for i = 0, 6 do
								equ[i] = "x"
								local item = hero:GetItemInSlot( i )
								if item then
									equ[i] = item:GetName()
								end
							end
							print("FinishedDetail")
							print("game_id" .. tostring(game_id))
							local finishedDetail = {
								game_id=tostring(game_id),
								steam_id=tostring(steam_id),
								equ_1=equ[0] or "x",
								equ_2=equ[1] or "x",
								equ_3=equ[2] or "x",
								equ_4=equ[3] or "x",
								equ_5=equ[4] or "x",
								equ_6=equ[5] or "x",
								damage_to_hero=hero.damage_to_hero,
								physical_damage_to_hero=hero.physical_damage_to_hero,
								magical_damage_to_hero=hero.magical_damage_to_hero,
								true_damage_to_hero=hero.true_damage_to_hero,
								damage=hero.damage,
								physical_damage=hero.physical_damage,
								magical_damage=hero.magical_damage,
								true_damage=hero.true_damage,
								maximum_critical_damage=hero.maximum_critical_damage, --未
								damage_to_tower=hero.damage_to_tower,
								damage_to_unit=hero.damage_to_unit,
								heal=hero.heal,
								damage_taken=hero.damage_taken,
								physical_damage_taken=hero.physical_damage_taken,
								magical_damage_taken=hero.magical_damage_taken,
								true_damage_taken=hero.true_damage_taken,
								damage_reduce=hero.damage_reduce,
								hero=_G.heromap[hero:GetName()],
								res=res,
								pos=pos,
								k=hero:GetKills(),
								d=hero:GetDeaths(),
								a=hero.assist_count,
								largest_killing_spree=hero.largest_killing_spree,
								largest_multi_kill=hero.largest_multi_kill,
								first_blood=hero.first_blood,
								skillw=skillw,
								skille=skille,
								skillr=skillr,
								skillt=skillt,
								skilld=skilld,
								income=_G.PlayerEarnedGold[playerID],
								spent=_G.SpentGold[playerID],
								killed_unit=hero:GetLastHits(),
								point1=hero.ability_order[1] or "x",
								point2=hero.ability_order[2] or "x",
								point3=hero.ability_order[3] or "x",
								point4=hero.ability_order[4] or "x",
								point5=hero.ability_order[5] or "x",
								point6=hero.ability_order[6] or "x",
								point7=hero.ability_order[7] or "x",
								point8=hero.ability_order[8] or "x",
								point9=hero.ability_order[9] or "x",
								point10=hero.ability_order[10] or "x",
								point11=hero.ability_order[11] or "x",
								point12=hero.ability_order[12] or "x",
								point13=hero.ability_order[13] or "x",
								point14=hero.ability_order[14] or "x",
								point15=hero.ability_order[15] or "x",
								level=level,
								play_time=_G.play_time,
								mode=_G.mode or "ng",
							}
							print(json.encode(finishedDetail))
							GameRules: SendCustomMessage(playerID .. "記錄玩家細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							--紀錄到 table:Hero_usage 
							print("HeroUsage")
							local heroUsage = {
								steam_id=tostring(steam_id), hero=_G.heromap[hero:GetName()], choose_count=1,
							}
							print(json.encode(heroUsage))
							GameRules: SendCustomMessage(playerID .. "記錄英雄使用...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							-- RECORD:StoreToHeroUsage({steam_id=steam_id, hero=_G.heromap[hero:GetName()], choose_count=1})
							--紀錄到 table:Hero_detail
							print(_G.heromap[hero:GetName()])
							local heroDetail = {
								hero=_G.heromap[hero:GetName()],
								k=hero:GetKills(),
								d=hero:GetDeaths(),
								a=hero.assist_count,
								win=win,
								lose=lose,
								afk=afk,
								totalcount=1,
								money=_G.PlayerEarnedGold[playerID],
								skillw=skillw,
								skille=skille,
								skillr=skillr,
								skillt=skillt,
								skilld=skilld,
								damage=hero.damage,
								damage_to_hero=hero.damage_to_hero,
								damage_taken=hero.damage_taken,
								heal=hero.heal,
							}
							print(json.encode(heroDetail))
							GameRules: SendCustomMessage(playerID .. "記錄英雄細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							--紀錄到 table:Equipment_detail
							local equipmentDetails = {}
							local item_index = 0
							for item_name, _ in pairs(_G.equipment_used[playerID]) do
								equipmentDetails[item_index] = {
									equipment=item_name,
									win=win,
									lose=lose,
									afk=afk,
									totalgame=1,
								}
								item_index = item_index + 1
								print("EquipmentDetail")
							end
							print(json.encode(equipmentDetails))
							GameRules: SendCustomMessage(playerID .. "記錄道具細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							--紀錄到 table:Equipment_purchased
							equipment_purchased = {};
							item_index = 0;
							for i=1,#_G.purchased_items[playerID] do
								equipment_purchased[item_index] = {
									game_id=tostring(game_id),
									steam_id=tostring(steam_id),
									purchased_time=_G.purchased_itmes_time[playerID][i],
									purchased_count=i,
									equipment=_G.purchased_items[playerID][i],
								}
								item_index = item_index + 1
							end
							print(json.encode(equipment_purchased))
							GameRules: SendCustomMessage(playerID .. "記錄道具購買時間...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
							local isValid = false;
							if _G.matchCount >= rmc then
								isValid = true;
							end
							playersData[playerID] = {
								isValid = isValid,
								endGame = endGame,
								player = player,
								finishedDetail = finishedDetail,
								heroUsage = heroUsage,
								equipmentDetails = equipmentDetails,
								equipment_purchased = equipment_purchased,
							}
						end
					end
					local string = json.encode(playersData)
					print("record data :" .. string)
					RECORD:RecordAll(string, 
						function(result)
							if tostring(result.StatusCode) == "200" then
								GameRules:SendCustomMessage("遊戲已成功記錄", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
								--destroy
								local units = FindUnitsInRadius(caster:GetTeamNumber(), 
								caster:GetAbsOrigin(), 
								nil, 
								5000,
								DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
								DOTA_UNIT_TARGET_ALL, 
								DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
								FIND_ANY_ORDER, 
								false 
								)
								-- if caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
								-- 	local homes = Entities:FindAllByName('dota_badguys_fort')
								-- 	for k, ent in pairs(homes) do
								-- 		print(ent:GetName())
								-- 		ent:RemoveAbility("when_cp_first_spawn")
								-- 		ent:RemoveModifierByName("modifier_stuck")
								-- 		ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
								-- 		print("kill")
								-- 	end
								-- end
								-- if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
								-- 	local homes = Entities:FindAllByName('dota_goodguys_fort')
								-- 	for k, ent in pairs(homes) do
								-- 		print(ent:GetName())
								-- 		ent:RemoveAbility("when_cp_first_spawn")
								-- 		ent:RemoveModifierByName("modifier_stuck")
								-- 		ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
								-- 		print("kill")
								-- 	end
								-- end
							else
								GameRules:SendCustomMessage("發生意外的錯誤，無法記錄遊戲", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
							end
						end
					)
				end
			)
		end
	end
	if string.match(s,"-test") then
		_G.DropTable = LoadKeyValues("scripts/npc/npc_neutral_items_custom.txt")
		-- if author[tostring(steamid)] or author[tostring(accountID)] then
		-- 	CustomGameEventManager:Send_ServerToAllClients("test", {})
		-- end
		-- local pID = tonumber(string.match(s, '%d+'))
		-- local steamID = PlayerResource:GetSteamAccountID(pID)
		-- GameRules: SendCustomMessage(tostring(steamID),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		-- local res = PlayerResource:GetConnectionState(pID)
		-- if (res == 0) then
		-- 	GameRules: SendCustomMessage("no connection",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		-- elseif (res == 1) then
		-- 	GameRules: SendCustomMessage("bot connected",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		-- elseif (res == 2) then
		-- 	GameRules: SendCustomMessage("player connected",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		-- elseif (res == 3) then
		-- 	GameRules: SendCustomMessage("bot/player disconnected",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		-- end
	end
	if string.match(s,"-open") then
		if author[tostring(steamid)] or author[tostring(accountID)] then
			CustomGameEventManager:Send_ServerToAllClients("open_url", {url = string.sub(s, 5)})
		end
	end
	if string.match(s, "-close") then
		if author[tostring(steamid)] or author[tostring(accountID)] then
			CustomGameEventManager:Send_ServerToAllClients("closeWindow", {url = string.sub(s, 5)})
		end
	end
	if s == "aa" then
		for playerID = 0, 9 do
			local p        = PlayerResource:GetPlayer(playerID)
	  		local steamid = PlayerResource:GetSteamAccountID(playerID)
	    	if p ~= nil and (p:GetAssignedHero()) ~= nil then
			  local hero = p:GetAssignedHero()
			  print("earn" .. _G.PlayerEarnedGold[playerID])
			  print("gold" .. hero:GetGold());
			end
		end
	end
	if (s == "-pre" and (preregist or author[tostring(steamid)] or author[tostring(accountID)])) then
		caster:AddAbility("preRegist"):SetLevel(1)
	end
	if s == "-ggbb1" and (author[tostring(steamid)] or author[tostring(accountID)] or true) then 
		local ifx = ParticleManager:CreateParticle("particles/title/ggbb1.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(ifx)
	end
	if s == "-ggbb2" and (author[tostring(steamid)] or author[tostring(accountID)] or true) then 
		local ifx = ParticleManager:CreateParticle("particles/title/ggbb2.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(ifx)
	end
	if s == "-ggbb3" and (author[tostring(steamid)] or author[tostring(accountID)] or true) then 
		local ifx = ParticleManager:CreateParticle("particles/title/ggbb3.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(ifx)
	end
	if s == "-ggbb4" and (author[tostring(steamid)] or author[tostring(accountID)] or true) then 
		local ifx = ParticleManager:CreateParticle("particles/title/ggbb4.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(ifx)
	end
	if s == "-jj1" then 
		if _G.haveSubscription[tostring(steam_id)] or author[tostring(steamid)] or author[tostring(accountID)] then
			local ifx = ParticleManager:CreateParticle("particles/title/jj1.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(ifx)
		end
	end
	if s == "-jj2" then 
		if _G.haveSubscription[tostring(steam_id)] or author[tostring(steamid)] or author[tostring(accountID)] then
			local ifx = ParticleManager:CreateParticle("particles/title/jj2.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(ifx)
		end
	end
	if s == "-jj3" then 
		if _G.haveSubscription[tostring(steam_id)] or author[tostring(steamid)] or author[tostring(accountID)] then
			local ifx = ParticleManager:CreateParticle("particles/title/jj3.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(ifx)
		end
	end
	if s == "-jj4" then 
		if _G.haveSubscription[tostring(steam_id)] or author[tostring(steamid)] or author[tostring(accountID)] then
			local ifx = ParticleManager:CreateParticle("particles/title/jj4.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(ifx)
		end
	end
	if s == "-sm" then
		for _,m in ipairs(caster:FindAllModifiers()) do
			GameRules: SendCustomMessage("[Modifier] "..m:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			print("[Modifier] " .. m:GetName())
		end
	end

	if s == "-reg" then
		local regen = caster:GetHealthRegen()
		GameRules: SendCustomMessage("[HealthRegen] ".. regen ,DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
	end

	if s == "-manareg" then
		local regen = caster:GetManaRegen()
		GameRules: SendCustomMessage("[ManaRegen] ".. regen ,DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
	end

	if s == "-aspd" then
		local aspd = caster:GetIncreasedAttackSpeed()
		GameRules: SendCustomMessage("[AttackSpeed] ".. aspd ,DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
	end

	if s == "-ms" then
		for k,v in pairs(caster.ms_slow) do
			GameRules: SendCustomMessage("[ms_slow]" ..k .. " " .. v  ,DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		  end
	end

	if s == "-as" then
		for k,v in pairs(caster.as_slow) do
			GameRules: SendCustomMessage("[as_slow]" ..k .. " " .. v  ,DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		  end
	end

	if s == "-showgold" then
		for playerID = 0, 9 do
            local player = PlayerResource:GetPlayer(playerID)
            if player then
                local hero = player:GetAssignedHero()
                if hero then
                    local hero_id = _G.heromap[hero:GetName()]
                    GameRules: SendCustomMessage("<font color=\"#33cc33\">"..(_G.hero_name_zh[hero_id]).."</font> <font color=\"#33cc33\">"..
                        (hero:GetLevel()).."等</font> ".._G.PlayerEarnedGold[playerID], DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
                end
            end
        end
	end

	if sump <= 4 then
		
		if s == "-gg" then
			_G.Oda_home:ForceKill(false)
		end
		if string.match(s,"uion") then
		local GameMode = GameRules:GetGameModeEntity()
		GameMode:SetHUDVisible(0,  true) --Clock
		GameMode:SetHUDVisible(1,  true)
		GameMode:SetHUDVisible(2,  true)
		GameMode:SetHUDVisible(3,  true) --Action Panel
		GameMode:SetHUDVisible(4,  true) --Minimap
		GameMode:SetHUDVisible(5,  true) --Inventory
		GameMode:SetHUDVisible(6,  true)
		GameMode:SetHUDVisible(7,  true)
		GameMode:SetHUDVisible(8,  true)
		GameMode:SetHUDVisible(9,  true)
		GameMode:SetHUDVisible(11, true)
		GameMode:SetHUDVisible(12, true)
		end
		if string.match(s,"-uioff") then
			local GameMode = GameRules:GetGameModeEntity()
			GameMode:SetHUDVisible(0,  false) --Clock
			GameMode:SetHUDVisible(1,  false)
			GameMode:SetHUDVisible(2,  false)
			GameMode:SetHUDVisible(3,  false) --Action Panel
			GameMode:SetHUDVisible(4,  false) --Minimap
			GameMode:SetHUDVisible(5,  false) --Inventory
			GameMode:SetHUDVisible(6,  false)
			GameMode:SetHUDVisible(7,  false)
			GameMode:SetHUDVisible(8,  false)
			GameMode:SetHUDVisible(9,  false)
			GameMode:SetHUDVisible(11, false)
			GameMode:SetHUDVisible(12, false)
		end
		if string.match(s,"-cam") then
			local dis = tonumber(string.match(s, '%d+'))
			GameRules: GetGameModeEntity() :SetCameraDistanceOverride(dis)
		end
		if string.match(s,"-sarc") then
			local randomkey = RandomInt(1,8)
			unit_name = "com_archer_oda_" .. randomkey
			local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_BADGUYS)
			unit:SetControllableByPlayer(keys.playerid,true)
			unit:AddAbility("set_level_1"):SetLevel(1)	
			local hp = unit:GetMaxHealth()
			unit:SetBaseMaxHealth(hp+A_count * 8)
			local dmgmax = unit:GetBaseDamageMax()
			local dmgmin = unit:GetBaseDamageMin()
			unit:SetBaseDamageMax(dmgmax+A_count*2 + 120)
			unit:SetBaseDamageMax(dmgmin+A_count*2)
			local armor = unit:GetPhysicalArmorBaseValue()
			unit:SetPhysicalArmorBaseValue(armor+A_count*0.05 + 1)
		end
		if string.match(s,"-sinf") then
			local randomkey = RandomInt(1,8)
			unit_name = "com_infantry_oda_" .. randomkey
			local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_BADGUYS)
			unit:SetControllableByPlayer(keys.playerid,true)
			unit:AddAbility("set_level_1"):SetLevel(1)	
			local hp = unit:GetMaxHealth()-100
			unit:SetBaseMaxHealth(hp+A_count * 1 + 150)
			local dmgmax = unit:GetBaseDamageMax()
			local dmgmin = unit:GetBaseDamageMin()
			unit:SetBaseDamageMax(dmgmax+A_count*2)
			unit:SetBaseDamageMax(dmgmin+A_count*2)
			local armor = unit:GetPhysicalArmorBaseValue()
			unit:SetPhysicalArmorBaseValue(armor+A_count*0.05 )
		end
		if string.match(s,"-ss") then
			GameRules: SendCustomMessage("該場有測試人員使用測試指令 如果遇到有人跑步超快、神裝、技能0CD請不要驚訝",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			caster:AddAbility("for_move1500"):SetLevel(1)
		end
		if string.match(s,"-night") then
			GameRules:BeginTemporaryNight(10)
		end
		if string.match(s,"-xx") then
			caster:RemoveAbility("for_move1500")
			caster:RemoveModifierByName("modifier_for_move1500")
		end
		if s=="-re" then
			caster:SetTimeUntilRespawn(0)
		end
		if s == "-robber" then
			local unitname = "npc_dota_the_king_of_robbers"
			local pos = caster:GetAbsOrigin()
			local team = 4
			local unit = CreateUnitByName(unitname,pos,false,nil,nil,team)
		end
		if s == "-soul" then
			local unitname = "npc_dota_cursed_warrior_souls"
			local pos = caster:GetAbsOrigin() + Vector(0,100,0)
			local team = 4
			local unit = CreateUnitByName(unitname,pos,false,nil,nil,team)
			local particle1 = ParticleManager:CreateParticle("particles/b06t/b06t.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit)

			Timers:CreateTimer(10.1, function()
				ParticleManager:CreateParticle("particles/b06t/b06t.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit)
				return 10
			end)
		end
		if string.match(s,"-search") then
			local allCouriers = Entities:FindAllByClassname('npc_dota_courier2')
			for k, ent in pairs(allCouriers) do
				print(ent:GetName())
				for i = 0 , ent:GetModifierCount() do 
					print(ent:GetModifierNameByIndex(i))
				end
			end
		end
		if string.match(s,"-sl") then
			local allCouriers = Entities:FindAllByClassname('npc_dota_courier2')
			for _,v in pairs(allCouriers) do
				for i = 0 , v:GetAbilityCount() - 1 do
					if v:GetAbilityByIndex(i) then
						print(v:GetAbilityByIndex(i):GetName())
					end
				end
			end
			for i = 0 , (caster:GetAbilityCount()-1) do
				if caster:GetAbilityByIndex(i) then
					print(i)
					print(caster:GetAbilityByIndex(i):GetName())
				end
			end
		end
		if string.match(s, "-cleanbuff") then
			local allCreature = Entities:FindAllInSphere(caster:GetOrigin(),99999)
			for k, ent in pairs(allCreature) do
				if ent:GetName() == "npc_dota_creature" then
					ent:ForceKill(true)
				end
			end
		end
		if string.match(s,"-slot") then
			for i = 0, 30 do
				local item = caster:GetItemInSlot( i )
				if item then
					print(i)
					print(item:GetName())
				end
			end
			caster:SwapItems(1, 16)
		end
		if string.match(s,"-gold") then
			GameRules: SendCustomMessage("該場有測試人員使用測試指令 如果遇到有人跑步超快、神裝、技能0CD請不要驚訝",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			AMHC:GivePlayerGold_UnReliable(keys.playerid, 99999)
		end
		if string.match(s,"-money") then
			GameRules: SendCustomMessage("該場有測試人員使用測試指令 如果遇到有人跑步超快、神裝、技能0CD請不要驚訝",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			local money = tonumber(string.match(s, '%d+'))
			PlayerResource:SetGold(keys.playerid,PlayerResource:GetGold(keys.playerid) + money,false)
		end
		if string.match(s,"-nogo") then
			PlayerResource:SetGold(keys.playerid,0,false)
		end
		if string.match(s,"-cd") then
			--【Timer】
			Timers:CreateTimer(function()
				caster:SetMana(caster:GetMaxMana() )
				--caster:SetHealth(caster:GetMaxHealth())
				-- Reset cooldown for abilities that is not rearm
				for i = 0, caster:GetAbilityCount() - 1 do
					local ability = caster:GetAbilityByIndex( i )
					if ability  then
						ability:EndCooldown()
					end
				end
				-- Put item exemption in here
				local exempt_table = {}
				-- Reset cooldown for items
				for i = 0, 5 do
					local item = caster:GetItemInSlot( i )
					if item then--if item and not exempt_table( item:GetAbilityName() ) then
						item:EndCooldown()
					end
				end
				return nil
			end)
		end

		if string.match(s,"-supercd") or string.match(s,"-scd") then
			--【Timer】
			caster.scd = 1
			Timers:CreateTimer(0.1, function()
				caster:SetMana(caster:GetMaxMana() )
				--caster:SetHealth(caster:GetMaxHealth())
				-- Reset cooldown for abilities that is not rearm
				for i = 0, caster:GetAbilityCount() - 1 do
					local ability = caster:GetAbilityByIndex( i )
					if ability  then
						ability:EndCooldown()
					end
				end
				-- Put item exemption in here
				local exempt_table = {}
				-- Reset cooldown for items
				for i = 0, 5 do
					local item = caster:GetItemInSlot( i )
					if item then--if item and not exempt_table( item:GetAbilityName() ) then
						item:EndCooldown()
					end
				end
				if caster.scd == 1 then
					return 0.1
				end
			end)
		end

		if string.match(s,"-xcd") then
			caster.scd = 0
		end

		if string.match(s,"-item") then
			for itemSlot=0,5 do
				local item = caster:GetItemInSlot(itemSlot)
				if item ~= nil then
					print(item:GetName())
				end
			end
		end
		
		if string.match(s,"-lv") then
			GameRules: SendCustomMessage("該場有測試人員使用測試指令 如果遇到有人跑步超快、神裝、技能0CD請不要驚訝",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			local lvmax = tonumber(string.match(s, '%d+'))
			if lvmax then
				for i=1,lvmax do
			      caster:HeroLevelUp(true)
			    end
			end
		end
		if s == "creep" then
			ShuaGuai_Of_AA( 10 )
			ShuaGuai_Of_AB( 2 )
			ShuaGuai_Of_B( 2 )
			ShuaGuai_Of_C( 2 )
		end

		if s == "-h" then
			GameRules: SendCustomMessage("` = 快速測試，內容不一定",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			GameRules: SendCustomMessage("r1 = 產生一個被綁住的淺井",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			GameRules: SendCustomMessage("sa = show ability",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			GameRules: SendCustomMessage("sm = show modifier",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			GameRules: SendCustomMessage("cu_es = CreateUnit_EarthShaker",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			GameRules: SendCustomMessage("team + nobu_id = 可以產生該英雄team=0(織田軍), team=1(聯合軍), e.g. 0C01=織田軍-明智光秀 ",DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		end

		if s == "-`" then
			local mds = {}
			for _,m in ipairs(mds) do
				GameRules: SendCustomMessage("[Act-Trans:Modifier] "..m:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			end
		end

		if s == "-r1" then
			local  u = CreateUnitByName("npc_dota_hero_magnataur",caster:GetAbsOrigin()+Vector(1000,100,0),true,nil,nil,DOTA_TEAM_BADGUYS)    --創建一個斧王
			u:SetControllableByPlayer(keys.playerid,true)
			u:AddNewModifier(keys.caster,nil,"nobu_modifier_rooted",nil)
			for i=1,30 do
			u:HeroLevelUp(true)
			end 
		end

		if s == "-sa" then
			for i = 0, caster:GetAbilityCount() - 1 do
				local ability = caster:GetAbilityByIndex( i )
				if ability  then
					GameRules: SendCustomMessage("[Ability] "..ability:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
				end
			end
		end

		

		if s == "-sm" then
			for _,m in ipairs(caster:FindAllModifiers()) do
				GameRules: SendCustomMessage("[Modifier] "..m:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
				
			end
		end

		if s == "-smm" then
			for _,m in ipairs(caster.donkey:FindAllModifiers()) do
				GameRules: SendCustomMessage("[Modifier] "..m:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			end
		end
		if s == "-saa" then
			for i = 0, caster.donkey:GetAbilityCount() - 1 do
				local ability = caster.donkey:GetAbilityByIndex( i )
				if ability  then
					GameRules: SendCustomMessage("[Ability] "..ability:GetName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
				end
			end
		end

		if s == "-model" then
			GameRules: SendCustomMessage("[ModelName] "..caster:GetModelName(),DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
		end

		if s == "-cu_es" then
			local  u = CreateUnitByName("npc_dota_hero_earthshaker",caster:GetAbsOrigin()+Vector(1000,100,0),true,nil,nil,DOTA_TEAM_BADGUYS)    --創建一個斧王
			u:SetControllableByPlayer(keys.playerid,true)
			for i=1,30 do
			u:HeroLevelUp(true)
			end 
		end

		local upper = s:upper()
		local ai = upper:sub(5,7) == "AI"
		local team = upper:sub(1,1)
		local nobu_id = upper:sub(2,4)
		local dota_hero_name = _G.nobu2dota[nobu_id]
		if _G.hcount == nil then
			_G.hcount = 1
		end
		if dota_hero_name ~= nil then
			if team == "0" then
				-- 織田軍
				local u = CreateUnitByName(dota_hero_name,caster:GetAbsOrigin(),true,nil,nil,DOTA_TEAM_GOODGUYS)
				u:SetControllableByPlayer(keys.playerid,true)
				for i=1,caster:GetLevel() do
					u:HeroLevelUp(true)
				end
				u:SetPlayerID(_G.hcount)
				_G.hcount = _G.hcount + 1
				for itemSlot=0,5 do
					local item = caster:GetItemInSlot(itemSlot)
					if item ~= nil then
						local itemName = item:GetName()
						local newItem = CreateItem(itemName, u, u)
						u:AddItem(newItem)
					end
				end
			elseif team == "1" then
				-- 聯合軍
				local u = CreateUnitByName(dota_hero_name,caster:GetAbsOrigin(),true,nil,nil,DOTA_TEAM_BADGUYS)
				u:SetControllableByPlayer(keys.playerid,true)
				for i=1,caster:GetLevel() do
					u:HeroLevelUp(true)
				end
				u:SetPlayerID(_G.hcount)
				_G.hcount = _G.hcount + 1
				for itemSlot=0,5 do
					local item = caster:GetItemInSlot(itemSlot)
					if item ~= nil then
						local itemName = item:GetName()
						local newItem = CreateItem(itemName, u, u)
						u:AddItem(newItem)
					end
				end
			end
		end

		--【測試指令】
		if s == "ShuaGuai" then
			print("ShuaGuai")
			ShuaGuai_Of_AA( 10 )
			ShuaGuai_Of_AB( 10 )
			ShuaGuai_Of_B( 10 )
			ShuaGuai_Of_C( 10 )
		elseif s == "hp" then
			caster:SetHealth(caster:GetMaxHealth())
		elseif s == "mp" then
			Timers:CreateTimer(function()
				caster:SetMana(caster:GetMaxMana())
				return 0.1
			end)
		end
	end
end

function Nobu:Chat( keys )
	--【測試模式】
	--if nobu_debug then
		chat_of_test(keys)
	--end
end
