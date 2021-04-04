local json = require "game/dkjson"
LinkLuaModifier( "modifier_record", "items/Addon_Items/record.lua",LUA_MODIFIER_MOTION_NONE )
gamestates =
{
	[0] = "DOTA_GAMERULES_STATE_INIT",
	[1] = "DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD",
	[2] = "DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP",
	[3] = "DOTA_GAMERULES_STATE_HERO_SELECTION",
	[4] = "DOTA_GAMERULES_STATE_STRATEGY_TIME",
	[5] = "DOTA_GAMERULES_STATE_TEAM_SHOWCASE",
	[6] = "DOTA_GAMERULES_STATE_PRE_GAME",
	[7] = "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS",
	[8] = "DOTA_GAMERULES_STATE_POST_GAME",
	[9] = "DOTA_GAMERULES_STATE_DISCONNECT"
}

function SendHTTPRequest(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://nobu.gg/clientApi/"..path )
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		callback(result.Body)
	end)
end

function SendHTTPRequestCheckSubscription(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://nobu.gg/clientApi/"..path)
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		print(result);
		callback(result.Body)
	end)
end

function SendHTTPRequestGetPlayers(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://nobu.gg/clientApi/"..path)
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		local table = {}
		for key, value in string.gmatch(tostring(result.Body), "(%w+)=(%w+)") do 
			table[key] = value
		end
		if table["0"] then
			_G.bStopGetFromClient = true
			_G.bGameFromClient = true
		 	for i=0, 10 do 
		 		PlayerResource:SetCustomTeamAssignment(i, 5)
			end
		end
		PrintTable(table)
		for i=0, 10 do
			if table["0"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 2)
				_G.selectHero[i] = table["hero1"]
				_G.matchCount = _G.matchCount + 1
			elseif table["1"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 2)
				_G.selectHero[i] = table["hero2"]
				_G.matchCount = _G.matchCount + 1
			elseif table["2"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 2)
				_G.selectHero[i] = table["hero3"]
				_G.matchCount = _G.matchCount + 1
			elseif table["3"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 2)
				_G.selectHero[i] = table["hero4"]
				_G.matchCount = _G.matchCount + 1
			elseif table["4"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 2)
				_G.selectHero[i] = table["hero5"]
				_G.matchCount = _G.matchCount + 1
			elseif table["5"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 3)
				_G.selectHero[i] = table["hero6"]
				_G.matchCount = _G.matchCount + 1
			elseif table["6"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 3)
				_G.selectHero[i] = table["hero7"]
				_G.matchCount = _G.matchCount + 1
			elseif table["7"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 3)
				_G.selectHero[i] = table["hero8"]
				_G.matchCount = _G.matchCount + 1
			elseif table["8"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 3)
				_G.selectHero[i] = table["hero9"]
				_G.matchCount = _G.matchCount + 1
			elseif table["9"] == tostring(PlayerResource:GetSteamID(i)) then
				PlayerResource:SetCustomTeamAssignment(i, 3)
				_G.selectHero[i] = table["hero10"]
				_G.matchCount = _G.matchCount + 1
			end
		end
		if table["mode"] then
			_G.mode = table["mode"]
			GameRules:FinishCustomGameSetup()
		end
		callback(result.Body)
	end)
end

--[[
[Nobu-lua] GameRules State Changed: 	DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP
think:
Q1.測試模式不會有state_init & DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD
Q2.每一個玩家進入事件異步，還是同步呢?
]]
function Nobu:OnGameRulesStateChange( keys )
  --獲取遊戲進度
  local newState = GameRules:State_Get()
  print("[Nobu-lua] GameRules State Changed: ",gamestates[newState])

  if(newState == DOTA_GAMERULES_STATE_INIT) then
	elseif(newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD) then
		--self.bSeenWaitForPlayers = true
	elseif(newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP) then
		_G.matchCount = 0;
		_G.recordCount = 0;
		_G.bStopGetFromClient = false
		_G.bGameFromClient = false
		_G.selectHero = {};
		_G.IsExist = {};
		-- 檢查這場遊戲是不是由client開的
		Timers:CreateTimer(0, function()
			if (_G.bStopGetFromClient == false) then
				local steam_id = PlayerResource:GetSteamID(0)
				if _G.aram then
					SendHTTPRequestGetPlayers("get_players/", "POST",
					{id = tostring(steam_id), mode = "aram"}, function(res)
						if (string.match(res, "error")) then
							callback()
						end
					end)
				else
					SendHTTPRequestGetPlayers("get_players/", "POST",
					{id = tostring(steam_id), mode = "ng"}, function(res)
						if (string.match(res, "error")) then
							callback()
						end
					end)
				end
				return 3
			end
			return
		end)
		-- -- --2織田軍 3聯合軍 5沒隊伍
		-- Timers:CreateTimer(0.1, function()
		-- 	GameRules:FinishCustomGameSetup()
		-- 	for i=0, 20 do 
		-- 		PlayerResource:SetCustomTeamAssignment(i, 5)
		-- 	end
		-- end)
	elseif(newState == DOTA_GAMERULES_STATE_HERO_SELECTION) then --選擇英雄階段
		--取得掉落表
		_G.DropTable = LoadKeyValues("scripts/npc/npc_neutral_items_custom.txt")
		--取得訂閱資格
		_G.haveSubscription = {};
		for playerID = 0, 9 do
			local steam_id = PlayerResource:GetSteamID(playerID)
			SendHTTPRequest("check_subscription/", "POST", {steam_id = tostring(steam_id)}, function(res)
				if (string.match(res, "error")) then
					print("error : " .. res)
				else
					print(res);
					print(string.len(res));
					if (string.len(res) > 20) then
						_G.haveSubscription[tostring(steam_id)] = true;
						print(steam_id);
						print(_G.haveSubscription[tostring(steam_id)]);
					end
				end
			end)
		end
		--取得skin
		_G.skin_table = {}
		_G.preregist_table = {}
		SendHTTPRequest("get_skin/", "POST", {}, function(res)
			if (string.match(res, "error")) then
				callback()
			else
				for id in string.gmatch(tostring(res), "%w+") do 
					_G.skin_table[id] = true;
				end
			end
		end)
		-- 取得事前登入資格
		SendHTTPRequest("get_preregist/", "POST", {}, function(res)
			if (string.match(res, "error")) then
				callback()
			else
				for id in string.gmatch(tostring(res), "%w+") do 
					_G.preregist_table[id] = true;
				end
			end
		end)

		-- 檢查是不是已經用client選好腳色了
		if _G.bStopGetFromClient then
			for playerID = 0, 9 do
				local player = PlayerResource:GetPlayer(playerID)
				local hero = ""
				for k, v in pairs(_G.heromap) do
					if _G.selectHero[playerID] == v then
						hero = k;
						break
					end
				end
				if (hero ~= "") then
					player:SetSelectedHero(hero)
				end
			end
		end

		-- 沒選好用內嵌的網頁選
		-- Timers:CreateTimer(50, function()
		-- 	for playerID = 0, 9 do
		-- 		local steam_id = PlayerResource:GetSteamID(playerID)
		-- 		local player   = PlayerResource:GetPlayer(playerID)
		-- 		if (player and player:GetAssignedHero() == nil) then
		-- 			SendHTTPRequestGetHero("", "POST",
		-- 			{id = tostring(playerID), steam_id = tostring(steam_id)}, function(res)
		-- 				if (string.match(res, "error")) then
		-- 					callback()
		-- 				end
		-- 			end)
		-- 		end
		-- 	end
		-- end)
		for i=0,20 do
			PlayerResource:SetGold(i,2000,false)--玩家ID需要減一
		end
	elseif(newState == DOTA_GAMERULES_STATE_STRATEGY_TIME) then
		_G.bStopGetFromClient = true;
	elseif(newState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE) then --選擇英雄階段
		for playerID = 0, 9 do
			local id       = playerID
			local p        = PlayerResource:GetPlayer(id)
			if p ~= nil then
				print("hero")
				print(p)
				p:MakeRandomHeroSelection()
			end
		end
	elseif(newState == DOTA_GAMERULES_STATE_PRE_GAME) then --當英雄選擇結束 --6
		_G.bStopGetFromClient = true;
    if (_G.nobu_debug) then -- 測試模式給裝
      for_test_equiment()
	end
	--遊戲開始時間
	--計算人數
	-- for i=0,20 do
	-- 	local player = PlayerResource:GetPlayer(i)
	-- 	if player then
	-- 		_G.matchCount = _G.matchCount + 1
	-- 	end
	-- end
	--test zone
	--test zone
	-- print("close window")
	-- Timers:CreateTimer(1, function()
	-- 	CustomGameEventManager:Send_ServerToAllClients("closeWindow", {})
	-- end)
	_G.isRecord = false;
    GameRules:SendCustomMessage(_G.version, DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
    GameRules:SendCustomMessage("15分鐘後可以打 -ff 投降" , DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	GameRules:SendCustomMessage("目前作者: Victor", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	GameRules:SendCustomMessage("響雨工作室", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	if ( _G.matchCount < 10 ) then
		GameRules:SendCustomMessage("此為練習模式 不計算分數", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	end
	elseif(newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS) then --遊戲開始 --7
		for mm, dd, yy in string.gmatch(tostring(GetSystemDate()), "(%w+)/(%w+)/(%w+)") do
			_G.createtime = string.format("20%d%02d%02d", yy, mm, dd)
		end
		for hh, mm, ss in string.gmatch(tostring(GetSystemTime()), "(%w+):(%w+):(%w+)") do
			_G.createtime = string.format("%s%02d%02d%02d",_G.createtime, hh, mm, ss)
		end
		_G.play_time = 0;
		Timers:CreateTimer(0, function()
			_G.play_time = _G.play_time + 1;
			return 1
		end)
		----------------------------------------------------------------------------------
	if _G.nobu_server_b then
      Nobu:OpenRoom()
    end
		--刪除建築物無敵
	local allBuildings = Entities:FindAllByClassname('npc_dota_building')
	for i = 1, #allBuildings, 1 do
		local building = allBuildings[i]
		if building:HasModifier('modifier_invulnerable') then
		building:RemoveModifierByName('modifier_invulnerable')
		end
	end
    --出兵觸發
    if _G.nobu_chubing_b then
		if _G.aram then
			ShuaGuai_Aram()
		else
			ShuaGuai()
		end
	for i=0,9 do
		-- 跳錢
		_G.PlayerEarnedGold[i] = 2000
		if _G.aram then
			Timers:CreateTimer(45, function()
				local gold = PlayerResource:GetUnreliableGold(i)
				PlayerResource:SetGold(i,gold + 5,false)
				_G.PlayerEarnedGold[i] = _G.PlayerEarnedGold[i] + 5
				return 2
			end)
		else
			Timers:CreateTimer(45, function()
				local gold = PlayerResource:GetUnreliableGold(i)
				PlayerResource:SetGold(i,gold + 10,false)
				_G.PlayerEarnedGold[i] = _G.PlayerEarnedGold[i] + 10
				return 2
			end)
		end
		if _G.aram then
			-- 跳經驗
			Timers:CreateTimer(45, function()
				local player = PlayerResource:GetPlayer(i)
				if player then 
					local hero = player:GetAssignedHero();
					hero:AddExperience(5,0,false,false)
				end
				return 2
			end)
		end
		-- 換skin
		local steamid = PlayerResource:GetSteamID(i)
		local accountID = PlayerResource:GetSteamAccountID(i)
		Timers:CreateTimer(0, function ()
			local player = PlayerResource:GetPlayer(i)
			if player then
				-- 紀錄玩家
				-- _G.matchCount = _G.matchCount + 1
				_G.IsExist[i] = true
				-- 紀錄角色
				_G.Hero[i] = player:GetAssignedHero()
				if _G.Hero[i] ~= nil then
					-- ARAM初始等級
					if _G.aram then
						if _G.Hero[i]:GetLevel() < 3 then
							_G.Hero[i]:AddExperience(485,0,false,false)
						end
					end
					if _G.skin_table[tostring(steamid)] == true or _G.skin_table[tostring(accountID)] == true then
						local caster = player:GetAssignedHero()
						caster.use_skin = true
						local nobu_id = _G.heromap[caster:GetName()]
						if (nobu_id == "C17") then
							caster.skin = "school"
							-- caster:SetModel("models/c17/c17_school.vmdl")
							caster:SetModel("models/oichi_student_new/oichi_student.vmdl")
							caster:SetModelScale(0.6)
							-- caster:SetOriginalModel("models/c17/c17_school.vmdl")
							caster:SetOriginalModel("models/oichi_student_new/oichi_student.vmdl")
						end
						if (nobu_id == "A26") then
							caster.skin = "school"
							caster:SetModel("models/a26/a26_school.vmdl")
							caster:SetOriginalModel("models/a26/a26_school.vmdl")
						end
						if (nobu_id == "B16") then
							caster.skin = "school"
							caster:SetModel("models/b16/b16_school.vmdl")
							caster:SetOriginalModel("models/b16/b16_school.vmdl")
						end
						if (nobu_id == "C19") then
							caster.skin = "school"
							caster:SetModel("models/c19/c19_school.vmdl")
							caster:SetOriginalModel("models/c19/c19_school.vmdl")
							caster:AddAbility("C19_school"):SetLevel(1)
						end
					end
				end
				if (_G.Hero[i] == nil) then
					-- GameRules: SendCustomMessage(i .. "獲取英雄失敗", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
					-- print("hero nil")
					-- print("return 1")
					return 1
				end
				-- GameRules: SendCustomMessage(i .. "獲取英雄成功", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
			end
		end)
		-- 紀錄技能
		_G.CountUsedAbility_Table[i] = {}
		-- 紀錄裝備
		if _G.equipment_used[i] == nil then
			_G.equipment_used[i] = {}
		end
		if _G.purchased_items[i] == nil then
			_G.purchased_items[i] = {}
		end
		if _G.purchased_itmes_time[i] == nil then
			_G.purchased_itmes_time[i] = {}
		end
	  end
	end
	--更新分數
	Timers:CreateTimer(1, function()
		local score = 0
		for i = 0,9 do
			if _G.Hero[i] ~= nil and _G.Hero[i]:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				if _G.Hero[i].kill_hero_count ~= nil then
					score = score + _G.Hero[i].kill_hero_count
				end
			end	
		end
		CustomGameEventManager:Send_ServerToAllClients("UpdateDireScore", {score = score})
		return 1
	end)
	--守護家園
	Timers:CreateTimer(600, function()
		local oda_def_home = CreateUnitByName("hide_unit", Vector(7445.46,-7517.94,128) , true, nil, nil, DOTA_TEAM_GOODGUYS) 
		oda_def_home:AddAbility("speed_up"):SetLevel(1)
		oda_def_home:AddAbility("home_aura"):SetLevel(1)
		local unified_def_home = CreateUnitByName("hide_unit", Vector(-7390.63,7203.02,128) , true, nil, nil, DOTA_TEAM_BADGUYS) 
		unified_def_home:AddAbility("speed_up"):SetLevel(1)
		unified_def_home:AddAbility("home_aura"):SetLevel(1)
	end)
	--平均等級1
	_G.average_level = {}
	_G.average_level[DOTA_TEAM_GOODGUYS] = 1
	_G.average_level[DOTA_TEAM_BADGUYS] = 1
	--檢查有沒有馬
	-- Timers:CreateTimer(1, function()
	-- 	for playerID = 0, 9 do
	-- 		local id       = playerID
	-- 		local p        = PlayerResource:GetPlayer(id)
	-- 		if p ~= nil then
	-- 			local hero	   = p:GetAssignedHero()
	-- 			if hero.courier == nil then
	-- 				local donkey = CreateUnitByName("npc_dota_courier", hero:GetAbsOrigin()+Vector(100, 100, 0), true, hero, hero, hero:GetTeam())
	-- 				donkey:SetOwner(hero)
	-- 				donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
	-- 				donkey:FindAbilityByName("courier_return_to_base"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_go_to_secretshop"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_return_stash_items"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_take_stash_items"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_transfer_items"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_burst"):SetLevel(1)
	-- 				donkey:FindAbilityByName("courier_take_stash_and_transfer_items"):SetLevel(1)
	-- 				donkey:FindAbilityByName("for_magic_immune"):SetLevel(1)
	-- 				donkey:FindAbilityByName("phased_dummy"):SetLevel(1)
	-- 				if hero.donkey == nil then
	-- 					hero.donkey = donkey
	-- 					print(hero.donkey)
	-- 				end
	-- 			end
				
	-- 		end
	-- 	end
	-- end)
	-- 出強王時間
	Timers:CreateTimer(180, function()
		GameRules: SendCustomMessage("<font color='#ffff00'>強盜之王出現了</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		unitname = "npc_dota_the_king_of_robbers"
		local pos = Vector(3487.55,3666,378)
		if _G.aram then
			pos = Vector(3449.93, 4404.84, 0)
		end
		local team = 4
		local CP_Monster = 0
		local unit = CreateUnitByName(unitname,pos,false,nil,nil,team)
		unit.origin_pos = pos
		unit.deathbuff = 0
		unit.pos = pos;
		local hp = unit:GetMaxHealth()
		unit:SetBaseMaxHealth(hp+CP_Monster * 50)
		local dmgmax = unit:GetBaseDamageMax()
		local dmgmin = unit:GetBaseDamageMin()
		unit:SetBaseDamageMax(dmgmax+CP_Monster*12)
		unit:SetBaseDamageMax(dmgmin+CP_Monster*12)
		for i = 0 , unit:GetAbilityCount() - 1 do
			if unit:GetAbilityByIndex(i) then
				unit:GetAbilityByIndex(i):SetLevel(1)
			end
		end
	end)
	--出詛咒亡靈武士時間
	Timers:CreateTimer(1200, function()
		GameRules: SendCustomMessage("<font color='#ffff00'>受詛咒的武士亡靈出現了</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		unitname = "npc_dota_cursed_warrior_souls"
		local pos = Vector(-3671.04,-3891.62,384)
		if _G.aram then
			pos = Vector(-4660.54, -3585.92, 256)
		end
		local team = 4
		local CP_Monster = 0
		local unit = CreateUnitByName(unitname,pos,false,nil,nil,team)
		local particle1 = ParticleManager:CreateParticle("particles/b06t/b06t.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit)
		
		unit.origin_pos = pos
		unit.pos = pos
		local hp = unit:GetMaxHealth()
		unit:SetBaseMaxHealth(hp+CP_Monster * 50)
		local dmgmax = unit:GetBaseDamageMax()
		local dmgmin = unit:GetBaseDamageMin()
		unit:SetBaseDamageMax(dmgmax+CP_Monster*12)
		unit:SetBaseDamageMax(dmgmin+CP_Monster*12)
		for i = 0 , unit:GetAbilityCount() - 1 do
			if unit:GetAbilityByIndex(i) then
				unit:GetAbilityByIndex(i):SetLevel(1)
			end
		end
	end)
	Timers:CreateTimer(0, function()
		local allUnits = Entities:FindAllByClassname('npc_dota_creep_lane')
		for k,ent in pairs(allUnits) do			
			if ent ~= nil and not ent:HasAbility("heal_soul_adder") then
				ent:AddAbility("heal_soul_adder"):SetLevel(1)
			end
		end
		return 1
	end)
	--清除所有CP怪
	Timers:CreateTimer(0, function()
		local allCPs = Entities:FindAllByClassname('npc_dota_creep_lane')
		for k, ent in pairs(allCPs) do
			if ent:HasModifier("modifier_record") then
				ent:RemoveModifierByName("modifier_record")
			end
			ent:AddNewModifier(ent, nil,"modifier_record",{})
			if ent:FindModifierByName("modifier_record") then 
				ent:FindModifierByName("modifier_record").caster = ent
			end
			if not string.match(ent:GetUnitName(),"general") then
				ent:AddAbility("when_cp_first_spawn"):SetLevel(1)
				ent:AddNoDraw()
			else
				--800 加技能
				for i = 0 , ent:GetAbilityCount() - 1 do
					if ent:GetAbilityByIndex(i) then
						ent:GetAbilityByIndex(i):SetLevel(1)
					end
				end
			end
		end
		local homes = Entities:FindAllByName('dota_badguys_fort')
		for k, ent in pairs(homes) do
			if ent:HasModifier("modifier_stuck") then
				ent:AddNoDraw()
			end
		end
		local homes = Entities:FindAllByName('dota_goodguys_fort')
		for k, ent in pairs(homes) do
			if ent:HasModifier("modifier_stuck") then
				ent:AddNoDraw()
			end
		end
	end)
	--45秒後出野怪
	Timers:CreateTimer(45, function()
		local allCPs = Entities:FindAllByClassname('npc_dota_creep_lane')
		for k, ent in pairs(allCPs) do
			ent:RemoveAbility("when_cp_first_spawn")
			ent:RemoveModifierByName("modifier_stuck")
			ent:RemoveNoDraw()
		end
	end)
    -- 增加單挑殺人得分
    Timers:CreateTimer(10, function()
    	if _G.mo then
	    	for _,hero in ipairs(HeroList:GetAllHeroes()) do
				if not hero:IsIllusion() and not hero:HasModifier("modifier_play_1v1") and hero:IsAlive() then
					hero:AddAbility("play_1v1"):SetLevel(1)
				end
			end
	    end
	    return 5
    end)
    Timers:CreateTimer(1200, function()
    	if _G.mo then
	    	local c1 = HeroList:GetAllHeroes()[1]
	    	local c2 = HeroList:GetAllHeroes()[2]
	    	if c1 and c2 then
	    		if c1.score == nil then c1.score = 0 end
	    		if c2.score == nil then c2.score = 0 end
	    		if c1.score > c2.score then
	    			c1.score = 3
	    		end
	    		if c2.score > c1.score then
	    			c2.score = 3
	    		end
	    	end
	    end
	    return 1
    end)
    local ccpres = -1
	Timers:CreateTimer(0, function()
		ccpres = ccpres + 1
		for n=2,3 do
			local pres = 150
			for playerID = 0, 9 do
				local player = PlayerResource:GetPlayer(playerID)
				if player then
					local hero = player:GetAssignedHero()
					if hero and hero:GetTeamNumber()==n then
						pres = pres
						pres = pres
					end
				end
			end
			local money = pres
			if ccpres > 0 then
				if n == 3 then
					-- GameRules: SendCustomMessage("<font color='#ffff00'>聯合將領得到了"..(money).." 支援</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
				elseif n == 2 then
					-- GameRules: SendCustomMessage("<font color='#ffff00'>織田將領得到了"..(money).." 支援</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
				end
				for playerID = 0, 9 do
					local player = PlayerResource:GetPlayer(playerID)
					if player then
						local hero = player:GetAssignedHero()
						if hero and hero:GetTeamNumber()==n then
							AMHC:GivePlayerGold_UnReliable(playerID, money)
							-- _G.PlayerEarnedGold[playerID] = _G.PlayerEarnedGold[playerID] + money
						end
					end
				end
			end
		end
		return 60
	end)
	-- Timers:CreateTimer(300, function()
	-- 	for playerID = 0, 9 do
	-- 		local player = PlayerResource:GetPlayer(playerID)
	-- 		if player then
	-- 			local hero = player:GetAssignedHero()
	-- 			if hero then
	-- 				local hero_id = _G.heromap[hero:GetName()]
	-- 				GameRules: SendCustomMessage("<font color=\"#33cc33\">"..(_G.hero_name_zh[hero_id]).."</font> <font color=\"#33cc33\">"..
	-- 					(hero:GetLevel()).."等</font> ".._G.PlayerEarnedGold[playerID], DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	-- 			end
	-- 		end
	-- 	end
	-- 	return 300
	-- end)
	

    
    Timers:CreateTimer(2, function ()
			_G.war_magic_mana = 0
		end)
    local start = 0

	elseif(newState == DOTA_GAMERULES_STATE_POST_GAME) then
	if _G.nobu_server_b then
		Timers:CreateTimer(3, function()
			GameRules: SendCustomMessage("遊戲結束啦", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			Nobu:CloseRoom()
		end)	
    end
	elseif(newState == DOTA_GAMERULES_STATE_DISCONNECT) then

	end

  -- DOTA_GAMERULES_STATE_INIT	0
  -- DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD	1
  -- DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP	2
  -- DOTA_GAMERULES_STATE_HERO_SELECTION	3
  -- DOTA_GAMERULES_STATE_STRATEGY_TIME	4
  -- DOTA_GAMERULES_STATE_TEAM_SHOWCASE	5
  -- DOTA_GAMERULES_STATE_PRE_GAME	6
  -- DOTA_GAMERULES_STATE_GAME_IN_PROGRESS	7
  -- DOTA_GAMERULES_STATE_POST_GAME	8
  -- DOTA_GAMERULES_STATE_DISCONNECT	9
end
