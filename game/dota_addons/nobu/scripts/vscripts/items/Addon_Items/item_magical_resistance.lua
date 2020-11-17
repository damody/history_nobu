function OnEquip( keys )
    local caster = keys.caster
    local ability = keys.ability
    local magical_resistance = ability:GetSpecialValueFor("magical_resistance")
    if caster.items == nil then
        caster.items = {}
    end
    if caster.magical_resistance == nil then
        caster.magical_resistance = 30
    end
    if caster.items[ability:GetName()] == nil then
        caster.items[ability:GetName()] = 1
        caster.magical_resistance = caster.magical_resistance + magical_resistance
    else
        caster.items[ability:GetName()] = caster.items[ability:GetName()] + 1 
    end
end

function OnUnequip( keys )
    local caster = keys.caster
    local ability = keys.ability
    local magical_resistance = ability:GetSpecialValueFor("magical_resistance")
    if caster.items == nil then
        caster.items = {}
    end
    if caster.items[ability:GetName()] then
        caster.items[ability:GetName()] = caster.items[ability:GetName()] - 1
        if caster.items[ability:GetName()] == 0 then
            caster.items[ability:GetName()] = nil
            caster.magical_resistance = caster.magical_resistance - magical_resistance
        end
    end
end