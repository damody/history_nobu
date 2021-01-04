function OnEquip ( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetBaseAttackRange() > 200 then
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_wayumi",nil)
    end
end

function OnUnEquip ( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetBaseAttackRange() > 200 then
        caster:RemoveModifierByName("modifier_wayumi")
    end
end