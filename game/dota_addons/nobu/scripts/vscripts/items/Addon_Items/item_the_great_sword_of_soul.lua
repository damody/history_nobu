function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul",nil)
end

function Shock2( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper",nil)
		ability:ApplyDataDrivenModifier(caster,target,"nobu_modifier_rooted",{duration = 2.5})
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper",nil)
		ability:ApplyDataDrivenModifier(caster,target,"nobu_modifier_rooted",{duration = 2.5})
	end
end

function Shock3( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:IsMagicImmune() then
		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
		ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration = 1.5})
		caster:PerformAttack(target, true, true, true, true, true, false, true)
	else
		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:AddNewModifier(caster,ability,"modifier_phased",{duration=0.1})
		ability:ApplyDataDrivenModifier(caster,target,"modifier_stunned",{duration = 1.5})
		caster:PerformAttack(target, true, true, true, true, true, false, true)
	end
end
