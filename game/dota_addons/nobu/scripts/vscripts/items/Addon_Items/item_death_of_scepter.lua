--逝者之笏

function Shock( keys )
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
	if caster.kill_hero_count == nil then caster.kill_hero_count = 0 end
	ability.start_count = caster.kill_hero_count
	ability.modifier_attribute_bouns = caster:FindModifierByName("modifier_attribute_bouns")
	ability.modifier_attribute_bouns:SetStackCount(1)
end

function OnHeroKilled( keys )
	local ability = keys.ability
	local caster = keys.caster
	local count = caster.kill_hero_count - ability.start_count + 2
	if count > 21 then
		count = 21
	end
	ability.modifier_attribute_bouns:SetStackCount(count)
end