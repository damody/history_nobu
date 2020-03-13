LinkLuaModifier( "modifier_unit_armor", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_armor", "scripts/vscripts/library/common/dummy.lua",LUA_MODIFIER_MOTION_NONE )
--print ('[Nobu-lua] chubing lua script Starting..' )
--if _G.nobu_chubing_b then --"Nobu" then
print("[Nobu-lua] _G.nobu_chubing_b")
--[[
IDEA:
	O先把秒數用全局紀錄下來，可以作成動態管理出兵秒數
	O中路尋路用攻擊指令，不用自動尋路
	O記得換足輕兩個單位
BUG
	o問題超多
	O移動速度會莫名其妙lag --解決
	O尋路系統效能耗超大 --解決
]]
if _G.A_count == nil then
prestige = nil
payprestige = nil
Timers:CreateTimer(5, function()
		prestige = _G.prestige
		payprestige = _G.payprestige
	end)

--用於記錄波數
ShuaGuai_bo=0

--紀錄出兵的兵量
ShuaGuai_Of_Archer_num=2 --弓箭手
ShuaGuai_Of_Walker_num=3 --足輕
ShuaGuai_Of_Cavalry_num=1 --騎兵
ShuaGuai_Of_Gunner_num=2 --火槍兵

_G.A_count = -1
_G.B_count = -1
_G.C_count = -1

_G.call_team = {}
_G.call_team[2] = 0
_G.call_team[3] = 0
_G.max_call = 4

_G.team_broken = {}
_G.team_broken[2] = {}
_G.team_broken[2]["top"] = 0
_G.team_broken[2]["mid"] = 0
_G.team_broken[2]["down"] = 0
_G.team_broken[3] = {}
_G.team_broken[3]["top"] = 0
_G.team_broken[3]["mid"] = 0
_G.team_broken[3]["down"] = 0

_G.big_team = {}
_G.big_team[2] = {}
_G.big_team[2]["top"] = 0
_G.big_team[2]["mid"] = 0
_G.big_team[2]["down"] = 0
_G.big_team[3] = {}
_G.big_team[3]["top"] = 0
_G.big_team[3]["mid"] = 0
_G.big_team[3]["down"] = 0

_G.minions = 40
_G.bigminions = 120

end
--紀錄出兵起始點、路徑 (必須要用計時器，初始化時物體還沒建造)
Timers:CreateTimer( 2, function()
	ShuaGuai_entity={
		Entities:FindByName(nil,"chubinluxian_location_of_nobu_button"),
		Entities:FindByName(nil,"chubinluxian_location_of_nobu_middle"),
		Entities:FindByName(nil,"chubinluxian_location_of_nobu_top"),
		Entities:FindByName(nil,"chubinluxian_location_of_wl_button"),
		Entities:FindByName(nil,"chubinluxian_location_of_wl_middle"),
		Entities:FindByName(nil,"chubinluxian_location_of_wl_top")
	}
	ShuaGuai_entity_point={} --誕生點
	ShuaGuai_entity_forvec={} --誕生方向
	for i=1,6 do
		ShuaGuai_entity_point[i] = ShuaGuai_entity[i]:GetAbsOrigin()
		--print(ShuaGuai_entity_point[i])
		ShuaGuai_entity_forvec[i] = ShuaGuai_entity[i]:GetForwardVector()
	end
	return nil
end)

-- 中路模式

function ShuaGuai( )
	--ShuaGuai_Of_A( )

	--出兵觸發:足輕+弓箭手
	--30秒出第一波，之後每30秒出一波
	local speedup = 0.01
	local ShuaGuai_count = -1
	local start_time = 45
	local no_buff = {
		["com_general_oda"] = true,
		["com_general_unified"] = true,
	}
	Timers:CreateTimer(10, function()
		local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
		for k, ent in pairs(allBuildings) do
			ent:AddAbility("buff_tower"):SetLevel(1)
			ent:SetPhysicalArmorBaseValue(5)
			ent:AddNewModifier(ent, ent:FindAbilityByName("tower_armor"), "modifier_tower_armor", nil)
		end
		local allBuildings2 = Entities:FindAllByName('npc_dota_building')
		for k, ent in pairs(allBuildings2) do
			ent:AddAbility("buff_tower"):SetLevel(1)
		end
		_G.Oda_home:AddAbility("buff_tower"):SetLevel(1)
		_G.Unified_home:AddAbility("buff_tower"):SetLevel(1)
		end)
	
	local armor = 15
	Timers:CreateTimer(start_time, function()
		--強化箭塔npc_dota_building
		local allBuildings = Entities:FindAllByClassname('npc_dota_tower')
		armor = armor - 1
		if armor < 15 then
			armor = 15
		end
		for k, ent in pairs(allBuildings) do
		    if ent:IsTower() then
		    	if no_buff[ent:GetUnitName()] == nil then
			    	ent:SetBaseDamageMax(ent:GetBaseDamageMax() + 4)
			    	ent:SetBaseDamageMin(ent:GetBaseDamageMin() + 4)
			    end
		    	ent:SetPhysicalArmorBaseValue(armor)
			end
		end
		return 45
	end)
	-- 出足輕   
 	Timers:CreateTimer(start_time, function()
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,2,1)
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,2,2)
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,2,3)
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,3,4)
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,3,5)
		ShuaGuai_Of_AA(ShuaGuai_Of_Walker_num,3,6)
		_G.A_count = _G.A_count + 1
  		return _G.minions
	 end)
	 -- 出弓箭手
	 Timers:CreateTimer(start_time+3, function()--50
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,2,1)
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,2,2) 
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,2,3)
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,3,4)
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,3,5)
		ShuaGuai_Of_AB(ShuaGuai_Of_Archer_num,3,6)
		 return _G.minions
	end)
	-- 出鐵炮跟騎兵
	Timers:CreateTimer(180,function()
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,2,1)
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,2,2)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,2,1)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,2,2)  
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,2,3)
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,3,4)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,2,3)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,3,4)
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,3,5)
		ShuaGuai_Of_B(ShuaGuai_Of_Gunner_num,3,6)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,3,5)
		ShuaGuai_Of_C(ShuaGuai_Of_Cavalry_num,3,6)
	    return _G.minions
	end)
end


--【足輕】
function ShuaGuai_Of_AA(num, team, pos)
	local A_count = _G.A_count
	local tem_count = 0
	--總共六個出發點 6
	local randomkey = RandomInt(1,8)
	local function ltt()
		tem_count = tem_count + 1
		if tem_count > num then return nil
		else
			for i=pos,pos do
				--騎兵營被拆
				local small_big = false
				if _G.team_broken[3]["top"] == 1 and i == 3 then
					small_big = true
				end
				if _G.team_broken[3]["mid"] == 1 and i == 2 then
					small_big = true
				end
				if _G.team_broken[3]["down"] == 1 and i == 1 then
					small_big = true
				end
				if _G.team_broken[2]["top"] == 1 and i == 6 then
					small_big = true
				end
				if _G.team_broken[2]["mid"] == 1 and i == 5 then
					small_big = true
				end
				if _G.team_broken[2]["down"] == 1 and i == 4 then
					small_big = true
				end
				--兵營被拆
				local big = false
				local big_team = false
				if _G.team_broken[3]["top"] == 2 and i == 3 then
					big = true
				end
				if _G.team_broken[3]["mid"] == 2 and i == 2 then
					big = true
				end
				if _G.team_broken[3]["down"] == 2 and i == 1 then
					big = true
				end
				if _G.team_broken[2]["top"] == 2 and i == 6 then
					big = true
				end
				if _G.team_broken[2]["mid"] == 2 and i == 5 then
					big = true
				end
				if _G.team_broken[2]["down"] == 2 and i == 4 then
					big = true
				end

				local go = false
				if _G.mo == nil then
					go = true
				elseif i==2 or i==5 then
					go = true
				end
				if go then
					--超過三的時候出兵變為聯合軍
					local unit_name = nil
					if i > 3 then
						team = 3
					else
						team = 2
					end
					if team == 2 then
						unit_name = "com_infantry_oda_" .. randomkey
					elseif team == 3 then
						unit_name = "com_infantry_unified_" .. randomkey
					end
					--創建單位
					--強化倍率
					local intensify = 1
					if small_big then intensify = 1.3 end
					if big then intensify = 1.3 end
					local unit = CreateUnitByName(unit_name, ShuaGuai_entity_point[i] , true, nil, nil, team)
					unit:AddAbility("set_level_1"):SetLevel(1)
					unit:AddNewModifier(unit, unit:FindAbilityByName("unit_armor"), "modifier_unit_armor", nil)
					local hp = (unit:GetMaxHealth() + 150) * intensify
					unit:SetBaseMaxHealth(hp+A_count * 8)
					local dmgmax = unit:GetBaseDamageMax() * intensify
					local dmgmin = unit:GetBaseDamageMin() * intensify
					unit:SetBaseDamageMax(dmgmax+A_count*1)
					unit:SetBaseDamageMax(dmgmin+A_count*1)
					local armor = unit:GetPhysicalArmorBaseValue() * intensify
					unit:SetPhysicalArmorBaseValue(armor+A_count*0.1)
					--creep:SetContextNum("isshibing",1,0)
					--單位面向角度
					unit:SetForwardVector(ShuaGuai_entity_forvec[i])
					--禁止單位尋找最短路徑
					unit:SetMustReachEachGoalEntity(false)
					--顏色
					if team == 3 then
						----unit:SetRenderColor(255,100,100)
					elseif team == 3 then
						----unit:SetRenderColor(100,255,100)
					end
					--讓單位沿著設置好的路線開始行動
					unit:SetInitialGoalEntity(ShuaGuai_entity[i])
				end
			end
			return 0.5
		end
	end
	Timers:CreateTimer(ltt)
end
--【弓箭手】
function ShuaGuai_Of_AB(num, team, pos)
	local A_count = _G.A_count
	local tem_count = 0
	
	--總共六個出發點 6
	local randomkey = RandomInt(1,8)
	local function ltt()
		tem_count = tem_count + 1
		if tem_count > num then return nil
		else
			for i=pos,pos do
				--騎兵營被拆
				local small_big = false
				if _G.team_broken[3]["top"] == 1 and i == 3 then
					small_big = true
				end
				if _G.team_broken[3]["mid"] == 1 and i == 2 then
					small_big = true
				end
				if _G.team_broken[3]["down"] == 1 and i == 1 then
					small_big = true
				end
				if _G.team_broken[2]["top"] == 1 and i == 6 then
					small_big = true
				end
				if _G.team_broken[2]["mid"] == 1 and i == 5 then
					small_big = true
				end
				if _G.team_broken[2]["down"] == 1 and i == 4 then
					small_big = true
				end
				--兵營被拆
				local big = false
				if _G.team_broken[3]["top"] == 2 and i == 3 then
					big = true
				end
				if _G.team_broken[3]["mid"] == 2 and i == 2 then
					big = true
				end
				if _G.team_broken[3]["down"] == 2 and i == 1 then
					big = true
				end
				if _G.team_broken[2]["top"] == 2 and i == 6 then
					big = true
				end
				if _G.team_broken[2]["mid"] == 2 and i == 5 then
					big = true
				end
				if _G.team_broken[2]["down"] == 2 and i == 4 then
					big = true
				end

				local go = false
				if _G.mo == nil then
					go = true
				elseif i==2 or i==5 then
					go = true
				end
				if go then
					--超過三的時候出兵變為聯合軍
					local unit_name = nil
					if i > 3 then
						team = 3
					else
						team = 2
					end
					if team == 2 then
						unit_name = "com_archer_oda_" .. randomkey
					elseif team == 3 then
						unit_name = "com_archer_unified_" .. randomkey
					end

					--創建單位
					--強化倍率
					local intensify = 1
					if small_big then intensify = 1.3 end
					if big then intensify = 1.3 end
					local unit = CreateUnitByName(unit_name, ShuaGuai_entity_point[i] , true, nil, nil, team)
					unit:AddAbility("set_level_1"):SetLevel(1)
					unit:AddNewModifier(unit, unit:FindAbilityByName("unit_armor"), "modifier_unit_armor", nil)
					local hp = unit:GetMaxHealth() * intensify
					unit:SetBaseMaxHealth(hp+A_count * 8)
					local dmgmax = unit:GetBaseDamageMax() * intensify
					local dmgmin = unit:GetBaseDamageMin() * intensify
					unit:SetBaseDamageMax(dmgmax+A_count*2)
					unit:SetBaseDamageMax(dmgmin+A_count*2)
					local armor = unit:GetPhysicalArmorBaseValue() * intensify
					unit:SetPhysicalArmorBaseValue(armor+A_count*0.05)
					--creep:SetContextNum("isshibing",1,0)
					--單位面向角度
					unit:SetForwardVector(ShuaGuai_entity_forvec[i])
					--禁止單位尋找最短路徑
					unit:SetMustReachEachGoalEntity(false)
					--顏色
					if team == 3 then
					----unit:SetRenderColor(255,100,100)
					elseif team == 3 then
						----unit:SetRenderColor(100,255,100)
					end
					--讓單位沿著設置好的路線開始行動
					unit:SetInitialGoalEntity(ShuaGuai_entity[i])
				end
			end
			return 0.5
		end
	end
	Timers:CreateTimer(ltt)
end

--【鐵炮兵】
function ShuaGuai_Of_B(num, team, pos)
	local tem_count = 0
	B_count = _G.B_count
	B_count = B_count + 1
	local A_count = _G.A_count
	print("A_count "..A_count)
	--總共六個出發點 6
	local randomkey = RandomInt(1,8)
	local function ltt()
		tem_count = tem_count + 1
		if tem_count > num then return nil
		else
			for i=pos,pos do
				--超過三的時候出兵變為聯合軍
				--騎兵營被拆
				local small_big = false
				if _G.team_broken[3]["top"] == 1 and pos == 3 then
					small_big = true
				end
				if _G.team_broken[3]["mid"] == 1 and pos == 2 then
					small_big = true
				end
				if _G.team_broken[3]["down"] == 1 and pos == 1 then
					small_big = true
				end
				if _G.team_broken[2]["top"] == 1 and pos == 6 then
					small_big = true
				end
				if _G.team_broken[2]["mid"] == 1 and pos == 5 then
					small_big = true
				end
				if _G.team_broken[2]["down"] == 1 and pos == 4 then
					small_big = true
				end
				--兵營被拆
				local big = false
				if _G.team_broken[3]["top"] == 2 and pos == 3 then
					big = true
				end
				if _G.team_broken[3]["mid"] == 2 and pos == 2 then
					big = true
				end
				if _G.team_broken[3]["down"] == 2 and pos == 1 then
					big = true
				end
				if _G.team_broken[2]["top"] == 2 and pos == 6 then
					big = true
				end
				if _G.team_broken[2]["mid"] == 2 and pos == 5 then
					big = true
				end
				if _G.team_broken[2]["down"] == 2 and pos == 4 then
					big = true
				end
				local unit_name = nil
				if team == 2 then
					unit_name = "com_gunner_oda_" .. randomkey
				elseif team == 3 then
					unit_name = "com_gunner_unified_" .. randomkey
				end
				
				--創建單位
				local n = 1
				--強化倍率
				local intensify = 1
				if small_big then intensify = 1.3 end
				if big then intensify = 1.3 end
				for x=1,n do
					local unit = CreateUnitByName(unit_name, ShuaGuai_entity_point[i] , true, nil, nil, team)
					unit:AddAbility("set_level_1"):SetLevel(1)
					unit:AddNewModifier(unit, unit:FindAbilityByName("unit_armor"), "modifier_unit_armor", nil)
					local hp = (unit:GetMaxHealth()) * intensify
					unit:SetBaseMaxHealth(hp+A_count * 5)
					local dmgmax = (unit:GetBaseDamageMax()) * intensify
					local dmgmin = (unit:GetBaseDamageMin()) * intensify
					unit:SetBaseDamageMax(dmgmax+A_count*3)
					unit:SetBaseDamageMin(dmgmin+A_count*3)
					local armor = (unit:GetPhysicalArmorBaseValue()) * intensify
					unit:SetPhysicalArmorBaseValue(armor+A_count*0.1)
					--creep:SetContextNum("isshibing",1,0)

					--單位面向角度
					unit:SetForwardVector(ShuaGuai_entity_forvec[i])

					--禁止單位尋找最短路徑
					unit:SetMustReachEachGoalEntity(false)

					--讓單位沿著設置好的路線開始行動
					unit:SetInitialGoalEntity(ShuaGuai_entity[i])
				end
			end
			return 0.5
		end
	end
	Timers:CreateTimer(ltt)
end

--【騎兵】
function ShuaGuai_Of_C(num, team, pos)
	local tem_count = 0
	C_count = _G.C_count
	C_count = C_count + 1
	local A_count = _G.A_count
	print("A_count "..A_count)
	--總共六個出發點 6
	local randomkey = RandomInt(1,8)
	local function ltt()
		tem_count = tem_count + 1
		if tem_count > num then return nil
		else
			for i=pos,pos do
				--騎兵營被拆
				local small_big = false
				if _G.team_broken[3]["top"] == 1 and pos == 3 then
					small_big = true
				end
				if _G.team_broken[3]["mid"] == 1 and pos == 2 then
					small_big = true
				end
				if _G.team_broken[3]["down"] == 1 and pos == 1 then
					small_big = true
				end
				if _G.team_broken[2]["top"] == 1 and pos == 6 then
					small_big = true
				end
				if _G.team_broken[2]["mid"] == 1 and pos == 5 then
					small_big = true
				end
				if _G.team_broken[2]["down"] == 1 and pos == 4 then
					small_big = true
				end
				--兵營被拆
				local big = false
				if _G.team_broken[3]["top"] == 2 and pos == 3 then
					big = true
				end
				if _G.team_broken[3]["mid"] == 2 and pos == 2 then
					big = true
				end
				if _G.team_broken[3]["down"] == 2 and pos == 1 then
					big = true
				end
				if _G.team_broken[2]["top"] == 2 and pos == 6 then
					big = true
				end
				if _G.team_broken[2]["mid"] == 2 and pos == 5 then
					big = true
				end
				if _G.team_broken[2]["down"] == 2 and pos == 4 then
					big = true
				end
				local unit_name = nil
				if team == 2 then
					unit_name = "com_cavalry_oda_" .. randomkey
				elseif team == 3 then
					unit_name = "com_cavalry_unified_" .. randomkey
				end

				--【騎兵】
				--創建單位
				local n = 1
				--強化倍率
				local intensify = 1
				if small_big then intensify = 1.3 end
				if big then intensify = 1.3 end
				for x=1,n do
					local unit = CreateUnitByName(unit_name, ShuaGuai_entity_point[i] , true, nil, nil, team)
					
					local hp = (unit:GetMaxHealth()) * intensify
					unit:SetBaseMaxHealth(hp+A_count * 10)
					local dmgmax = (unit:GetBaseDamageMax()) * intensify
					local dmgmin = (unit:GetBaseDamageMin()) * intensify
					unit:SetBaseDamageMax(dmgmax+A_count*3)
					unit:SetBaseDamageMin(dmgmin+A_count*3)
					local armor = (unit:GetPhysicalArmorBaseValue()) * intensify
					unit:SetPhysicalArmorBaseValue(armor+A_count*0.1)
					unit:FindAbilityByName("for_no_collision"):SetLevel(1)
					--creep:SetContextNum("isshibing",1,0)

					--單位面向角度
					unit:SetForwardVector(ShuaGuai_entity_forvec[i])

					--禁止單位尋找最短路徑
					unit:SetMustReachEachGoalEntity(false)

					--讓單位沿著設置好的路線開始行動
					unit:SetInitialGoalEntity(ShuaGuai_entity[i])
				end
			end
			return 0.5
		end
	end
	Timers:CreateTimer(ltt)
end


