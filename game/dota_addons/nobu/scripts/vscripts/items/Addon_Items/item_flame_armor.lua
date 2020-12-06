
function Burn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	local point = caster:GetAbsOrigin()
	local group = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, aura_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i,v in ipairs(group) do
		if v:CanEntityBeSeenByMyTeam(caster) and not caster:IsIllusion() and not caster:HasModifier("modifier_invisible") then
			AMHC:Damage(caster,v, keys.Damage,AMHC:DamageType( "DAMAGE_TYPE_MAGICAL" ) )
			ability:ApplyDataDrivenModifier(caster, v, "modifier_flame_armor_debuff", {duration = 0.95})
			local flame = ParticleManager:CreateParticle("particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_flames_b.vpcf", PATTACH_ABSORIGIN, v)
			Timers:CreateTimer(0.9, function ()
				ParticleManager:DestroyParticle(flame, false)
			end)
		end
	end
end

function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_flame_armor_aura")
	if modifier == nil then 
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_flame_armor_aura",nil)
	end
end

function OnUnequip( keys )
	print("OnUnequip")
end


