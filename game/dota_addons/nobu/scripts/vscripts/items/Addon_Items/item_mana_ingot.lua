function OnEquip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local mana = keys.mana
	if not caster:IsRealHero() then
		caster.mana = caster.mana + mana
	end
end

function OnUnequip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local mana = keys.mana
	if not caster:IsRealHero() then
		caster.mana = caster.mana - mana
	end
end