
function OnAttackLanded( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:FindModifierByName("modifier_satsuma_gun_hint") then
        if not target:IsBuilding() then
            caster:RemoveModifierByName("modifier_satsuma_gun_hint")
            item_satsuma_gun = 0
            ability:ApplyDataDrivenModifier(caster, target, "modifier_satsuma_gun", {})
            Physics:Unit(target)
            local diff = target:GetAbsOrigin()-caster:GetAbsOrigin()
            diff.z = 0
            local dir = diff:Normalized()
            target:SetVelocity(Vector(0,0,-9.8))
            target:AddPhysicsVelocity(dir*1000)
        end
    end
    ability:ApplyDataDrivenModifier(caster,target,"modifier_satsuma_gun_DH",{})
end

function Shock( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_satsuma_gun_hint", {})
end

