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

function OnSpellStart( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local duration = ability:GetSpecialValueFor("duration")
    local cnt = ability:GetSpecialValueFor("cnt")
    EmitSoundOnLocationWithCaster( caster:GetAbsOrigin(),"DOTA_Item.HurricanePike.Activate", target)
    ParticleManager:CreateParticle( "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_item_force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    Physics:Unit(target)
    Physics:Unit(caster)
    target:SetPhysicsVelocity((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()*2250)
    caster:SetPhysicsVelocity((caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()*2250)
    target:StartPhysicsSimulation()
    caster:StartPhysicsSimulation()
    Timers:CreateTimer(0.2, function()
        target:StopPhysicsSimulation()
        caster:StopPhysicsSimulation()
	end)
    caster.wayumi_target = target
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_wayumi_count_down", {duration=duration})
    local hModifier = caster:FindModifierByName("modifier_wayumi_count_down")
    hModifier:SetStackCount(cnt)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_wayumi_target", {duration=duration})
    hModifier = caster:FindModifierByName("modifier_wayumi_count_down")
    hModifier:SetStackCount(cnt)
    local order = {UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
        TargetIndex = target:entindex()}
    ExecuteOrderFromTable(order)
end

function OnAttackStart( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if target:HasModifier("modifier_wayumi_target") and caster:HasModifier("modifier_wayumi_count_down") then
        local stack = caster:FindModifierByName("modifier_wayumi_count_down"):GetStackCount()
        caster:FindModifierByName("modifier_wayumi_count_down"):SetStackCount(stack - 1)
        target:FindModifierByName("modifier_wayumi_target"):SetStackCount(stack - 1)
        if caster:FindModifierByName("modifier_wayumi_count_down"):GetStackCount() <= 0 then
            caster:RemoveModifierByName("modifier_wayumi_count_down")
            target:RemoveModifierByName("modifier_wayumi_target")
        end
    else 
        caster:RemoveModifierByName("modifier_wayumi_snipe")
    end
end

function OnAttacked( keys )
    local caster = keys.attacker
    local target = caster.wayumi_target
    local ability = keys.ability
    local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length()
    if target:HasModifier("modifier_wayumi_target") and caster:HasModifier("modifier_wayumi_count_down") then
        print(distance)
        print(caster:GetProjectileSpeed())
        print(distance/caster:GetProjectileSpeed())
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_wayumi_snipe", {duration=1/caster:GetAttackSpeed() + distance/caster:GetProjectileSpeed() + 0.1})
    end
end