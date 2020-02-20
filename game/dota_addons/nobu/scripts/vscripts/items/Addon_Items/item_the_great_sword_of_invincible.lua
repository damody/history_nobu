
--禦神

function OnEquip( keys )	
	local caster = keys.caster
	local ability = keys.ability
	caster.Is_invincible_equip = true
	caster:RemoveModifierByName("modifier_sword_of_invincible_passive")
	Timers:CreateTimer(ability:GetCooldownTimeRemaining(), function() 
		if not caster.Is_invincible_equip then
			return nil
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sword_of_invincible_passive", nil)
		end)
end

function OnUnequip( keys )
	local caster = keys.caster
	caster.Is_invincible_equip = false
	print(caster.Is_invincible_equip)
	caster:RemoveModifierByName("modifier_sword_of_invincible_passive")
end

function Shock( keys )
	local target = keys.caster
	local ability = keys.ability
	local shield_size = 30 -- could be adjusted to model scale
	if not target.invincible_counter then target.invincible_counter = 0 end
	if target:GetHealth() > target:GetMaxHealth()*0.3 then
		return 
	end
	-- -- Strong Dispel 刪除負面效果
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

	-- Particle. Need to wait one frame for the older particle to be destroyed
	
	target.ShieldParticle = ParticleManager:CreateParticle("particles/a07w5/a07w5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
	ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))

	-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
	ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)--attach_attack1
	
	ability:ApplyDataDrivenModifier(target, target, "modifier_sword_of_invincible", nil)
	target:RemoveModifierByName("modifier_sword_of_invincible_passive")
	target.invincible_counter = 70
	ability:StartCooldown(target.invincible_counter)
	Timers:CreateTimer(0, function() 
		target.invincible_counter = target.invincible_counter - 1
		target:RemoveModifierByName("modifier_sword_of_invincible_passive")
		if not target.Is_invincible_equip then return nil end
		if target.invincible_counter == -1 then
			ability:ApplyDataDrivenModifier(target, target, "modifier_sword_of_invincible_passive", nil)
			return nil
		end
		return 1
		end)
	Timers:CreateTimer(2, function() 
		ParticleManager:DestroyParticle(target.ShieldParticle, false)
		end)
end


