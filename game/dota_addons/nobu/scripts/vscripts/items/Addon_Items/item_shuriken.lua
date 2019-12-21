function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not target:IsBuilding() then
		AMHC:Damage(caster,target,150,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
		ability:ApplyDataDrivenModifier(caster, target,"modifier_stunned",{duration=0.05})
	end
end