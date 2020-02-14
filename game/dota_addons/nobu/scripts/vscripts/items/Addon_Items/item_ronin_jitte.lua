--浪人十手

function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local max_counter = ability:GetSpecialValueFor("max_counter")
	local duration = ability:GetSpecialValueFor("duration")
	ability:ApplyDataDrivenModifier(caster, caster,"modifier_melee_block",{duration=duration})
	local modifier = caster:FindModifierByName("modifier_melee_block")
	modifier:SetStackCount(max_counter)
end

function OntakeDamage( keys )
	local target = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.DamageTaken
	--DeepPrintTable(keys)
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length()
	print(distance)
	local modifier = caster:FindModifierByName("modifier_melee_block")
	if distance < 200 and modifier:GetStackCount() > 0 then
		modifier:SetStackCount(modifier:GetStackCount() - 1)
		caster:SetHealth(caster:GetHealth() + damage)
	end
	if modifier:GetStackCount() == 0 then
		caster:RemoveModifierByName("modifier_melee_block")
	end
end