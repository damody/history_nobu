function OnEquip ( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetBaseAttackRange() < 200 then
        if not caster:HasModifier("Passive_contemporary_armor2") then 
            ability:ApplyDataDrivenModifier(caster, caster, "Passive_contemporary_armor2", nil)
        end
    else
        if not caster:HasModifier("Passive_contemporary_armor3") then 
            ability:ApplyDataDrivenModifier(caster, caster, "Passive_contemporary_armor3", nil)
        end
    end
    
end

function OnUnEquip ( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetBaseAttackRange() < 200 then
        if caster:HasModifier("Passive_contemporary_armor2") then 
            caster:RemoveModifierByName("Passive_contemporary_armor2")
        end
    else
        if caster:HasModifier("Passive_contemporary_armor3") then 
            caster:RemoveModifierByName("Passive_contemporary_armor3")
        end
    end
    
end
