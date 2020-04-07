function Shock( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if ability:IsCooldownReady() then
        if not target:IsBuilding() then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_satsuma_gun", {})
            Physics:Unit(target)
            local diff = target:GetAbsOrigin()-caster:GetAbsOrigin()
            diff.z = 0
            local dir = diff:Normalized()
            target:SetVelocity(Vector(0,0,-9.8))
            target:AddPhysicsVelocity(dir*200)
            ability:StartCooldown(5)
        end
    end
end