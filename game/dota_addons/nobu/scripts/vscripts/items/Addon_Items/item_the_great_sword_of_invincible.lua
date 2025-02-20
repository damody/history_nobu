
--禦神

function OnEquip( keys )	
	local caster = keys.caster
	local ability = keys.ability
	caster.Is_invincible_equip = true
	local attribute = caster:GetPrimaryAttribute()
	if attribute == 0 then
		caster:RemoveModifierByName("modifier_sword_of_invincible_str")
	elseif attribute == 1 then
		caster:RemoveModifierByName("modifier_sword_of_invincible_agi")
	else
		caster:RemoveModifierByName("modifier_sword_of_invincible_int")
	end
	caster:RemoveModifierByName("modifier_sword_of_invincible_passive")
	ability.timer = Timers:CreateTimer(0, function() 
		if not caster.Is_invincible_equip then
			return nil
		end
		if ability:IsCooldownReady() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_sword_of_invincible_passive", nil)
		end
		return 0.5
		end)
end

function OnUnequip( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster.Is_invincible_equip = false
	caster:RemoveModifierByName("modifier_sword_of_invincible_passive")
	Timers:RemoveTimer(ability.timer)
end

function Shock( keys )
	local target = keys.caster
	local ability = keys.ability
	local shield_size = 30 -- could be adjusted to model scale
	local cooldown = ability:GetCooldown(-1)
	if not target.invincible_counter then target.invincible_counter = 0 end
	if not keys.attacker:IsHero() then return end
	if target:GetHealth() > target:GetMaxHealth()*0.6 then
		return 
	end
	-- -- Strong Dispel 刪除負面效果
	-- local RemovePositiveBuffs = false
	-- local RemoveDebuffs = true
	-- local BuffsCreatedThisFrameOnly = false
	-- local RemoveStuns = true
	-- local RemoveExceptions = false
	-- target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

	-- Particle. Need to wait one frame for the older particle to be destroyed
	target.ms_slow = {}
	target.as_slow = {}
	target.ShieldParticle = ParticleManager:CreateParticle("particles/a07w5/a07w5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))

	-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
	ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)--attach_attack1
	
	ability:ApplyDataDrivenModifier(target, target, "modifier_sword_of_invincible", nil)
	target:RemoveModifierByName("modifier_sword_of_invincible_passive")
	ability:StartCooldown(cooldown)
	
end

function OnDestroy( keys )
	local caster = keys.caster
	local ability = keys.ability
	ParticleManager:DestroyParticle(caster.ShieldParticle, false)
end

function NoDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local dmg = keys.DamageTaken
	caster:SetHealth(caster:GetHealth() + dmg)
end
