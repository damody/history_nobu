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

function Shock( keys )
    local caster = keys.caster
    local ability = keys.ability
    local block_duration = ability:GetSpecialValueFor("block_duration")
    local block_cd = ability:GetSpecialValueFor("block_cd")
    local block_radius = ability:GetSpecialValueFor("block_radius")
    local groups = FindUnitsInRadius(caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        block_radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false)
    for _,target in pairs(groups) do
        if not target:HasModifier("modifier_contemporary_armor_block_cd") then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_contemporary_armor_block", {duration = block_duration})
            ability:ApplyDataDrivenModifier(caster, target, "modifier_contemporary_armor_block_cd", {duration = block_cd})
            target.contemporary_armor_shield = ParticleManager:CreateParticle("particles/econ/items/pangolier/pangolier_ti8_immortal/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            Timers:CreateTimer(0, function() 
                if IsValidEntity(target) then
                    ParticleManager:SetParticleControl(target.contemporary_armor_shield,1,target:GetAbsOrigin()+Vector(0, 0, 30))
                else
                    isend = true
                end
                if not isend then
                    return 0.05
                else
                    ParticleManager:DestroyParticle(target.contemporary_armor_shield, false)
                    return nil
                end
            end)
        end
    end
end

function OnDestroy( keys )
    local target = keys.target
    ParticleManager:DestroyParticle(target.contemporary_armor_shield, false)
end