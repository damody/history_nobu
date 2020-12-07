LinkLuaModifier( "modifier_A08T2", "scripts/vscripts/heroes/A_Oda/A08.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_A08T", "scripts/vscripts/heroes/A_Oda/A08.lua",LUA_MODIFIER_MOTION_NONE )

local incoming_damage_percentage = 0

function A08E_OnSpellStart( event )
	-- Variables
	local ability = event.ability
	local damage = ability:GetSpecialValueFor("damage")
	local duration = ability:GetSpecialValueFor("stun")
	local caster = event.caster
	caster:Heal(caster:GetMaxHealth()*0.2,caster)	
	caster:EmitSound( "Hero_Nevermore.ROS_Flames")
	local ifx = ParticleManager:CreateParticle( "particles/c20r_real/c20r.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl( ifx, 0, caster:GetAbsOrigin())
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )
	for _,xx in pairs(units) do
		if xx:HasAbility("majia") then
			units[_] = nil
		end
	end
	for _,unit in ipairs(units) do
		damageTable = {
		victim = unit,
		attacker = caster,
		ability = ability,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		if not unit:IsBuilding() then
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_stunned", {duration=duration})
			ApplyDamage(damageTable)
		end
	end
end

function A08R_OnAttackLanded( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local dmg1 = ability:GetSpecialValueFor("dmg1")
	local dmg2 = ability:GetSpecialValueFor("dmg2")

	local buff = math.floor((100-caster:GetHealthPercent())*0.1)
	local dmg = dmg1+dmg2*buff
	if not target:IsBuilding() then
		AMHC:Damage( caster,target,dmg,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
	end
end


modifier_A08T2 = class({})

function modifier_A08T2:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_A08T2:GetModifierIncomingDamage_Percentage( keys )
	local a = keys.attacker:GetAbsOrigin() - self.caster:GetAbsOrigin() 
	a = a:Normalized()
	b = self.caster:GetForwardVector()
	local angle = math.acos(dot(a,b) / (a:Length() * b:Length()))
	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,xx in pairs(enemies) do
		if xx:HasAbility("majia") then
			enemies[_] = nil
		end
	end
	local enemies_reduce = #enemies * 3 * -1 * 2
	if math.deg(angle) > 90 then
		return enemies_reduce
	end
	return self.incoming_damage_percentage + enemies_reduce
end

function dot(a,b)
	return (a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end

modifier_A08T = class({})

function modifier_A08T:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_A08T:GetModifierIncomingDamage_Percentage( keys )
	local a = keys.attacker:GetAbsOrigin() - self.caster:GetAbsOrigin() 
	a = a:Normalized()
	b = self.caster:GetForwardVector()
	local angle = math.acos(dot(a,b) / (a:Length() * b:Length()))
	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,xx in pairs(enemies) do
		if xx:HasAbility("majia") then
			enemies[_] = nil
		end
	end
	local enemies_reduce = #enemies * 3 * -1
	if math.deg(angle) > 90 then
		return enemies_reduce
	end
	return self.incoming_damage_percentage + enemies_reduce
end

function A08T_OnUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	incoming_damage_percentage = ability:GetSpecialValueFor("incoming_damage_percentage")
	caster:AddNewModifier(caster, ability, "modifier_A08T", nil)
	caster:FindModifierByName("modifier_A08T").caster = caster
	caster:FindModifierByName("modifier_A08T").incoming_damage_percentage = incoming_damage_percentage
end

function A08T_OnOwnerSpawned( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:AddNewModifier(caster, ability, "modifier_A08T", nil)
	caster:FindModifierByName("modifier_A08T").caster = caster
	caster:FindModifierByName("modifier_A08T").incoming_damage_percentage = incoming_damage_percentage
end

function A08T( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local duration = ability:GetSpecialValueFor("duration")
	local hp_bonus = ability:GetSpecialValueFor("hp_bonus")
	incoming_damage_percentage = ability:GetSpecialValueFor("incoming_damage_percentage") 
	if caster:HasModifier("modifier_A08T2") then
		caster:RemoveModifierByName("modifier_A08T2")
	end
	caster:AddNewModifier(caster, ability, "modifier_A08T2", {duration = duration})
	caster:FindModifierByName("modifier_A08T2").caster = caster
	caster:FindModifierByName("modifier_A08T2").incoming_damage_percentage = incoming_damage_percentage
	caster:Heal(hp_bonus,caster)
end

function A08T_OnTakeDamage_old( keys )
	--[[
	O在這邊放計時器是因為節省particle的使用
	O魔免的時候，不能在KV裡面傷害單位
		要在lua裡面
	]]
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local dmg = keys.dmg
	if not attacker:IsHero() then
		caster:Heal(dmg,caster)
	end
end
