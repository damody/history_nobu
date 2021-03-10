function OnEquip ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability

    if not caster:HasModifier("modifier_ninja_cloth_untake_damage") then
        if caster.ninja_cloth == nil then
            caster.ninja_cloth = 0
        end
        if caster.ninja_cloth < 3 then
            caster.ninja_cloth = caster.ninja_cloth + 1
        end
        if caster.ninja_cloth >=3 then
            if not caster:HasModifier("modifier_ninja_cloth_untake_damage") then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_ninja_cloth_untake_damage", {})
                local handle = caster:FindModifierByName("modifier_ninja_cloth_untake_damage")
                if handle then
                    handle:SetStackCount(1)
                end
            end
        end
    else
        local handle = caster:FindModifierByName("modifier_ninja_cloth_untake_damage")
        if handle then
            local c = handle:GetStackCount()
            if c <= 99 then
                c = c + 1
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_ninja_cloth_untake_damage", {})
                handle:SetStackCount(c)
            end
        end
    end
  
    

end

function OnAttacked ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster:FindModifierByName("modifier_ninja_cloth_untake_damage") then
        caster:RemoveModifierByName("modifier_ninja_cloth_untake_damage")
    end
end

function OnUnEquip( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster.ninja_cloth then
        caster.ninja_cloth = nil
    end
    if caster:HasModifier("modifier_ninja_cloth_untake_damage") then
        caster:RemoveModifierByName("modifier_ninja_cloth_untake_damage")
    end
end

function OnTakeDamage ( keys )
    local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    if caster.ninja_cloth then
        caster.ninja_cloth = 0
    end
    if caster:HasModifier("modifier_ninja_cloth_untake_damage") then
        caster:RemoveModifierByName("modifier_ninja_cloth_untake_damage")
    end
end