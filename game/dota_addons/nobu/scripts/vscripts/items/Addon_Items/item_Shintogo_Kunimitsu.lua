function TakenDamage ( keys )
    local target = keys.caster
    local ability = keys.ability
    local modifier = target:FindModifierByName("modifier_Shintogo_Kunimitsu")
    if modifier == nil then
        ability:ApplyDataDrivenModifier(target,target,"modifier_Shintogo_Kunimitsu",{})
        modifier = target:FindModifierByName("modifier_Shintogo_Kunimitsu")
        modifier:SetStackCount(1)
        target.Shintogo_Kunimitsu = 1
        target.magical_resistance = target.magical_resistance + 3
    else
        local count = modifier:GetStackCount() + 1
        if count >= 5 then
            count = 5
        end
        if target.Shintogo_Kunimitsu < 5 then
            target.magical_resistance = target.magical_resistance + 3
            modifier:SetStackCount(count)
            ability:ApplyDataDrivenModifier(target,target,"modifier_Shintogo_Kunimitsu",nil)
            target.Shintogo_Kunimitsu = count
        elseif target.Shintogo_Kunimitsu == 5 then
            modifier:SetStackCount(count)
            ability:ApplyDataDrivenModifier(target,target,"modifier_Shintogo_Kunimitsu",nil)
            target.Shintogo_Kunimitsu = count
        end
        
    end
end


function OnDestroy( keys )
    local target = keys.caster
    local ability = keys.ability
    if target.Shintogo_Kunimitsu > 0 then
        target.Shintogo_Kunimitsu = target.Shintogo_Kunimitsu - 1
        target.magical_resistance = target.magical_resistance - 3
        if target.Shintogo_Kunimitsu >= 1 then
            ability:ApplyDataDrivenModifier(target,target,"modifier_Shintogo_Kunimitsu",nil)
            local modifier = target:FindModifierByName("modifier_Shintogo_Kunimitsu")
            if modifier then
                modifier:SetStackCount(target.Shintogo_Kunimitsu)
            end
        end
    end
end

function OnDeath( keys )
    local target = keys.caster
    local ability = keys.ability
    if target.Shintogo_Kunimitsu > 0 then
        target.magical_resistance = target.magical_resistance - 3 * target.Shintogo_Kunimitsu
        target.Shintogo_Kunimitsu = 0
    end
end