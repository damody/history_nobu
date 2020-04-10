LinkLuaModifier( "modifier_ronin_jitte", "items/Addon_Items/item_ronin_jitte.lua",LUA_MODIFIER_MOTION_NONE )

modifier_ronin_jitte = class({})

--------------------------------------------------------------------------------

function modifier_ronin_jitte:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_ronin_jitte:GetModifierIncomingDamage_Percentage(event)
	local caster = self.caster
	local attacker = event.attacker
	if (caster:GetAbsOrigin() - attacker:GetAbsOrigin()):Length() < 200 then
		return -10
	else
		return 0
	end
end

--浪人十手

function Shock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local max_counter = ability:GetSpecialValueFor("max_counter")
	local duration = ability:GetSpecialValueFor("duration")
	ability:ApplyDataDrivenModifier(caster, caster,"modifier_melee_block",{duration=duration})
	local modifier = caster:FindModifierByName("modifier_melee_block")
	modifier:SetStackCount(max_counter)
end

function OntakeDamage( keys )
	local target = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.DamageTaken
	--DeepPrintTable(keys)
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length()
	print(distance)
	local modifier = caster:FindModifierByName("modifier_melee_block")
	if distance < 200 and modifier:GetStackCount() > 0 then
		modifier:SetStackCount(modifier:GetStackCount() - 1)
		caster:SetHealth(caster:GetHealth() + damage)
	end
	if modifier:GetStackCount() == 0 then
		caster:RemoveModifierByName("modifier_melee_block")
	end
end

function OnEquip(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:AddNewModifier(caster, ability, "modifier_ronin_jitte", {})
	caster:FindModifierByName("modifier_ronin_jitte").caster = caster
end

function OnUnequip(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_ronin_jitte")
end