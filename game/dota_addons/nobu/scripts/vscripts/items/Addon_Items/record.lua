--記錄傷害用

modifier_record = class({})

--------------------------------------------------------------------------------

function modifier_record:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_record:OnCreated(event)
end

function modifier_record:IsHidden()
	return true
end

function modifier_record:OnTakeDamage(event)
	local attacker = event.attacker
	local victim = event.unit
	local original_damage = event.original_damage
	local damage_type = event.damage_type
	local damage_flags = event.damage_flags
	local damage = event.damage
	if victim == self.caster then
		if victim ~= nil and IsValidEntity(victim) then
			-- 承受傷害
			if victim.damage_taken == nil then
				victim.damage_taken = 0
			end
			if victim.physical_damage_taken == nil then
				victim.physical_damage_taken = 0
			end
			if victim.magical_damage_taken == nil then
				victim.magical_damage_taken = 0
			end
			if victim.true_damage_taken == nil then
				victim.true_damage_taken = 0
			end
			if victim.damage_reduce == nil then
				victim.damage_reduce = 0
			end
			-- 造成傷害
			if attacker.damage_to_hero == nil then
				attacker.damage_to_hero = 0
			end
			if attacker.physical_damage_to_hero == nil then
				attacker.physical_damage_to_hero = 0
			end
			if attacker.magical_damage_to_hero == nil then
				attacker.magical_damage_to_hero = 0
			end
			if attacker.true_damage_to_hero == nil then
				attacker.true_damage_to_hero = 0
			end
			if attacker.damage == nil then
				attacker.damage = 0
			end
			if attacker.physical_damage == nil then
				attacker.physical_damage = 0
			end
			if attacker.magical_damage == nil then
				attacker.magical_damage = 0
			end
			if attacker.true_damage == nil then
				attacker.true_damage = 0
			end
			if attacker.maximum_critical_damage == nil then
				attacker.maximum_critical_damage = 0
			end
			if attacker.damage_to_tower == nil then
				attacker.damage_to_tower = 0
			end
			if attacker.damage_to_unit == nil then
				attacker.damage_to_unit = 0
			end
			victim.damage_taken = victim.damage_taken + damage
			attacker.damage = attacker.damage + damage
			--damage reduce
			victim.damage_reduce = victim.damage_reduce + (original_damage - damage)
			--damage to hero
			if victim:IsRealHero() and not victim:IsIllusion() then
				attacker.damage_to_hero = attacker.damage_to_hero + damage
				if damage_type == DAMAGE_TYPE_PHYSICAL then
					attacker.physical_damage_to_hero = attacker.physical_damage_to_hero + damage
					victim.physical_damage_taken = victim.physical_damage_taken + damage
				end
				if damage_type == DAMAGE_TYPE_MAGICAL then
					attacker.magical_damage_to_hero = attacker.magical_damage_to_hero + damage
					victim.magical_damage_taken = victim.magical_damage_taken + damage
				end
				if damage_type == DAMAGE_TYPE_PURE then
					attacker.true_damage_to_hero = attacker.true_damage_to_hero + damage
					victim.true_damage_taken = victim.true_damage_taken + damage
				end
			else
				if damage_type == DAMAGE_TYPE_PHYSICAL then
					attacker.physical_damage = attacker.physical_damage + damage
				end
				if damage_type == DAMAGE_TYPE_MAGICAL then
					attacker.magical_damage = attacker.magical_damage + damage
				end
				if damage_type == DAMAGE_TYPE_PURE then
					attacker.true_damage = attacker.true_damage + damage
				end
			end
			if victim:IsBuilding() then
				--damage to tower
				attacker.damage_to_tower = attacker.damage_to_tower + damage
			elseif not victim:IsBuilding() and not victim:IsRealHero() then
				--damage to unit
				attacker.damage_to_unit = attacker.damage_to_unit + damage
			end
		end
	end
end

function Start(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local target = keys.target
	caster.damage = 0
	caster.takedamage = 0
	caster.herodamage = 0
	caster:AddNewModifier(caster, ability, "modifier_record", {})
	caster:FindModifierByName("modifier_record").caster = caster
	Timers:CreateTimer(
		1,
		function()
			if not caster:HasModifier("modifier_record") then
				caster:AddNewModifier(caster, ability, "modifier_record", {})
				caster:FindModifierByName("modifier_record").caster = caster
			end
			return 1
		end
	)
end
