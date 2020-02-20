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
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper",nil)
	end
end