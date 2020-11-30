function OnEquip ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster.swiftness_boots == nil then
        caster.swiftness_boots = 0
    end
    if caster.swiftness_boots < 5 then
        caster.swiftness_boots = caster.swiftness_boots + 1
    end
    if caster.swiftness_boots == 5 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_UntakeDamage", {})
    end
end

function OnUnEquip( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster.swiftness_boots then
        caster.swiftness_boots = nil
    end
    if caster:HasModifier("modifier_UntakeDamage") then
        caster:RemoveModifierByName("modifier_UntakeDamage")
    end
end

function OnTakeDamage ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster.swiftness_boots then
        caster.swiftness_boots = 0
    end
    if caster:HasModifier("modifier_UntakeDamage") then
        caster:RemoveModifierByName("modifier_UntakeDamage")
    end
end