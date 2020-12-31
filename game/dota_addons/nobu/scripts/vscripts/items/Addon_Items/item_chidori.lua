function Chidori_Damage ( keys )
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local int = caster:GetIntellect()
    if not target:IsBuilding() then
        AMHC:Damage(caster,target,int * 1.25,AMHC:DamageType("DAMAGE_TYPE_MAGICAL"))
    end
end
function Chidori_Steal ( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local int = caster:GetIntellect()
    local tint = target:GetIntellect()
    if target:IsHero() then
        target:ModifyIntellect(-2)
        caster:ModifyIntellect(2)
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_Chidori4",nil)
        ability:ApplyDataDrivenModifier(caster,target,"modifier_Chidori3",nil)
        local stack_self = caster:FindModifierByName("modifier_Chidori4")
        local stack = target:FindModifierByName("modifier_Chidori3")
        stack:SetStackCount(stack:GetStackCount() + 1)
        stack_self:SetStackCount(stack_self:GetStackCount() + 1)
    end
    Timers:CreateTimer(15, function()
        target:ModifyIntellect(2)
        caster:ModifyIntellect(-2)
        if IsValidEntity(target) and target:FindModifierByName("modifier_Chidori3") then
            local stack = target:FindModifierByName("modifier_Chidori3")
            if stack:GetStackCount() == 1 then
                target:RemoveModifierByName("modifier_Chidori3")
            else
                stack:SetStackCount(stack:GetStackCount() -1)
            end
        end
        if IsValidEntity(caster) and caster:FindModifierByName("modifier_Chidori4") then
            local stack_self = caster:FindModifierByName("modifier_Chidori4")
            if stack_self:GetStackCount() == 1 then
                caster:RemoveModifierByName("modifier_Chidori4")
            else
                stack_self:SetStackCount(stack_self:GetStackCount() -1)
            end
        end
    end)
end