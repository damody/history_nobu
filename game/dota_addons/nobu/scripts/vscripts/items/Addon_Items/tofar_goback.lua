LinkLuaModifier("modifier_ninja2", "heroes/modifier_ninja2.lua", LUA_MODIFIER_MOTION_NONE)
local kill_robber_count = 0
local kill_warrior_soul_count = 0
local dummy
local robber_buff
function choose_20( keys )
	local caster = keys.caster
	local ability = keys.ability
	local nobu_id = _G.heromap[caster:GetName()]
	-- 通知所有玩家該英雄已經變成新版
	GameRules:SendCustomMessage("<font color='#ccbbff'>20版 ".._G.hero_name_zh[nobu_id].." 參戰</font>",0,0)
	caster.isnew = true
	caster:SetAbilityPoints(caster:GetLevel())
	caster.version = "20"

	for i = 0, caster:GetAbilityCount() - 1 do
      local ability = caster:GetAbilityByIndex( i )
      if ability  then
        caster:RemoveAbility(ability:GetName())
      end
    end
    local skill = _G.heromap_skill[nobu_id]["20"]
    for si=1,#skill do
      if si == 5 then
        caster:AddAbility("attribute_bonusx"):SetLevel(1)
      end
      caster:AddAbility(nobu_id..skill:sub(si,si).."_20")
    end
    -- 要自動學習的技能
    local askill = _G.heromap_autoskill[nobu_id]["20"]
    for si=1,#askill do
      caster:FindAbilityByName(nobu_id..askill:sub(si,si).."_20"):SetLevel(1)
    end
    -- 直江兼續新版要砍普攻距離
    if nobu_id == "B36" and caster:HasModifier("modifier_B36D_old") then
    	caster:RemoveModifierByName("modifier_B36D_old")
    end
    -- 加藤段藏天生技要拿掉
    if nobu_id == "C08" and caster:HasModifier("modifier_C08D_old_duge") then
    	caster:RemoveModifierByName("modifier_C08D_old_duge")
    end
    caster:AddAbility(nobu_id.."_precache"):SetLevel(1)
    for i=1,4 do
    	if caster:HasModifier("modifier_buff_"..i) then
    		caster:AddAbility("buff_"..i):SetLevel(1)
    	end
    end
end

function choose_16( keys )
	local caster = keys.caster
	local ability = keys.ability
	local nobu_id = _G.heromap[caster:GetName()]
	-- 通知所有玩家該英雄已經變成新版
	GameRules:SendCustomMessage("<font color='#33ff88'>16版 ".._G.hero_name_zh[nobu_id].." 參戰</font>",0,0)
	caster:SetAbilityPoints(caster:GetLevel())
	caster.version = "16"

	for i = 0, caster:GetAbilityCount() - 1 do
      local ability = caster:GetAbilityByIndex( i )
      if ability  then
        caster:RemoveAbility(ability:GetName())
      end
    end
    local skill = _G.heromap_skill[nobu_id]["16"]
    for si=1,#skill do
      if si == #skill and #skill < 6 then
        caster:AddAbility("attribute_bonusx"):SetLevel(1)
      end
      caster:AddAbility(nobu_id..skill:sub(si,si))
    end
    if #skill >= 6 then
      caster:AddAbility("attribute_bonusx"):SetLevel(1)
    end
    -- 要自動學習的技能
    local askill = _G.heromap_autoskill[nobu_id]["16"]
    for si=1,#askill do
      caster:FindAbilityByName(nobu_id..askill:sub(si,si)):SetLevel(1)
    end
    -- 直江兼續新版要砍普攻距離
    if nobu_id == "B36" and caster:HasModifier("modifier_B36D_old") then
    	caster:RemoveModifierByName("modifier_B36D_old")
    end
    -- 加藤段藏天生技要拿掉
    if nobu_id == "C08" and caster:HasModifier("modifier_C08D_old_duge") then
    	caster:RemoveModifierByName("modifier_C08D_old_duge")
    end
    caster:AddAbility(nobu_id.."_precache"):SetLevel(1)
    for i=1,4 do
    	if caster:HasModifier("modifier_buff_"..i) then
    		caster:AddAbility("buff_"..i):SetLevel(1)
    	end
    end
end

function choose_11( keys )
	local caster = keys.caster
	local ability = keys.ability
	local nobu_id = _G.heromap[caster:GetName()]
	-- 通知所有玩家該英雄已經變成舊版
	GameRules:SendCustomMessage("<font color='#ff3388'>11版 ".._G.hero_name_zh[nobu_id].." 參戰</font>",0,0)
	caster:SetAbilityPoints(caster:GetLevel())
	caster.version = "11"

	-- 拔掉英雄的技能
	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability  then
			caster:RemoveAbility(ability:GetName())
		end
	end
	for i = 0, caster:GetAbilityCount() - 1 do
      local ability = caster:GetAbilityByIndex( i )
      if ability  then
        caster:RemoveAbility(ability:GetName())
      end
    end
    local skill = _G.heromap_skill[nobu_id]["11"]
    for si=1,#skill do
      if si == #skill and #skill < 6 then
        caster:AddAbility("attribute_bonusx"):SetLevel(1)
      end
      caster:AddAbility(nobu_id..skill:sub(si,si).."_old")
    end
    if #skill >= 6 then
      caster:AddAbility("attribute_bonusx"):SetLevel(1)
    end
    -- 要自動學習的技能
    local askill = _G.heromap_autoskill[nobu_id]["11"]
    for si=1,#askill do
      caster:FindAbilityByName(nobu_id..askill:sub(si,si).."_old"):SetLevel(1)
    end
    caster:AddAbility(nobu_id.."_precache"):SetLevel(1)
    for i=1,4 do
    	if caster:HasModifier("modifier_buff_"..i) then
    		caster:AddAbility("buff_"..i):SetLevel(1)
    	end
    end
    caster:AddAbility("halloween_attack"):SetLevel(1)
end

function play_1v1( keys )
	local caster = keys.caster
	local ability = keys.ability
	if caster.score == nil then caster.score = 0 end
	caster.score = caster.score + 1
end

function kill_warrior_souls_when_start( keys )
	local caster = keys.caster
	if kill_warrior_soul_count == 0 then
		caster:ForceKill(true)
		kill_warrior_soul_count = kill_warrior_soul_count + 1
	end
end

function warrior_souls_critical ( keys ) 
	local caster = keys.caster
	local ability = keys.ability
	local ran =  RandomInt(1, 100)
	local rate = caster:GetAttacksPerSecond()
	caster:RemoveModifierByName("modifier_warrior_souls_criticalmultiplier")
	print(ran)
	print(caster.soul_critical)
	if (caster.soul_critical == nil) then
		caster.soul_critical = 0
	end
	if (ran > 25) then
		caster.soul_critical = caster.soul_critical + 1
	end
	if ( caster.soul_critical > 4 or ran <= 40) then
		caster.soul_critical = 0
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_warrior_souls_cannot_miss",{duration = 1/rate})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_warrior_souls_criticalmultiplier", { } )
		if rate < 1 then
			caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,1)
		else
			caster:StartGestureWithPlaybackRate(ACT_DOTA_ECHO_SLAM,rate)
		end
	end
	
end


function warrior_souls_debuff_OnIntervalThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
		nil,  830 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,it in pairs(group) do
		AMHC:Damage(caster,it, 100,AMHC:DamageType( "DAMAGE_TYPE_PURE" ))
		if it.warrior_souls_deuff_count == nil then
			it.warrior_souls_deuff_count = 1
		end
		local modifier = it:FindModifierByName("modifier_warrior_souls_debuff")
		if(it:IsAlive()) then
			if modifier == nil then 
				ability:ApplyDataDrivenModifier(caster, it, "modifier_warrior_souls_debuff", {duration = 3})
				it:FindModifierByName("modifier_warrior_souls_debuff"):SetStackCount(1)
			else
				local stack = modifier:GetStackCount()
				ability:ApplyDataDrivenModifier(caster, it, "modifier_warrior_souls_debuff", {duration = 3})
				modifier:SetStackCount(stack + 1)
			end
		end
	end
end

function warrior_souls_OnDeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	if kill_warrior_soul_count == 0 then
		return 
	end
	if (attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color='#ffff00'>織田軍擊殺了武士亡靈並得到黃金</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		GameRules: SendCustomMessage("<font color='#ffff00'>織田軍的士兵不再懼怕死亡，全軍士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍擊殺了武士亡靈並得到黃金</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍的士兵不再懼怕死亡，全軍士氣大增</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	end
	for playerID=0,9 do
		local player = PlayerResource:GetPlayer(playerID)
		if player then
			local hero = player:GetAssignedHero()
			if hero == nil then
				return
			end
			if hero:GetTeamNumber() == keys.attacker:GetTeamNumber() then
				AMHC:GivePlayerGold_UnReliable(playerID, 1000)
			end
		end
	end
	local dummy = CreateUnitByName("hide_unit", attacker:GetAbsOrigin() , true, nil, attacker, attacker:GetTeamNumber()) 
	dummy:AddNewModifier(nil,nil,"modifier_kill",{duration=180})
	dummy:AddAbility("warrior_souls_buff_skill"):SetLevel(1)
	dummy:SetAbsOrigin(Vector(8000,8000,128))
end

function warrior_soul_buff_OnIntervalThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
		nil,  99999 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,it in pairs(group) do
		if it ~= caster then 
			ability:ApplyDataDrivenModifier(caster, it, "modifier_warrior_souls_buff", {duration = 7})
		end
	end
end

function robbers_checkfly( keys )
	local caster = keys.caster
	local ability = keys.ability
	if (caster:GetAbsOrigin()-caster.origin_pos):Length2D() > 200 then
		ability:ApplyDataDrivenModifier( caster , caster , "modifier_fly" , { duration = 1.1 } )
	else
		if caster:GetHealth() == caster:GetMaxHealth() then
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_stunned",{ duration = 1.1 })
		end
	end
	
end

function robber_create( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster.deathbuff = robber_buff

	ability:ApplyDataDrivenModifier(caster,caster,"modifier_truesight",{})
	if kill_robber_count == 0 then
		caster:ForceKill(true)
		kill_robber_count = kill_robber_count + 1
	else
		if kill_robber_count == 1 then
			GameRules: SendCustomMessage("強盜王蒐集了各地的錢財", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			if caster.deathbuff == 0 then
				GameRules: SendCustomMessage("強盜王蒐集了各地的錢財，並捲土重來", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			elseif caster.deathbuff == 1 then
				GameRules: SendCustomMessage("強盜王蒐集了各地的武器，並捲土重來", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			elseif caster.deathbuff == 2 then
				GameRules: SendCustomMessage("強盜王蒐集了各地的裝甲，並捲土重來", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			elseif caster.deathbuff == 3 then
				GameRules: SendCustomMessage("強盜王蒐集了各地的療傷藥，並捲土重來", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			end
		end
	end
end

function robber_death( keys )
	local caster = keys.caster
	local ability = keys.ability
	local random_skill = caster.deathbuff
	if kill_robber_count == 0 then
		return 
	end
	if kill_robber_count == 1 then
		random_skill = RandomInt(1,3)
		robber_buff = RandomInt(1,3)
		kill_robber_count = kill_robber_count + 1
	else 
		robber_buff = RandomInt(1,3)
		kill_robber_count = kill_robber_count + 1
	end

	--隨機buff

	-- if (keys.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
	-- 	GameRules: SendCustomMessage("<font color='#ffff00'>織田軍得到了強盜王的黃金</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	-- else
	-- 	GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍得到了強盜王的黃金</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	-- end
	for playerID=0,9 do
		local player = PlayerResource:GetPlayer(playerID)
		if player then
			local hero = player:GetAssignedHero()
			if hero:GetTeamNumber() == keys.attacker:GetTeamNumber() then
				AMHC:GivePlayerGold_UnReliable(playerID, 300)
				hero:AddExperience(200, 0, false, false)
			end
		end
	end
	if random_skill == 1 then
		if (keys.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color='#ffff00'>織田軍得到了強盜王的武器</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍得到了強盜王的武器</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		for playerID=0,9 do
			local player = PlayerResource:GetPlayer(playerID)
			if player then
				local hero = player:GetAssignedHero()
				if hero:GetTeamNumber() == keys.attacker:GetTeamNumber() then
					caster:RemoveModifierByName("modifier_robbers_king_attack_buff")
					ability:ApplyDataDrivenModifier(caster, hero, "modifier_robbers_king_attack_buff",{duration = 180})
				end
			end
		end
	elseif random_skill == 2 then
		if (keys.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color='#ffff00'>織田軍得到了強盜王的裝甲</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍得到了強盜王的裝甲</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		for playerID=0,9 do
			local player = PlayerResource:GetPlayer(playerID)
			if player then
				local hero = player:GetAssignedHero()
				if hero:GetTeamNumber() == keys.attacker:GetTeamNumber() then
					caster:RemoveModifierByName("modifier_robbers_king_armor_buff")
					ability:ApplyDataDrivenModifier(caster, hero, "modifier_robbers_king_armor_buff",{duration = 180})
				end
			end
		end
	elseif random_skill == 3 then
		if (keys.attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color='#ffff00'>織田軍得到了強盜王的療傷藥</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color='#ffff00'>聯合軍得到了強盜王的療傷藥</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		for playerID=0,9 do
			local player = PlayerResource:GetPlayer(playerID)
			if player then
				local hero = player:GetAssignedHero()
				if hero:GetTeamNumber() == keys.attacker:GetTeamNumber() then
					caster:RemoveModifierByName("modifier_robbers_king_regen_buff")
					ability:ApplyDataDrivenModifier(caster, hero, "modifier_robbers_king_regen_buff",{duration = 180})
				end
			end
		end
	end

	Timers:CreateTimer(60, function()
		if robber_buff == 0 then
			GameRules: SendCustomMessage("強盜王正在蒐集各地的錢財", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		elseif robber_buff == 1 then
			GameRules: SendCustomMessage("強盜王正在蒐集各地的武器", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		elseif robber_buff == 2 then
			GameRules: SendCustomMessage("強盜王正在蒐集各地的裝甲", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		elseif robber_buff == 3 then
			GameRules: SendCustomMessage("強盜王正在蒐集各地的療傷藥", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		end
	end)

end

function play_on_die( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:StartGestureWithPlaybackRate(ACT_DOTA_DIE,1)
	
	Timers:CreateTimer(2, function ()
		caster:Destroy()
	end)
end

function gold_to_prestige( keys )
	local caster = keys.caster
	local ability = keys.ability
	local add_prestige = 100
	if caster:IsHero() then
		_G.goldprestige[caster:GetTeamNumber()] = _G.goldprestige[caster:GetTeamNumber()] + add_prestige
	end
	prestige = _G.prestige
	goldprestige = _G.goldprestige
	if prestige == nil then prestige = {} end
	if goldprestige == nil then goldprestige = {} end
	prestige[2] = goldprestige[2] or 0
	prestige[3] = goldprestige[3] or 0
	local sumkill = 0
	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
	if not v:IsIllusion() then
	  local hero     = v
	  if (hero.kill_count ~= nil)  then
	    prestige[hero:GetTeamNumber()] = prestige[hero:GetTeamNumber()] + hero.kill_count
	  end
	  if (hero.kill_hero_count ~= nil)  then
	    prestige[hero:GetTeamNumber()] = prestige[hero:GetTeamNumber()] + hero.kill_hero_count*5
	  end
	end
	end
end

function reward6300(keys)
	local caster = keys.caster
	local ability = keys.ability
	local pos = caster:GetAbsOrigin()
	if caster:IsHero() then
		local dummy = CreateUnitByName("npc_dummy_unit",caster.donkey.oripos ,false,caster,caster,caster:GetTeamNumber())	
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_invulnerable",{duration=60})
		ability:ApplyDataDrivenModifier(caster,dummy,"modifier_kill",{duration=60})
		dummy:AddAbility("reward6300"):SetLevel(1)
		dummy:FindAbilityByName("reward6300"):ApplyDataDrivenModifier(dummy,dummy,"modifier_reward6300_hero_aura",nil)
		dummy:FindAbilityByName("reward6300"):ApplyDataDrivenModifier(dummy,dummy,"modifier_reward6300_aura",nil)
	end
end

function tofar_goback(keys)
	local caster = keys.caster
	Timers:CreateTimer(1, function()
		if caster.pos == nil then
			caster.pos = caster:GetAbsOrigin()
		end
		if IsValidEntity(caster) then
			if (VectorDistance(caster:GetAbsOrigin(), caster.pos) > 1000) then
				local order = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			 		Position = caster.pos, --Optional.  Only used when targeting the ground
			 		Queue = 0 --Optional.  Used for queueing up abilities
			 	}
				ExecuteOrderFromTable(order)
			end
			return 1
		end
	end)
end

Timers:CreateTimer( 3, function()
	if _G.aram then
		_G.Unified_pos3 = Entities:FindByName(nil,"chubinluxian_location_of_wl_middle"):GetAbsOrigin()
		_G.Nobu_pos3 = Entities:FindByName(nil,"chubinluxian_location_of_nobu_middle"):GetAbsOrigin()
	else
		_G.Unified_pos1 = Entities:FindByName(nil,"chubinluxian_location_of_wl_button"):GetAbsOrigin()
		_G.Unified_pos2 = Entities:FindByName(nil,"chubinluxian_location_of_wl_top"):GetAbsOrigin()
		_G.Unified_pos3 = Entities:FindByName(nil,"chubinluxian_location_of_wl_middle"):GetAbsOrigin()
		_G.Nobu_pos1 = Entities:FindByName(nil,"chubinluxian_location_of_nobu_button"):GetAbsOrigin()
		_G.Nobu_pos2 = Entities:FindByName(nil,"chubinluxian_location_of_nobu_top"):GetAbsOrigin()
		_G.Nobu_pos3 = Entities:FindByName(nil,"chubinluxian_location_of_nobu_middle"):GetAbsOrigin()
	end
end)

function reset_pos(keys)
	local caster = keys.caster
	caster.pos = caster:GetAbsOrigin()
end

function patrol_Unified(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	if caster.isgo == nil then
		caster.isgo = 0
	end
	if (VectorDistance(_G.Unified_pos1, caster:GetAbsOrigin()) > 1500) and
		(VectorDistance(_G.Unified_pos2, caster:GetAbsOrigin()) > 1500) and
		(VectorDistance(_G.Unified_pos3, caster:GetAbsOrigin()) > 1500) then
		print("toofar")
		local order = {
	 		UnitIndex = caster:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	 		Position = caster.pos, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(order)
	elseif caster.isgo == 1 or caster.isgo == 3 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Unified_pos3 })
		caster.isgo = caster.isgo + 1
	elseif caster.isgo == 0 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Unified_pos1 })	
		caster.isgo = caster.isgo + 1
	elseif caster.isgo == 2 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Unified_pos2 })
		caster.isgo = caster.isgo + 1
	end
	caster.isgo = caster.isgo%4
end

function patrol_Nobu(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	if caster.isgo == nil then
		caster.isgo = 0
	end
	if (VectorDistance(_G.Nobu_pos1, caster:GetAbsOrigin()) > 1500) and
		(VectorDistance(_G.Nobu_pos2, caster:GetAbsOrigin()) > 1500) and
		(VectorDistance(_G.Nobu_pos3, caster:GetAbsOrigin()) > 1500) then
		print("toofar")
		local order = {
	 		UnitIndex = caster:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	 		Position = caster.pos, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(order)
	elseif caster.isgo == 1 or caster.isgo == 3 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Nobu_pos3 })
		caster.isgo = caster.isgo + 1
	elseif caster.isgo == 0 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Nobu_pos1 })	
		caster.isgo = caster.isgo + 1
	elseif caster.isgo == 2 then
		ExecuteOrderFromTable( { UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE , Position = _G.Nobu_pos2 })
		caster.isgo = caster.isgo + 1
	end
	caster.isgo = caster.isgo % 4
end

function attack_building(keys)
	if IsServer() then
		local caster = keys.caster
		local pos = caster:GetAbsOrigin()

		Timers:CreateTimer(3, function()
			if IsValidEntity(caster) then
				local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
					nil,  700 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				local com_general = nil
				for _,it in pairs(group) do
			    	if it:GetUnitName() == "com_general" then
			    		com_general = it
			    	end
			    end
			    if com_general then
			    	caster:SetForceAttackTarget(group[1])
			    else
					local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
						nil,  700 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING,
						DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					if #group > 0 then
						caster:SetForceAttackTarget(group[1])
					else
						caster:SetForceAttackTarget(nil)
					end
				end
				return 3
			end
			end)
	end
end


function dead_destroy(keys)
	local caster = keys.caster
	caster:Destroy()
end

function dead_give_item(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("keys.item "..keys.item)
	local item = CreateItem(keys.item,nil, nil)
	CreateItemOnPositionSync(pos+RandomVector(100), item)
end

function near_hero_then_can_use_ability(keys)
	local caster = keys.caster
	local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
		nil,  500 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	for abilitySlot=0,15 do
        local ability = caster:GetAbilityByIndex(abilitySlot)
        if ability ~= nil then
          local abilityLevel = ability:GetLevel()
          local abilityName = ability:GetAbilityName()
          if abilityName ~= "near_hero_then_can_use_ability" then
          	if #group > 0 then
          		ability:SetActivated(true)
          	else
          		ability:SetActivated(false)
          	end
          end
        end
    end

    for _,it in pairs(group) do
    	caster.buyer = it
		caster:SetOwner(caster.buyer)
		caster:SetControllableByPlayer(caster.buyer:GetPlayerID(), true)
    	--print("caster.buyer "..it:GetUnitName())
    	break
    end
end

function update_buy_ninja3(keys)
	local caster = keys.caster.owner
	if caster.buy_ninja3 then
		caster.buy_ninja3 = caster.buy_ninja3 - 1
	end
end

function call_ninja3_OnAbilityPhaseStart(keys)
	local caster = keys.caster
	if caster.buyer.buy_ninja3 == nil then caster.buyer.buy_ninja3 = 0 end
	if caster.buyer.buy_ninja3 >= 15 then
		caster:Interrupt()
	else
		caster.buyer.buy_ninja3 = caster.buyer.buy_ninja3 + 1
	end
end

function update_buy_ninja1_old(keys)
	local caster = keys.caster.owner
	if caster.buy_ninja1 then
		caster.buy_ninja1 = caster.buy_ninja1 - 1
	end
end

function update_ninja1(keys)
	local caster = keys.caster
	local owner = keys.caster.owner
	if caster.number == 1 then
		owner.ninja1 = nil
	else
		owner.ninja1_2 = nil
	end
end

function update_ninja2(keys)
	local caster = keys.caster
	local owner = keys.caster.owner
	owner.ninja2 = nil
end

function call_ninja1_OnAbilityPhaseStart(keys)
	local caster = keys.caster
	if caster.buyer.buy_ninja1 == nil then caster.buyer.buy_ninja1 = 0 end
	if caster.buyer.buy_ninja1 >= 1 then
		caster:Interrupt()
	else
		caster.buyer.buy_ninja1 = caster.buyer.buy_ninja1 + 1
	end
end

function call_ninja1(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	local donkey = CreateUnitByName("ninja_unit1", caster:GetAbsOrigin() + Vector(50, 100, 0), true, caster, caster, caster:GetTeamNumber())
    donkey:SetOwner(caster.buyer)
    donkey.owner = caster.buyer
    donkey:SetControllableByPlayer(caster.buyer:GetPlayerOwnerID(), true)
	donkey:AddNewModifier(donkey,ability,"modifier_phased",{duration=0.1})
	donkey:AddNewModifier(donkey,nil,"modifier_kill",{duration=300})
end

function call_ninja2(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	local donkey = CreateUnitByName("ninja_unit2", caster:GetAbsOrigin() + Vector(50, 100, 0), true, caster, caster, caster:GetTeamNumber())
    donkey:SetOwner(caster.buyer)
    donkey.owner = caster.buyer
    donkey:SetControllableByPlayer(caster.buyer:GetPlayerOwnerID(), true)
    donkey:AddNewModifier(donkey,ability,"modifier_phased",{duration=0.1})
    donkey:FindAbilityByName("ninja_hole"):SetLevel(1)
end

function call_ninja3(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	local donkey = CreateUnitByName("ninja_unit3", caster:GetAbsOrigin() + Vector(50, 100, 0), true, caster, caster, caster:GetTeamNumber())
    donkey:SetOwner(caster.buyer)
    donkey.owner = caster.buyer
    donkey:SetControllableByPlayer(caster.buyer:GetPlayerOwnerID(), true)
    donkey:AddNewModifier(donkey,ability,"modifier_phased",{duration=0.1})
end

function ninja_hole_start(keys)
	local caster = keys.caster
    caster:AddNewModifier(donkey,ability,"modifier_ninja2",{})
end

function ninja_hole_end(keys)
	local caster = keys.caster
    caster:RemoveModifierByName("modifier_ninja2")
end

function warrior_souls_OnAttackLanded(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	target:SetMana(0)
end

function disconnect_checker(keys)
	local player_count = 0
	for i=0,9 do
		if _G.IsExist[i] == true then
			player_count = player_count + 1;
		end
	end
	for _,hero in ipairs(HeroList:GetAllHeroes()) do
		local id = hero:GetPlayerID()
		local team = PlayerResource:GetTeam(id)
		local state = PlayerResource:GetConnectionState(id)
		local nobuafk = Vector(7714.519043,-5177.663086,257.197266)
		local unitafk = Vector(-5596.307129,7738.742676,256.000000)
		if _G.aram then
			nobuafk = Vector(3749.84,-3950.23,128)
			unitafk = Vector(-5484.47,5088.38,128)
		end
		if hero.deathtime and hero.deathtime > 0 then
			hero.deathtime = hero.deathtime - 1
		end
		if state == 3 then -- 2 = connected
			local position = hero.donkey:GetAbsOrigin()
			for i = 0, 6 do 
				local item = hero.donkey:GetItemInSlot(i)
				hero.donkey:DropItemAtPositionImmediate(item, hero.spawn_location)
			end
			if hero.disconnect == false and player_count >= 10 and _G.isRecord == false then
				local steam_id = PlayerResource:GetSteamID(hero:GetPlayerOwnerID())
				playersData = {
					steamID = tostring(steam_id)
				}
				local string = json.encode(playersData)
				SendHTTPRequest("game_disconnect/", "POST",
				string, function(res)
				end)
			end
			hero.disconnect_time = hero.disconnect_time + 1
			hero.disconnect = true
			hero.donkey:ForceKill(true)
			hero.donkey = nil
			if team == 2 then
				hero:MoveToPosition(nobuafk)
			else
				hero:MoveToPosition(unitafk)
			end
		end
		if state == 2 then
			if not hero:IsIllusion() then
				Timers:CreateTimer ( 3 , function ()
					if hero:GetTeamNumber() > 3 then
						return ;
					end
					if hero.disconnect == true and player_count >= 10 and _G.isRecord == false then
						local steam_id = PlayerResource:GetSteamID(hero:GetPlayerOwnerID())
						playersData = {
							steamID = tostring(steam_id)
						}
						local string = json.encode(playersData)
						SendHTTPRequest("game_connect/", "POST",
						string, function(res)
						end)
					end
					hero.disconnect = false
					if hero.donkey == nil then
					local donkey = CreateUnitByName("npc_dota_courier2", hero:GetAbsOrigin()+Vector(100, 100, 0), true, hero, hero, hero:GetTeam())
					donkey:SetOwner(hero)
					donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
					donkey:FindAbilityByName("courier_return_to_base"):SetLevel(1)
					donkey:FindAbilityByName("courier_go_to_secretshop"):SetLevel(1)
					donkey:FindAbilityByName("courier_return_stash_items"):SetLevel(1)
					donkey:FindAbilityByName("courier_take_stash_items"):SetLevel(1)
					donkey:FindAbilityByName("courier_transfer_items"):SetLevel(1)
					donkey:FindAbilityByName("courier_burst"):SetLevel(1)
					donkey:FindAbilityByName("courier_take_stash_and_transfer_items"):SetLevel(1)
					donkey:FindAbilityByName("for_magic_immune"):SetLevel(1)
					donkey:FindAbilityByName("phased_dummy"):SetLevel(1)
					donkey:FindAbilityByName("courier_mute"):SetLevel(1)
					hero.donkey = donkey
					end
				end)
			end
		end
	end
end


function donkey_back(keys)
	local caster = keys.caster
	local ability = keys.ability
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
    for _,enemy in pairs(enemies) do
    	print(enemy:GetUnitName())
		if string.match(enemy:GetUnitName(),"npc_dota_courier2") then
			enemy:SetAbsOrigin(caster:GetAbsOrigin()+(enemy:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()*1000)
			enemy:AddNewModifier(nil, nil, 'modifier_phased', {duration = 0.1})
			FindClearSpaceForUnit(enemy,enemy:GetAbsOrigin(),true)
		end
	end
	if caster:GetHealthPercent() == 100 then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_stunned",{duration = 1.1})
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_magic_immune",{duration = 1.1})
		if caster.origin_pos then
			caster:SetAbsOrigin(caster.origin_pos)
		end
	end
end

function big_cp_purge(keys)
	local target = keys.target
	local modifiers = target:FindAllModifiers()
	for i,m in ipairs(modifiers) do
		if m:IsDebuff() then
			print(m:GetName())
			target:RemoveModifierByName(m:GetName())
		end
	end
end

function afk_checker ( keys )
	local player_count = 0
	for i=0,9 do
		if _G.IsExist[i] == true then
			player_count = player_count + 1;
		end
	end
	local ability = keys.ability
	local caster = keys.caster
	if caster.origin_pos == nil then
		caster.afk_count = 0
		caster.origin_pos = caster:GetAbsOrigin()
	else
		if (caster:GetAbsOrigin() - caster.origin_pos):Length() < 300 then
			caster.afk_count = caster.afk_count + 1
		else
			if caster.afk == true and player_count >= 10 and _G.isRecord == false then
				local steam_id = PlayerResource:GetSteamID(caster:GetPlayerOwnerID())
				playersData = {
					steamID = tostring(steam_id)
				}
				local string = json.encode(playersData)
				SendHTTPRequest("game_connect/", "POST",
				string, function(res)
				end)
			end
			caster.afk = false
			caster.afk_count = 0
		end
		caster.origin_pos = caster:GetAbsOrigin()
	end
	if caster.afk_count >= 60 then
		if caster.afk == false and player_count >= 10 and _G.isRecord == false then 
			local steam_id = PlayerResource:GetSteamID(caster:GetPlayerOwnerID())
			playersData = {
				steamID = tostring(steam_id)
			}
			local string = json.encode(playersData)
			SendHTTPRequest("game_disconnect/", "POST",
			string, function(res)
			end)
		end
		caster.afk = true
	end
  end

function SendHTTPRequest(path, method, values, callback)
	-- local req = CreateHTTPRequestScriptVM( method, "http://nobu.gg/clientApi//"..path )
	-- print("path : " .. path)
	-- print("values : " .. values)
    -- req:SetHTTPRequestRawPostBody("application/json", values)
    -- req:Send(
    --     function(result)
    --         callback(result)
    --     end
    -- )
end