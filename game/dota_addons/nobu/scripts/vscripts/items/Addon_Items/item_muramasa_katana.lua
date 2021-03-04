function OnHeroKilled(keys)
	local caster = keys.caster
	local ability = keys.ability
	local heal_percentage = ability:GetSpecialValueFor("heal_percentage")/100
	caster:Heal(caster:GetMaxHealth()*heal_percentage,caster)
	caster:SetMana(caster:GetMana() + caster:GetMaxMana()*heal_percentage)
end

function OnEquip( keys )	
	local caster = keys.caster
	local ability = keys.ability
	if caster.muramasa_katana_stack == nil or caster.muramasa_katana_stack == 0 then
		caster.muramasa_katana_stack = 0
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_muramasa_atk", {})
		local matk = caster:FindModifierByName("modifier_muramasa_atk")
		matk:SetStackCount(caster.muramasa_katana_stack)
	end
end

function OnUnequip( keys )	
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_muramasa_atk")
end

function OnKill( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	if target:IsHero() then
		caster.muramasa_katana_stack = caster.muramasa_katana_stack + 15
	else
		caster.muramasa_katana_stack = caster.muramasa_katana_stack + 1
	end
	if caster.muramasa_katana_stack > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_muramasa_atk", {})
		local matk = caster:FindModifierByName("modifier_muramasa_atk")
		if matk then
			matk:SetStackCount(caster.muramasa_katana_stack)
		end
	end
end

function OnDeath( keys )
	local ability = keys.ability
	local caster = keys.caster
	caster.muramasa_katana_stack = caster.muramasa_katana_stack / 3
	if caster:HasModifier("modifier_muramasa_atk") then
		caster:FindModifierByName("modifier_muramasa_atk"):SetStackCount(caster.muramasa_katana_stack)
		if caster.muramasa_katana_stack == 0 then
			caster:RemoveModifierByName("modifier_muramasa_atk")
		end
	end
	caster:RemoveModifierByName("modifier_muramasa_atk_speed")
end

function OnRespawn( keys )
	local ability = keys.ability
	local caster = keys.caster
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_muramasa_atk", {})
	caster:FindModifierByName("modifier_muramasa_atk"):SetStackCount(caster.muramasa_katana_stack)
end

function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_steal_life", {duration = 5})
end

function StealLife(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not caster:FindModifierByName("modifier_muramasa_atk_speed") then caster.muramasa_attackCount = 0 end
	ability:ApplyDataDrivenModifier(caster , caster, "modifier_muramasa_atk_speed", nil)
	caster.muramasa_attackCount = caster.muramasa_attackCount + 1
	if caster.muramasa_attackCount > 10 then  caster.muramasa_attackCount = 10 end
	local modifier = caster:FindModifierByName("modifier_muramasa_atk_speed")
	modifier:SetStackCount(caster.muramasa_attackCount)
	if target.isvoid == nil then
		local ability = keys.ability
		local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		--if (caster.nobuorb1 == "muramasa_katana" or caster.nobuorb1 == "illusion" or caster.nobuorb1 == nil) and not target:IsBuilding() then
		if not target:IsBuilding() then
			local damageReduction = 0
			local targetArmor = target:GetPhysicalArmorValue(true)
			if targetArmor > 0 then
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
			else
				targetArmor = -targetArmor
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
				damageReduction = -damageReduction
			end
			if damageReduction < -1 then
				damageReduction = -1
			end
			if damageReduction > 1 then
				damageReduction = 1
			end
			caster:Heal(dmg*caster.muramasa_attackCount*0.03*(1-damageReduction), ability)
		    ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end


function StealLife2(keys)
	--【Basic】
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target.isvoid == nil then
		-- local level = ability:GetLevel() - 1
		local dmg = keys.dmg
		if not target:IsBuilding() then
			local damageReduction = 0
			local targetArmor = target:GetPhysicalArmorValue(true)
			if targetArmor > 0 then
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
			else
				targetArmor = -targetArmor
				damageReduction = ((0.06 * targetArmor) / (1 + 0.06* targetArmor))
				damageReduction = -damageReduction
			end
			if damageReduction < -1 then
				damageReduction = -1
			end
			if damageReduction > 1 then
				damageReduction = 1
			end
			caster:Heal(dmg*keys.StealPercent*0.01*(1-damageReduction), ability)
		    ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	end
end

function OnIntervalThink( keys )
	local ability = keys.ability
	local caster = keys.caster
	local radius = ability:GetSpecialValueFor("radius")
	local group = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
		FIND_ANY_ORDER,
		false)
	for _,target in pairs(group) do
		if target:GetHealth() / target:GetMaxHealth() <= 0.3 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_blade_of_blood_devourer", {duration=1})
		end
	end
end
