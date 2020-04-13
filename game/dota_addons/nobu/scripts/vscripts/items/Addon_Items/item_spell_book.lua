
function Shock( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	if (target:GetTeamNumber() == caster:GetTeamNumber()) then
		keys.ability:ApplyDataDrivenModifier(caster, target,"modifier_spell_book_friendly", nil)
	else
		keys.ability:ApplyDataDrivenModifier(caster, target,"modifier_spell_book_enemy", nil)
	end
	local particle = ParticleManager:CreateParticle("particles/a03t_old_j.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin()+Vector(0,0,100))
end
