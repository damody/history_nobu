--逝者之笏

function Shock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spell_amplify",{duration = duration})
	caster.spell_leech = caster.spell_leech + 30
	Timers:CreateTimer(duration,function()
		caster.spell_leech = caster.spell_leech - 30
	end)
end

function Shock_old( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local stack = caster.kill_hero_count - ability.start_count 
	damage = damage + (stack*100)
	if damage > 800 then
		damage = 800
	end
	AMHC:Damage( caster,target, damage ,AMHC:DamageType( "DAMAGE_TYPE_PURE" ))
	ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed_halo.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:CreateParticle("particles/generic_gameplay/dust_impact_medium.vpcf",PATTACH_ABSORIGIN_FOLLOW, target)
end

function OnEquip( keys )
	local ability = keys.ability
	local caster = keys.caster
	if caster.spell_leech == nil then
		caster.spell_leech = 0
	end
	caster.spell_leech = caster.spell_leech + 10
	if caster.item_death_of_scepter_count == nil then caster.item_death_of_scepter_count = 8 end
	if caster.item_death_of_scepter_count ~= 0 then
		caster:FindModifierByName("modifier_spell_amplify_stack"):SetStackCount(caster.item_death_of_scepter_count)
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	caster.spell_leech = caster.spell_leech - 10

end

function OnOwnerSpawned( keys )
	local ability = keys.ability
	local caster = keys.caster
	print(caster.item_death_of_scepter_count)
	if caster.item_death_of_scepter_count > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spell_amplify_stack", {})
		caster:FindModifierByName("modifier_spell_amplify_stack"):SetStackCount(caster.item_death_of_scepter_count)
	else
		caster:RemoveModifierByName("modifier_spell_amplify_stack")
	end
end

function OnDeath( keys )
	local ability = keys.ability
	local caster = keys.caster
	caster.item_death_of_scepter_count = caster.item_death_of_scepter_count - 3
	if caster.item_death_of_scepter_count < 0 then
		caster.item_death_of_scepter_count = 0
	end
	if caster.item_death_of_scepter_count == 0 then
		caster:RemoveAbility("modifier_spell_amplify_stack")
	end
end

function OnHeroKilled( keys )
	print("kill")
	local ability = keys.ability
	local caster = keys.caster
	caster.item_death_of_scepter_count = caster.item_death_of_scepter_count + 1
	if caster.item_death_of_scepter_count > 21 then
		caster.item_death_of_scepter_count = 21
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spell_amplify_stack", {})
	caster:FindModifierByName("modifier_spell_amplify_stack"):SetStackCount(caster.item_death_of_scepter_count)
end