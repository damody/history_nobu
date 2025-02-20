-- 齋藤義龍


function C14W_OnSpellStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability =keys.ability
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )
	for _,unit in ipairs(units) do
		if not unit:IsBuilding() then
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_C14W",{duration = 6})
		end
	end
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,0.6)
	Timers:CreateTimer(0.2,function()
		local order = {UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:entindex()}
		ExecuteOrderFromTable(order)
		end)
end


LinkLuaModifier( "modifier_C14T_model", "scripts/vscripts/heroes/C_Neutral/C14.lua",LUA_MODIFIER_MOTION_NONE )

modifier_C14T_model = class({})

--[[Author: Noya, Pizzalol
	Date: 27.09.2015.
	Changes the model, reduces the movement speed and disables the target]]
function modifier_C14T_model:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
	}

	return funcs
end

function modifier_C14T_model:GetModifierModelScale()
	return 2
end
function modifier_C14T_model:GetModifierModelChange()
	return "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl"
end


function modifier_C14T_model:IsHidden() 
	return false
end

function modifier_C14T_model:IsDebuff()
	return false
end


function modifier_C14T_model:IsPurgable()
	return false
end



function modifier_C14T_effect_OnIntervalThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local point = target:GetAbsOrigin()
	local damage = ability:GetSpecialValueFor("damage")
	if IsValidEntity(caster) and IsValidEntity(target) then
		damageTable = {
			victim = target,
			attacker = caster,
			ability = ability,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if not target:IsBuilding() then
			ApplyDamage(damageTable)
		end
	end
end

function C14T_OnSpellStart( event )
	-- Variables
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("During")
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),"Hero_Nevermore.ROS_Flames",caster)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	--local ifx = ParticleManager:CreateParticle( "particles/c20r_real/c20r.vpcf", PATTACH_CUSTOMORIGIN, caster)
	--ParticleManager:SetParticleControl( ifx, 0, caster:GetAbsOrigin())
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_C14T_model", {duration=duration})
	caster.as_slow = {}
	local C14E_ability = caster:FindAbilityByName("C14E")
	local C14E_level = C14E_ability:GetLevel()
	local C14E_cooldown = C14E_ability:GetCooldownTime()
	caster:RemoveAbility("C14E")
	caster:AddAbility("C14E2")
	caster:FindAbilityByName("C14E2"):SetLevel(C14E_level)
	caster:FindAbilityByName("C14E2"):StartCooldown(C14E_cooldown)
end

function C14T_OnDestroy( event )
	local caster = event.caster
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	local C14E_ability = caster:FindAbilityByName("C14E2")
	local C14E_level = C14E_ability:GetLevel()
	local C14E_cooldown = C14E_ability:GetCooldownTime()
	caster:RemoveAbility("C14E2")
	caster:AddAbility("C14E")
	caster:FindAbilityByName("C14E"):SetLevel(C14E_level)
	caster:FindAbilityByName("C14E"):StartCooldown(C14E_cooldown)
end

function modifier_C14T_OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target =keys.target
	local point = target:GetAbsOrigin()
	local tickPerSec = 0.1

	local pos = target:GetAbsOrigin()
	local count = 0
	local damageTable = {
		victim = target,
		attacker = caster,
		ability = ability,
		damage = 100,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	}
	Timers:CreateTimer(0, function()
		count = count + tickPerSec
		if IsValidEntity(caster) and IsValidEntity(ability) then
			local group = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, ability:GetSpecialValueFor("fire_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false)
			for _,v in ipairs(group) do
				ability:ApplyDataDrivenModifier(caster, v, "modifier_C14T_burn", {})
			end
			local group2 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, ability:GetSpecialValueFor("fire_radius"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for _,v in ipairs(group2) do
				ability:ApplyDataDrivenModifier(caster, v, "modifier_C14T_slow", {duration = 0.15})
			end
		end
		if count <= ability:GetSpecialValueFor("fire_duration") then
			return tickPerSec
		else
			return nil
		end
    end)
	
	local ifx = ParticleManager:CreateParticle("particles/c14t_ground/c14t_ground.vpcf",PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(ifx,3,point)
	ParticleManager:ReleaseParticleIndex(ifx)
end

function modifier_C14T_effect_OnIntervalThink( keys )
	--for i,v in pairs(keys) do
   --     print(tostring(i).."="..tostring(v))
    --end
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local point = target:GetAbsOrigin()
	if IsValidEntity(caster) and IsValidEntity(target) then
		local damage = 130
		damageTable = {
			victim = target,
			attacker = caster,
			ability = ability,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if not target:IsBuilding() then
			ApplyDamage(damageTable)
		end
	end
end

function C14T_burn( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:IsBuilding() then
		AMHC:Damage( caster,target,ability:GetSpecialValueFor("burn_damage")*0.1*0.5,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	else
		AMHC:Damage( caster,target,ability:GetSpecialValueFor("burn_damage")*0.1,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end

function C14E ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local casterabs = caster:GetAbsOrigin()
	projectile_table = {
		Ability				= ability,
		EffectName			= "particles/c14e/c14e.vpcf",
		vSpawnOrigin		= "attach_origin",
		fDistance			= 800,
		fStartRadius		= 100,
		fEndRadius			= 300,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		iUnitTargetType		= DOTA_UNIT_TARGET_FLAG_NONE,
		fExpireTime			= GameRules:GetGameTime() + 2,
		bDeleteOnHit		= false,
		vVelocity			= 0,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile(projectile_table)
end


function C14E_OnProjectileHitUnit( event )
	local caster = event.caster 
	local target = event.target
	local ability = event.ability
	if target:FindModifierByName("modifier_C14W") then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_C14E_effect", nil)
	end
end


function modifier_C14E_effect_OnIntervalThink( keys )
	--for i,v in pairs(keys) do
   --     print(tostring(i).."="..tostring(v))
    --end
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local point = target:GetAbsOrigin()
	local damage = ability:GetSpecialValueFor("damage")
		damageTable = {
			victim = target,
			attacker = caster,
			ability = ability,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if not target:IsBuilding() then
			ApplyDamage(damageTable)
		end
end

