LinkLuaModifier("modifier_war_magic", "heroes/modifier_war_magic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_archer", "heroes/modifier_archer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cavalry", "heroes/modifier_cavalry.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gunner", "heroes/modifier_gunner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soldier_oda", "heroes/modifier_soldier_oda.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soldier_unified", "heroes/modifier_soldier_unified.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ninja", "heroes/modifier_ninja.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_gohomelua", "items/Addon_Items/war_magic.lua",LUA_MODIFIER_MOTION_NONE )
modifier_gohomelua = class({})

--------------------------------------------------------------------------------
local inspect = require("inspect")

function modifier_gohomelua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_gohomelua:OnTakeDamage(event)
	if IsServer() then
	    local attacker = event.unit
	    local victim = event.attacker
	    local return_damage = event.original_damage
	    local damage_type = event.damage_type
	    local damage_flags = event.damage_flags
	    local ability = self:GetAbility()
	    if (self.caster ~= nil) and IsValidEntity(self.caster) then
		    if victim:GetTeam() ~= attacker:GetTeam() and attacker == self.caster then
		        self.caster:RemoveModifierByName("modifier_gohomelua")
		        self.caster:RemoveModifierByName("modifier_wantgohome")
		    end
		end
	end
end

function back_wall( keys )
	local caster = keys.caster
	local point = 1
	local ability = keys.ability
	
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動背水一戰</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		local fort = Entities:FindByName(nil,"dota_goodguys_fort")
		point = fort:GetAbsOrigin()+Vector(-300,300,0)
		ability:ApplyDataDrivenModifier(caster,fort,"modifier_invulnerable",{duration=5})
		for i=1,5 do
			local com_general2 = CreateUnitByName("com_general3", point, true, nil, nil, caster:GetTeamNumber())
			com_general2.pos = point
			com_general2:AddNewModifier(com_general2,nil,"modifier_kill",{duration=100})
		end
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動背水一戰</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		local fort = Entities:FindByName(nil,"dota_badguys_fort")
		point = fort:GetAbsOrigin()+Vector(300,-300,0)
		ability:ApplyDataDrivenModifier(caster,fort,"modifier_invulnerable",{duration=5})
		for i=1,5 do
			local com_general2 = CreateUnitByName("com_general3", point, true, nil, nil, caster:GetTeamNumber())
			com_general2.pos = point
			com_general2:AddNewModifier(com_general2,nil,"modifier_kill",{duration=100})
		end
	end
	Timers:CreateTimer( 1, function()
		caster:RemoveAbility("war_magic_back_wall")
	end)
end

function findanything( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local donkey = CreateUnitByName("findeverything_unit", point, true, nil, nil, caster:GetTeamNumber())
	donkey:FindAbilityByName("true_gem"):SetLevel(1)
	donkey:FindAbilityByName("majia_2"):SetLevel(1)
	donkey:FindAbilityByName("for_no_damage"):SetLevel(1)
	local spell_hint_table = {
		duration   = aura_duration,		-- 持續時間
		radius     = 1200,		-- 半徑
		teamonly   = true,
	}
	donkey:AddNewModifier(donkey,nil,"nobu_modifier_spell_hint",spell_hint_table)
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動偵隱戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動偵隱戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
end

function light( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動曳光戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動曳光戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 50, 7.0, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, caster:GetAbsOrigin(), 50, 7.0, false)
	local particle = ParticleManager:CreateParticle("particles/item/war_light.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, Vector(point.x,point.y,200 ))
	
	AddFOWViewer(caster:GetTeamNumber(), point, 1000, 10.0, false)
end

function treecut_check( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local heros = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #heros == 0 then
		caster:Interrupt()
	end
end

function treecut( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動砍樹戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動砍樹戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	GridNav:DestroyTreesAroundPoint(point, 300, false)
end

function slowattack( keys )
	local caster = keys.caster
	local point = keys.target_points[1] 
	local ability = keys.ability
	local dummy = CreateUnitByName("npc_dummy_unit",point,false,nil,nil,caster:GetTeamNumber())
	dummy:AddNewModifier(dummy,nil,"modifier_kill",{duration=10})
	
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動阻撓戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動阻撓戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	local count = 0
	Timers:CreateTimer(0, function()
		count = count + 1
		local particle = ParticleManager:CreateParticle("particles/slow/slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
		ParticleManager:ReleaseParticleIndex(particle)
		local group = FindUnitsInRadius(caster:GetTeamNumber(), point,
			nil,  400 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			ability:ApplyDataDrivenModifier(caster,it,"modifier_slowattack",{duration = 2.9})
		end
		if count < 5 then
			return 1
		else
			return nil
		end
	end)
end

function gohome( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍即將發動召集戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍即將發動召集戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	--local particle = ParticleManager:CreateParticle("particles/events/ti6_teams/teleport_start_ti6_lvl3_ehome.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	--ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	if target.B23T_old then 
		Timers:CreateTimer(1, function()
			target:RemoveModifierByName("modifier_wantgohome")
			target:RemoveModifierByName("modifier_gohomelua")
		end)
		return 
	end
	target:AddNewModifier(target,ability,"modifier_gohomelua",{duration=8})
	target:FindModifierByName("modifier_gohomelua").caster = target
	Timers:CreateTimer(8, function()
		--ParticleManager:DestroyParticle(particle,false)
		if target:HasModifier("modifier_wantgohome") then
			if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
				GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動召集戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
			else
				GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動召集戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
			end
			target:SetTimeUntilRespawn(0)
			target:AddNewModifier(target,ability,"modifier_phased",{duration=0.1})
			Timers:CreateTimer(1, function()
				target:RemoveModifierByName("modifier_wantgohome")
				target:RemoveModifierByName("modifier_gohomelua")
			end)
		end
	end)
end

function nogohome( keys )
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_wantgohome")

end

function speedup( keys )
	local caster = keys.caster
	local ability = keys.ability
	if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
		GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動神速戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
	else
		GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動神速戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
	end
	local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
		nil,  90000 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, it in pairs(group) do
		ability:ApplyDataDrivenModifier(caster,it,"modifier_speedup",{duration = 5})
	end
end


function moreattack( keys )
	local caster = keys.caster
	local ability = keys.ability
	Timers:CreateTimer(0.5, function()
		if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動強攻戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動強攻戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  90000 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			ability:ApplyDataDrivenModifier(caster,it,"modifier_moreattack",{duration = 10})
		end
	end)
end

function regen( keys )
	local caster = keys.caster
	local ability = keys.ability
	Timers:CreateTimer(0.5, function()
		if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動再起戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動再起戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  90000 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _, it in pairs(group) do
			ability:ApplyDataDrivenModifier(caster,it,"modifier_regen",{duration = 20})
		end
	end)
end


function lessattack( keys )
	local caster = keys.caster
	local ability = keys.ability
	Timers:CreateTimer(0.5, function()
		if (caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
			GameRules: SendCustomMessage("<font color=\"#cc3333\">織田軍發動干擾戰法</font>", DOTA_TEAM_GOODGUYS + DOTA_TEAM_BADGUYS, 0)
		else
			GameRules: SendCustomMessage("<font color=\"#cc3333\">聯合軍發動干擾戰法</font>", DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, 0)
		end
		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
			nil,  90000 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

		for _, it in pairs(group) do
			ability:ApplyDataDrivenModifier(caster,it,"modifier_lessattack",{duration = 10})
		end
	end)
end

goldprestige = {}
goldprestige[2] = 0
goldprestige[3] = 0

prestige = {}
prestige[2] = 0
prestige[3] = 0
payprestige = {}
payprestige[2] = 0
payprestige[3] = 0
CP_Monster = 0
_G.prestige = prestige
_G.goldprestige = goldprestige
_G.payprestige = payprestige
_G.CP_Monster = CP_Monster
_G.war_magic_mana = 20


function to_war_magic_unit(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_war_magic_unit")
	--[[
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
	Timers:CreateTimer(1, function() 
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("war_magic_light"):SetLevel(1)
		    donkey:AddAbility("war_magic_speedup"):SetLevel(1)
		    donkey:AddAbility("war_magic_moreattack"):SetLevel(1)
		    donkey:AddAbility("war_magic_regen"):SetLevel(1)
		    donkey:AddAbility("war_magic_slowattack"):SetLevel(1)
		    donkey:AddAbility("war_magic_lessattack"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		local pres = prestige[donkey:GetTeamNumber()]
		local maxmana = math.floor(pres / 50) * 5 + _G.war_magic_mana
		if donkey:GetMana() > maxmana then
			donkey:SetMana(maxmana)
		end
		return 0.2
		end)
		local count = 0
	Timers:CreateTimer(1, function()
    	for playerID = 0, 9 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
		end
		return 5
    	end)
	donkey:AddNewModifier(donkey, ability, "modifier_war_magic", {})
	]]
end


function to_war_magic_unit2(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_war_magic_unit2")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
	Timers:CreateTimer(1, function()
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
			donkey:AddAbility("war_magic_gohome"):SetLevel(1)
		    --donkey:AddAbility("war_magic_findanything"):SetLevel(1)
		    --donkey:AddAbility("war_magic_treecut"):SetLevel(1)
		    --donkey:AddAbility("war_magic_back_wall"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		local pres = prestige[donkey:GetTeamNumber()]
		local maxmana = math.floor(pres / 50) * 5 + _G.war_magic_mana
		if donkey:GetMana() > maxmana then
			donkey:SetMana(maxmana)
		end
		return 0.2
		end)
		local count = 0
	Timers:CreateTimer(1, function()
    	for playerID = 0, 9 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
		end
		return 5
    	end)
	donkey:AddNewModifier(donkey, ability, "modifier_war_magic", {})

end

function set_level_1(keys)
	local caster = keys.caster
	Timers:CreateTimer(1, function()
		if IsValidEntity(caster) then
			for abilitySlot=0,15 do
		        local ability = caster:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          ability:SetLevel(1)
		        end
		    end
		end
    end)
end


function to_soldier_Oda(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_soldier_Oda")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("soldier_Oda_big"):SetLevel(1)
		    donkey:AddAbility("soldier_Oda_top"):SetLevel(1)
		    donkey:AddAbility("soldier_Oda_mid"):SetLevel(1)
		    donkey:AddAbility("soldier_Oda_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[2]-payprestige[2])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/ashigaru/infantry_oda_6.vmdl")
	donkey:SetOriginalModel("models/ashigaru/infantry_oda_6.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_soldier_oda", {})

	--強化cp怪
	Timers:CreateTimer(60, function()
		CP_Monster = CP_Monster + 1
		return 60
		end)
end


function to_soldier_Unified(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_soldier_Unified")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("soldier_Unified_big"):SetLevel(1)
		    donkey:AddAbility("soldier_Unified_top"):SetLevel(1)
		    donkey:AddAbility("soldier_Unified_mid"):SetLevel(1)
		    donkey:AddAbility("soldier_Unified_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[3]-payprestige[3])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/ashigaru/infantry_unified_2.vmdl")
	donkey:SetOriginalModel("models/ashigaru/infantry_unified_2.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_soldier_unified", {})
end


function to_archer_Oda(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_archer_Oda")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("archer_Oda_top"):SetLevel(1)
		    donkey:AddAbility("archer_Oda_mid"):SetLevel(1)
		    donkey:AddAbility("archer_Oda_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[2]-payprestige[2])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/archer/archer_oda_6.vmdl")
	donkey:SetOriginalModel("models/archer/archer_oda_6.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_archer", {})
end


function to_archer_Unified(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_archer_Unified")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("archer_Unified_top"):SetLevel(1)
		    donkey:AddAbility("archer_Unified_mid"):SetLevel(1)
		    donkey:AddAbility("archer_Unified_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[3]-payprestige[3])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/archer/archer_unified_2.vmdl")
	donkey:SetOriginalModel("models/archer/archer_unified_2.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_archer", {})
end


function to_gunner_Oda(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_gunner_Oda")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("gunner_Oda_top"):SetLevel(1)
		    donkey:AddAbility("gunner_Oda_mid"):SetLevel(1)
		    donkey:AddAbility("gunner_Oda_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[2]-payprestige[2])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/arquebusier/gunner_oda_6.vmdl")
	donkey:SetOriginalModel("models/arquebusier/gunner_oda_6.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_gunner", {})
end


function to_gunner_Unified(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_gunner_Unified")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("gunner_Unified_top"):SetLevel(1)
		    donkey:AddAbility("gunner_Unified_mid"):SetLevel(1)
		    donkey:AddAbility("gunner_Unified_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[3]-payprestige[3])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/arquebusier/gunner_unified_2.vmdl")
	donkey:SetOriginalModel("models/arquebusier/gunner_unified_2.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_gunner", {})
end



function to_cavalry_Oda(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_cavalry_Oda")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("cavalry_Oda_top"):SetLevel(1)
		    donkey:AddAbility("cavalry_Oda_mid"):SetLevel(1)
		    donkey:AddAbility("cavalry_Oda_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[2]-payprestige[2])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/cavalry/cavalry_oda_6.vmdl")
	donkey:SetOriginalModel("models/cavalry/cavalry_oda_6.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(donkey, ability, "modifier_cavalry", {})
end


function to_cavalry_Unified(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_cavalry_Unified")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
		if _G.hardcore then 
			caster:ForceKill(true)
			return nil 
		end
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("cavalry_Unified_top"):SetLevel(1)
		    donkey:AddAbility("cavalry_Unified_mid"):SetLevel(1)
		    donkey:AddAbility("cavalry_Unified_bottom"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[3]-payprestige[3])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:SetModel("models/cavalry/cavalry_unified_2.vmdl")
	donkey:SetOriginalModel("models/cavalry/cavalry_unified_2.vmdl")
	donkey:AddNewModifier(donkey, ability, "modifier_rooted", {})
	donkey:AddNewModifier(donkey, ability, "modifier_invulnerable", {})
	donkey:AddNewModifier(caster, ability, "modifier_cavalry", {})
end


function SendHTTPRequest(path, method, values, callback)
	local req = CreateHTTPRequestScriptVM( method, "http://172.104.107.13/"..path )
	for key, value in pairs(values) do
		req:SetHTTPRequestGetOrPostParameter(key, value)
	end
	req:Send(function(result)
		callback(result.Body)
	end)
end

function check_Oda_is_dead(keys)
	local caster = keys.caster
	_G.Oda_home = caster
	print("check_Oda_is_dead")
	Timers:CreateTimer(1, function()
		if IsValidEntity(caster) and not caster:IsAlive() then
			_G.CountUsedAbility_Table["winteam"] = DOTA_TEAM_BADGUYS
			local sum = 0
			for playerID = 0, 9 do
				local id       = playerID
		  		local p        = PlayerResource:GetPlayer(id)
		  		local steamid = PlayerResource:GetSteamAccountID(id)
		  		local res = PlayerResource:GetConnectionState(id)
		  		if res == 2 then
		  			sum = sum + 1
		  		end
		    	if p ~= nil and (p:GetAssignedHero()) ~= nil then
				  local hero = p:GetAssignedHero()
				  if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				  	_G.CountUsedAbility_Table[id+1]["res"] = "L"
				  else
				  	_G.CountUsedAbility_Table[id+1]["res"] = "W"
				  end
				  _G.CountUsedAbility_Table[id+1]["name"] = hero.name
				  _G.CountUsedAbility_Table[id+1]["version"] = hero.version
				  _G.CountUsedAbility_Table[id+1]["damage"] = hero.damage
				  _G.CountUsedAbility_Table[id+1]["takedamage"] = hero.takedamage
				  _G.CountUsedAbility_Table[id+1]["herodamage"] = hero.herodamage
				  _G.CountUsedAbility_Table[id+1]["team"] = hero:GetTeamNumber()
				  _G.CountUsedAbility_Table[id+1]["kda"] = {}
				  _G.CountUsedAbility_Table[id+1]["kda"]["k"] = tostring(hero:GetKills())
				  _G.CountUsedAbility_Table[id+1]["kda"]["d"] = tostring(hero:GetDeaths())
				  _G.CountUsedAbility_Table[id+1]["kda"]["a"] = tostring(hero:GetAssists())
				  _G.CountUsedAbility_Table[id+1]["kda"]["kcount"] = tostring(hero.kill_count)
				  _G.CountUsedAbility_Table[id+1]["kda"]["steamid"] = steamid
				end
			end
			if sum > 7 then
				if _G.game_level > 0 and _G.game_level < 10 then
					_G.CountUsedAbility_Table.rank = 1
				end
				SendHTTPRequest("save_ability_data", "POST",
					{
					  data = tostring(inspect(_G.CountUsedAbility_Table)),
					},
					function(result)
					  print(result)
					end)
			end
			return nil
		end
		--return 1
		end)
end

function check_Unified_is_dead(keys)
	local caster = keys.caster
	_G.Unified_home = caster
	print("check_Unified_is_dead")
	Timers:CreateTimer(1, function()
		if IsValidEntity(caster) and not caster:IsAlive() then
			_G.CountUsedAbility_Table["winteam"] = DOTA_TEAM_GOODGUYS
			local sum = 0
			for playerID = 0, 9 do
				local id       = playerID
		  		local p        = PlayerResource:GetPlayer(id)
		  		local steamid = PlayerResource:GetSteamAccountID(id)
		  		local res = PlayerResource:GetConnectionState(id)
		  		if res == 2 then
		  			sum = sum + 1
		  		end
		    	if p ~= nil and (p:GetAssignedHero()) ~= nil then
				  local hero = p:GetAssignedHero()

				  if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				  	_G.CountUsedAbility_Table[id+1]["res"] = "L"
				  else
				  	_G.CountUsedAbility_Table[id+1]["res"] = "W"
				  end
				  _G.CountUsedAbility_Table[id+1]["name"] = hero.name
				  _G.CountUsedAbility_Table[id+1]["version"] = hero.version
				  _G.CountUsedAbility_Table[id+1]["damage"] = hero.damage
				  _G.CountUsedAbility_Table[id+1]["takedamage"] = hero.takedamage
				  _G.CountUsedAbility_Table[id+1]["herodamage"] = hero.herodamage
				  _G.CountUsedAbility_Table[id+1]["team"] = hero:GetTeamNumber()
				  _G.CountUsedAbility_Table[id+1]["kda"] = {}
				  _G.CountUsedAbility_Table[id+1]["kda"]["k"] = tostring(hero:GetKills())
				  _G.CountUsedAbility_Table[id+1]["kda"]["d"] = tostring(hero:GetDeaths())
				  _G.CountUsedAbility_Table[id+1]["kda"]["a"] = tostring(hero:GetAssists())
				  _G.CountUsedAbility_Table[id+1]["kda"]["kcount"] = tostring(hero.kill_count)
				  _G.CountUsedAbility_Table[id+1]["kda"]["steamid"] = steamid
				end
			end
			if sum > 7 then
				if _G.game_level > 0 and _G.game_level < 10 then
					_G.CountUsedAbility_Table.rank = 1
				end
				SendHTTPRequest("save_ability_data", "POST",
					{
					  data = tostring(inspect(_G.CountUsedAbility_Table)),
					},
					function(result)
					  print(result)
					end)
			end
			return nil
		end
		--return 1
		end)
end

-- 賣忍者
function to_sell_ninja_unit(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	print("to_sell_ninja_unit")
	local donkey = CreateUnitByName("npc_dota_courier", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1, function() 
			for abilitySlot=0,15 do
		        local ability = donkey:GetAbilityByIndex(abilitySlot)
		        if ability ~= nil then 
		          local abilityLevel = ability:GetLevel()
		          local abilityName = ability:GetAbilityName()
		          donkey:RemoveAbility(abilityName)
		        end
		    end
		    donkey:AddAbility("majia_no_vison"):SetLevel(1)
		    donkey:AddAbility("call_ninja1"):SetLevel(1)
		    --donkey:AddAbility("call_ninja2"):SetLevel(1)
		    --donkey:AddAbility("call_ninja3"):SetLevel(1)
		    donkey:AddAbility("near_hero_then_can_use_ability"):SetLevel(1)
		    caster:ForceKill(true)
		end)
	Timers:CreateTimer(1, function()
		donkey:SetMana(prestige[3]-payprestige[3])
		return 0.2
		end)
	Timers:CreateTimer(1, function()
    	for playerID = 0, 10 do
    		local id       = playerID
	  		local p        = PlayerResource:GetPlayer(id-1)
	    	if p ~= nil and (p: GetAssignedHero()) ~= nil then
			  local hero     = p: GetAssignedHero()
			  if hero:GetTeamNumber() == donkey:GetTeamNumber() then
			  	--donkey:SetOwner(hero)
			  	donkey:SetControllableByPlayer(hero:GetPlayerID(), true)
			  	return nil
			  end
			end
    	end
		--return 1
    	end)
	donkey:AddNewModifier(donkey, ability, "modifier_ninja", {})
end



