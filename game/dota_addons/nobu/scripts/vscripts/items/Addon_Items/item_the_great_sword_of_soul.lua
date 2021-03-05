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
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper2",nil)
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper",nil)
		ability:ApplyDataDrivenModifier(caster,target,"nobu_modifier_rooted",{duration = 2.5})
		ability:ApplyDataDrivenModifier(caster,target,"modifier_the_great_sword_of_soul_hyper2",nil)
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

function Aura_Create ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target.states_resistance then
		target.states_resistance = target.states_resistance - 10
	end
end

function Aura_Destroy ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target.states_resistance then
		target.states_resistance = target.states_resistance + 10
	end
end

function onHit_Create ( keys )
	local caster = keys.caster
	local target = keys.target
	if target.states_resistance then
		target.states_resistance = target.states_resistance - 20
	end
end

function onHit_Destroy ( keys )
	local caster = keys.caster
	local target = keys.target
	if target.states_resistance then
		target.states_resistance = target.states_resistance + 20
	end
end	

function Shock_Create ( keys )
	local caster = keys.caster
	local target = keys.target
	if target.states_resistance then
		Timers:CreateTimer(0.1,function()
			target.states_resistance = target.states_resistance - 500
		end)
	end
end

function Shock_Destroy ( keys )
	local caster = keys.caster
	local target = keys.target
	if target.states_resistance then
		target.states_resistance = target.states_resistance + 500
	end
end	