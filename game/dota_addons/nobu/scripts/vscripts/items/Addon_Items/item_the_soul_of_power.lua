local json = require "game/dkjson"
function item_soul_OnTakeDamage( event )
	-- Variables
	if IsServer() then
		local damage = event.DamageTaken
		local ability = event.ability
		if ability then
			local caster =ability:GetCaster()
			if damage > caster:GetHealth() and not caster:IsIllusion() then
				caster:StartGestureWithPlaybackRate(ACT_DOTA_DIE,1)
				caster:SetHealth(caster:GetMaxHealth())
				caster:SetMana(caster:GetMaxMana())
				local am = caster:FindAllModifiers()
				for _,v in pairs(am) do
					if IsValidEntity(v:GetCaster()) and v:GetParent().GetTeamNumber ~= nil then
						if v:GetParent():GetTeamNumber() ~= caster:GetTeamNumber() or v:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber() then
							caster:RemoveModifierByName(v:GetName())
						end
					end
				end
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_the_soul_of_power2",{duration = 3})
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_invulnerable",{duration = 8})
				Timers:CreateTimer(1, function()
					for itemSlot=0,5 do
						local item = caster:GetItemInSlot(itemSlot)
						if item ~= nil then
							local itemName = item:GetName()
							if (itemName == "item_the_soul_of_power") then
								item:Destroy()
								break
							end
						end
					end
					end)
			end
		end
	end
end

function getMVP_value(hero)
	if hero.building_count == nil then
		hero.building_count = 0
	end
	if hero.building_count then
		local kda = hero:GetKills()*1.5-hero:GetDeaths()+hero:GetAssists()+hero.building_count
		return kda
	end
	return 0
end


function MVP_OnTakeDamage( event )
	-- Variables
	if IsServer() then
		print(DOTA_TEAM_BADGUYS) -- 3
		print(DOTA_TEAM_GOODGUYS) -- 2
		-- local damage = event.DamageTaken
		PrintTable( event )
		local ability = event.ability
		if ability then
			local caster = ability:GetCaster()
			
			-- if damage > caster:GetHealth() then
				-- 傳送遊戲結果
				-- 紀錄遊戲結束時間
				for mm, dd, yy in string.gmatch(tostring(GetSystemDate()), "(%w+)/(%w+)/(%w+)") do
					_G.endtime = string.format("20%d%02d%02d", yy, mm, dd)
				end
				for hh, mm, ss in string.gmatch(tostring(GetSystemTime()), "(%w+):(%w+):(%w+)") do
					_G.endtime = string.format("%s%02d%02d%02d",_G.endtime, hh, mm, ss)
				end
				-- if _G.isRecord == false and _G.matchCount >= _G.recordCount then
				if _G.isRecord == false then
					_G.isRecord = true;
					--紀錄到 table:Finished_game
					print("FinishedGame")
					-- GameRules:SendCustomMessage("記錄遊戲場次...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
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
									-- GameRules: SendCustomMessage(playerID .. "記錄玩家勝敗...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
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
									-- GameRules: SendCustomMessage(playerID .. "記錄玩家細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
									--紀錄到 table:Hero_usage 
									print("HeroUsage")
									local heroUsage = {
										steam_id=tostring(steam_id), hero=_G.heromap[hero:GetName()], choose_count=1,
									}
									print(json.encode(heroUsage))
									-- GameRules: SendCustomMessage(playerID .. "記錄英雄使用...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
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
									-- GameRules: SendCustomMessage(playerID .. "記錄英雄細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
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
									-- GameRules: SendCustomMessage(playerID .. "記錄道具細節...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
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
									-- GameRules: SendCustomMessage(playerID .. "記錄道具購買時間...", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS,0)
									playersData[playerID] = {
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
										if caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
											local homes = Entities:FindAllByName('dota_badguys_fort')
											for k, ent in pairs(homes) do
												print(ent:GetName())
												ent:RemoveAbility("when_cp_first_spawn")
												ent:RemoveModifierByName("modifier_stuck")
												ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
												print("kill")
											end
										end
										if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
											local homes = Entities:FindAllByName('dota_goodguys_fort')
											for k, ent in pairs(homes) do
												print(ent:GetName())
												ent:RemoveAbility("when_cp_first_spawn")
												ent:RemoveModifierByName("modifier_stuck")
												ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
												print("kill")
											end
										end
									else
										GameRules:SendCustomMessage("發生意外的錯誤，無法記錄遊戲", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
									end
								end
							)
						end
					) 
				end
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
				if caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
					local homes = Entities:FindAllByName('dota_badguys_fort')
					for k, ent in pairs(homes) do
						print(ent:GetName())
						ent:RemoveAbility("when_cp_first_spawn")
						ent:RemoveModifierByName("modifier_stuck")
						ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
						print("kill")
					end
				end
				if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					local homes = Entities:FindAllByName('dota_goodguys_fort')
					for k, ent in pairs(homes) do
						print(ent:GetName())
						ent:RemoveAbility("when_cp_first_spawn")
						ent:RemoveModifierByName("modifier_stuck")
						ent:AddNewModifier(unit, nil, "modifier_kill", {duration=0.2})
						print("kill")
					end
				end
			-- end
		end
	end
end
