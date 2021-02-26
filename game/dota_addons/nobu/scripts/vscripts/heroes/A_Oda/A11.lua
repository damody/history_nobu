-- 齋藤道三 by Nian Chen
-- 2017.3.28
LinkLuaModifier("modifier_A11E", "scripts/vscripts/heroes/A_Oda/A11.lua",LUA_MODIFIER_MOTION_NONE)

function A11W( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("A11W_duration")
	local radius = ability:GetSpecialValueFor("A11W_radius")
	local A11W_damage = ability:GetSpecialValueFor("A11W_damage")
	local A11W_adjustOnBuilding = ability:GetSpecialValueFor("A11W_adjustOnBuilding")

	local dummy = CreateUnitByName( "npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
	dummy:AddNewModifier( dummy, nil, "modifier_kill", {duration=duration} )
	dummy:SetOwner( caster)
	dummy:AddAbility( "majia"):SetLevel(1)

	local time = 0.1 + duration
	local count = 0

	Timers:CreateTimer(0,function()
		count = count + 1
		if count > time then
			return nil
		end

		local ifx = ParticleManager:CreateParticle( "particles/a11w/a11wonkey_king_spring_water_base.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( ifx, 0, point + Vector(0,0,50))
		ParticleManager:SetParticleControl( ifx, 3, point + Vector(0,0,50))
		Timers:CreateTimer(duration, function ()
			ParticleManager:DestroyParticle(ifx,true)
		end)

		StartSoundEvent("Hero_Slark.Pounce.Impact",dummy)

		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )

		for _,unit in ipairs(units) do
			damageTable = {
				victim = unit,
				attacker = caster,
				ability = ability,
				damage = A11W_damage,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
			}
			if not caster:IsAlive() then
				damageTable.attacker = dummy
			end
			if unit:IsBuilding() then
				damageTable.damage = damageTable.damage * A11W_adjustOnBuilding
			end
			ApplyDamage(damageTable)
		end
		return 1
	end)
end

function A11E( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("A11E_duration")
	local distance_percentage = ability:GetSpecialValueFor("distance_percentage")
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local pos = (caster_pos + target_pos) * distance_percentage / 100
	local distance = (pos - target_pos):Length()
	target.A11E_move_speed = distance / duration
	ExecuteOrderFromTable({
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = pos,
		Queue = false
	})
	target:AddNewModifier(target, ability, "modifier_A11E", {duration = duration})
	local particle = ParticleManager:CreateParticle("particles/a11e/a11e_rope.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	caster.A11E_target = target

	local particle3 = ParticleManager:CreateParticle("particles/a11e/a11e_rope_flames.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle3, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle3, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_A11E_increase_int", {}):SetStackCount(1)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_A11E_descrease_int", {}):SetStackCount(1)
	local A11E_count = 0
	Timers:CreateTimer(0.2, function ()
      	if target ~= nil and IsValidEntity(target) and target:HasModifier("modifier_A11E") then
      		local particle2 = ParticleManager:CreateParticle("particles/a11e/a11e_rope_flames.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle2, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			A11E_count = A11E_count + 0.2
			print(A11E_count)
			if A11E_count > 1 then
				if target:HasModifier("modifier_A11E_descrease_int") then
					local stack_count = target:FindModifierByName("modifier_A11E_descrease_int"):GetStackCount()
					target:FindModifierByName("modifier_A11E_descrease_int"):SetStackCount(stack_count + 1)
				else
					ability:ApplyDataDrivenModifier(caster, target, "modifier_A11E_descrease_int", {}):SetStackCount(1)
				end
				if caster:HasModifier("modifier_A11E_increase_int") then
					local stack_count = caster:FindModifierByName("modifier_A11E_increase_int"):GetStackCount()
					caster:FindModifierByName("modifier_A11E_increase_int"):SetStackCount(stack_count + 1)
				else
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_A11E_increase_int", {}):SetStackCount(1)
				end
				A11E_count = 0
			end
      		return 0.2
      	else
      		if IsValidEntity(target) then
				target:RemoveModifierByName("modifier_A11E")  
      		end
      		caster.A11E_target = nil
      		ParticleManager:DestroyParticle(particle,false)
      		return nil
      	end
    end)
end

function A11E_Stop( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	target:RemoveModifierByName("modifier_A11E")
end

modifier_A11E = class({})
-------------------------------------------------------------------
function modifier_A11E:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

function modifier_A11E:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end

function modifier_A11E:IsDebuff()
	return true
end

function modifier_A11E:GetModifierMoveSpeed_Absolute( params )
	return self:GetCaster().A11E_move_speed
end

function A11E_old( keys )
	local caster = keys.caster
	local target = keys.target
	local particle = ParticleManager:CreateParticle("particles/a11e/a11e_rope.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	caster.A11E_target = target

	local particle3 = ParticleManager:CreateParticle("particles/a11e/a11e_rope_flames.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle3, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle3, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.2, function ()
      	if target ~= nil and IsValidEntity(target) and target:HasModifier("modifier_A11E") and caster:HasModifier("modifier_A11E2") then
      		local particle2 = ParticleManager:CreateParticle("particles/a11e/a11e_rope_flames.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle2, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
      		return 0.2
      	else
      		if IsValidEntity(target) then
      			target:RemoveModifierByName("modifier_A11E")
      		end
      		caster.A11E_target = nil
      		ParticleManager:DestroyParticle(particle,false)
      		return nil
      	end
    end)
end

function A11R( keys )
	local caster = keys.caster
	local ability = keys.ability
	local event_ability = keys.event_ability
	local unit = keys.unit
	local A11R_damage = caster:GetIntellect() * 1.5
	if not unit:HasModifier("modifier_A11R_locker") then
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_A11R_locker", nil)
		damageTable = {
			victim = unit,
			attacker = caster,
			ability = ability,
			damage = A11R_damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		Timers:CreateTimer(event_ability:GetCastPoint()+0.05, function ()
			if not unit:IsMagicImmune() then
				ApplyDamage(damageTable)
			end
		end)
	end
end

function A11T_OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("A11T_radius")
	local duration = ability:GetSpecialValueFor("A11T_duration")
	local heal = ability:GetSpecialValueFor("A11T_hpBonus")
	caster:Heal( heal , caster)
	local spell_hint_table = {
		duration   = duration,		-- 持續時間
		radius     = radius,		-- 半徑
		show 	   = true,
		caster     = caster
	}
	caster:AddNewModifier(caster,nil,"nobu_modifier_spell_hint_self",spell_hint_table)
end

function A11T( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("A11T_radius")
	local A11T_damage = caster:GetIntellect()
	local maxTarget = ability:GetSpecialValueFor("A11T_maxTarget")
	local heal_constant = ability:GetSpecialValueFor("A11T_heal_constant")
	caster:Heal( A11T_damage * heal_constant, caster)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )

	for i,unit in ipairs(units) do
		damageTable = {
			victim = unit,
			attacker = caster,
			ability = ability,
			damage = A11T_damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DAMAGE_TYPE_MAGICAL,
		}
		local particle = ParticleManager:CreateParticle("particles/a11t2/a11t5b.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		if not unit:IsMagicImmune() then
			ApplyDamage(damageTable)
		end
		if i==maxTarget then
			break
		end
	end
end

function A11T_Debuff( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length()
	ability:ApplyDataDrivenModifier(caster,target,"modifier_A11T_slow3",{duration = 0.15})

end

function A11T_old( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("A11T_duration")

	local dummy = CreateUnitByName( "npc_dummy_unit", caster:GetOrigin(), false, nil, nil, caster:GetTeamNumber())
	dummy:AddNewModifier( dummy, nil, "modifier_kill", {duration=duration} )
	dummy:SetOwner(caster)
	dummy:AddAbility( "majia"):SetLevel(1)

	ability:ApplyDataDrivenModifier( caster, dummy, "modifier_A11T_aura", nil)
	ability:ApplyDataDrivenModifier( caster, dummy, "modifier_A11T_aura2", nil)
end