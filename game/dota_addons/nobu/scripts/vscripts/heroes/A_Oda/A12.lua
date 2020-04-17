-- LinkLuaModifier( "A12W_modifier", "scripts/vscripts/heroes/A_Oda/A12.lua",LUA_MODIFIER_MOTION_NONE )

-- A12W_modifier = class ({})
-- function A12W_modifier:OnCreated(event)
-- 	AMHC:CreateParticle("particles/b15t/b15t.vpcf",PATTACH_ABSORIGIN,false,self:GetCaster(),2.0,nil)
-- 	print("A12W")
-- end
-- function A12W_modifier:IsHidden()
-- 	return false
-- end

-- function A12W_modifier:IsDebuff()
-- 	return true
-- end
local A12R_damage
local A12R_level = 0
local A12E_level
local A12E_duration
local A12W_level

function A12W( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	caster.abilityName = "A12W"
	local group = {}
    local radius = 500
    group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    
	for _,unit in ipairs(group) do
		ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		Physics:Unit(unit)
		local diff = unit:GetAbsOrigin()-point
		diff.z = 0
		local dir = diff:Normalized()
		unit:SetVelocity(Vector(0,0,-9.8))
		unit:AddPhysicsVelocity(dir*800)
	end
	if caster.A12D_B == true then
		ability:ApplyDataDrivenModifier(caster,v,"modifier_A12W",nil)
		ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		for _,v in ipairs(group) do
			v:AddNewModifier( caster, ability, "modifier_stunned" , { duration = ability:GetLevel()*0.5 } )
		end
	else
		ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end

	caster.A12D_B = false --最後一定要加
end

function A12W_HIDE( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	caster.abilityName = "A12W_HIDE"
	local group = {}
	local radius = 500
	local particle2=ParticleManager:CreateParticle("particles/a12w/a12w_hide_test.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particle2,0,point)
    group = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    
	for _,unit in ipairs(group) do
		ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		Physics:Unit(unit)
		local diff = unit:GetAbsOrigin()-point
		diff.z = 0
		local dir = diff:Normalized()
		unit:SetVelocity(Vector(0,0,-9.8))
		unit:AddPhysicsVelocity(dir*400*-1)
	end
	if caster.A12D_B == true then
		ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		for _,v in ipairs(group) do
			v:AddNewModifier( caster, ability, "modifier_stunned" , { duration = (A12W_level - 1)*0.25 + 0.5 } )
		end
	else
		ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end

	caster.A12D_B = false --最後一定要加
end

function A12E_OnUpgrade( keys )
	A12E_ability = keys.ability
end

function A12E( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster.abilityName = "A12E"
	if caster.A12D_B == true then
		print("A12E A12D_B")
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_A12E_2",nil)
		ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	else
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_A12E",nil)
		ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end

	--print("@@" .. tostring(caster.A12D_B) .. "   +   " ..  tostring(caster.A12D_Time))
	caster.A12D_B = false --最後一定要加	
end

function A12E_OnAttackLanded1( keys )
	local caster = keys.attacker
	local ability = keys.ability
	local cure_count = ability:GetLevelSpecialValueFor("CureMana",ability:GetLevel() - 1) 
	local chance = ability:GetLevelSpecialValueFor("Chance",ability:GetLevel() - 1) 
	--print("CHANCE"..tostring(caster.A12E_CHANCE))
	caster.A12E_CHANCE = RandomInt(0,10)
	if caster:IsAlive() then
		if caster.A12E_CHANCE >= 7 then 
			local cure = caster:GetMaxMana() * cure_count / 100
			caster:Heal(cure,caster)
			AMHC:CreateNumberEffect(caster,cure,2,AMHC.MSG_ORIT ,{0,225,0},0)
			ParticleManager:CreateParticle("particles/a12w/a12w.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end

function A12E_OnAttackLanded2( keys )
	local caster = keys.attacker
	local ability = keys.ability
	local cure_count = ability:GetLevelSpecialValueFor("CureMana",ability:GetLevel() - 1) 
	local chance = ability:GetLevelSpecialValueFor("Chance",ability:GetLevel() - 1) 
	--print("CHANCE"..tostring(caster.A12E_CHANCE))
	if caster.A12E_CHANCE == nil then
		caster.A12E_CHANCE = 0
	end
	caster.A12E_CHANCE = RandomInt(0,10)
	if caster:IsAlive()  then
		if caster.A12E_CHANCE >= 7 then 
			local cure = caster:GetMaxMana() * cure_count / 100
			caster:SetMana(caster:GetMana() + cure)
			AMHC:CreateNumberEffect(caster,cure,2,AMHC.MSG_ORIT ,{0,0,225},0)
			
			ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end

function A12E_HIDE( keys )
	local caster = keys.attacker
	local ability = keys.ability
	local point = caster:GetAbsOrigin()
	local range = ability:GetSpecialValueFor("range")
	local duration = A12E_duration
	local count = 0
	local particle = ParticleManager:CreateParticle("particles/a12e/a12e_hide.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin()+Vector(0,0,100))
	Timers:CreateTimer(0, function()
		count = count + 0.1
		if count >= duration or not caster:HasModifier("modifier_A12T") then
			ParticleManager:DestroyParticle(particle,true)
			return nil 
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, range,DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,unit in pairs(units) do
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_A12E_HIDE",{duration = 0.2})
		end
		return 0.1
	end)
	if caster.A12D_B == true then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_A12E_HIDE_2_lv"..A12E_level, {duration = duration})
		end
	end

	--print("@@" .. tostring(caster.A12D_B) .. "   +   " ..  tostring(caster.A12D_Time))
	caster.A12D_B = false --最後一定要加	
end

function A12E_HIDE_OnTakeDamage( keys )
	local unit = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability
	local range = ability:GetSpecialValueFor("range")
	local distance = (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length()
	if not attacker:IsBuilding() and distance > range then
		unit:SetHealth(unit:GetHealth() + keys.damage)
	end
end

function A12R_OnUpgrade( keys )
	local ability = keys.ability
	A12R_damage = ability:GetSpecialValueFor("damage")
	A12R_level = ability:GetLevel()
end

function A12R( keys )
	local caster		= keys.caster
	local ability	= keys.ability
	local point = ability:GetCursorPosition()
	caster.abilityName = "A12R"
	local particle=ParticleManager:CreateParticle("particles/a12r2/a12r2.vpcf",PATTACH_POINT,caster)
	local Special_damage = ability:GetLevelSpecialValueFor("Special_damage",ability:GetLevel() - 1)
	ParticleManager:SetParticleControl(particle,0,point)
	ParticleManager:SetParticleControl(particle,1,Vector(1000,1000,0))

	ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/a12r/a12r.vpcf",PATTACH_POINT,caster),0,point)
	Timers:CreateTimer( 0.4, function()
		ParticleManager:DestroyParticle(particle,true)
	end )

	if caster.A12D_B == true then
		ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	    local group = {}
	    local radius = 500
	    local damage = 0
	    group = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
		for _,v in ipairs(group) do
			damage = v:GetMaxHealth()*Special_damage/100
			AMHC:Damage( caster,v,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end
	caster.A12D_B = false --最後一定要加	
end

function A12R_HIDE( keys )
	local caster		= keys.caster
	local ability	= keys.ability
	local point = ability:GetCursorPosition()
	caster.abilityName = "A12R"
	local particle=ParticleManager:CreateParticle("particles/a12r2/a12r2.vpcf",PATTACH_POINT,caster)
	local Special_damage = ability:GetLevelSpecialValueFor("Special_damage",ability:GetLevel() - 1)
	ParticleManager:SetParticleControl(particle,0,point)
	ParticleManager:SetParticleControl(particle,1,Vector(1000,1000,0))

	ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/a12r/a12r.vpcf",PATTACH_POINT,caster),0,point)
	Timers:CreateTimer( 0.4, function()
		ParticleManager:DestroyParticle(particle,true)
	end )
	local group = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 500, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
	for _,v in ipairs(group) do
		damage = A12R_damage
		AMHC:Damage( caster,v,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
	if caster.A12D_B == true then
		ParticleManager:CreateParticle("particles/a12w2/a12w2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	    local group = {}
	    local radius = 500
	    local damage = 0
	    group = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
		for _,v in ipairs(group) do
			damage = v:GetMaxHealth()*Special_damage/100
			AMHC:Damage( caster,v,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		end
	end
	caster.A12D_B = false --最後一定要加	
end

function A12F_finish( keys )
	local caster = keys.caster
	caster.A12D_B = false
end

function A12F( keys )
	PrintTable(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local stack = 1
	if caster.A12D_B == true then
		AMHC:Damage( caster,target,damage,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL"))
	else
		AMHC:Damage( caster,target,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL"))
	end
	--reduce magic resistance
	if target:IsAlive() then
		if target:HasModifier("modifier_A12F") then
			stack = target:FindModifierByName("modifier_A12F"):GetStackCount() + 1
			target:RemoveModifierByName("modifier_A12F")
		end
		ability:ApplyDataDrivenModifier(caster,target,"modifier_A12F",{duration = 3})
		target:FindModifierByName("modifier_A12F"):SetStackCount(stack)
	end
end
function A12F_Start( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack = 1
	--reduce magic resistance
	local cooldown = 1/caster:GetAttacksPerSecond()
	ability:EndCooldown()
	ability:StartCooldown(cooldown)
end

function A12T_lock( keys )
	local caster = keys.caster
	local A12R_ability = caster:FindAbilityByName("A12R")
	if A12R_ability ~= nil then
		keys.ability:SetActivated(true)
	else
		keys.ability:SetActivated(false)
	end
end

function A12T_unlock( keys )
	keys.ability:SetActivated(true)
end

local isToggle = false

function A12T_OnToggleOn( keys )
	if not isToggle then
		isToggle = true
		local caster = keys.caster
		local ability = keys.ability
		local A12F_ability = caster:FindAbilityByName("A12F")
		local A12W_ability = caster:FindAbilityByName("A12W")
		local A12E_ability = caster:FindAbilityByName("A12E")
		local A12R_ability = caster:FindAbilityByName("A12R")
		if A12R_ability == nil then
			ability:EndCooldown()
			return
		end
		local modifier_A12T = caster:FindModifierByName("modifier_A12T")
		if modifier_A12T then
			A12T_OnToggleOff(keys)
			caster:RemoveModifierByName("modifier_A12T")
		end
		local point = caster:GetAbsOrigin()
		local radius = ability:GetSpecialValueFor("radius")
		--add A12R_HIDE
		A12R_level = A12R_ability:GetLevel()
		local cooldown = caster:FindAbilityByName("A12R"):GetCooldownTime()
		caster:RemoveAbility("A12R")
		if A12R_level > 0 then
			caster:AddAbility("A12R_HIDE"):SetLevel(ability:GetLevel())
			caster:FindAbilityByName("A12R_HIDE"):StartCooldown(cooldown)
		else
			caster:AddAbility("A12R_HIDE"):SetLevel(0)
		end
		--add A12E_HIDE
		A12E_level = A12E_ability:GetLevel()
		A12E_duration = A12E_ability:GetSpecialValueFor("duration")
		caster:RemoveAbility("A12E")
		if A12E_level > 0 then
			caster:AddAbility("A12E_HIDE"):SetLevel(ability:GetLevel())
		else
			caster:AddAbility("A12E_HIDE"):SetLevel(0)
		end
		--add A12W_HIDE
		A12W_level = A12W_ability:GetLevel()
		caster:RemoveAbility("A12W")
		if A12W_level > 0 then
			caster:AddAbility("A12W_HIDE"):SetLevel(ability:GetLevel())
		else
			caster:AddAbility("A12W_HIDE"):SetLevel(0)
		end
		--spell hint
		local spell_hint_table = {
			radius     = radius,		-- 半徑
			show = true,
		}
		caster:AddNewModifier(caster,nil,"nobu_modifier_spell_hint_self",spell_hint_table)
		A12F_ability:SetLevel(ability:GetLevel())
		A12F_ability:SetActivated(true)
		Timers:CreateTimer(0, function()
			AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 100, 0.3, false)
			AddFOWViewer(DOTA_TEAM_BADGUYS, caster:GetAbsOrigin(), 100, 0.3, false)
			if not isToggle then return nil end
			return 0.25
		end)
	end
end

function A12T_OnToggleOff( keys )
	if isToggle then
		isToggle = false
		local caster = keys.caster
		local A12F_ability = keys.caster:FindAbilityByName("A12F")
		A12F_ability:SetActivated(false)
		caster:RemoveModifierByName("nobu_modifier_spell_hint_self")
		--remove A12R
		local cooldown = caster:FindAbilityByName("A12R_HIDE"):GetCooldownTime()
		caster:RemoveAbility("A12R_HIDE")
		caster:AddAbility("A12R"):SetLevel(A12R_level)
		caster:FindAbilityByName("A12R"):StartCooldown(cooldown)
		--remove A12E
		caster:RemoveAbility("A12E_HIDE")
		caster:AddAbility("A12E"):SetLevel(A12E_level)
		--remove A12W
		caster:RemoveAbility("A12W_HIDE")
		caster:AddAbility("A12W"):SetLevel(A12W_level)
	end
end

function A12T_OnOwnerSpawned( keys )
	 if isToggle then
		local caster = keys.caster
		A12T_OnToggleOff(keys)
		caster:RemoveModifierByName("modifier_A12T")
 	end
end

function A12T_old( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local special_dmg = ability:GetLevelSpecialValueFor("Special_Damage",ability:GetLevel() - 1)
	local SpendMana = ability:GetLevelSpecialValueFor("SpendMana",ability:GetLevel() - 1)
	local damage = 0 
	--if _G.EXCLUDE_TARGET_NAME[target:GetUnitName()] == nil then
		if not target:IsBuilding() then
			damage = caster:GetMana()*special_dmg/100
			if target:IsMagicImmune() then
				AMHC:Damage( caster,target,damage,AMHC:DamageType( "DAMAGE_TYPE_PHYSICAL" ) )
			else
				AMHC:Damage( caster,target,damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			end
			AMHC:CreateNumberEffect(target,damage,2,AMHC.MSG_ORIT ,{0,0,225},4)
		end
	--end
	caster.A12T = false
end



function A12T_old_Start( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local special_dmg = ability:GetLevelSpecialValueFor("Special_Damage",ability:GetLevel() - 1)
	local damage = 0
	local SpendMana = ability:GetLevelSpecialValueFor("SpendMana",ability:GetLevel() - 1)
	
end


function A12D_OnAbilityExecuted( keys )
	if keys.event_ability:IsToggle() then return end
	if keys.event_ability:GetName() == "item_logging" then return end
	if keys.event_ability:GetName() == "item_tpscroll" then return end
	local caster = keys.caster
	local handle = caster:FindModifierByName("modifier_A12D")
	if caster.A12D_Time == nil then
		caster.A12D_Time = 0
	end
	if handle then
		if handle:GetStackCount() <= 4 then
			handle:SetStackCount(handle:GetStackCount() + 1)
		end
		if handle:GetStackCount() > 4 then
			local is_ability = false
			for i = 0 , caster:GetAbilityCount() - 1 do
				if caster:GetAbilityByIndex(i) then
					if keys.event_ability:GetName() == caster:GetAbilityByIndex(i):GetName() then
						if caster:GetAbilityByIndex(i):GetName() ~= "A12T" then
							is_ability = true
							break
						end
					end
				end
			end
			if is_ability then
				caster:FindAbilityByName("A12D")
				caster.A12D_B = true
				caster.A12D_Time = 0
				handle:SetStackCount(0)
			else
				handle:SetStackCount(4)
			end
		end
		caster.A12D_Time = handle:GetStackCount()
	end
end

function A12D( keys )
	local caster = keys.caster
	caster.abilityName = "A12D"
end
