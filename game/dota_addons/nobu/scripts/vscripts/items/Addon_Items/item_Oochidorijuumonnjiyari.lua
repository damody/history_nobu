function Shock ( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    local group = FindUnitsInRadius(caster:GetTeamNumber(),
    target:GetAbsOrigin(),
    nil,
    500,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
    FIND_ANY_ORDER,
    false)
    for i,unit in ipairs(group) do
        if IsValidEntity(unit) then
            local info = {
                Target = unit,
                Source = caster,
                -- EffectName = "particles/a34w/a34w.vpcf",
                EffectName = "particles/items3_fx/gleipnir_projectile.vpcf",
                Ability = ability,
                iMoveSpeed = 2000,
                vSpawnOrigin = caster:GetAbsOrigin()
            }
            ProjectileManager:CreateTrackingProjectile ( info )
        end
    end

end